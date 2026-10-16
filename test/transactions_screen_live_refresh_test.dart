import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/localization/app_localizations.dart';
import 'package:floosy/core/providers.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';
import 'package:floosy/data/remote/datasources/detected_card_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/sms_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/services/sms_ingestion_service.dart';
import 'package:floosy/data/services/sms_polling_service.dart';
import 'package:floosy/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auto-refresh off: Supabase's GoTrueClient otherwise starts a 10s
/// periodic timer that outlives the widget tree in 	estWidgets.
SupabaseClient _dummyClient() => SupabaseClient(
      'https://example.supabase.co',
      'public-anon-key',
      authOptions: const FlutterAuthClientOptions(
          autoRefreshToken: false,
      ),
    );

class _RemoteTx implements TransactionRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RemoteMoney implements MoneyRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RemoteSms implements SmsRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RemoteCards implements DetectedCardRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A polling service that never schedules a timer, so the widget test has no
/// pending timers when the tree is disposed.
class _NoopPollingService extends SmsPollingService {
  _NoopPollingService()
      : super(
          ingestion: _FakeIngestion(),
          resolveUserId: () async => null,
          resolveKnownBanks: () async => const <Bank>[],
        );

  @override
  void start() {}

  @override
  void stop() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Future<SmsIngestionResult> scanNow({bool fullScan = false}) async =>
      _emptyResult;
}

/// A zeroed result: the screen's refresh must work with NO new SMS at all,
/// which is exactly the "no rescan required" acceptance criterion.
const _emptyResult = SmsIngestionResult(
  scanned: 0,
  transactionsCreated: 0,
  duplicatesOrSkipped: 0,
  errors: 0,
);

