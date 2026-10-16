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
  Future<bool> isDuplicateTransaction(
          {required String userId, required String fingerprint}) async =>
      await local.getTransactionByFingerprint(userId, fingerprint) != null;

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

/// REGRESSION for the actual reported failure.
///
/// The earlier suites seeded T2/T3 with `card_last4 = 1234` before the
/// confirmation, so they only ever exercised a `card_last4 = confirmed` query.
/// On the real device every sibling row had `card_last4 IS NULL`, that query
/// matched nothing, and only the edited row ever changed.
///
/// These tests reproduce the real shape: same user, same bank, NULL last 4.
void main() {
  const user = 'user';
  const faisal = 'Faisal Bank';
  const alex = 'AlexBank';

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

  /// A transaction plus its linked detection record — the persisted
  /// relationship the propagation joins on.
  Future<Transaction> insert({
    required int amount,
    required String bank,
    String? last4,
    String? cardId,
    String? smsLast4,
  }) async {
    final id = 't${seq++}';
    final row = Transaction(
      id: id,
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      cardId: cardId,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-$id',
    );
    await txnLocal.insertTransaction(row);
    await smsLocal.upsert(SMSMessage(
      id: 's$id',
      userId: user,
      sender: bank,
      messageHash: 'h-$id',
      receivedAt: DateTime.now(),
      bankIdentified: true,
      detectedBankName: bank,
      detectedCardLast4: smsLast4,
      cardLast4Identified: smsLast4 != null,
      transactionId: id,
    ));
    return row;
  }

  Future<(String? last4, String? cardId)> txn(String id) async {
    final row =
        (await txnLocal.getTransactionsByUserId(user)).firstWhere((r) => r.id == id);
    return (row.cardLast4, row.cardId);
  }

  Future<String?> smsLast4For(String txnId) async => (await database
          .select(database.smsMessages)
          .get())
      .firstWhere((s) => s.transactionId == txnId)
      .detectedCardLast4;

  Future<bool> smsFlagFor(String txnId) async => (await database
          .select(database.smsMessages)
          .get())
      .firstWhere((s) => s.transactionId == txnId)
      .cardLast4Identified;

  TransactionEditController controller() => TransactionEditController(
        userId: user,
        transactionRepository: txnRepo,
        moneyRepository: moneyRepo,
        cardRepository: cardRepo,
        bankCatalogLoader: () async => <Bank>[],
        onChanged: () => changedCalls++,
      );

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
  // THE REQUIRED SCENARIO
  // ─────────────────────────────────────────────────────────────────────────────
  test('confirming 9876 on T1 fills T2/T3, spares AlexBank and the resolved row',
      () async {
    // T1/T2/T3: same user, same bank, NULL card_last4 — the real shape.
    final t1 = await insert(amount: 100000, bank: faisal);
    final t2 = await insert(amount: 200000, bank: faisal);
    final t3 = await insert(amount: 300000, bank: faisal);
    // T4: a different bank, also NULL.
    final t4 = await insert(amount: 400000, bank: alex);
    // T5: already fully resolved, with a Last 4 the user did NOT confirm.
    final existing = await cardRepo.upsertCard(
        userId: user, last4: '5555', bankName: faisal);
    final t5 = await insert(
        amount: 500000, bank: faisal, last4: '5555', cardId: existing.id);

    expect(await txn(t1.id), (null, null), reason: 'the failing real shape');
    expect(await txn(t2.id), (null, null));
    expect(await txn(t3.id), (null, null));

    // ---- Edit T1, enter 9876, Save ----
    final learned = await controller().save(draft(t1, '9876'));
    expect(learned!.isResolved, isTrue,
        reason: 'Faisal Bank + 9876 must resolve: ${learned.resolution.reason}');
    final cardA = (learned.resolution as Resolved).card;

    // T1 -> 9876
    expect(await txn(t1.id), ('9876', cardA.id));
    // T2/T3 -> 9876 and the card (both fields were NULL)
    expect(await txn(t2.id), ('9876', cardA.id));
    expect(await txn(t3.id), ('9876', cardA.id));
    // T4 (AlexBank) -> untouched
    expect(await txn(t4.id), (null, null),
        reason: 'a different bank must never be reached');
    // T5 -> untouched, its own identity intact
    expect(await txn(t5.id), ('5555', existing.id),
        reason: 'an already-resolved row must never be rewritten');

    // The UI is notified after the local commit.
    expect(changedCalls, 1);
  });

  test('the linked SMS detection records are filled in the same commit',
      () async {
    final t1 = await insert(amount: 100000, bank: faisal);
    final t2 = await insert(amount: 200000, bank: faisal);
    final t3 = await insert(amount: 300000, bank: faisal);
    final t4 = await insert(amount: 400000, bank: alex);
    final t5 = await insert(amount: 500000, bank: faisal, last4: '5555');

    expect(await smsLast4For(t1.id), isNull);
    expect(await smsLast4For(t5.id), isNull);

    await controller().save(draft(t1, '9876'));

    expect(await smsLast4For(t1.id), '9876');
    expect(await smsLast4For(t2.id), '9876');
    expect(await smsLast4For(t3.id), '9876');
    expect(await smsFlagFor(t1.id), isTrue,
        reason: 'the identification state must match the stored value');
    expect(await smsFlagFor(t3.id), isTrue);

    // Unrelated records are not modified.
    expect(await smsLast4For(t4.id), isNull, reason: 'AlexBank is untouched');
    expect(await smsLast4For(t5.id), isNull,
        reason: 'the already-resolved row keeps its own record');
  });

  test('an existing explicit card_id is preserved while its last4 is filled',
      () async {
    // A row that is linked to a card but still missing the number. The two
    // fields are independent, so it must gain 9876 WITHOUT losing its card.
    final otherCard =
        await cardRepo.upsertCard(userId: user, last4: '1111', bankName: alex);
    final owned = await insert(
        amount: 100000, bank: faisal, cardId: otherCard.id);
    final t1 = await insert(amount: 200000, bank: faisal);

    await controller().save(draft(t1, '9876'));

    final after = await txn(owned.id);
    expect(after.$1, '9876',
        reason: 'a missing last4 is filled even when a card id exists');
    expect(after.$2, otherCard.id,
        reason: 'and the explicit card ownership is never overwritten');
  });

  test('a sibling of ANOTHER user is never reached', () async {
    // Same bank, same NULL last4 — but a different user.
    final mine = await insert(amount: 100000, bank: faisal);
    final theirs = Transaction(
      id: 'other',
      userId: 'other-user',
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 200000,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-other',
    );
    await txnLocal.insertTransaction(theirs);
    await smsLocal.upsert(SMSMessage(
      id: 'sother',
      userId: 'other-user',
      sender: faisal,
      messageHash: 'h-other',
      receivedAt: DateTime.now(),
      bankIdentified: true,
      detectedBankName: faisal,
      transactionId: 'other',
    ));

    await controller().save(draft(mine, '9876'));

    expect((await txnLocal.getTransactionsByUserId('other-user')).single.cardLast4,
        isNull,
        reason: 'one user must never inherit another user\'s confirmation');
    expect((await txn(mine.id)).$1, '9876');
  });

  test('bank identity is canonical, not a raw string compare', () async {
    // The edited row's detection says "faisal bank" (lower case); the sibling's
    // says "Faisal Bank". normalizeBankIdentity must treat them as one bank.
    final t1 = Transaction(
      id: 'canon-1',
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 100000,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-canon-1',
    );
    await txnLocal.insertTransaction(t1);
    await smsLocal.upsert(SMSMessage(
      id: 'scanon1',
      userId: user,
      sender: 'faisal bank',
      messageHash: 'h-c1',
      receivedAt: DateTime.now(),
      bankIdentified: true,
      detectedBankName: 'faisal bank',
      transactionId: 'canon-1',
    ));
    final t2 = await insert(amount: 200000, bank: 'Faisal Bank');

    await controller().save(draft(t1, '9876'));

    expect((await txn(t2.id)).$1, '9876',
        reason: 'case variants are one canonical bank');
  });
}
