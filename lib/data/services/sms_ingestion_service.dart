import 'dart:async';

import '../local/datasources/processed_sms_local_datasource.dart';
import '../remote/datasources/sms_remote_datasource.dart';
import '../models/user_model.dart';
import '../../core/services/sms_inbox_service.dart';
import '../../core/utils/app_logger.dart';
import 'sms_transaction_processor.dart';
import 'sms_parser_service.dart';
import '../models/detection_window.dart';

/// Aggregate result of one inbox scan.
///
/// The [scanned] / [transactionsCreated] / [duplicatesOrSkipped] / [errors]
/// counters keep their historical meaning; the additional optional counters
/// report the *stages* of a historical scan (requirement L) without breaking
/// existing callers or tests.
class SmsIngestionResult {
  final int scanned;
  final int transactionsCreated;
  final int duplicatesOrSkipped;
  final int errors;

  /// Messages that passed the supported-date gate AND the bank/wallet
  /// sender/domain gate (i.e. entered the financial-detection scope).
  final int eligible;

  /// Eligible messages already recorded in the processed ledger (skipped
  /// without re-parsing; requirement F).
  final int alreadyProcessed;

  /// Eligible-but-unprocessed messages that produced a stored transaction.
  final int newlyProcessed;

  /// Messages rejected by the non-financial-sender gate (requirement E).
  final int skippedNonBank;

  /// Eligible messages whose parse produced no storable transaction.
  final int parseFailures;

  /// Number of inbox pages/batches consumed by this scan (requirement D).
  final int pagesConsumed;

  /// True when the inbox signaled more messages remain but the scan hit its
  /// safety cap (requirement D). The caller must surface this.
  final bool truncated;

  /// Oldest message timestamp observed on the LAST page consumed by this
  /// result (pagination cursor). Null when the page was empty or this result
  /// is an aggregate. Internal to the ingestion paginator.
  final DateTime? oldestSeenOnPage;

  /// Newest message timestamp observed on the page (the top of the scanned
  /// region). Used by the polling cursor to advance `lastProcessedAt` without
  /// assuming that a timestamp identifies a message.
  final DateTime? newestSeenOnPage;

  const SmsIngestionResult({
    required this.scanned,
    required this.transactionsCreated,
    required this.duplicatesOrSkipped,
    required this.errors,
    this.eligible = 0,
    this.alreadyProcessed = 0,
    this.newlyProcessed = 0,
    this.skippedNonBank = 0,
    this.parseFailures = 0,
    this.pagesConsumed = 0,
    this.truncated = false,
    this.oldestSeenOnPage,
    this.newestSeenOnPage,
  });

  /// Adds the page/run counters of [other] (same-scan aggregation).
  /// The cursors of the LAST page win (newest = latest instant seen anywhere).
  SmsIngestionResult operator +(SmsIngestionResult other) {
    return SmsIngestionResult(
      scanned: scanned + other.scanned,
      transactionsCreated: transactionsCreated + other.transactionsCreated,
      duplicatesOrSkipped: duplicatesOrSkipped + other.duplicatesOrSkipped,
      errors: errors + other.errors,
      eligible: eligible + other.eligible,
      alreadyProcessed: alreadyProcessed + other.alreadyProcessed,
      newlyProcessed: newlyProcessed + other.newlyProcessed,
      skippedNonBank: skippedNonBank + other.skippedNonBank,
      parseFailures: parseFailures + other.parseFailures,
      pagesConsumed: pagesConsumed + other.pagesConsumed,
      truncated: truncated || other.truncated,
      oldestSeenOnPage: other.oldestSeenOnPage ?? oldestSeenOnPage,
      newestSeenOnPage: _laterOf(newestSeenOnPage, other.newestSeenOnPage),
    );
  }

