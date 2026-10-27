import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_logger.dart';

/// Persistent ingestion watermark for the bank/wallet SMS pipeline.
///
/// This is what makes "first scan reads history, every later scan reads only
/// NEW SMS" reliable across app restarts:
///
///  * [historyComplete] — the one-time historical walk reached the OLDEST
///    available inbox message. Until this is true the pipeline keeps walking
///    backwards, one bounded page per scan, so a huge inbox never blocks the
///    UI in a single pass.
///  * [walkCursor] — exclusive upper bound of the next backward page
///    ("strictly older than this"). Because the native query is
///    `DATE <= walkCursor ORDER BY DATE DESC`, a message that arrives *while*
///    the walk runs is still picked up by the next page — an ongoing
///    historical walk can never skip a new SMS.
///  * [pendingSince] — lower bound of an unfinished backward walk of a newly
///    arrived BACKLOG (more new messages than one incremental page). Without it
///    a burst larger than one page could advance the cursor past messages that
///    were never inspected.
///  * [lastProcessedAt] — newest message timestamp already handled; the anchor
///    for incremental scans. A timestamp ALONE is never treated as sufficient
///    identity: a bounded overlap is re-inspected, and the processed-SMS ledger
///    plus the transaction fingerprint remain the authoritative dedupe layers.
///
/// Stored per user id, so two accounts on one device never share a cursor.
class SmsSyncState {
  final bool historyComplete;
  final DateTime? walkCursor;
  final DateTime? pendingSince;
  final DateTime? lastProcessedAt;
  final int pagesScanned;
  final DateTime? updatedAt;

  const SmsSyncState({
    this.historyComplete = false,
    this.walkCursor,
    this.pendingSince,
    this.lastProcessedAt,
    this.pagesScanned = 0,
    this.updatedAt,
  });

  /// Nothing scanned yet: the next scan is the FIRST (historical) scan.
  static const SmsSyncState empty = SmsSyncState();

  /// True while a bounded backward walk is still unfinished (either the
  /// historical baseline or a drained backlog).
  bool get isWalking => !historyComplete || pendingSince != null;

  /// Inclusive lower bound for the next INCREMENTAL inbox query.
  DateTime? incrementalSince(Duration overlap) =>
      lastProcessedAt?.subtract(overlap);

  SmsSyncState copyWith({
    bool? historyComplete,
    DateTime? walkCursor,
    bool clearWalkCursor = false,
    DateTime? pendingSince,
    bool clearPendingSince = false,
    DateTime? lastProcessedAt,
    bool clearLastProcessedAt = false,
    int? pagesScanned,
    DateTime? updatedAt,
  }) {
    return SmsSyncState(
      historyComplete: historyComplete ?? this.historyComplete,
      walkCursor: clearWalkCursor ? null : (walkCursor ?? this.walkCursor),
      pendingSince:
          clearPendingSince ? null : (pendingSince ?? this.pendingSince),
      lastProcessedAt: clearLastProcessedAt
          ? null
          : (lastProcessedAt ?? this.lastProcessedAt),
      pagesScanned: pagesScanned ?? this.pagesScanned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() => {
        'historyComplete': historyComplete,
        'walkCursor': walkCursor?.toIso8601String(),
        'pendingSince': pendingSince?.toIso8601String(),
        'lastProcessedAt': lastProcessedAt?.toIso8601String(),
        'pagesScanned': pagesScanned,
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory SmsSyncState.fromJson(Map<String, dynamic> json) {
    DateTime? parse(Object? raw) =>
        raw is String && raw.isNotEmpty ? DateTime.tryParse(raw) : null;
    return SmsSyncState(
      historyComplete: json['historyComplete'] == true,
      walkCursor: parse(json['walkCursor']),
      pendingSince: parse(json['pendingSince']),
      lastProcessedAt: parse(json['lastProcessedAt']),
      pagesScanned: (json['pagesScanned'] as num?)?.toInt() ?? 0,
      updatedAt: parse(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SmsSyncState &&
      other.historyComplete == historyComplete &&
      other.walkCursor == walkCursor &&
      other.pendingSince == pendingSince &&
      other.lastProcessedAt == lastProcessedAt &&
      other.pagesScanned == pagesScanned;

  @override
  int get hashCode => Object.hash(
      historyComplete, walkCursor, pendingSince, lastProcessedAt, pagesScanned);

  @override
  String toString() => 'SmsSyncState(historyComplete=$historyComplete, '
      'walkCursor=$walkCursor, pendingSince=$pendingSince, '
      'lastProcessedAt=$lastProcessedAt, pages=$pagesScanned)';
}

/// Persists [SmsSyncState] per user.
///
/// SharedPreferences (the app's existing lightweight persistence path) is used
/// when available. On a platform/test environment where the plugin is missing,
/// the store transparently falls back to an in-memory map so the pipeline keeps
/// working instead of throwing — the cursor then simply does not survive a
/// process restart, and the first scan runs again (safe: the processed-SMS
/// ledger and the transaction fingerprint still prevent duplicates).
class SmsSyncStateStore {
  static const String _keyPrefix = 'floosy_sms_sync_state_';

  final Map<String, SmsSyncState> _memory = {};

  String _key(String userId) => '$_keyPrefix$userId';

  /// Reads the cursor for [userId]; returns [SmsSyncState.empty] when unknown.
  Future<SmsSyncState> read(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(userId));
      if (raw == null || raw.isEmpty) {
        return _memory[userId] ?? SmsSyncState.empty;
      }
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return _memory[userId] ?? SmsSyncState.empty;
      final parsed = SmsSyncState.fromJson(Map<String, dynamic>.from(decoded));
      _memory[userId] = parsed;
      return parsed;
    } catch (e) {
      logWarning('SMS_SYNC_STATE read unavailable (${e.runtimeType}) — '
          'using in-memory cursor');
      return _memory[userId] ?? SmsSyncState.empty;
    }
  }

  /// Writes [state], skipping the write when nothing changed (no needless
  /// platform-channel traffic on every quiet 5-second poll).
  Future<void> write(String userId, SmsSyncState state) async {
    if (_memory[userId] == state) return;
    _memory[userId] = state;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key(userId), jsonEncode(state.toJson()));
    } catch (e) {
      logWarning('SMS_SYNC_STATE write unavailable (${e.runtimeType}) — '
          'cursor kept in memory only');
    }
  }

  /// Clears the cursor for [userId] (used by the data-reset flow so a deleted
  /// transaction history can be re-ingested from scratch).
  Future<void> clear(String userId) async {
    _memory.remove(userId);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key(userId));
    } catch (_) {
      // Nothing persisted — nothing to clear.
    }
  }
}
