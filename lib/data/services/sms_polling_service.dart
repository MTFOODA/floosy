import 'dart:async';

import 'package:flutter/widgets.dart';

import '../local/datasources/processed_sms_local_datasource.dart';
import '../models/user_model.dart';
import '../../core/utils/app_logger.dart';
import 'sms_ingestion_service.dart';
import 'sms_sync_state_store.dart';

/// Central bank/wallet SMS synchronization.
///
/// ONE timer for the whole app — every 5 seconds it runs the SAME
/// [SmsIngestionService.scanAndProcess] pipeline used by pull-to-refresh
/// (single-flight: overlapping callers join the in-flight scan).
///
/// INGESTION MODEL (first scan vs. incremental — the core contract):
///
///   * FIRST EVER SCAN — a bounded backward walk over the WHOLE available
///     inbox history. One page ([historyPageSize]) per scan, newest → oldest,
///     so a huge inbox is ingested across several cycles and never blocks the
///     main isolate in one pass. When a page comes back short the walk is
///     complete and [SmsSyncState.historyComplete] is persisted.
///   * EVERY LATER SCAN — only messages NEWER than the persisted cursor
///     (`lastProcessedAt - incrementalOverlap`). The bound is pushed down to
///     the native inbox query, so old SMS are not even transferred.
///   * A BURST larger than one incremental page is drained backwards
///     (`pendingSince`) before the cursor advances past it, so no message can
///     be skipped.
///
/// There is NO date cutoff (the old "September 1, 2026" constant is gone) and
/// NO display-range coupling: which SMS are ingested is decided ONLY by the
/// processed-SMS ledger + this persisted cursor. The Transactions page display
/// filter never calls into this service.
class SmsPollingService extends WidgetsBindingObserver {
  /// Automatic check interval for newly arrived bank/wallet SMS.
  static const Duration interval = Duration(seconds: 5);

  /// Network/catalog work must never hold a scan forever.
  static const Duration _catalogTimeout = Duration(seconds: 8);

  /// Upper bound for one scan so pull-to-refresh always terminates.
  static const Duration defaultScanTimeout = Duration(seconds: 60);

  /// Overlap re-inspected by every incremental scan.
  ///
  /// A timestamp alone is NOT a sufficient message identity (several SMS can
  /// share one timestamp and the device clock can skew), so a bounded window is
  /// deliberately re-read. The processed-SMS ledger (per-message hash) plus the
  /// transaction fingerprint make the re-read idempotent, so this can never
  /// create a duplicate transaction.
  static const Duration incrementalOverlap = Duration(minutes: 2);

  /// Messages inspected per historical page (bounded work per scan).
  static const int historyPageSize = 200;

  /// Messages inspected per incremental scan.
  static const int incrementalPageSize = 50;

  final SmsIngestionService ingestion;

  /// Resolves the authenticated user id for the scan (null → not logged in).
  final Future<String?> Function() resolveUserId;

  /// Resolves the runtime bank catalog for sender validation.
  final Future<List<Bank>> Function() resolveKnownBanks;

  /// Persistent ingestion watermark (first scan vs. incremental), per user.
  final SmsSyncStateStore syncStateStore;

  /// Local processed-SMS ledger: the authoritative, restart-safe
  /// "newest processed point" used as a floor for the cursor.
  final ProcessedSmsLocalDataSource? processedSmsLocalDataSource;

  /// Invoked when NEW transactions were created — refreshes money/UI state.
  final void Function(int transactionsCreated)? onTransactionsCreated;

  /// Upper bound for ONE scan page (injectable so tests can exercise the
  /// timeout path without waiting a real minute).
  final Duration scanTimeout;

  Timer? _timer;
  bool _started = false;
  bool _resumed = true;

  /// The single in-flight scan, or null when idle. Second callers join this
  /// future instead of starting duplicate work.
  Future<SmsIngestionResult>? _inflight;

  /// Claim of the last scan that hit [scanTimeout]. Such a claim is STILL
  /// RUNNING in the background (futures are not cancellable), so a joiner must
  /// never answer its timeout by starting a competing pipeline.
  Future<SmsIngestionResult>? _timedOutClaim;

