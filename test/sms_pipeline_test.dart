import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/services/sms_inbox_service.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/expense_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/detection_window.dart';
import 'package:floosy/data/models/money_model.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/remote/datasources/cash_wallet_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/expense_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/sms_remote_datasource.dart';
import 'package:floosy/data/services/sms_ingestion_service.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/data/services/sms_polling_service.dart';
import 'package:floosy/data/services/sms_sync_state_store.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
import 'package:floosy/features/transactions/presentation/widgets/transaction_widgets.dart'
    show groupTransactionsByDay;
import 'package:supabase_flutter/supabase_flutter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fakes & helpers
// ─────────────────────────────────────────────────────────────────────────────

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

Transaction _txn(String id, DateTime date, {String fingerprint = ''}) {
  return Transaction(
    id: id,
    userId: 'u1',
    type: TransactionType.transfer_out,
    source: TransactionSource.sms,
    amountMinor: 1000,
    currency: 'EGP',
    transactionDate: date,
    fingerprint: fingerprint,
  );
}

const String _faisalBody =
    'تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';

/// Money-repository fake: the SMS pipeline's final write step. Records every
/// recorded transaction so tests can assert the FULL runtime flow
/// (ingestion → parser → processor → repository) without a real database.
/// (The super constructor's Drift stores are never touched — every money
/// method used by the pipeline is overridden — so the drift "multiple
/// databases" warning printed below is harmless test noise.)
class _FakeMoneyRepository extends MoneyRepository {
  final Set<String> _seenFingerprints = {};
  final List<Transaction> recorded = [];
  final List<String?> recordedAccountIds = [];
  List<UserBankAccount> accounts = const [];

  _FakeMoneyRepository()
      : super(
          remote: MoneyRemoteDataSource(_dummyClient()),
          local: MoneyLocalDataSource(db.AppDatabase()),
          transactionRepository: TransactionRepository(
            TransactionRemoteDataSource(_dummyClient()),
            TransactionLocalDataSource(db.AppDatabase()),
          ),
          cashWalletRepository: CashWalletRepository(
            remoteDataSource: CashWalletRemoteDataSource(_dummyClient()),
          ),
          expenseRepository: ExpenseRepository(
            remoteDataSource: ExpenseRemoteDataSource(_dummyClient()),
            localDataSource: ExpenseLocalDataSource(db.AppDatabase()),
          ),
        );

  @override
  Future<List<UserBankAccount>> getBankAccounts(String userId) async =>
      accounts;

  @override
  Future<bool> recordSmsTransaction({
    required String userId,
    required Transaction transaction,
    String? accountId,
  }) async {
    // Same dedupe rule as the real repository (fingerprint idempotency).
    if (transaction.fingerprint.isNotEmpty &&
        _seenFingerprints.contains(transaction.fingerprint)) {
      return false;
    }
    _seenFingerprints.add(transaction.fingerprint);
    recorded.add(transaction);
    recordedAccountIds.add(accountId);
    return true;
  }
}

SMSTransactionProcessor _makeProcessor() {
  return SMSTransactionProcessor(moneyRepository: _FakeMoneyRepository());
}

class _FakeInboxService extends SmsInboxService {
  List<SmsInboxMessage> messages = const [];
  @override
  Future<bool> hasPermissions() async => true;
  @override
  Future<List<SmsInboxMessage>> readInbox({
    int maxCount = 200,
    DateTime? sinceDate,
    DateTime? untilDate,
  }) async {
    var result = messages;
    if (sinceDate != null) {
      result = result.where((m) => !m.date.isBefore(sinceDate)).toList();
    }
    if (untilDate != null) {
      result = result.where((m) => !m.date.isAfter(untilDate)).toList();
    }
    return result;
  }
}

/// Ingestion fake for the polling tests — records how the poller drives the
/// central pipeline (since-filter, single-flight guard, refresh callback).
class _RecordingIngestionService extends SmsIngestionService {
  final List<DateTime?> sinceArgs = [];
  final List<DateTime?> beforeArgs = [];
  final List<Map<String, DateTime>> expansionWindows = [];
  int calls = 0;
  Completer<void>? gate;

  /// When true the NEXT pipeline run fails with errors=1 (simulates a scan
  /// that blew up) and the flag resets — used to test the joiner-retry path.
  bool failNext = false;

  _RecordingIngestionService()
      : super(
          inboxService: SmsInboxService(),
          processor: _makeProcessor(),
        );

  /// Range-expansion runs are recorded so tests can assert that ONLY the
  /// newly relevant historical portion is inspected (requirements #6/#7/#14B).
  @override
  Future<SmsIngestionResult> scanRangeExpansion({
    required String userId,
    required List<Bank> knownBanks,
    required DetectionWindow window,
    DateTime? since,
    int pageSize = 200,
    int maxPages = 200,
  }) async {
    expansionWindows.add({
      'start': window.start ?? DateTime.now(),
      'end': window.end ?? DateTime.now()
    });
    return const SmsIngestionResult(
        scanned: 0, transactionsCreated: 0, duplicatesOrSkipped: 0, errors: 0);
  }