  static DateTime? _laterOf(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  @override
  String toString() => 'SmsIngestionResult(scanned=$scanned, '
      'created=$transactionsCreated, skipped=$duplicatesOrSkipped, '
      'errors=$errors, eligible=$eligible, already=$alreadyProcessed, '
      'new=$newlyProcessed, nonBank=$skippedNonBank, '
      'parseFail=$parseFailures, pages=$pagesConsumed, '
      'truncated=$truncated)';
}

/// End-to-end SMS ingestion:
///
///   Android inbox → SmsInboxService (retrieval, unfiltered)
///     → SMSTransactionProcessor (classification, dedupe, financial rules)
///
/// A failure on ONE message never stops the scan (requirement #15) — the
/// error is counted and logged, the remaining messages are still processed.
class SmsIngestionService {
  /// The batched sms_messages dedupe check is a fast-path optimization; it
  /// is bounded so a hung network cannot stall a full scan. Injectable for
  /// tests.
  final Duration batchDedupeTimeout;

  final SmsInboxService inboxService;
  final SMSTransactionProcessor processor;
  final SmsRemoteDataSource? smsRemoteDataSource;
  final ProcessedSmsLocalDataSource? processedSmsLocalDataSource;

  SmsIngestionService({
    required this.inboxService,
    required this.processor,
    this.smsRemoteDataSource,
    this.batchDedupeTimeout = const Duration(seconds: 10),
    this.processedSmsLocalDataSource,
  });

  /// Scans the inbox and stores every eligible bank/wallet message.
  ///
  /// SCOPE CONTRACT (SMS INGESTION is not the Transactions DISPLAY filter):
  ///   * Ingestion decides which SMS have already been processed and stored
  ///     permanently. It is deliberately NOT scoped by any UI date filter: a
  ///     display filter must never hide a message from ingestion, and changing
  ///     a display filter must never trigger a re-scan of old SMS.
  ///   * [since] is the persistent scan cursor: only messages received at/after
  ///     it are considered NEW. It is pushed down to the NATIVE inbox query
  ///     (`sinceDateMs`), so an incremental scan does not even transfer old
  ///     messages over the platform channel (ANR fix).
  ///   * [before] is the exclusive upper bound used to walk backwards through
  ///     history one bounded page at a time (first-run baseline and backlog
  ///     draining). It is pushed down as `untilDateMs`.
  ///
  /// The processed-SMS ledger stays authoritative: an already processed message
  /// is skipped WITHOUT re-parsing, and the processor keeps its own SMS-hash +
  /// transaction-fingerprint dedupe as layer 2.
  /// Structured per-stage timing for ONE bounded scan page. Logged ONCE per
  /// scan (never per message) so Logcat shows exactly where the 60 s budget
  /// goes: inbox read, local dedupe, remote dedupe, parse/process/DB writes.
  void _logScanStages({
    required DateTime startedAt,
    required DateTime readDoneAt,
    required DateTime localDedupeDoneAt,
    required DateTime remoteDedupeDoneAt,
    required int scanned,
    required int eligible,
    required int alreadyProcessed,
    required int newlyProcessed,
    required int skippedNonBank,
    required int parseFailures,
    required int errors,
    required int transactionsCreated,
    Object? timeoutError,
  }) {
    int ms(DateTime a, DateTime b) => b.difference(a).inMilliseconds;
    logInfo('SMS_SCAN_STAGES '
        'inbox_ms=${ms(startedAt, readDoneAt)} '
        'localDedupe_ms=${ms(readDoneAt, localDedupeDoneAt)} '
        'remoteDedupe_ms=${ms(localDedupeDoneAt, remoteDedupeDoneAt)} '
        'process_ms=${ms(remoteDedupeDoneAt, DateTime.now())} '
        'total_ms=${ms(startedAt, DateTime.now())} '
        'scanned=$scanned eligible=$eligible already=$alreadyProcessed '
        'new=$newlyProcessed nonBank=$skippedNonBank '
        'parseFailures=$parseFailures errors=$errors '
        'created=$transactionsCreated');
    if (timeoutError != null) {
      logError('SMS_SCAN_STAGE_TIMEOUT', timeoutError);
    }
  }