  /// The UNDERLYING pipeline future for the in-flight scan (the actual
  /// platform/DB/network work). A Dart `.timeout()` never cancels this work,
  /// so this slot is cleared ONLY when the work itself settles. While it is
  /// non-null NO new ingestion pipeline may start — not from the 5-second
  /// poller, not from pull-to-refresh, not from the timeout path.
  Future<SmsIngestionResult>? _activeWork;

  /// Completed scan count (diagnostics/tests).
  int _scansCompleted = 0;

  /// Last known watermark per user (avoids a prefs read on every tick).
  final Map<String, SmsSyncState> _stateCache = {};

  SmsPollingService({
    required this.ingestion,
    required this.resolveUserId,
    required this.resolveKnownBanks,
    SmsSyncStateStore? syncStateStore,
    this.processedSmsLocalDataSource,
    this.onTransactionsCreated,
    Duration? scanTimeout,
  })  : syncStateStore = syncStateStore ?? SmsSyncStateStore(),
        scanTimeout = scanTimeout ?? defaultScanTimeout;

  /// Number of scans this service completed (diagnostics/tests).
  int get scansCompleted => _scansCompleted;

  /// True while a historical/backfill walk is unfinished for [userId].
  bool isBackfillPending(String userId) =>
      (_stateCache[userId] ?? SmsSyncState.empty).isWalking;