  @override
  Future<SmsIngestionResult> scanAndProcess({
    required String userId,
    List<Bank> knownBanks = const [],
    int maxMessages = 200,
    DateTime? since,
    DateTime? before,
  }) async {
    calls++;
    sinceArgs.add(since);
    beforeArgs.add(before);
    if (failNext) {
      failNext = false;
      // On failure, return an empty result with no cursor (so the caller
      // doesn't advance the watermark past unprocessed messages).
      return SmsIngestionResult(
        scanned: 1,
        transactionsCreated: 0,
        duplicatesOrSkipped: 0,
        errors: 1,
        newestSeenOnPage: since,
      );
    }
    if (gate != null) await gate!.future;
    // The fake pipeline reports created=1 only for the FIRST scan; any later
    // scan finds nothing new (dedupe enforced inside the pipeline).
    // Provide a newestSeenOnPage so the cursor advances in incremental scans.
    final now = DateTime.now();
    return SmsIngestionResult(
      scanned: 1,
      transactionsCreated: calls == 1 ? 1 : 0,
      duplicatesOrSkipped: 0,
      errors: 0,
      newestSeenOnPage: now,
    );
  }
}

SmsPollingService _makePoller(
  _RecordingIngestionService ingestion,
  void Function(int)? onCreated, {
  Duration? scanTimeout,
}) {
  return SmsPollingService(
    ingestion: ingestion,
    resolveUserId: () async => 'u1',
    resolveKnownBanks: () async => const <Bank>[],
    onTransactionsCreated: onCreated,
    scanTimeout: scanTimeout,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Repository read-path fakes (requirement #13/#14)
// ─────────────────────────────────────────────────────────────────────────────

class _FakeTransactionRemoteDataSource extends TransactionRemoteDataSource {
  final List<Transaction> rows = [];
  bool failRead = false;
  bool failWrite = false;

  _FakeTransactionRemoteDataSource() : super(_dummyClient());

  @override
  Future<List<Transaction>> getTransactions({
    required String userId,
    int limit = 100,
  }) async {
    if (failRead) throw Exception('remote read failed');
    return List.of(rows);
  }

  @override
  Future<Transaction> createTransaction(Transaction transaction) async {
    if (failWrite) throw Exception('remote write failed');
    rows.add(transaction);
    return transaction;
  }
}

class _FakeTransactionLocalDataSource extends TransactionLocalDataSource {
  final Map<String, Transaction> _rows = {};

  _FakeTransactionLocalDataSource() : super(db.AppDatabase());

  @override
  Future<void> insertTransaction(Transaction transaction) async =>
      _rows[transaction.id] = transaction;

  @override
  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    final list = _rows.values.where((t) => t.userId == userId).toList()
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return list;
  }

  @override
  Future<Transaction?> getTransactionByFingerprint(
    String userId,
    String fingerprint,
  ) async {
    for (final t in _rows.values) {
      if (t.userId == userId && t.fingerprint == fingerprint) return t;
    }
    return null;
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    if (_rows.containsKey(transaction.id)) {
      _rows[transaction.id] = transaction;
    }
  }
}

void main() {
  // SmsPollingService registers itself with WidgetsBinding (lifecycle-safe
  // observer) — the binding must exist for its start()/stop() calls.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Date gate (cutoff removed, requirement #8)', () {
    test('historical messages (before old Sept 1 cutoff) ARE eligible now', () {
      expect(SMSParser.isWithinSupportedDate(DateTime(2026, 8, 31, 23, 59, 59)),
          isTrue);
      expect(SMSParser.isWithinSupportedDate(DateTime(2026, 9, 1)), isTrue);
      expect(SMSParser.isWithinSupportedDate(DateTime(2026, 9, 11, 14, 30)),
          isTrue);
    });

    test('missing message date is rejected', () {
      expect(SMSParser.isWithinSupportedDate(null), isFalse);
    });
  });

  group('Bank/wallet sender recognition (requirement #9)', () {
    test('recognized senders pass', () {
      for (final sender in [
        'FAISAL BANK',
        'CIB',
        'NBE',
        'QNB',
        'MISR',
        'IPN',
        'InstaPay',
        'Vodafone Cash',
      ]) {
        expect(SMSParser.isRecognizedBankOrWalletSender(sender: sender), isTrue,
            reason: sender);
      }
    });

    test('unsupported senders are rejected', () {
      for (final sender in ['Jo Groceries', 'Careem', '3sks', '']) {
        expect(
            SMSParser.isRecognizedBankOrWalletSender(sender: sender), isFalse,
            reason: sender);
      }
    });
  });

  group('Faisal example end-to-end parse (requirement #11)', () {
    Future<ParsedSms> parseFaisal() =>
        SMSParser.parse(smsContent: _faisalBody, sender: 'FAISAL BANK');

    test('detects Faisal Bank', () async {
      expect((await parseFaisal()).bankName, 'Faisal Bank');
    });

    test('extracts the 10.00 جم amount (1000 minor, EGP)', () async {
      final result = await parseFaisal();
      expect(result.amountMinor, 1000);
      expect(result.currency, 'EGP');
    });

    test('direction is outgoing (تحويل من حسابكم) — transfer_out', () async {
      expect((await parseFaisal()).type, TransactionType.transfer_out);
    });

    test('7351 is not treated as card last-4', () async {
      expect((await parseFaisal()).cardLast4, isNull);
    });

    test('حسابكم is not treated as merchant', () async {
      expect((await parseFaisal()).merchant, isNot(contains('حسابكم')));
    });
  });

  group('Full ingestion pipeline (requirement #1/#2)', () {
    test('Faisal SMS flows inbox → parser → processor → repository', () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: _faisalBody,
            date: DateTime(2026, 9, 11, 14, 30),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.scanned, 1);
      expect(result.transactionsCreated, 1);
      expect(result.errors, 0);

      final txn = money.recorded.single;
      expect(txn.type, TransactionType.transfer_out);
      expect(txn.amountMinor, 1000);
      expect(txn.currency, 'EGP');
      expect(txn.merchantName, 'Faisal Bank');
      // Real message timestamp (date + time) is preserved.
      expect(txn.transactionDate, DateTime(2026, 9, 11, 14, 30));
      expect(txn.cardLast4, isNull);
      expect(txn.fingerprint, isNotEmpty);
    });

    test('duplicate SMS is never recorded twice (requirement #7)', () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: _faisalBody,
            date: DateTime(2026, 9, 11, 14, 30),
          ),
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: _faisalBody,
            date: DateTime(2026, 9, 11, 14, 30),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.transactionsCreated, 1);
      expect(money.recorded, hasLength(1));
    });

    // Requirement: the September 1, 2026 cutoff has been REMOVED.
    // Historical bank/wallet SMS of ANY date must now be processed on first
    // scan, and only genuinely NEW messages are inspected afterwards.
    test('SMS dated before September 1, 2026 IS processed (cutoff removed)',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: 'تم شراء بمبلغ 20.00 جم رقم مرجعي 1111',
            date: DateTime(2026, 8, 31, 20, 0),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      // First scan processes ALL historical bank/wallet SMS regardless of
      // date — no September 1 cutoff.
      expect(result.transactionsCreated, 1);
      expect(money.recorded, hasLength(1));
    });

    test('unrelated sender never creates a transaction (requirement #9)',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'Jo Groceries',
            body: 'Your order 12345 shipped. EGP coupons inside!',
            date: DateTime(2026, 9, 11, 10, 0),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.transactionsCreated, 0);
      expect(money.recorded, isEmpty);
    });

    test('polling since-filter skips already-processed messages', () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: _faisalBody,
            date: DateTime(2026, 9, 11, 14, 30),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      // First scan (startup/broader): no since filter.
      await ingestion.scanAndProcess(userId: 'u1');
      // A later 5-second cycle only inspects NEW messages — the old one is
      // skipped before the processor even runs.
      final result = await ingestion.scanAndProcess(
        userId: 'u1',
        since: DateTime(2026, 9, 11, 14, 31),
      );

      expect(result.transactionsCreated, 0);
      expect(money.recorded, hasLength(1));
    });

    test(
        'missing bank-account link does NOT discard a valid transaction '
        '(requirement #13)', () async {
      final money = _FakeMoneyRepository()..accounts = const [];
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'FAISAL BANK',
            body: _faisalBody,
            date: DateTime(2026, 9, 11, 14, 30),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      // The transaction is preserved even with NO linked bank account.
      expect(result.transactionsCreated, 1);
      expect(money.recorded, hasLength(1));
      expect(money.recordedAccountIds.single, isNull);
    });

    test('one malformed SMS does not stop processing the others (#15)',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          // Unparseable body (no amount) — skipped by the processor, not fatal.
          SmsInboxMessage(
            sender: 'CIB',
            body: 'Welcome to CIB digital banking',
            date: DateTime(2026, 9, 11, 9, 0),
          ),
          SmsInboxMessage(
            sender: 'IPN',
            body: 'InstaPay: You received EGP 1,500.00 from ahmed@example. '
                'Balance EGP 5500.00',
            date: DateTime(2026, 9, 11, 10, 0),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.errors, 0);
      expect(result.transactionsCreated, 1);
      expect(money.recorded.single.type, TransactionType.transfer_in);
    });
  });

  group('5-second polling (requirement #4/#7)', () {
    test('pull-to-refresh invokes the central scan (since = null)', () async {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);

      final result = await service.scanNow(fullScan: true);

      expect(result.transactionsCreated, 1);
      expect(ingestion.calls, 1);
      expect(ingestion.sinceArgs.single, isNull);
      service.stop();
    });

    test('later cycles only inspect NEW messages (since cutoff)', () async {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);

      await service.scanNow(); // first cycle
      final result = await service.scanNow(); // later 5-second cycle

      expect(result.transactionsCreated, 0); // nothing new → no duplicate
      expect(ingestion.calls, 2);
      expect(ingestion.sinceArgs[0], isNull);
      expect(ingestion.sinceArgs[1], isNotNull);
      service.stop();
    });

    test('scanNow does not create duplicates across repeated pulls (#3/#14)',
        () async {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);

      final first = await service.scanNow(fullScan: true);
      final second = await service.scanNow(fullScan: true);

      expect(first.transactionsCreated, 1);
      expect(second.transactionsCreated, 0); // dedupe, no recreation
      service.stop();
    });

    test('concurrent scans are single-flight guarded (requirement #6)',
        () async {
      final ingestion = _RecordingIngestionService()..gate = Completer<void>();
      final service = _makePoller(ingestion, null);

      // Pull-to-refresh while an automatic cycle is already running:
      // the second call must NOT start another scan — it JOINS the
      // in-flight scan and reuses its result (never a fake empty result).
      final inFlight = service.scanNow(fullScan: true);
      // Let the in-flight scan progress up to (and into) the fake pipeline's
      // gate so the guard is observable.
      await Future<void>.delayed(Duration.zero);
      final overlappingFuture = service.scanNow();
      // Both callers complete once the single scan finishes — no deadlock.
      ingestion.gate!.complete();
      final results = await Future.wait([inFlight, overlappingFuture]);

      expect(ingestion.calls, 1);
      expect(results[0].transactionsCreated, 1);
      expect(results[1].transactionsCreated, 1);
      service.stop();
    });

    test('a full scan joining an in-flight scan reuses it (no duplicate run)',
        () async {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);

      // Prime _lastScanAt so the next incremental scan uses a bounded
      // `since` window (otherwise the very first scan is already unbounded).
      await service.scanNow();
      ingestion.calls = 0;
      ingestion.gate = Completer<void>();

      final incremental = service.scanNow();
      await Future<void>.delayed(Duration.zero);
      // A full-scan caller arrives while the incremental scan is running: it
      // JOINS that scan instead of starting a second pipeline run. The
      // one-time historical walk is NOT restarted from here - the 5-second
      // poll cycle owns the walk and continues it on its next tick, so a pull
      // can never trigger a history re-read (requirements #6 / #8 / #9).
      final fullFuture = service.scanNow(fullScan: true);
      ingestion.gate!.complete();
      final results = await Future.wait([incremental, fullFuture]);

      // ONE pipeline run only - the joined result is reused by both callers.
      expect(ingestion.calls, 1);
      // Both callers observe the SAME joined scan: the bounded incremental
      // run (created = 1) whose result is shared, never a duplicate scan.
      expect(results[0].transactionsCreated, 1);
      expect(results[1].transactionsCreated, 1);
      // No unbounded follow-up scan was started by the joining caller: the
      // only pipeline runs are the priming scan (unbounded) plus the JOINED
      // bounded incremental run (sinceArgs is not reset by this test).
      expect(ingestion.sinceArgs, hasLength(2));
      expect(ingestion.sinceArgs.first, isNull);
      expect(ingestion.sinceArgs.last, isNotNull);
      service.stop();
    });

    test('UI is refreshed only when NEW transactions were created (#16)',
        () async {
      final ingestion = _RecordingIngestionService();
      final createdCounts = <int>[];
      final service = _makePoller(ingestion, createdCounts.add);

      await service.scanNow(); // created=1 → callback
      await service.scanNow(); // created=0 → NO callback (no invalidation)

      expect(createdCounts, [1]);
      service.stop();
    });

    test('start() never creates duplicate timers (requirement #4)', () {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);

      service.start();
      service.start(); // must be ignored — exactly one timer.
      service.stop();
      service.stop(); // idempotent.
    });
  });

  group('Transactions presentation (requirement #12)', () {
    test('transactions are grouped by day and ordered newest first', () {
      final grouped = groupTransactionsByDay([
        _txn('a', DateTime(2026, 9, 11, 22, 45)),
        _txn('b', DateTime(2026, 9, 11, 8, 20)),
        _txn('c', DateTime(2026, 9, 10, 12, 0)),
        _txn('d', DateTime(2026, 9, 11, 10, 15)),
      ]);

      // Days newest first.
      expect(grouped.keys.toList(), ['2026-09-11', '2026-09-10']);
      // Within a day: full-timestamp order, newest first.
      expect(
        grouped['2026-09-11']!.map((t) => t.id),
        ['a', 'd', 'b'], // 22:45, 10:15, 08:20
      );
      expect(grouped['2026-09-10']!.map((t) => t.id), ['c']);
    });
  });

  group('Repository read path (requirement #13/#14)', () {
    test('local rows are NEVER hidden by an empty remote list', () async {
      final remote = _FakeTransactionRemoteDataSource(); // remote returns []
      final local = _FakeTransactionLocalDataSource();
      await local.insertTransaction(
          _txn('local1', DateTime(2026, 9, 11, 14, 30), fingerprint: 'fp1'));
      final repository = TransactionRepository(remote, local);

      final transactions = await repository.getTransactions(userId: 'u1');

      // This was the empty-Transactions bug: the remote list replaced the
      // result whenever the sync query succeeded.
      expect(transactions, isNotEmpty);
      expect(transactions.first.id, 'local1');
    });

    test('remote rows merge INTO the local store and both appear', () async {
      final remote = _FakeTransactionRemoteDataSource()
        ..rows.add(
            _txn('remote1', DateTime(2026, 9, 10, 9, 0), fingerprint: 'fpr1'));
      final local = _FakeTransactionLocalDataSource();
      await local.insertTransaction(
          _txn('local1', DateTime(2026, 9, 11, 14, 30), fingerprint: 'fp1'));
      final repository = TransactionRepository(remote, local);

      final transactions = await repository.getTransactions(userId: 'u1');

      expect(transactions.map((t) => t.id), containsAll(['local1', 'remote1']));
      // Newest first across merged sources.
      expect(transactions.first.id, 'local1');
    });

    test(
        'createTransaction persists locally even when the remote write '
        'fails (and logs instead of silently swallowing)', () async {
      final remote = _FakeTransactionRemoteDataSource()..failWrite = true;
      final local = _FakeTransactionLocalDataSource();
      final repository = TransactionRepository(remote, local);

      final txn =
          _txn('t1', DateTime(2026, 9, 11, 14, 30), fingerprint: 'fpt1');
      final result = await repository.createTransaction(transaction: txn);

      expect(result.id, 't1');
      expect(await local.getTransactionByFingerprint('u1', 'fpt1'), isNotNull);
    });
  });
  group('New SMS patterns end-to-end (purchase + IPN received transfer)', () {
    test('IPN received transfer creates ONE transfer_in transaction', () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'IPN',
            body: 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240',
            date: DateTime(2026, 9, 12, 9, 5),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.errors, 0);
      final txn = money.recorded.single;
      expect(txn.type, TransactionType.transfer_in);
      expect(txn.amountMinor, 24000); // 240.00 EGP
      expect(txn.currency, 'EGP');
      expect(txn.transactionDate, DateTime(2026, 9, 12, 9, 5));
      // My-Balance path: the repository's getUnrepresentedIncomingSum treats
      // confirmed transfer_in as incoming money for "My Balance".
      expect(txn.status, TransactionStatus.confirmed);
    });

    test('identical IPN SMS processed twice creates only ONE transaction',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'IPN',
            body: 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240',
            date: DateTime(2026, 9, 12, 9, 5),
          ),
          SmsInboxMessage(
            sender: 'IPN',
            body: 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240',
            date: DateTime(2026, 9, 12, 9, 5),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      // Layer-2 fingerprint dedupe guarantees one record regardless of the
      // "since-filter" behavior for two identical bodies.
      expect(result.transactionsCreated, 1);
      expect(money.recorded, hasLength(1));
      expect(money.recorded.single.amountMinor, 24000);
    });

    test('card purchase SMS flows into the money repository as purchase',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'CIB',
            // `**2307` reveals the last four; the `2307**` form used by several
            // Egyptian banks is a PREFIX and deliberately yields no last 4.
            body: 'تمت عملية بمبلغ1200.00 EGPببطاقة**2307 '
                'في12/09/26-15:40 عند GEIDEAE*COTTONIL ABDIN EG',
            date: DateTime(2026, 9, 12, 15, 40),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.errors, 0);
      final txn = money.recorded.single;
      expect(txn.type, TransactionType.purchase);
      expect(txn.amountMinor, 120000);
      expect(txn.cardLast4, '2307');
      expect(txn.merchantName, 'GEIDEAE*COTTONIL ABDIN EG');
    });

    test('a trailing-mask card (2307**) yields its Last 4 end to end',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'CIB',
            body: 'تمت عملية بمبلغ1200.00 EGPببطاقة2307** '
                'في12/09/26-15:40 عند GEIDEAE*COTTONIL ABDIN EG',
            date: DateTime(2026, 9, 12, 15, 40),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      await ingestion.scanAndProcess(userId: 'u1');

      expect(money.recorded.single.cardLast4, '2307',
          reason:
              'the trailing ** is an alignment artifact, not a prefix marker');
    });
  });

  group('Concurrency + resilience (SMS sync vs pull-to-refresh)', () {
    test('polling + manual refresh share ONE scan — no duplicate pipeline run',
        () async {
      // Test 2 scenario: the 5-second poller is mid-scan when the user pulls
      // to refresh. The manual refresh must JOIN the poll scan — exactly one
      // pipeline run, both callers get the same transactions.
      final ingestion = _RecordingIngestionService()..gate = Completer<void>();
      final created = <int>[];
      final service = _makePoller(ingestion, created.add);

      final pollScan = service.scanNow();
      await Future<void>.delayed(Duration.zero);
      final refreshScan = service.scanNow(fullScan: true);
      ingestion.gate!.complete();

      final results = await Future.wait([pollScan, refreshScan]);
      expect(ingestion.calls, 1);
      // The manual refresh was fullScan while the poll scan was already
      // unbounded (first scan, since == null) → the joined result covers the
      // full window and NO follow-up scan runs.
      expect(ingestion.sinceArgs, hasLength(1));
      expect(ingestion.sinceArgs.single, isNull);
      expect(results[0].transactionsCreated, 1);
      expect(results[1].transactionsCreated, 1);
      // UI invalidated exactly once for the ONE scan that created rows.
      expect(created, [1]);
      service.stop();
    });

    test('concurrent refresh + SMS sync never deadlocks or duplicates',
        () async {
      // Test 1 scenario: an SMS sync is running, the user pulls to refresh
      // twice. All callers join the single scan; only ONE transaction is
      // created for the one SMS (pipeline-level dedupe on repeated runs).
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'IPN',
            body: 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240',
            date: DateTime(2026, 9, 12, 9, 5),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );
      final service = SmsPollingService(
        ingestion: ingestion,
        resolveUserId: () async => 'u1',
        resolveKnownBanks: () async => const <Bank>[],
      );

      final sync = service.scanNow();
      await Future<void>.delayed(Duration.zero);
      final refresh1 = service.scanNow(fullScan: true);
      final refresh2 = service.scanNow(fullScan: true);

      final results = await Future.wait([sync, refresh1, refresh2]);

      // Exactly one pipeline run produced the transaction.
      expect(money.recorded, hasLength(1));
      expect(money.recorded.single.amountMinor, 24000);
      expect(results.every((r) => r.transactionsCreated <= 1), isTrue);
      expect(results[0].transactionsCreated, 1);
    });

    test('a failed in-flight scan is retried by the joining caller', () async {
      final ingestion = _RecordingIngestionService();
      final service = _makePoller(ingestion, null);
      // First run fails with errors=1; the retried run succeeds.
      ingestion.failNext = true;

      final owner = service.scanNow();
      await Future<void>.delayed(Duration.zero);
      final joiner = service.scanNow();

      final ownerResult = await owner;
      final joinerResult = await joiner;

      // Owner got the failed scan, joiner retried fresh and got a clean
      // result (2 pipeline runs total — no lost refresh).
      expect(ownerResult.errors, 1);
      expect(joinerResult.errors, 0);
      expect(ingestion.calls, 2);
      service.stop();
    });

    test('hung remote sms_messages checks never block transaction creation',
        () async {
      // A hung/offline sms_messages table must not stall the pipeline: the
      // transaction still reaches the money repository (layer-2 fingerprint
      // dedupe keeps it unique). Each hung call is cut by its own timeout —
      // this test proves the scan COMPLETES with a created transaction.
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'IPN',
            body: 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240',
            date: DateTime(2026, 9, 12, 9, 5),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(
          moneyRepository: money,
          smsRemoteDataSource: _HungSmsRemoteDataSource(),
          smsRecordTimeout: const Duration(milliseconds: 5),
          cardLinkTimeout: const Duration(milliseconds: 5),
        ),
        batchDedupeTimeout: const Duration(milliseconds: 5),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.transactionsCreated, 1);
      expect(money.recorded, hasLength(1));
    });

    test('two different cards keep their balances isolated (#19 Test 5)',
        () async {
      final money = _FakeMoneyRepository();
      final inbox = _FakeInboxService()
        ..messages = [
          SmsInboxMessage(
            sender: 'CIB',
            body: 'تمت عملية بمبلغ1200.00 EGPببطاقة**2307 '
                'في12/09/26-15:40 عند GEIDEAE*COTTONIL ABDIN EG',
            date: DateTime(2026, 9, 12, 15, 40),
          ),
          SmsInboxMessage(
            sender: 'CIB',
            body: 'تمت عملية بمبلغ300.00 EGPببطاقة**4321 '
                'في12/09/26-18:05 عند ANOTHER MERCHANT',
            date: DateTime(2026, 9, 12, 18, 5),
          ),
        ];
      final ingestion = SmsIngestionService(
        inboxService: inbox,
        processor: SMSTransactionProcessor(moneyRepository: money),
      );

      final result = await ingestion.scanAndProcess(userId: 'u1');

      expect(result.transactionsCreated, 2);
      expect(money.recorded, hasLength(2));
      // Card A carries its own amount/card; card B is untouched by A.
      final cardA = money.recorded.firstWhere((t) => t.cardLast4 == '2307');
      final cardB = money.recorded.firstWhere((t) => t.cardLast4 == '4321');
      expect(cardA.amountMinor, 120000);
      expect(cardB.amountMinor, 30000);
      expect(cardA.id, isNot(cardB.id));
    });
  });

  group('Historical walk completeness (audit)', () {
    test(
        'the first-ever historical walk ingests the ENTIRE inbox, one bounded '
        'page per scan', () async {
      final harness = _WalkHarness();
      const total = 450; // more than two pages of historyPageSize (200)
      harness.inbox.messages = [
        for (var i = 1; i <= total; i++)
          _bankSms(i, DateTime(2025, 1, 1).add(Duration(minutes: i))),
      ];

      final scans = await harness.walkToCompletion();

      // No cutoff, no page cap, no time cap: EVERY eligible message is stored.
      expect(harness.money.recorded, hasLength(total));
      expect(harness.poller.isBackfillPending('u1'), isFalse);
      // Bounded work per scan: a handful of pages, never one giant pass.
      expect(scans, lessThanOrEqualTo(5));
    });

    test(
        'messages sharing ONE timestamp are never lost when the page boundary '
        'cuts through the tie group', () async {
      final harness = _WalkHarness();
      final tie = DateTime(2025, 3, 10, 12, 0);
      // 194 distinct newer messages, then 11 messages with the SAME timestamp
      // (so the 200-message page boundary falls inside that tie group), then 30
      // older ones.
      harness.inbox.messages = [
        for (var i = 1; i <= 194; i++)
          _bankSms(i, tie.add(Duration(minutes: 1000 - i))),
        for (var i = 195; i <= 205; i++) _bankSms(i, tie),
        for (var i = 206; i <= 235; i++)
          _bankSms(i, tie.subtract(Duration(minutes: i - 205))),
      ];

      await harness.walkToCompletion();

      expect(harness.money.recorded, hasLength(235));
      final amounts = harness.money.recorded.map((t) => t.amountMinor).toSet();
      for (var i = 195; i <= 205; i++) {
        expect(amounts, contains(i * 100),
            reason: 'tie message #$i was silently skipped');
      }
      expect(harness.poller.isBackfillPending('u1'), isFalse);
    });
  });

  group('Backlog drain + cursor recovery (audit)', () {
    test(
        'a pull-to-refresh during the FIRST walk never abandons the remaining '
        'history', () async {
      final harness = _WalkHarness();
      final base = DateTime(2025, 5, 1, 9, 0);
      // Restore-style burst: 120 messages inside the last two minutes, plus 200
      // older ones. The first page therefore contains the whole burst and only
      // part of the older history.
      harness.inbox.messages = [
        for (var i = 1; i <= 120; i++)
          _bankSms(i, base.add(Duration(milliseconds: i * 900))),
        for (var i = 121; i <= 320; i++)
          _bankSms(i, base.subtract(Duration(minutes: i))),
      ];

      await harness.poller.scanNow(fullScan: true); // first (historical) page
      // The user pulls to refresh / the Dashboard checks while the walk is still
      // unfinished. This is a NON-walk scan and must not shorten the walk's
      // coverage.
      await harness.poller.scanNow();
      await harness.walkToCompletion();

      expect(harness.money.recorded, hasLength(320));
      expect(harness.poller.isBackfillPending('u1'), isFalse);
    });

    test(
        'a multi-day burst larger than one page is fully ingested even when a '
        'refresh joins the drain', () async {
      final harness = _WalkHarness();
      harness.inbox.messages = [
        for (var i = 1; i <= 20; i++)
          _bankSms(i, DateTime(2025, 6, 1, 8, 0).add(Duration(minutes: i))),
      ];
      await harness.walkToCompletion();
      expect(harness.money.recorded, hasLength(20));

      // App closed for three days: 140 bank SMS arrive in one burst.
      final burst = DateTime(2025, 6, 4, 20, 0);
      harness.inbox.messages = [
        ...harness.inbox.messages,
        for (var i = 21; i <= 160; i++)
          _bankSms(i, burst.add(Duration(seconds: i))),
      ];

      await harness.poller.scanNow(); // incremental page -> backlog detected
      await harness.poller.scanNow(); // pull-to-refresh mid-drain
      await harness.walkToCompletion();

      expect(harness.money.recorded, hasLength(160));
      expect(harness.poller.isBackfillPending('u1'), isFalse);
    });

    test(
        'a cursor beyond the clock is recovered instead of permanently hiding '
        'new SMS', () async {
      final harness = _WalkHarness();
      final now = DateTime.now();
      // Previous session left a cursor in the FUTURE (clock moved backwards, a
      // corrupt/future sender timestamp, or a restored backup).
      await harness.store.write(
        'u1',
        SmsSyncState(
          historyComplete: true,
          lastProcessedAt: now.add(const Duration(days: 1)),
          updatedAt: now,
        ),
      );
      harness.inbox.messages = [
        _bankSms(7, now.subtract(const Duration(minutes: 1))),
      ];

      final result = await harness.poller.scanNow();
      harness.poller.stop();

      // The fresh SMS is still found (the unusable cursor was dropped).
      expect(result.transactionsCreated, 1);
      expect(harness.money.recorded, hasLength(1));
    });
  });

  group('Concurrency + permanence (audit)', () {
    test('a timed-out joined scan never starts a second ingestion pipeline',
        () async {
      final ingestion = _RecordingIngestionService()..gate = Completer<void>();
      final service = _makePoller(ingestion, null,
          scanTimeout: const Duration(milliseconds: 30));

      final owner = service.scanNow();
      await Future<void>.delayed(Duration.zero);
      final joiner = service.scanNow();

      final results = await Future.wait([owner, joiner]);

      // The stuck page was NOT restarted: exactly ONE pipeline run, ever.
      expect(ingestion.calls, 1);
      expect(results.every((r) => r.errors == 1), isTrue);
      // Let the still-running page finish so nothing is left pending.
      ingestion.gate!.complete();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      service.stop();
    });

    test('deleting the source SMS never deletes the stored transaction',
        () async {
      final harness = _WalkHarness();
      harness.inbox.messages = [_bankSms(3, DateTime(2025, 7, 1, 10, 0))];
      await harness.walkToCompletion();
      expect(harness.money.recorded, hasLength(1));

      // The user deletes the SMS from the phone: the stored transaction stays.
      harness.inbox.messages = const [];
      await harness.poller.scanNow();
      await harness.poller.scanNow(fullScan: true);

      expect(harness.money.recorded, hasLength(1));
      expect(harness.money.recorded.single.amountMinor, 300);
      harness.poller.stop();
    });
  });
}

