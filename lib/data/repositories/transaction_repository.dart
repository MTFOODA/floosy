import '../../domain/repositories/transaction_repository.dart' as domain;
import 'dart:async';

import '../../domain/entities/transaction_model.dart';
import '../remote/datasources/transaction_remote_datasource.dart';
import '../local/datasources/transaction_local_datasource.dart';
import '../remote/datasources/money_remote_datasource.dart';
import '../remote/datasources/sms_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class TransactionRepository implements domain.TransactionRepository {
  final SmsRemoteDataSource? _smsRemoteDataSource;
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;
  final MoneyRemoteDataSource? _moneyRemoteDataSource;
  final Future<void> Function(String transactionId)?
      _deleteTransactionMovements;
  final Future<void> Function(String transactionId)? _detachSmsTransaction;
  final Future<void> Function(Transaction previous, Transaction next)?
      _reconcileTransactionMovements;

  TransactionRepository(
    this._remoteDataSource,
    this._localDataSource, {
    Future<void> Function(String transactionId)? deleteTransactionMovements,
    Future<void> Function(String transactionId)? detachSmsTransaction,
    Future<void> Function(Transaction previous, Transaction next)?
        reconcileTransactionMovements,
    MoneyRemoteDataSource? moneyRemoteDataSource,
    SmsRemoteDataSource? smsRemoteDataSource,
  })  : _deleteTransactionMovements = deleteTransactionMovements,
        _detachSmsTransaction = detachSmsTransaction,
        _reconcileTransactionMovements = reconcileTransactionMovements,
        _moneyRemoteDataSource = moneyRemoteDataSource,
        _smsRemoteDataSource = smsRemoteDataSource;

  /// Network timeout for remote reads. A hung Supabase request must never
  /// hold up a screen load or the SMS pipeline's local write transaction.
  static const Duration _remoteReadTimeout = Duration(seconds: 10);
  static const Duration _remoteWriteTimeout = Duration(seconds: 15);

  /// Used inside a larger local ledger transaction. No network work here.
  @override
  Future<void> insertLocally(Transaction transaction) =>
      _localDataSource.insertTransaction(transaction);

  @override
  Future<bool> mirrorCreatedTransaction(Transaction transaction) async {
    try {
      await _remoteDataSource
          .createTransaction(transaction)
          .timeout(_remoteWriteTimeout);
      return true;
    } catch (e) {
      logError(
          'TRANSACTION_REMOTE_WRITE_FAILED stage=create id=${transaction.id}',
          e);
      return false;
    }
  }

  /// Create a new transaction (first locally, then sync to Supabase).
  @override
  Future<Transaction> createTransaction({
    required Transaction transaction,
  }) async {
    // Save locally first for offline-first. The local row is the source of
    // truth — a remote failure must never abort the SMS pipeline.
    await _localDataSource.insertTransaction(transaction);

    try {
      // Sync to remote
      final remoteTransaction = await _remoteDataSource
          .createTransaction(transaction)
          .timeout(_remoteWriteTimeout);
      return remoteTransaction;
    } catch (e) {
      // If remote fails, the row is still saved locally and will be retried
      // on the next sync. Never swallow this silently (stage + identity +
      // error type) — this is how the missing transfer_in/transfer_out enum
      // values in Supabase went unnoticed.
      logError(
          'TRANSACTION_REMOTE_WRITE_FAILED stage=create '
          'id=${transaction.id} fingerprint=${transaction.fingerprint}',
          e);
      return transaction;
    }
  }

  /// Get transactions from the local store (the single source of truth),
  /// optionally syncing remote rows INTO the local cache first.
  ///
  /// FIX: this used to return the REMOTE list whenever the sync query
  /// succeeded, so any locally-saved SMS transaction that had failed to
  /// reach Supabase (e.g. enum value rejected remotely) made the entire
  /// Transactions page appear empty. The local store is always the base;
  /// remote rows are merged into it.
  @override
  Future<List<Transaction>> getTransactions({
    required String userId,
    bool syncWithRemote = true,
    int limit = 100,
  }) async {
    // Local rows first — offline-safe, never lost.
    var transactions = await _localDataSource.getTransactionsByUserId(userId);

    if (!syncWithRemote) return transactions;

    try {
      // Fetch from remote and merge into the local store.
      final remoteTransactions = await _remoteDataSource
          .getTransactions(userId: userId, limit: limit)
          .timeout(_remoteReadTimeout);

      // ANR FIX: index the LOCAL rows we already loaded by fingerprint —
      // one map lookup per remote row replaces the previous per-row
      // fingerprint SELECT, and unchanged rows are no longer rewritten.
      // Opening the Transactions page previously issued up to 2 extra SQL
      // statements (SELECT + INSERT/UPDATE) per remote row — with a 200-row
      // remote page that was ~400 statements of UI-isolate database churn
      // on every screen entry. Merge semantics are unchanged: new remote
      // rows are inserted, changed rows are updated, local-only rows stay.
      final localByFingerprint = {
        for (final t in transactions) t.fingerprint: t,
      };

      for (final transaction in remoteTransactions) {
        final existing = localByFingerprint[transaction.fingerprint];

        if (existing == null) {
          await _localDataSource.insertTransaction(transaction);
          localByFingerprint[transaction.fingerprint] = transaction;
        } else if (_differsFromRemote(existing, transaction)) {
          await _localDataSource.updateTransaction(transaction);
          localByFingerprint[transaction.fingerprint] = transaction;
        }
      }

      // Re-read from local so BOTH remote rows and local-only rows appear.
      transactions = await _localDataSource.getTransactionsByUserId(userId);
    } catch (e) {
      // Sync failed (offline / Supabase error / hang) — return local cache.
      logError(
          'TRANSACTION_SYNC_FAILED stage=remote_read '
          'falling back to local cache',
          e);
    }

    return transactions;
  }

  /// True when [local] differs from [remote] in any field the local
  /// [TransactionLocalDataSource.updateTransaction] actually writes. Rows
  /// that only differ in locally-owned metadata (id, card linkage, created/
  /// updated timestamps) are considered equal and are NOT rewritten.
  static bool _differsFromRemote(Transaction local, Transaction remote) {
    bool differs() {
      if (local.type != remote.type) return true;
      if (local.source != remote.source) return true;
      if (local.amountMinor != remote.amountMinor) return true;
      if (local.currency != remote.currency) return true;
      // isAtSameMomentAs compares instants, so a UTC remote timestamp equals
      // its local-time representation.
      if (!local.transactionDate.isAtSameMomentAs(remote.transactionDate)) {
        return true;
      }
      if (local.status != remote.status) return true;
      if (local.merchantName != remote.merchantName) return true;
      if (local.categoryId != remote.categoryId) return true;
      if (local.merchantId != remote.merchantId) return true;
      if (local.notes != remote.notes) return true;
      return false;
    }

    return differs();
  }

  /// Check for duplicate transaction by fingerprint
  @override
  Future<bool> isDuplicateTransaction({
    required String userId,
    required String fingerprint,
  }) async {
    final existing = await _localDataSource.getTransactionByFingerprint(
      userId,
      fingerprint,
    );
    return existing != null;
  }

  /// Update a transaction
  ///
  /// The local Drift write is the authoritative step and always happens first.
  ///
  /// [syncRemote] lets a caller that must return immediately (the Edit -> Save
  /// flow) commit locally and mirror to Supabase afterwards via
  /// [mirrorTransactionInBackground]. The remote write is best-effort by design:
  /// a failure is logged and the committed local row stands.
  @override
  Future<void> updateTransaction({
    required Transaction transaction,
    bool syncRemote = true,
  }) async {
    final matching = (await _localDataSource.getTransactionsByUserId(
      transaction.userId,
    ))
        .where((row) => row.id == transaction.id)
        .toList();
    final previous = matching.isEmpty ? null : matching.first;
    await _localDataSource.updateTransaction(transaction);

    // Rebuild transaction-referenced ledger effects. This keeps derived
    // balances authoritative when amount, type, status, or account changes.
    if (previous != null &&
        (previous.amountMinor != transaction.amountMinor ||
            previous.type != transaction.type ||
            previous.status != transaction.status ||
            previous.currency != transaction.currency)) {
      await _reconcileTransactionMovements?.call(previous, transaction);
    }

    if (!syncRemote) return;
    await _mirrorTransaction(transaction);
  }

  /// Mirrors [transaction] to Supabase without blocking the caller.
  ///
  /// Used by the edit/save path once the local commit is done and the UI has
  /// already been refreshed, so network latency is never on the critical path.
  @override
  void mirrorTransactionInBackground(Transaction transaction) {
    unawaited(_mirrorTransaction(transaction));
  }

  Future<void> _mirrorTransaction(Transaction transaction) async {
    try {
      await _remoteDataSource
          .updateTransaction(transaction)
          .timeout(_remoteWriteTimeout);
    } catch (e) {
      logError('TRANSACTION_REMOTE_UPDATE_FAILED id=${transaction.id}', e);
    }
  }

  /// Re-asserts the confirmed card identity on a committed transaction row.
  ///
  /// This is the repair half of the "re-read the transaction after commit to
  /// verify" step: if any later write restored the stale `card_id` or dropped the
  /// confirmed `card_last4`, this puts the user's explicit confirmation back.
  ///
  /// Only `card_last4` and `card_id` are written — the rest of the row is left
  /// exactly as committed, so the repair can never resurrect other stale fields
  /// from the pre-edit object. The remote mirror is fire-and-forget: a repair
  /// that failed remotely must still leave the local database correct.
  @override
  Future<void> restoreCardIdentity({
    required Transaction transaction,
    required String? cardId,
    required String? last4,
  }) async {
    await _localDataSource.updateTransactionCardIdentity(
      transaction.id,
      cardId: cardId,
      cardLast4: last4,
    );
    unawaited(_mirrorTransaction(transaction.copyWith(
      cardId: cardId,
      cardLast4: last4,
    )));
  }

  /// Delete a transaction
  @override
  Future<void> deleteTransaction({
    required String transactionId,
  }) async {
    await _deleteTransactionMovements?.call(transactionId);
    await _detachSmsTransaction?.call(transactionId);
    try {
      await _moneyRemoteDataSource?.deleteTransactionMovements(transactionId);
      await _smsRemoteDataSource?.deleteTransactionReferences(transactionId);
    } catch (e) {
      logError(
          'TRANSACTION_REMOTE_MOVEMENT_DELETE_FAILED id=$transactionId', e);
    }
    await _localDataSource.deleteTransaction(transactionId);

    try {
      await _remoteDataSource.deleteTransaction(transactionId);
    } catch (e) {
      logError('Failed to delete transaction remotely: $e');
    }
  }

  /// Get monthly transactions
  @override
  Future<List<Transaction>> getMonthlyTransactions({
    required String userId,
    required int year,
    required int month,
  }) async {
    return await _localDataSource.getTransactionsByMonth(userId, year, month);
  }

  /// Get transactions within the given date range (inclusive bounds).
  ///
  /// Null bounds mean unbounded in that direction. Always filters from the
  /// local store (the authoritative transaction ledger). Range change never
  /// triggers SMS re-detection — transactions are simply shown/hidden by the
  /// current Detection Range (requirement #16).
  @override
  Future<List<Transaction>> getTransactionsByRange({
    required String userId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    bool syncWithRemote = true,
    int limit = 100,
  }) async {
    // Local rows first — offline-safe, never lost.
    var transactions = await _localDataSource.getTransactionsByRange(userId,
        startDateTime: startDateTime, endDateTime: endDateTime);

    if (!syncWithRemote) return transactions;

    try {
      final remoteTransactions = await _remoteDataSource
          .getTransactions(userId: userId, limit: limit)
          .timeout(_remoteReadTimeout);

      // Merge remote rows into local, then re-read from local so BOTH remote
      // rows and local-only rows appear (same semantics as getTransactions).
      final localByFingerprint = {
        for (final t in transactions) t.fingerprint: t,
      };

      for (final transaction in remoteTransactions) {
        final existing = localByFingerprint[transaction.fingerprint];
        if (existing == null) {
          await _localDataSource.insertTransaction(transaction);
          localByFingerprint[transaction.fingerprint] = transaction;
        } else if (_differsFromRemote(existing, transaction)) {
          await _localDataSource.updateTransaction(transaction);
          localByFingerprint[transaction.fingerprint] = transaction;
        }
      }

      transactions = await _localDataSource.getTransactionsByRange(userId,
          startDateTime: startDateTime, endDateTime: endDateTime);
    } catch (e) {
      logError(
          'TRANSACTION_SYNC_FAILED stage=remote_read '
          'falling back to local cache',
          e);
    }

    return transactions;
  }
}