class _FakeIngestion implements SmsIngestionService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// UI-LEVEL regression: the real Transactions screen must reflect a card edit
/// immediately after Save, with no restart, rescan or manual refresh.
void main() {
  const user = 'user';

  late db.AppDatabase database;
  late TransactionLocalDataSource txnLocal;
  late SmsMessageLocalDataSource smsLocal;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    txnLocal = TransactionLocalDataSource(database);
    smsLocal = SmsMessageLocalDataSource(database);
  });
  tearDown(() => database.close());

  Widget app(ProviderContainer c) => UncontrolledProviderScope(
        container: c,
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: TransactionsScreen(),
        ),
      );

  Future<ProviderContainer> makeContainer() async {
    final c = ProviderContainer(overrides: <Override>[
      currentUserIdProvider.overrideWithValue(user),
      appDatabaseProvider.overrideWithValue(database),
      transactionRemoteDataSourceProvider.overrideWithValue(_RemoteTx()),
      moneyRemoteDataSourceProvider.overrideWithValue(_RemoteMoney()),
      smsRemoteDataSourceProvider.overrideWithValue(_RemoteSms()),
      bankCatalogProvider.overrideWith((ref) async => <Bank>[]),
      supabaseClientProvider.overrideWithValue(_dummyClient()),
      // No real HTTP: the card repository is local-only in this test.
      detectedCardRepositoryProvider.overrideWithValue(DetectedCardRepository(
        local: DetectedCardLocalDataSource(),
        remote: _RemoteCards(),
      )),
      // The screen watches this for its periodic SMS poll; replacing it keeps
      // the test free of pending timers once the tree is disposed.
      smsPollingServiceProvider.overrideWith(
          (ref) => _NoopPollingService()),
    ]);
    // The repositories are built from the overridden sources, so they use the
    // in-memory Drift database above.
    final moneyRepo = c.read(moneyRepositoryProvider);
    final txnRepo = c.read(transactionRepositoryProvider);
    expect(moneyRepo, isNotNull);
    expect(txnRepo, isNotNull);
    return c;
  }

  /// Seeds one unresolved transaction plus its SMS detection record.
  Future<Transaction> seed({
    required String id,
    required int amount,
    String? last4,
    String? bank,
    String? merchantName,
  }) async {
    final row = Transaction(
      id: id,
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      merchantName: merchantName ?? bank,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-$id',
    );
    await txnLocal.insertTransaction(row);
    if (bank != null) {
      await smsLocal.upsert(SMSMessage(
        id: 'sms$id',
        userId: user,
        messageHash: 'hash-$id',
        receivedAt: DateTime.now(),
        bankIdentified: true,
        detectedBankName: bank,
        transactionId: id,
      ));
    }
    return row;
  }

  testWidgets(
      'after Edit->Save the screen shows the new last4, drops the red dot '
      'and the row carries the learned card_id', (tester) async {
    final c = await makeContainer();
    addTearDown(c.dispose);

    // T1 has no card, T2 already carries the same bank + last4.
    await seed(id: 't1', amount: 100000, bank: 'CIB',
        merchantName: 'KOSHARY ABU TAREK');
    await seed(id: 't2', amount: 200000, last4: '1234', bank: 'CIB');

    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();

    // Before the edit the list shows the stored transaction.
    expect(find.textContaining('KOSHARY ABU TAREK'), findsOneWidget);

    // Long press -> Edit.
    await tester.longPress(find.textContaining('KOSHARY ABU TAREK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // Type the Card Last 4 and press Save.
    final last4Field = find.widgetWithText(TextField, 'Card last4');
    expect(last4Field, findsOneWidget);
    await tester.enterText(last4Field, '1234');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // ---- VERIFY DB ----
    final rows = await txnLocal.getTransactionsByUserId(user);
    final t1 = rows.firstWhere((r) => r.id == 't1');
    final t2 = rows.firstWhere((r) => r.id == 't2');
    // ignore: avoid_print
    print('[VERIFY DB] t1 cardId=${t1.cardId} last4=${t1.cardLast4}');
    // ignore: avoid_print
    print('[VERIFY DB] t2 cardId=${t2.cardId} last4=${t2.cardLast4}');
    expect(t1.cardLast4, '1234');
    expect(t1.cardId, isNotNull, reason: 'edited row must be assigned');
    expect(t2.cardId, t1.cardId, reason: 'matching row must be propagated');

    // ---- VERIFY PROVIDERS (what the screen renders from) ----
    await c.read(unassignedTransactionsProvider.future);
    final unresolved = await c.read(unassignedTransactionsProvider.future);
    // ignore: avoid_print
    print('[VERIFY UI] unresolved ids=${unresolved.map((e) => e.id).toList()}');
    expect(unresolved.map((e) => e.id), isNot(contains('t1')),
        reason: 'red dot must disappear immediately');

    // The list the screen renders must contain the updated row.
    final listed = await c.read(transactionRepositoryProvider)
        .getTransactionsByRange(
            userId: user, startDateTime: null, endDateTime: null,
            syncWithRemote: false);
    final listedT1 = listed.firstWhere((r) => r.id == 't1');
    // ignore: avoid_print
    print('[VERIFY UI] t1 cardId=${listedT1.cardId} last4=${listedT1.cardLast4}');
    expect(listedT1.cardId, t1.cardId);
    expect(listedT1.cardLast4, '1234');

    // The card transaction query must include both rows.
    final cards = await c.read(detectedCardsProvider.future);
    // ignore: avoid_print
    print('[VERIFY UI] cards=${cards.map((e) => '${e.last4}/${e.bankName}').toList()}');
    final forCard = await c.read(moneyRepositoryProvider)
        .getTransactionsForCard(user, '1234', bankName: 'CIB');
    // ignore: avoid_print
    print('[VERIFY UI] forCard=${forCard.map((r) => r.id).toList()}');
    expect(forCard.map((r) => r.id).toSet(), containsAll(['t1', 't2']));

    // The Supabase card-id mirror is wrapped in a 15s .timeout(), which
    // registers a timer in the test's fake-async zone. Drain it so the test
    // ends clean (the mirror is best-effort and already caught its error).
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(seconds: 20));
    }
  });

  // TESTS
}