/// A distinct, parseable Faisal Bank SMS. It reuses the Arabic sample already
/// verified by this suite (no new Arabic literal) while guaranteeing a UNIQUE
/// amount + reference, so every message produces its own transaction
/// fingerprint.
SmsInboxMessage _bankSms(int i, DateTime date) => SmsInboxMessage(
      sender: 'FAISAL BANK',
      body: _faisalBody
          .replaceFirst('10.00', '$i.00')
          .replaceFirst('7351', '${900000 + i}'),
      date: date,
    );

/// Inbox fake that reproduces the NATIVE query contract EXACTLY: inclusive
/// `since`/`until` bounds, newest-first ordering and the `maxCount` cap. This is
/// what makes the walk/pagination maths observable in a unit test.
class _PagingInboxService extends SmsInboxService {
  List<SmsInboxMessage> messages = const [];
  int reads = 0;

  @override
  Future<bool> hasPermissions() async => true;

  @override
  Future<List<SmsInboxMessage>> readInbox({
    int maxCount = 200,
    DateTime? sinceDate,
    DateTime? untilDate,
  }) async {
    reads++;
    final ordered = [...messages]..sort((a, b) => b.date.compareTo(a.date));
    final matching = ordered.where((m) {
      if (sinceDate != null && m.date.isBefore(sinceDate)) return false;
      if (untilDate != null && m.date.isAfter(untilDate)) return false;
      return true;
    });
    return matching.take(maxCount).toList();
  }
}