  Future<SmsIngestionResult> scanAndProcess({
    required String userId,
    List<Bank> knownBanks = const [],
    int maxMessages = 200,
    DateTime? since,
    DateTime? before,
  }) async {
    final startedAt = DateTime.now();
    logInfo('SMS_SCAN_START userId=$userId max=$maxMessages '
        'since=${since?.toIso8601String()} before=${before?.toIso8601String()}');

    // Native date filtering for BOTH bounds: an incremental poll transfers only
    // the messages it can actually use.
    final messages = await inboxService.readInbox(
      maxCount: maxMessages,
      sinceDate: since,
      untilDate: before,
    );
    final readDoneAt = DateTime.now();

    var created = 0;
    var skipped = 0;
    var errors = 0;
    var eligible = 0;
    var alreadyProcessed = 0;
    var newlyProcessed = 0;
    var skippedNonBank = 0;
    var parseFailures = 0;
    DateTime? oldestSeen;
    DateTime? newestSeen;

    // Batch dedupe fast-path (local ledger authoritative, remote best effort).
    final dedupHashes = hashesFor(messages);
    final knownHashes = <String>{};
    Object? stageTimeout;
    var localDedupeDoneAt = readDoneAt;
    var remoteDedupeDoneAt = readDoneAt;
    if (dedupHashes.isNotEmpty) {
      try {
        knownHashes.addAll(await knownHashesLocal(userId, dedupHashes));
      } on TimeoutException catch (e) {
        stageTimeout = e;
      }
      localDedupeDoneAt = DateTime.now();
      try {
        knownHashes.addAll(await knownHashesRemote(userId, dedupHashes));
      } on TimeoutException catch (e) {
        stageTimeout = e;
      }
      remoteDedupeDoneAt = DateTime.now();
    }

    for (final message in messages) {
      if (oldestSeen == null || message.date.isBefore(oldestSeen)) {
        oldestSeen = message.date;
      }
      if (newestSeen == null || message.date.isAfter(newestSeen)) {
        newestSeen = message.date;
      }
      try {
        // A missing date is the ONLY date rejection: the 2026-09-01 cutoff is
        // gone, so historical bank/wallet SMS are fully eligible.
        if (!SMSParser.isWithinSupportedDate(message.date)) {
          skipped++;
          continue;
        }
        // Sender/domain gate: only recognized bank/wallet identifiers enter
        // the financial pipeline (ads/OTP/delivery/telecom never do).
        // The gate sees the sender AND the text: messages whose bank identity
        // lives in the BODY (Bank of Alexandria via a numeric/foreign sender)
        // stay eligible, while arbitrary company SMS stay rejected.
        if (!SMSParser.isRecognizedBankOrWalletSender(
          sender: message.sender,
          knownBanks: knownBanks,
          body: message.body,
        )) {
          skippedNonBank++;
          skipped++;
          logDebug('SMS_SKIPPED_UNRECOGNIZED_SENDER sender=${message.sender}');
          continue;
        }
        eligible++;

        // Ledger gate: an already processed message is skipped WITHOUT
        // re-parsing it (requirement: never reread/reparse old SMS).
        if (message.body.isNotEmpty) {
          final hash =
              SMSParser.fingerprintOf('${message.sender}|${message.body}');
          if (hash.isNotEmpty && knownHashes.contains(hash)) {
            alreadyProcessed++;
            skipped++;
            continue;
          }
        }

        final recorded = await processor.process(
          userId: userId,
          smsContent: message.body,
          sender: message.sender,
          knownBanks: knownBanks,
          // The transaction carries the REAL message timestamp (date + time),
          // never the processing instant.
          receivedAt: message.date,
        );
        if (recorded) {
          created++;
          newlyProcessed++;
          logInfo('SMS_TRANSACTION_CREATED sender=${message.sender} '
              'at=${message.date.toIso8601String()}');
        } else {
          parseFailures++;
          skipped++;
          logInfo('TRANSACTION_SKIPPED sender=${message.sender} reason=duplicate_or_unparseable');
        }
      } catch (e) {
        // One malformed message never stops the rest of the scan.
        errors++;
        logError('TRANSACTION_FAILED sender=${message.sender}', e);
      }
    }

    final result = SmsIngestionResult(
      scanned: messages.length,
      transactionsCreated: created,
      duplicatesOrSkipped: skipped,
      errors: errors,
      eligible: eligible,
      alreadyProcessed: alreadyProcessed,
      newlyProcessed: newlyProcessed,
      skippedNonBank: skippedNonBank,
      parseFailures: parseFailures,
      pagesConsumed: messages.isEmpty ? 0 : 1,
      oldestSeenOnPage: oldestSeen,
      newestSeenOnPage: newestSeen,
    );
    logInfo('SMS_SCAN_DONE $result '
        'elapsed_ms=${DateTime.now().difference(startedAt).inMilliseconds}');
    // One aggregate timing line per scan (never per message): pinpoints which
    // pipeline stage owns the 60 s budget on a real device.
    _logScanStages(
      startedAt: startedAt,
      readDoneAt: readDoneAt,
      localDedupeDoneAt: localDedupeDoneAt,
      remoteDedupeDoneAt: remoteDedupeDoneAt,
      scanned: messages.length,
      eligible: eligible,
      alreadyProcessed: alreadyProcessed,
      newlyProcessed: newlyProcessed,
      skippedNonBank: skippedNonBank,
      parseFailures: parseFailures,
      errors: errors,
      transactionsCreated: created,
      timeoutError: stageTimeout,
    );
    return result;
  }

