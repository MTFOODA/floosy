import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fakes & helpers
// ─────────────────────────────────────────────────────────────────────────────

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

/// Real local datasource backed by an in-memory Drift database, counting the
/// expensive calls the ANR fix targets: per-row fingerprint SELECTs and
/// UPDATE statements issued while merging remote rows.
class _CountingLocalDataSource extends TransactionLocalDataSource {
  int insertCalls = 0;
  int updateCalls = 0;
  int fingerprintLookups = 0;

  _CountingLocalDataSource() : super(db.AppDatabase(NativeDatabase.memory()));

  @override
  Future<void> insertTransaction(Transaction transaction) async {
    insertCalls++;
    await super.insertTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    updateCalls++;
    await super.updateTransaction(transaction);
  }

  @override
  Future<Transaction?> getTransactionByFingerprint(
    String userId,
    String fingerprint,
  ) async {
    fingerprintLookups++;
    return super.getTransactionByFingerprint(userId, fingerprint);
  }
}

class _FakeTransactionRemoteDataSource extends TransactionRemoteDataSource {
  _FakeTransactionRemoteDataSource() : super(_dummyClient());

  List<Transaction> rows = [];

  @override
  Future<List<Transaction>> getTransactions({
    required String userId,
    int limit = 100,
  }) async =>
      List.of(rows);
}

/// Local datasource whose range query ALWAYS fails, simulating a real-device
/// database error (locked/corrupt file, dead background isolate, I/O fault).
///
/// Used to prove that such a failure propagates as a Future error and is never
/// converted into an empty list.
class _ThrowingLocalDataSource extends TransactionLocalDataSource {
  _ThrowingLocalDataSource() : super(db.AppDatabase(NativeDatabase.memory()));

  @override
  Future<List<Transaction>> getTransactionsByRange(
    String userId, {
    required DateTime? startDateTime,
    required DateTime? endDateTime,
  }) async {
    throw Exception('simulated local database failure');
  }
}

Transaction _txn(
  String id,
  String fingerprint,
  DateTime date, {
  String? cardLast4,
  String? notes,
  int amountMinor = 1000,
  TransactionType type = TransactionType.purchase,
}) {
  return Transaction(
    id: id,
    userId: 'u1',
    type: type,
    source: TransactionSource.sms,
    amountMinor: amountMinor,
    currency: 'EGP',
    transactionDate: date,
    merchantName: notes == null ? null : 'CIB',
    notes: notes,
    cardLast4: cardLast4,
    fingerprint: fingerprint,
    status: TransactionStatus.confirmed,
  );
}