/// End-to-end harness: the REAL ingestion pipeline (real pagination, real parser,
/// real processor, real cursor maths) driven through the REAL polling service,
/// over a fake inbox and a fake money repository.
class _WalkHarness {
  final _PagingInboxService inbox = _PagingInboxService();
  final _FakeMoneyRepository money = _FakeMoneyRepository();
  final SmsSyncStateStore store = SmsSyncStateStore();

  late final SmsIngestionService ingestion = SmsIngestionService(
    inboxService: inbox,
    processor: SMSTransactionProcessor(moneyRepository: money),
  );

  late final SmsPollingService poller = SmsPollingService(
    ingestion: ingestion,
    resolveUserId: () async => 'u1',
    resolveKnownBanks: () async => const <Bank>[],
    syncStateStore: store,
  );

  /// Runs bounded scans until the walk reports completion (first scan or
  /// backlog drain) and returns how many scans that took.
  Future<int> walkToCompletion({int maxScans = 40}) async {
    var scans = 0;
    while (scans < maxScans && poller.isBackfillPending('u1')) {
      await poller.scanNow(fullScan: true);
      scans++;
    }
    poller.stop();
    return scans;
  }
}

/// Remote SMS data source whose every call hangs (simulates an offline /
/// stalled network). The pipeline must never wait on it.
class _HungSmsRemoteDataSource extends SmsRemoteDataSource {
  _HungSmsRemoteDataSource() : super(_dummyClient());

  @override
  Future<bool> isKnownMessage(String userId, String messageHash) =>
      Completer<bool>().future; // never completes

  Future<SMSMessage> createSmsMessage(SMSMessage message) =>
      Completer<SMSMessage>().future; // never completes

  @override
  Future<Set<String>> knownMessageHashes(
    String userId,
    List<String> messageHashes,
  ) =>
      Completer<Set<String>>().future; // never completes

  @override
  Future<void> linkTransaction({
    required String smsMessageId,
    required String transactionId,
  }) =>
      Completer<void>().future; // never completes
}
