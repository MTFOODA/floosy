import 'package:drift/drift.dart';
import '../database/app_database.dart' as db;

/// One successfully processed (detected) SMS in the local ledger.
class ProcessedSmsRecord {
  final String id;
  final String userId;
  final String? sender;
  final String messageHash;
  final DateTime receivedAt;
  final String? transactionId;
  final DateTime processedAt;

  const ProcessedSmsRecord({
    required this.id,
    required this.userId,
    required this.messageHash,
    required this.receivedAt,
    this.sender,
    this.transactionId,
    required this.processedAt,
  });
}

/// Local (Drift) storage for the per-message processed-SMS ledger
/// (`processed_sms_messages` table).
///
/// THE authoritative local answer to "Has this exact SMS already been
/// processed?" — the same (user_id, message_hash) identity the remote
/// `sms_messages` table enforces, mirrored locally so dedupe survives app
/// restarts and works completely offline. Written once per successfully
/// detected SMS; range changes never touch it (requirement #15).
class ProcessedSmsLocalDataSource {
  final db.AppDatabase _db;

  ProcessedSmsLocalDataSource(this._db);

  /// Records [record] as processed. Idempotent — the unique
  /// (user_id, message_hash) index makes a re-insert a no-op, so a message
  /// processed twice can never create a duplicate ledger row (and the caller
  /// never has to check first).
  Future<void> markProcessed(ProcessedSmsRecord record) async {
    await _db.into(_db.processedSmsMessages).insert(
          db.ProcessedSmsMessagesCompanion.insert(
            id: record.id,
            userId: record.userId,
            sender: Value(record.sender),
            messageHash: record.messageHash,
            receivedAt: record.receivedAt,
            transactionId: Value(record.transactionId),
            processedAt: Value(record.processedAt),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  /// True when an SMS with [messageHash] was already processed for [userId].
  Future<bool> isProcessed(String userId, String messageHash) async {
    final row = await (_db.select(_db.processedSmsMessages)
          ..where((t) =>
              t.userId.equals(userId) & t.messageHash.equals(messageHash)))
        .getSingleOrNull();
    return row != null;
  }

  /// Batched version of [isProcessed]: ONE (chunked) query resolves which of
  /// [messageHashes] are already processed for [userId]. Used by the
  /// ingestion gate so a scan never re-parses processed messages.
  Future<Set<String>> knownHashes(String userId, List<String> hashes) async {
    final known = <String>{};
    // Chunk the `in` filter to keep the statement well-sized for very
    // large scans.
    const chunkSize = 500;
    for (var i = 0; i < hashes.length; i += chunkSize) {
      final end = (i + chunkSize) > hashes.length ? hashes.length : i + chunkSize;
      final chunk = hashes.sublist(i, end);
      final rows = await (_db.select(_db.processedSmsMessages)
            ..where((t) =>
                t.userId.equals(userId) & t.messageHash.isIn(chunk)))
          .get();
      for (final row in rows) {
        known.add(row.messageHash);
      }
    }
    return known;
  }

  /// Newest `received_at` in the ledger for [userId], or null when empty.
  ///
  /// This is the authoritative, restart-safe, offline "newest processed point"
  /// of the SMS pipeline. The polling service uses it as a floor for its
  /// persisted cursor so a lost/rolled-back SharedPreferences value can never
  /// make the app re-scan (or, worse, skip) messages.
  Future<DateTime?> latestReceivedAt(String userId) async {
    final query = _db.selectOnly(_db.processedSmsMessages)
      ..addColumns([_db.processedSmsMessages.receivedAt.max()])
      ..where(_db.processedSmsMessages.userId.equals(userId));
    final row = await query.getSingleOrNull();
    final value = row?.read(_db.processedSmsMessages.receivedAt.max());
    return value;
  }

  /// Removes the whole processed ledger for [userId] (data-reset flow only).
  Future<int> clearForUser(String userId) async {
    return (_db.delete(_db.processedSmsMessages)
          ..where((t) => t.userId.equals(userId)))
        .go();
  }
}