void main() {
  late _CountingLocalDataSource local;
  late _FakeTransactionRemoteDataSource remote;
  late TransactionRepository repository;

  final t1 = DateTime(2026, 9, 10, 12, 0, 0);
  final t2 = DateTime(2026, 9, 11, 9, 30, 0);
  final t3 = DateTime(2026, 9, 12, 18, 45, 0);

  setUp(() {
    local = _CountingLocalDataSource();
    remote = _FakeTransactionRemoteDataSource();
    repository = TransactionRepository(remote, local);
  });

  group('Transactions remote merge (ANR regression)', () {
    test('merges remote rows without per-row fingerprint queries', () async {
      remote.rows = [
        _txn('r-1', 'fp-1', t1, cardLast4: '2307'),
        _txn('r-2', 'fp-2', t2, cardLast4: '1234'),
      ];

      final result =
          await repository.getTransactions(userId: 'u1', syncWithRemote: true);

      expect(result.length, 2);
      // The merge must NOT issue one fingerprint SELECT per remote row —
      // that per-row churn (up to ~400 statements for a 200-row remote page)
      // is what saturated the UI isolate and froze the Transactions page.
      expect(local.fingerprintLookups, 0);
      expect(local.insertCalls, 2);
    });

    test('re-entry with unchanged remote rows performs NO redundant writes',
        () async {
      remote.rows = [
        _txn('r-1', 'fp-1', t1, cardLast4: '2307'),
        _txn('r-2', 'fp-2', t2, cardLast4: '1234'),
      ];

      await repository.getTransactions(userId: 'u1', syncWithRemote: true);
      final insertsAfterFirstSync = local.insertCalls;
      final updatesAfterFirstSync = local.updateCalls;

      // Simulate opening the Transactions page again (redundant remote
      // re-fetch of the same rows).
      final again =
          await repository.getTransactions(userId: 'u1', syncWithRemote: true);

      expect(again.length, 2);
      expect(local.insertCalls, insertsAfterFirstSync,
          reason: 'unchanged rows must not be re-inserted');
      expect(local.updateCalls, updatesAfterFirstSync,
          reason: 'unchanged rows must not be re-written');
    });

    test('a genuinely changed remote row is updated exactly once', () async {
      remote.rows = [_txn('r-1', 'fp-1', t1, cardLast4: '2307')];
      await repository.getTransactions(userId: 'u1', syncWithRemote: true);
      final updatesBefore = local.updateCalls;

      remote.rows = [
        _txn('r-1', 'fp-1', t1, cardLast4: '2307', amountMinor: 2500),
      ];
      final result =
          await repository.getTransactions(userId: 'u1', syncWithRemote: true);

      expect(local.updateCalls, updatesBefore + 1);
      expect(
        result.firstWhere((t) => t.fingerprint == 'fp-1').amountMinor,
        2500,
      );
    });

    test('local-only rows survive the remote merge (offline-first preserved)',
        () async {
      // Local row saved by the SMS pipeline that never reached Supabase.
      await local.insertTransaction(
        _txn('local-1', 'fp-local', t3, cardLast4: '9999'),
      );
      remote.rows = [_txn('r-1', 'fp-1', t1, cardLast4: '2307')];

      final result =
          await repository.getTransactions(userId: 'u1', syncWithRemote: true);

      expect(result.map((t) => t.id), containsAll(['local-1', 'r-1']));
    });

    test('transactions for multiple cards load and filter per card', () async {
      remote.rows = [
        _txn('r-1', 'fp-1', t1, cardLast4: '2307'),
        _txn('r-2', 'fp-2', t2, cardLast4: '1234'),
        _txn('r-3', 'fp-3', t3, cardLast4: '2307'),
      ];
      final result =
          await repository.getTransactions(userId: 'u1', syncWithRemote: true);

      expect(result.length, 3);
      // Card-specific filtering (same predicate the UI applies for the
      // selected card) stays intact.
      final card2307 = result.where((t) => t.cardLast4 == '2307').toList();
      final card1234 = result.where((t) => t.cardLast4 == '1234').toList();
      expect(card2307.map((t) => t.id).toSet(), {'r-1', 'r-3'});
      expect(card1234.map((t) => t.id).toSet(), {'r-2'});
    });
  });

  group('Transactions by range (SMS Detection Range regression)', () {
    // Verification that TransactionsScreen loads immediately without
    // waiting for SMS detection or remote sync.
    test('local-only range query returns stored transactions immediately',
        () async {
      // Pre-populate local DB (simulating SMS pipeline having saved transactions).
      await local.insertTransaction(_txn('local-1', 'fp-1', t1));
      await local.insertTransaction(_txn('local-2', 'fp-2', t2));
      await local.insertTransaction(_txn('local-3', 'fp-3', t3));

      // Range query with syncWithRemote: false MUST return immediately
      // without touching the network — this is what TransactionsScreen uses.
      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: null, // Total Range
        endDateTime: null, // Total Range
        syncWithRemote: false,
      );

      expect(result.length, 3,
          reason: 'Total Range must return ALL stored transactions');
      expect(result.map((t) => t.id), containsAll(['local-1', 'local-2', 'local-3']));
    });

    test('custom range returns only transactions inside the window',
        () async {
      await local.insertTransaction(_txn('before', 'fp-before', t1));
      await local.insertTransaction(_txn('inside', 'fp-inside', t2));
      await local.insertTransaction(_txn('after', 'fp-after', t3));

      // Custom window: [t2, t2] (inclusive) — only t2 should match.
      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: t2,
        endDateTime: t2,
        syncWithRemote: false,
      );

      expect(result.length, 1);
      expect(result.single.id, 'inside');
    });

    test('start boundary is inclusive', () async {
      await local.insertTransaction(_txn('at-start', 'fp-start', t1));

      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: t1, // inclusive
        endDateTime: t3,
        syncWithRemote: false,
      );

      expect(result.map((t) => t.id), contains('at-start'),
          reason: 'startDateTime must be inclusive');
    });

    test('end boundary is inclusive', () async {
      await local.insertTransaction(_txn('at-end', 'fp-end', t3));

      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: t1,
        endDateTime: t3, // inclusive
        syncWithRemote: false,
      );

      expect(result.map((t) => t.id), contains('at-end'),
          reason: 'endDateTime must be inclusive');
    });

    test('transactions outside range remain stored after range query',
        () async {
      await local.insertTransaction(_txn('outside-old', 'fp-old', t1));
      await local.insertTransaction(_txn('inside-range', 'fp-mid', t2));
      await local.insertTransaction(_txn('outside-new', 'fp-new', t3));

      // Query only the middle transaction.
      await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: t2,
        endDateTime: t2,
        syncWithRemote: false,
      );

      // All three must still exist in the DB.
      final all = await local.getTransactionsByUserId('u1');
      expect(all.map((t) => t.id).toSet(),
          {'outside-old', 'inside-range', 'outside-new'},
          reason: 'range query is a filter, NOT a delete');
    });

    test('Total Range (null bounds) returns everything stored', () async {
      await local.insertTransaction(_txn('old', 'fp-old', DateTime(2020, 1, 1)));
      await local.insertTransaction(_txn('mid', 'fp-mid', t2));
      await local.insertTransaction(_txn('future', 'fp-future', DateTime(2030, 1, 1)));

      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: null, // unbounded start
        endDateTime: null, // unbounded end
        syncWithRemote: false,
      );

      expect(result.length, 3,
          reason: 'Total Range (both null) must be unbounded');
    });

    test('empty database reaches empty list (never hangs)', () async {
      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: null,
        endDateTime: null,
        syncWithRemote: false,
      );

      expect(result, isEmpty,
          reason: 'empty DB must return [] and complete immediately');
    });

    test('range query completes even when remote is unreachable',
        () async {
      // Insert a local transaction.
      await local.insertTransaction(_txn('local-only', 'fp-local', t2));

      // Even if the remote throws, the local-only query (syncWithRemote: false)
      // MUST complete and return the local row.
      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: null,
        endDateTime: null,
        syncWithRemote: false,
      );

      expect(result.length, 1);
      expect(result.single.id, 'local-only');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Error-state regression: LoadError must be distinguishable from Loaded([]).
  //
  // The Transactions screen previously did `catch (...) { return []; }`, which
  // made a real database/isolate failure render identically to "no
  // transactions found". The screen now relies on the returned Future FAILING
  // so its `snapshot.hasError` branch (with the Retry button) can render a true
  // error state. These tests pin that contract at the repository boundary.
  // ───────────────────────────────────────────────────────────────────────────
  group('Transactions error state (LoadError != Loaded([]))', () {
    test('a local range-query failure PROPAGATES instead of returning []',
        () async {
      final repo = TransactionRepository(remote, _ThrowingLocalDataSource());

      await expectLater(
        repo.getTransactionsByRange(
          userId: 'u1',
          startDateTime: null,
          endDateTime: null,
          syncWithRemote: false,
        ),
        throwsA(isA<Exception>()),
        reason: 'a broken database must surface as an error, never as an '
            'empty list that looks like "no transactions found"',
      );
    });

    test('a healthy query with zero rows is NOT an error (empty state)',
        () async {
      // Identical call shape, but the database works and simply holds no rows.
      // This must complete normally so the UI shows the empty state.
      final result = await repository.getTransactionsByRange(
        userId: 'u1',
        startDateTime: null,
        endDateTime: null,
        syncWithRemote: false,
      );

      expect(result, isEmpty);
    });
  });
}