  /// Scans one explicit historical [DetectionWindow] of the inbox for
  /// unprocessed eligible SMS (deliberate historical recall only).
  ///
  /// This is NOT driven by any display filter. Production steady-state
  /// scanning is owned by SmsPollingService (one-time historical walk,
  /// then incremental-only scans); this method exists for deliberate,
  /// bounded historical recalls - e.g. re-checking a suspicious inbox
  /// gap - and for tests of the paginated window behavior.
  ///
  /// PAGINATED: the read/process loop consumes the window in bounded
  /// batches (newest message first) and advances the cursor until the
  /// whole window is exhausted. The local processed ledger
  /// (per-message identity) stays authoritative; the optional [since]
  /// lower bound further restricts the window when only newer messages
  /// inside it matter.
  ///
  /// Per-message processed check: already-processed SMS are SKIPPED (not
  /// re-parsed). Only unprocessed eligible SMS are parsed and persisted.
  Future<SmsIngestionResult> scanRangeExpansion({
    required String userId,
    required List<Bank> knownBanks,
    required DetectionWindow window,
    DateTime? since,
    int pageSize = _defaultExpansionPageSize,
    int maxPages = _defaultExpansionMaxPages,
  }) async {
    logInfo('SMS_RANGE_EXPANSION userId=$userId window=$window since=$since');

    var total = const SmsIngestionResult(
      scanned: 0,
      transactionsCreated: 0,
      duplicatesOrSkipped: 0,
      errors: 0,
    );

    // Bounded history cursor: newest → oldest inside [window]. After each
    // page we narrow `until` to just below the oldest message already seen,
    // so the next page continues where this one stopped (requirement D).
    DateTime? pageUntil = window.end;
    var pages = 0;
    var truncated = false;

    while (true) {
      SmsIngestionResult page;
      try {
        page = await _scanRangeExpansionPage(
          userId: userId,
          knownBanks: knownBanks,
          windowStart: window.start,
          pageUntil: pageUntil,
          since: since,
          pageSize: pageSize,
        );
      } catch (e) {
        // One failed page must not abort the whole historical scan.
        logError('SMS_RANGE_EXPANSION_PAGE_FAILED page=${pages + 1}', e);
        total = total +
            const SmsIngestionResult(
              scanned: 0,
              transactionsCreated: 0,
              duplicatesOrSkipped: 0,
              errors: 1,
              pagesConsumed: 1,
            );
        break;
      }

      total = total + page;
      pages++;

      if (page.pagesConsumed == 0) break; // empty page → window exhausted
      final oldestSeen = page.oldestSeenOnPage;
      if (oldestSeen == null) break;

      // Defensive caps (ANR/OOM guard, requirement D): the window loop can
      // always continue on the next user action — it must never spin forever.
      if (pages >= maxPages) {
        truncated = true;
        logError(
          'SMS_RANGE_EXPANSION_TRUNCATED reached maxPages=$maxPages '
              'window=$window',
          'truncated',
        );
        break;
      }

      // Advance the cursor just below the oldest message already seen so the
      // next page continues strictly older. Clamp to the window start (with a
      // 1-second safety floor) so a degenerate stream of equal timestamps can
      // never loop forever.
      var nextUntil = oldestSeen.subtract(const Duration(milliseconds: 1));
      final floor = window.start;
      if (floor != null && nextUntil.isBefore(floor)) break;
      if (nextUntil.isAtSameMomentAs(pageUntil ?? nextUntil)) break;
      pageUntil = nextUntil;
    }

    if (truncated) {
      total = total +
          const SmsIngestionResult(
            scanned: 0,
            transactionsCreated: 0,
            duplicatesOrSkipped: 0,
            errors: 0,
            pagesConsumed: 0,
            truncated: true,
          );
    }

    logInfo('SMS_RANGE_EXPANSION_DONE userId=$userId window=$window $total');
    return total;
  }

