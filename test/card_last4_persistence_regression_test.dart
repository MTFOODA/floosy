import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/services/card_ownership.dart';
import 'package:floosy/features/transactions/presentation/state/transaction_edit_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

class _LocalOnlyTransactionRepository extends TransactionRepository {
  final TransactionLocalDataSource local;
  _LocalOnlyTransactionRepository(this.local)
      : super(TransactionRemoteDataSource(_dummyClient()), local);

  @override
  Future<Transaction> createTransaction(
      {required Transaction transaction}) async {
    await local.insertTransaction(transaction);
    return transaction;
  }

  @override
  Future<List<Transaction>> getTransactions(
          {required String userId,
          bool syncWithRemote = true,
          int limit = 100}) async =>
      local.getTransactionsByUserId(userId);
}

class _Remote implements MoneyRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Cash implements CashWalletRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Expenses implements ExpenseRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// THE REQUIREMENT UNDER TEST.
///
/// Propagating only `card_id` is NOT sufficient: the user-typed `card_last4`
/// must be PERSISTED in the same local update. A Last 4 that only ever reached
/// the UI, or only Supabase, is a value the user never really saved — and the
/// red-dot indicator, the per-card balances and the transaction list all read
/// `card_last4` straight from the database.
void main() {
  const user = 'user';
  const cib = 'CIB';
  const nbe = 'NBE';

  late db.AppDatabase database;
  late MoneyLocalDataSource moneyLocal;
  late TransactionLocalDataSource txnLocal;
  late SmsMessageLocalDataSource smsLocal;
  late DetectedCardRepository cardRepo;
  late MoneyRepository moneyRepo;
  late _LocalOnlyTransactionRepository txnRepo;
  var changedCalls = 0;

  setUp(() {
    changedCalls = 0;
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    moneyLocal = MoneyLocalDataSource(database);
    txnLocal = TransactionLocalDataSource(database);
    smsLocal = SmsMessageLocalDataSource(database);
    cardRepo = DetectedCardRepository(local: DetectedCardLocalDataSource());
    txnRepo = _LocalOnlyTransactionRepository(txnLocal);
    moneyRepo = MoneyRepository(
      remote: _Remote(),
      local: moneyLocal,
      transactionRepository: txnRepo,
      cashWalletRepository: _Cash(),
      expenseRepository: _Expenses(),
      detectedCardRepository: cardRepo,
      smsMessageLocalDataSource: smsLocal,
    );
  });
  tearDown(() => database.close());

  var seq = 0;

  /// Inserts a transaction plus the SMS detection record that gives it a bank
  /// identity, exactly as the ingestion pipeline does.
  Future<Transaction> insert({
    required int amount,
    String? last4,
    String? bank,
    String? cardId,
  }) async {
    final id = 'txn${seq++}';
    final row = Transaction(
      id: id,
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      cardId: cardId,
      merchantName: bank,
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

  /// Reads BOTH identity columns straight from the Drift table — no repository
  /// cache, no provider, no widget.
  Future<(String? last4, String? cardId)> dbIdentity(String id) async {
    final row = (await txnLocal.getTransactionsByUserId(user))
        .firstWhere((r) => r.id == id);
    return (row.cardLast4, row.cardId);
  }

  /// The full "Edit -> type Last 4 -> Save" path.
  TransactionEditController controller() => TransactionEditController(
        userId: user,
        transactionRepository: txnRepo,
        moneyRepository: moneyRepo,
        cardRepository: cardRepo,
        bankCatalogLoader: () async => <Bank>[],
        onChanged: () => changedCalls++,
      );

  /// The dialog payload, with the bank field pre-filled the way the screen
  /// pre-fills it (from merchantName).
  TransactionEditDraft draft(Transaction t, String last4Text) =>
      TransactionEditDraft(
        transaction: t,
        type: t.type,
        amountMinor: t.amountMinor,
        currency: t.currency,
        bankText: t.merchantName ?? '',
        last4Text: last4Text,
        categoryId: t.categoryId,
        merchantName: t.merchantName,
        transactionDate: t.transactionDate,
      );

  // ─────────────────────────────────────────────────────────────────────────────
  // THE EXACT SPECIFIED SCENARIO
  // ─────────────────────────────────────────────────────────────────────────────
  test('the confirmed Last 4 is PERSISTED, not just the card_id', () async {
    // CardA = CIB + 1234 already exists, and so does its link on T2/T3.
    final cardA =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);

    // T1 = CIB / NULL / NULL
    final t1 = await insert(amount: 100000, last4: null, bank: cib);
    // T2 = CIB / 1234 / CardA
    final t2 = await insert(
        amount: 200000, last4: '1234', bank: cib, cardId: cardA.id);
    // T3 = CIB / 1234 / CardA
    final t3 = await insert(
        amount: 300000, last4: '1234', bank: cib, cardId: cardA.id);
    // T4 = NBE / 1234 / NULL
    final t4 = await insert(amount: 400000, last4: '1234', bank: nbe);

    // Starting state, verified directly in the database.
    expect(await dbIdentity(t1.id), (null, null));
    expect(await dbIdentity(t2.id), ('1234', cardA.id));
    expect(await dbIdentity(t3.id), ('1234', cardA.id));
    expect(await dbIdentity(t4.id), ('1234', null));

    // ---- long press T1 -> Edit -> enters Card Last4 = 1234 -> Save ----
    final learned = await controller().save(draft(t1, '1234'));
    expect(learned, isNotNull);
    expect(learned!.isResolved, isTrue,
        reason: 'CIB + 1234 must resolve: ${learned.resolution.reason}');
    final resolved = (learned.resolution as Resolved).card;
    expect(resolved.id, cardA.id, reason: 'the existing CIB/1234 card is reused');

    // ---- query Drift directly ----
    // T1 receives the Last 4 IMMEDIATELY: the user explicitly confirmed this
    // exact transaction, so there is no ambiguity to preserve.
    expect((await dbIdentity(t1.id)).$1, '1234',
        reason: 'T1.card_last4 must be PERSISTED in the database');
    expect((await dbIdentity(t1.id)).$2, cardA.id,
        reason: 'T1.card_id must be the confirmed card');

    // The confirmed matching transactions carry the same persisted values.
    expect(await dbIdentity(t2.id), ('1234', cardA.id));
    expect(await dbIdentity(t3.id), ('1234', cardA.id));

    // Cross-bank isolation intact.
    expect(await dbIdentity(t4.id), ('1234', null),
        reason: 'NBE + 1234 must never join the CIB card');

    // The UI was told to refresh, so no restart / rescan is needed.
    expect(changedCalls, 1, reason: 'the screen must be notified after commit');
  });

  test('a CIB + 5678 row never inherits the confirmed CIB + 1234 card',
      () async {
    final cardA =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);
    final t1 = await insert(amount: 100000, last4: null, bank: cib);
    final other = await insert(amount: 200000, last4: '5678', bank: cib);

    await controller().save(draft(t1, '1234'));

    expect((await dbIdentity(t1.id)).$2, cardA.id);
    expect((await dbIdentity(other.id)).$1, '5678',
        reason: 'the other CIB card keeps its own Last 4');
    expect((await dbIdentity(other.id)).$2, isNull,
        reason: 'confirming one card must not mass-assign the whole bank');
  });

  test('a sibling CIB + NULL row IS filled, the edited row is, and a row that '
      'already has the last4 only gains the card link', () async {
    final cardA =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);
    final edited = await insert(amount: 100000, last4: null, bank: cib);
    final sibling = await insert(amount: 200000, last4: null, bank: cib);
    final matching = await insert(amount: 300000, last4: '1234', bank: cib);

    await controller().save(draft(edited, '1234'));

    expect(await dbIdentity(edited.id), ('1234', cardA.id));
    // The NULL-Last4 sibling is filled - this is the population that the old
    // `card_last4 = confirmed` query could never find.
    expect(await dbIdentity(sibling.id), ('1234', cardA.id));
    // The row that already had the number keeps it and only gains the link.
    expect(await dbIdentity(matching.id), ('1234', cardA.id));
  });

  test('an existing explicit card assignment is never overwritten', () async {
    final cardA =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);
    // A DIFFERENT card deliberately linked onto a CIB + 1234 row.
    final otherCard =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: nbe);
    final pinned = await insert(
        amount: 100000, last4: '1234', bank: cib, cardId: otherCard.id);
    final t1 = await insert(amount: 200000, last4: null, bank: cib);

    await controller().save(draft(t1, '1234'));

    expect((await dbIdentity(pinned.id)).$2, otherCard.id,
        reason: 'an explicit card_id must never be overwritten');
    expect((await dbIdentity(t1.id)).$2, cardA.id);
  });

  test('the saved Last 4 survives a full repository reload', () async {
    final cardA =
        await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);
    final t1 = await insert(amount: 100000, last4: null, bank: cib);
    final t2 = await insert(amount: 200000, last4: '1234', bank: cib);

    await controller().save(draft(t1, '1234'));

    // What the screen does after invalidating its providers: a brand-new read.
    // Nothing is held in memory, so a Last 4 that was never committed would
    // show up here as NULL.
    final reloaded = await txnLocal.getTransactionsByUserId(user);
    final r1 = reloaded.firstWhere((r) => r.id == t1.id);
    final r2 = reloaded.firstWhere((r) => r.id == t2.id);
    expect(r1.cardLast4, '1234');
    expect(r1.cardId, cardA.id);
    expect(r2.cardLast4, '1234');
    expect(r2.cardId, cardA.id);
  });

  test('the red dot clears and the balance updates without a restart', () async {
    await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);
    // T1 has no Last 4 at all, so it carries the red dot.
    final t1 = await insert(amount: 100000, last4: null, bank: cib);
    // T2 already proves CIB + 1234, so it is resolved and balances already.
    final t2 = await insert(amount: 200000, last4: '1234', bank: cib);

    expect(
      (await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id),
      <String>[t1.id],
      reason: 'only the Last 4-less row is unassigned before the edit',
    );

    await controller().save(draft(t1, '1234'));

    final unresolved =
        (await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id);
    expect(unresolved, isNot(contains(t1.id)));
    expect(unresolved, isNot(contains(t2.id)));
    final balance = await moneyRepo.getCardBalance(user, '1234', bankName: cib);
    expect(balance.deductedMinor, 300000,
        reason: 'both transactions count against the confirmed card');
  });

  test('a row with no detectable bank keeps the typed Last 4 but stays '
      'unresolved', () async {
    // The transaction has no detected bank, so the identity cannot be proven.
    // The typed Last 4 is still persisted, and the row keeps its red dot.
    final t1 = await insert(amount: 100000, last4: null, bank: null);
    await cardRepo.upsertCard(userId: user, last4: '1234', bankName: cib);

    final learned = await controller().save(draft(t1, '1234'));

    expect(learned!.isResolved, isFalse,
        reason: 'no bank identity means nothing can be proven');
    expect((await dbIdentity(t1.id)).$1, '1234',
        reason: 'the entered Last 4 is still saved on the row');
    expect((await dbIdentity(t1.id)).$2, isNull,
        reason: 'no bank means no card is assigned');
  });
}