  /// Starts the 5-second polling once. Safe to call multiple times — extra
  /// calls are ignored (exactly one timer, ever). An immediate first cycle runs
  /// so OPENING THE APP checks for new bank/wallet SMS right away (and performs
  /// the one-time historical scan on first run) instead of waiting a whole
  /// interval.
  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(interval, (_) => _tick());
    logInfo('SMS_POLLING_START interval=${interval.inSeconds}s');
    unawaited(_tick());
  }

  /// Stops polling and releases the observer (no leaks).
  void stop() {
    _timer?.cancel();
    _timer = null;
    _started = false;
    WidgetsBinding.instance.removeObserver(this);
    logInfo('SMS_POLLING_STOP');
  }

  /// Forgets the persisted watermark for [userId] (data-reset flow) so the next
  /// scan performs a fresh historical ingest.
  Future<void> resetSyncState(String userId) async {
    _stateCache.remove(userId);
    await syncStateStore.clear(userId);
    logInfo('SMS_SYNC_STATE_RESET userId=$userId');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _resumed = false;
      _timer?.cancel();
      _timer = null;
      logInfo('SMS_POLLING_PAUSED');
    } else if (state == AppLifecycleState.resumed) {
      _resumed = true;
      _timer?.cancel();
      _timer = Timer.periodic(interval, (_) => _tick());
      logInfo('SMS_POLLING_RESUMED');
    }
  }

  /// One automatic polling cycle. Never runs a scan concurrently with another
  /// scan (a tick during an in-flight scan is skipped — that scan already
  /// covers the inbox). This is the ONLY path allowed to start or continue the
  /// one-time historical walk, so a pull-to-refresh can never trigger a
  /// historical re-read.
  Future<void> _tick() async {
    if (!_resumed) return;
    if (_inflight != null) return;
    final userId = await resolveUserId();
    if (userId == null) return;
    // Re-check after the async gap: a manual scan may have started meanwhile.
    if (_inflight != null) return;
    try {
      await _runScan(userId: userId, allowWalk: true, origin: 'POLL');
    } catch (e) {
      // A failing cycle must never kill the timer; the next cycle retries.
      logError('SMS_POLLING_CYCLE_FAILED', e);
    }
  }

  /// Immediate scan through the SAME central pipeline (pull-to-refresh, opening
  /// the Transactions page, manual checks). Concurrency-safe: when a scan is
  /// already running this caller JOINS it (awaits the same future) instead of
  /// starting duplicate work or returning a fake empty result.
  ///
  /// [fullScan] = "this caller may also start/continue the one-time historical
  /// walk". Pull-to-refresh passes the default (false) so it ONLY looks for
  /// messages newer than the cursor and can never trigger a full history
  /// re-read.
  ///
  /// FAILED JOIN -> ONE FRESH ATTEMPT: a joined scan that threw, timed out, or
  /// finished with `errors > 0` does NOT satisfy this caller. The caller runs
  /// ONE fresh scan instead, so a user-triggered refresh is never answered with
  /// the failure of an unrelated automatic cycle. The attempt is BOUNDED: the
  /// retry's own result is returned as-is (never re-joined, never retried
  /// again), so a permanently failing pipeline can never spin.
  Future<SmsIngestionResult> scanNow({bool fullScan = false}) async {
    final joinedClaim = _inflight;
    if (joinedClaim != null) {
      logInfo('SMS_SCAN_JOIN inFlight=true requestedWalk=$fullScan');
      final joined = await _awaitClaim(joinedClaim, fullScan: fullScan);
      if (joined != null && joined.errors == 0) return joined;
      if (identical(joinedClaim, _timedOutClaim)) {
        // The joined scan did not COMPLETE - it timed out and is still running
        // in the background. Retrying now would put a second ingestion pipeline
        // next to a running one (duplicate work, cursor races), so this caller
        // reports the timeout result instead.
        logInfo('SMS_SCAN_JOIN_TIMEOUT_NO_RETRY requestedWalk=$fullScan');
        return joined ?? _empty(errors: 1);
      }
      logInfo('SMS_SCAN_JOIN_RETRY requestedWalk=$fullScan');
    }
    final userId = await resolveUserId();
    if (userId == null) {
      logDebug('SMS_SCAN_SKIPPED no signed-in user');
      return _empty();
    }
    // Re-check after the async gap: another caller may have claimed the slot.
    // The claim this caller ALREADY awaited is excluded, so a completed claim
    // can never be awaited twice (that would be a loop, not a join).
    //
    // TIMEOUT-DUPLICATE GATE: when the underlying pipeline work is still
    // running (a timed-out scan that keeps executing in the background), do
    // NOT start a second pipeline on top of it. The caller observes the
    // timeout result instead; the real scan's side effects (DB writes, cursor,
    // UI callbacks) still land when it completes.
    if (_activeWork != null) {
      logInfo('SMS_SCAN_ACTIVE_WORK_BUSY requestedWalk=$fullScan '
          'no duplicate pipeline started');
      return _empty(errors: 1);
    }
    final claimant = _inflight;
    if (claimant != null && !identical(claimant, joinedClaim)) {
      final result = await _awaitClaim(claimant, fullScan: fullScan);
      if (result != null) return result;
    }
    return _runScan(
      userId: userId,
      allowWalk: fullScan,
      origin: fullScan ? 'REFRESH' : 'CHECK',
    );
  }

  /// Awaits an in-flight scan claim WITHOUT throwing: a failed claim yields
  /// null so the caller can decide between joining another claim and running a
  /// fresh attempt of its own.
  Future<SmsIngestionResult?> _awaitClaim(
    Future<SmsIngestionResult> claim, {
    required bool fullScan,
  }) async {
    try {
      return await claim;
    } catch (e, st) {
      logError('SMS_SCAN_JOIN_FAILED requestedWalk=$fullScan', e, st);
      return null;
    }
  }

  /// Claims the single-flight slot, runs the scan, then releases the slot.
  /// The slot is claimed SYNCHRONOUSLY so two callers in the same microtask can
  /// never start two concurrent scans.
  ///
  /// TIMEOUT-DUPLICATE SAFETY: a Dart `.timeout()` does NOT cancel the
  /// underlying pipeline future — the real scan keeps running in the
  /// background after the claim answers. [_activeWork] tracks that real work
  /// and stays occupied until the work ITSELF settles, so neither the
  /// 5-second poller nor pull-to-refresh can start a second competing
  /// ingestion pipeline on top of a timed-out run.
  Future<SmsIngestionResult> _runScan({
    required String userId,
    required bool allowWalk,
    required String origin,
  }) {
    final completer = Completer<SmsIngestionResult>();
    final claim = completer.future;
    _inflight = claim;
    final work =
        _performScan(userId: userId, allowWalk: allowWalk, origin: origin);
    _activeWork = work;
    unawaited(work.whenComplete(() {
      if (identical(_activeWork, work)) _activeWork = null;
    }));
    work.timeout(
      scanTimeout,
      onTimeout: () {
        // A timeout is NOT a definitive failure: Dart futures are not
        // cancellable, so this page keeps running in the background.
        // Remember the claim so a JOINER returns its result instead of
        // starting a second ingestion pipeline on top of the running one.
        _timedOutClaim = claim;
        logError(
          'SMS_SCAN_TIMEOUT exceeded ${scanTimeout.inSeconds}s origin=$origin',
          'timeout',
        );
        return _empty(errors: 1);
      },
    ).then((result) {
      if (!completer.isCompleted) completer.complete(result);
    }, onError: (Object e, StackTrace st) {
      if (!completer.isCompleted) completer.completeError(e, st);
    });
    // The claim slot releases when the CLAIM settles (timeout or result) so
    // waiting callers are never stuck; [_activeWork] keeps guarding the real
    // work underneath until it truly finishes.
    return claim.whenComplete(() {
      if (identical(_inflight, claim)) _inflight = null;
    });
  }

  /// Routes one scan to the right strategy: the one-time historical walk, a
  /// backlog drain, or the steady-state incremental check.
  Future<SmsIngestionResult> _performScan({
    required String userId,
    required bool allowWalk,
    required String origin,
  }) async {
    final banks = await _resolveBanks();
    final state = await _loadState(userId);

    if (state.isWalking) {
      if (!allowWalk) {
        // Pull-to-refresh / manual check: NEVER start or continue a historical
        // walk. Only look for messages newer than the persisted cursor.
        logInfo('SMS_INCREMENTAL_ONLY origin=$origin walking=true');
        return _runIncremental(
          userId: userId,
          banks: banks,
          state: state,
          origin: origin,
        );
      }
      return _runWalkPage(
        userId: userId,
        banks: banks,
        state: state,
        origin: origin,
      );
    }

    return _runIncremental(
      userId: userId,
      banks: banks,
      state: state,
      origin: origin,
    );
  }

  /// ONE bounded page of the backward walk (first-ever historical scan, or the
  /// drain of a bulky backlog). Bounded on purpose: a huge inbox is ingested
  /// across several cycles instead of blocking the main isolate once.
  Future<SmsIngestionResult> _runWalkPage({
    required String userId,
    required List<Bank> banks,
    required SmsSyncState state,
    required String origin,
  }) async {
    final isFirstScan = !state.historyComplete;
    final tag = isFirstScan ? 'SMS_FIRST_SCAN' : 'SMS_BACKFILL';
    final before = state.walkCursor;
    // The FIRST walk must reach the OLDEST message in the inbox, so it is never
    // bounded below by a backlog floor: a floor registered by a concurrent
    // incremental scan would cut the page short, look like "history complete",
    // and silently abandon everything older than that floor.
    final since = isFirstScan ? null : state.pendingSince;
    final startedAt = DateTime.now();
    logInfo('$tag origin=$origin page=${state.pagesScanned + 1} '
        'since=${since?.toIso8601String()} before=${before?.toIso8601String()} '
        'max=$historyPageSize');

    final page = await ingestion.scanAndProcess(
      userId: userId,
      knownBanks: banks,
      maxMessages: historyPageSize,
      since: since,
      before: before,
    );

    final oldest = page.oldestSeenOnPage;
    // A short page means the walk reached its lower bound. An EMPTY page never
    // completes the walk: it also covers "no permission yet" / "read failed",
    // and the next cycle simply retries instead of permanently skipping the
    // whole history.
    var reachedLowerBound = page.scanned > 0 && page.scanned < historyPageSize;
    // TIE-SAFE BOUNDARY: the native bound is INCLUSIVE (`DATE <= until`), so the
    // next page starts AT the oldest timestamp of this page instead of 1 ms
    // BELOW it. Messages that share one timestamp and did not fit into this
    // page are therefore re-inspected by the next page (the processed-SMS ledger
    // and the transaction fingerprint make that idempotent) instead of being
    // skipped forever.
    var nextCursor = (reachedLowerBound || oldest == null) ? null : oldest;
    // STALL GUARD: if the WHOLE page sits exactly on the inclusive upper bound,
    // it is a single tie group larger than one page - walking inclusively would
    // re-read the same page forever. Step strictly below it so the walk still
    // makes progress and terminates (only the excess of such an absurd tie group
    // can remain, and a date-only cursor cannot address beyond it).
    if (!reachedLowerBound &&
        oldest != null &&
        before != null &&
        !oldest.isBefore(before)) {
      logError(
        '$tag tie group larger than one page at ${oldest.toIso8601String()} - '
            'stepping strictly below it to keep the walk moving',
        'tie_overflow',
      );
      nextCursor = oldest.subtract(const Duration(milliseconds: 1));
    }

    final newest = _maxDate(state.lastProcessedAt, page.newestSeenOnPage);
    final drained = !isFirstScan && reachedLowerBound;

    final next = isFirstScan
        ? state.copyWith(
            historyComplete: reachedLowerBound,
            // The first walk covers the WHOLE inbox, so any backlog floor is
            // obsolete once it completes.
            clearPendingSince: reachedLowerBound,
            walkCursor: nextCursor,
            clearWalkCursor: nextCursor == null,
            lastProcessedAt: newest,
            pagesScanned: state.pagesScanned + 1,
            updatedAt: DateTime.now(),
          )
        : state.copyWith(
            clearPendingSince: drained,
            walkCursor: nextCursor,
            clearWalkCursor: nextCursor == null,
            lastProcessedAt: newest,
            pagesScanned: state.pagesScanned + 1,
            updatedAt: DateTime.now(),
          );

    logInfo('$tag ${reachedLowerBound ? "LOWER_BOUND_REACHED" : "PAGE_DONE"} '
        'walked=${page.scanned} created=${page.transactionsCreated}');
    await _commit(userId, next, page, startedAt, tag);
    return page;
  }

  /// Steady state: inspect ONLY messages newer than the persisted cursor.
  /// The `since` bound is pushed down to the native inbox query, so no old SMS
  /// travel over the platform channel (ANR fix).
  ///
  /// If the page comes back FULL there were more new messages than one page can
  /// carry: the previous cursor is kept as `pendingSince` and the backlog is
  /// drained backwards by later scans, so a burst can never skip a message.
  Future<SmsIngestionResult> _runIncremental({
    required String userId,
    required List<Bank> banks,
    required SmsSyncState state,
    required String origin,
  }) async {
    final since = state.incrementalSince(incrementalOverlap);
    final startedAt = DateTime.now();
    logInfo('SMS_INCREMENTAL origin=$origin since=${since?.toIso8601String()} '
        'max=$incrementalPageSize');
    final page = await ingestion.scanAndProcess(
      userId: userId,
      knownBanks: banks,
      maxMessages: incrementalPageSize,
      since: since,
    );

    final pageFull = page.scanned >= incrementalPageSize;
    final newest = _maxDate(state.lastProcessedAt, page.newestSeenOnPage);
    SmsSyncState next;
    if (pageFull && page.oldestSeenOnPage != null) {
      // A CAPPED page means something between this window's start and the page
      // bottom was not inspected. The walk/backlog machinery must cover it, so
      // the bookkeeping may only move in the SAFE direction:
      //   * the FLOOR (`pendingSince`) may only ever be LOWERED - raising it
      //     would declare unread history as handled, and the abandoned region
      //     would never be visited again (silent, permanent loss);
      //   * the CURSOR (`walkCursor`) may be RAISED - everything above it was
      //     already inspected and the walk is idempotent, so re-descending from
      //     there guarantees the region left unread by this page gets covered.
      final floor = _minDate(
        state.pendingSince,
        since ?? DateTime.fromMillisecondsSinceEpoch(0),
      )!;
      final cursor = _maxDate(state.walkCursor, page.oldestSeenOnPage!)!;
      next = state.copyWith(
        lastProcessedAt: newest,
        pendingSince: floor,
        walkCursor: cursor,
        pagesScanned: state.pagesScanned + 1,
        updatedAt: DateTime.now(),
      );
      logInfo('SMS_INCREMENTAL_BACKLOG_DETECTED pending_since='
          '${floor.toIso8601String()} cursor=${cursor.toIso8601String()}');
    } else {
      next = state.copyWith(
        lastProcessedAt: newest,
        pagesScanned: state.pagesScanned + 1,
        updatedAt: DateTime.now(),
      );
    }
    await _commit(userId, next, page, startedAt, 'SMS_INCREMENTAL');
    return page;
  }

  /// Persists the watermark, emits the aggregate diagnostics line and notifies
  /// the app when NEW transactions were stored.
  Future<void> _commit(
    String userId,
    SmsSyncState next,
    SmsIngestionResult page,
    DateTime startedAt,
    String tag,
  ) async {
    _stateCache[userId] = next;
    await syncStateStore.write(userId, next);
    _scansCompleted++;
    logInfo('SMS_SCAN_APPLIED tag=$tag '
        'mode=${next.historyComplete ? "incremental" : "walking"} '
        'inspected=${page.scanned} eligible=${page.eligible} '
        'new=${page.newlyProcessed} already=${page.alreadyProcessed} '
        'nonBank=${page.skippedNonBank} parseFailures=${page.parseFailures} '
        'errors=${page.errors} '
        'duration_ms=${DateTime.now().difference(startedAt).inMilliseconds}');
    if (page.transactionsCreated > 0) {
      logInfo(
          'SMS_NEW_TRANSACTIONS count=${page.transactionsCreated} tag=$tag');
      onTransactionsCreated?.call(page.transactionsCreated);
    }
  }

  /// Loads the watermark for [userId] and applies the processed-SMS LEDGER as a
  /// floor: the newest message the ledger already contains is the safest known
  /// cursor, so a lost/rolled-back preference can never cause a re-scan from
  /// scratch (or a skip).
  Future<SmsSyncState> _loadState(String userId) async {
    var state = _stateCache[userId] ?? await syncStateStore.read(userId);
    // CLOCK / TIMESTAMP RECOVERY. A cursor that sits BEYOND the current clock
    // (device clock moved backwards, a sender timestamp in the future, a
    // restored backup with future dates) pushes every incremental window start
    // into the future, so newly arriving SMS could never be seen again. Such a
    // cursor is unusable and is dropped: the next scan reads without a lower
    // bound, the processed-SMS ledger skips what is already handled, and the
    // walk/backlog machinery re-covers any gap - no message is missed and no
    // transaction is duplicated.
    final wall = DateTime.now().add(incrementalOverlap);
    if (state.lastProcessedAt != null && state.lastProcessedAt!.isAfter(wall)) {
      logWarning('SMS_CURSOR_BEYOND_CLOCK cursor='
          '${state.lastProcessedAt!.toIso8601String()} '
          'wall=${wall.toIso8601String()} -> cursor dropped');
      state = state.copyWith(clearLastProcessedAt: true);
    }
    final ledgerNewest = await _ledgerLatest(userId);
    // The ledger floor is a safety net, NEVER a step into the future.
    if (ledgerNewest != null &&
        !ledgerNewest.isAfter(wall) &&
        (state.lastProcessedAt == null ||
            ledgerNewest.isAfter(state.lastProcessedAt!))) {
      state = state.copyWith(lastProcessedAt: ledgerNewest);
    }
    _stateCache[userId] = state;
    return state;
  }

  Future<DateTime?> _ledgerLatest(String userId) async {
    final ledger = processedSmsLocalDataSource;
    if (ledger == null) return null;
    try {
      return await ledger.latestReceivedAt(userId);
    } catch (e) {
      logDebug('SMS_LEDGER_CURSOR unavailable (${e.runtimeType})');
      return null;
    }
  }

  /// Runtime bank catalog (best effort — the parser also matches statically).
  Future<List<Bank>> _resolveBanks() async {
    try {
      return await resolveKnownBanks().timeout(_catalogTimeout);
    } catch (e) {
      logError('SMS_SCAN catalog unavailable, using static fallback', e);
      return const <Bank>[];
    }
  }

  static DateTime? _maxDate(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  static DateTime? _minDate(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isBefore(b) ? a : b;
  }

  static SmsIngestionResult _empty({int errors = 0}) => SmsIngestionResult(
        scanned: 0,
        transactionsCreated: 0,
        duplicatesOrSkipped: 0,
        errors: errors,
      );
}