  /// One (chunked) query resolving which of [hashes] are already stored for
  /// [userId] in the LOCAL processed ledger. This is the authoritative
  /// offline-capable dedup source (survives restarts and works completely
  /// offline).
  Future<Set<String>> knownHashesLocal(
    String userId,
    List<String> hashes,
  ) async {
    if (processedSmsLocalDataSource == null || hashes.isEmpty) return {};
    return await processedSmsLocalDataSource!.knownHashes(userId, hashes);
  }

  /// One (chunked) query resolving which of [hashes] are already stored for
  /// [userId] remotely. Extra fast path only - the local ledger is
  /// authoritative, so a failure/timeout here never blocks detection
  /// (offline detection keeps working).
  Future<Set<String>> knownHashesRemote(
    String userId,
    List<String> hashes,
  ) async {
    if (smsRemoteDataSource == null || hashes.isEmpty) return {};
    try {
      return await smsRemoteDataSource!
          .knownMessageHashes(userId, hashes)
          .timeout(batchDedupeTimeout);
    } on TimeoutException catch (e) {
      logError(
          'SMS_BATCH_DEDUPE_TIMEOUT falling back to per-message dedupe', e);
      return {};
    } catch (e) {
      logError('SMS_BATCH_DEDUPE_FAILED falling back to per-message dedupe', e);
      return {};
    }
  }

  static List<String> hashesFor(List<SmsInboxMessage> messages) {
    final out = <String>[];
    for (final m in messages) {
      final h = SMSParser.fingerprintOf('${m.sender}|${m.body}');
      if (h.isNotEmpty) out.add(h);
    }
    return out;
  }

  /// Bounded batch size for ONE historical page (ANR/OOM guard). The native
  /// inbox query caps results anyway, but keeping this explicit documents the
  /// batching contract.
  static const int _defaultExpansionPageSize = 200;

  /// Absolute upper bound on pages consumed per expansion window. 200 pages x
  /// 200 messages = 40,000 SMS per window - far beyond any real inbox, while
  /// guaranteeing the loop can never spin forever.
  static const int _defaultExpansionMaxPages = 200;

  /// Processes ONE bounded page of the window. Returns the page result plus
  /// the oldest/newest message timestamps seen (used by the paginator to
  /// advance the cursor), or a zero-count result when the page is
  /// empty/exhausted.
  Future<SmsIngestionResult> _scanRangeExpansionPage({
    required String userId,
    required List<Bank> knownBanks,
    required DateTime? windowStart,
    required DateTime? pageUntil,
    required DateTime? since,
    required int pageSize,
  }) async {
    // Native date bounds: the platform query filters the window directly.
    final messages = await inboxService.readInbox(
      maxCount: pageSize,
      sinceDate: windowStart,
      untilDate: pageUntil,
    );

    if (messages.isEmpty) {
      return const SmsIngestionResult(
        scanned: 0,
        transactionsCreated: 0,
        duplicatesOrSkipped: 0,
        errors: 0,
      );
    }

    var created = 0;
    var skipped = 0;
    var errors = 0;
    var eligible = 0;
    var alreadyProcessed = 0;
    var newlyProcessed = 0;
    var skippedNonBank = 0;
    var parseFailures = 0;

    // Dedup set: union of local ledger + remote hashes. The LOCAL ledger is
    // the authoritative per-message identity; the remote check is only an
    // extra fast path and must never block detection.
    final dedupHashes = hashesFor(messages);
    final knownHashes = <String>{};
    if (dedupHashes.isNotEmpty) {
      knownHashes.addAll(await knownHashesLocal(userId, dedupHashes));
      try {
        knownHashes.addAll(await knownHashesRemote(userId, dedupHashes));
      } catch (_) {
        // Remote may be offline - local ledger is authoritative
      }
    }

    var oldestSeen = messages.first.date;
    var newestSeen = messages.first.date;
    for (final message in messages) {
      if (message.date.isBefore(oldestSeen)) oldestSeen = message.date;
      if (message.date.isAfter(newestSeen)) newestSeen = message.date;
      try {
        // The sender/domain/bank gate is authoritative. A recognized
        // bank/wallet sender is decided here - never by generic body keywords.
        // The gate sees the sender AND the text (Bank of Alexandria via a
        // numeric/foreign sender stays eligible; arbitrary company SMS stays
        // rejected).
        if (!SMSParser.isRecognizedBankOrWalletSender(
          sender: message.sender,
          knownBanks: knownBanks,
          body: message.body,
        )) {
          skippedNonBank++;
          skipped++;
          continue;
        }

        // Only messages inside the expanded window (inclusive bounds).
        final inWindow =
            (windowStart == null || !message.date.isBefore(windowStart)) &&
                (pageUntil == null || !message.date.isAfter(pageUntil));
        if (!inWindow) {
          skipped++;
          continue;
        }
        eligible++;

        // The processed ledger is authoritative: already processed messages
        // are skipped WITHOUT parsing again.
        final hash =
            SMSParser.fingerprintOf('${message.sender}|${message.body}');
        if (hash.isNotEmpty && knownHashes.contains(hash)) {
          alreadyProcessed++;
          skipped++;
          continue;
        }

        final recorded = await processor.process(
          userId: userId,
          smsContent: message.body,
          sender: message.sender,
          knownBanks: knownBanks,
          receivedAt: message.date,
        );

        if (recorded) {
          created++;
          newlyProcessed++;
        } else {
          // Eligible but not storable (unparseable amount/type etc.) - the
          // processor deliberately skips these; counting continues.
          parseFailures++;
          skipped++;
        }
      } catch (e) {
        // One malformed message / parser exception never stops the remaining
        // messages of the historical scan.
        errors++;
        logError(
          'SMS_EXPANSION_MESSAGE_FAILED sender=${message.sender} '
          'date=${message.date.toIso8601String()}',
          e,
        );
      }
    }

    return SmsIngestionResult(
      scanned: messages.length,
      transactionsCreated: created,
      duplicatesOrSkipped: skipped,
      errors: errors,
      eligible: eligible,
      alreadyProcessed: alreadyProcessed,
      newlyProcessed: newlyProcessed,
      skippedNonBank: skippedNonBank,
      parseFailures: parseFailures,
      pagesConsumed: 1,
      oldestSeenOnPage: oldestSeen,
      newestSeenOnPage: newestSeen,
    );
  }
}
