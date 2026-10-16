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
import 'package:floosy/data/services/sms_transaction_processor.dart';
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

  setUp(() {
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
    required TransactionType type,
    required int amount,
    String? last4,
    String? bank,
    String? merchantName,
  }) async {
    final id = 'txn${seq++}';
    final row = Transaction(
      id: id,
      userId: user,
      type: type,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      // The SMS pipeline sets merchantName to `parsed.merchant ?? bankName`, so
      // a purchase SMS usually carries a MERCHANT here - which is exactly what
      // used to be mistaken for the bank.
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

  /// Reads straight from the Drift table, bypassing every repository cache.
  Future<Transaction> dbRow(String id) async => (await txnLocal
      .getTransactionsByUserId(user))
      .firstWhere((r) => r.id == id);

  TransactionEditController controller() => TransactionEditController(
        userId: user,
        transactionRepository: txnRepo,
        moneyRepository: moneyRepo,
        cardRepository: cardRepo,
        // No remote bank catalog in this environment.
        bankCatalogLoader: () async => <Bank>[],
      );

  /// The dialog payload, with the bank field pre-filled exactly the way the
  /// screen pre-fills it (from merchantName).
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

  /// THE EXACT REPORTED SCENARIO (T1..T5).
  test('Edit->Save on T1 with 1234 links T2 and T3, leaves T4 and T5 alone',
      () async {
    // Card A = CIB/1234 does NOT exist yet. Card B = CIB/5678 DOES.
    final cardB =
        await cardRepo.upsertCard(userId: user, last4: '5678', bankName: cib);

    // T1: CIB, no last4, no card. Its merchant name is a SHOP, not a bank.
    final t1 = await insert(
      type: TransactionType.purchase,
      amount: 100000,
      bank: cib,
      merchantName: 'KOSHARY ABU TAREK',
    );
    expect((await dbRow(t1.id)).cardLast4, isNull);
    expect((await dbRow(t1.id)).cardId, isNull);

    // T2, T3: CIB + 1234, no card yet - the rows that must be linked.
    final t2 = await insert(
        type: TransactionType.purchase, amount: 200000, last4: '1234', bank: cib);
    final t3 = await insert(
        type: TransactionType.purchase, amount: 300000, last4: '1234', bank: cib);

    // T4: already pinned to the CIB/5678 card.
    final t4 = await insert(
        type: TransactionType.purchase, amount: 400000, last4: '5678', bank: cib);
    await moneyLocal.updateTransactionCardId(t4.id, cardB.id);

    // T5: NBE + 1234, no card - must stay unresolved.
    final t5 = await insert(
        type: TransactionType.purchase, amount: 500000, last4: '1234', bank: nbe);

    // ---- long press T1 -> Edit -> type 1234 -> Save ----
    // The bank field is pre-filled with the MERCHANT name and left untouched:
    // this is the real-world case that used to learn a bogus identity and so
    // propagated to nothing.
    final learned = await controller().save(draft(t1, '1234'));

    expect(learned, isNotNull);
    expect(learned!.isResolved, isTrue,
        reason: 'CIB + 1234 must resolve: ${learned.resolution.reason}');
    final cardA = (learned.resolution as Resolved).card;

    // The learned identity must be the DETECTED bank, never the merchant.
    expect(normalizeBankIdentity(cardA.bankName), 'cib',
        reason: 'must learn the bank, not the merchant name');

    // ---- verify the DATABASE ----
    expect((await dbRow(t1.id)).cardId, cardA.id, reason: 'T1 assigned');
    expect((await dbRow(t1.id)).cardLast4, '1234', reason: 'T1 last4 saved');
    expect((await dbRow(t2.id)).cardId, cardA.id, reason: 'T2 propagated');
    expect((await dbRow(t3.id)).cardId, cardA.id, reason: 'T3 propagated');
    expect((await dbRow(t4.id)).cardId, cardB.id,
        reason: 'T4 must stay on CardB');
    expect((await dbRow(t5.id)).cardId, isNull,
        reason: 'T5 (NBE) must stay unresolved');

    // Red dots: gone for the CIB rows, still on the NBE row.
    final unresolved =
        (await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id).toSet();
    expect(unresolved.contains(t1.id), isFalse);
    expect(unresolved.contains(t2.id), isFalse);
    expect(unresolved.contains(t3.id), isFalse);
    expect(unresolved.contains(t5.id), isTrue);

    // Balances follow ownership, per card and isolated.
    final bA = await moneyRepo.getCardBalance(user, '1234', bankName: cib);
    final bB = await moneyRepo.getCardBalance(user, '5678', bankName: cib);
    expect(bA.myBalanceMinor, -600000);
    expect(bA.deductedMinor, 600000);
    expect(bB.myBalanceMinor, -400000);
    expect(bB.deductedMinor, 400000);
  });

  // A future SMS for the learned identity is routed at ingestion.
  test('a later SMS for the learned identity is assigned at ingestion',
      () async {
    // The SMS parser identifies a bank by its catalog NAME, so the transaction
    // and the incoming message must agree on that exact string for the learned
    // identity to be found. (Floosy stores the name, not the short code.)
    const detectedBank = 'Commercial International Bank';
    final t1 = await insert(
        type: TransactionType.purchase, amount: 100000, bank: detectedBank);
    final learned = await controller().save(draft(t1, '1234'));
    final cardA = (learned!.resolution as Resolved).card;

    final processor = SMSTransactionProcessor(
      moneyRepository: moneyRepo,
      detectedCardRepository: cardRepo,
    );
    await processor.process(
      userId: user,
      sender: 'CIB',
      smsContent: 'CIB: purchase EGP 75.00 card ****1234',
    );

    final rows = await txnLocal.getTransactionsByUserId(user);
    final fresh = rows.firstWhere((r) => r.amountMinor == 7500);
    expect(fresh.cardId, cardA.id,
        reason: 'assigned during ingestion, no unresolved intermediate state');
    // Reused, not duplicated.
    expect(
        (await cardRepo.getCards(user)).where((c) => c.last4 == '1234').length,
        1);
  });

  // Re-saving must not duplicate identities or double-count balances.
  test('saving the same confirmation twice is idempotent', () async {
    final t1 =
        await insert(type: TransactionType.purchase, amount: 100000, bank: cib);
    final t2 = await insert(
        type: TransactionType.purchase, amount: 200000, last4: '1234', bank: cib);

    await controller().save(draft(t1, '1234'));
    final first = await moneyRepo.getCardBalance(user, '1234', bankName: cib);
    await controller().save(draft(await dbRow(t1.id), '1234'));
    final second = await moneyRepo.getCardBalance(user, '1234', bankName: cib);

    expect(second.myBalanceMinor, first.myBalanceMinor);
    expect((await cardRepo.getCards(user)).length, 1);
    expect((await dbRow(t2.id)).cardId, (await dbRow(t1.id)).cardId);
  });

  // The product rule: confirming a Last 4 for a bank fills every same-user,
  // same-bank row that is MISSING the number. This replaces the previous
  // "bank alone proves nothing" guard, which left real rows unresolved.
  test('a CIB row with NO last4 DOES receive the confirmed last4', () async {
    final t1 =
        await insert(type: TransactionType.purchase, amount: 100000, bank: cib);
    // Same bank, no card number yet: this is exactly the population that used to
    // be left untouched.
    final noLast4 =
        await insert(type: TransactionType.purchase, amount: 900000, bank: cib);

    await controller().save(draft(t1, '1234'));

    expect((await dbRow(t1.id)).cardId, isNotNull);
    expect((await dbRow(noLast4.id)).cardLast4, '1234',
        reason: 'same user + same bank + NULL last4 must be filled');
    expect((await dbRow(noLast4.id)).cardId, isNotNull,
        reason: 'and it gets the resolved card, since it had none');
  });

  // Cross-bank safety, through the real save path.
  test('CIB+1234 and CIB+5678 stay separate cards via the save path',
      () async {
    final t1 =
        await insert(type: TransactionType.purchase, amount: 100000, bank: cib);
    final tA = await insert(
        type: TransactionType.purchase, amount: 200000, last4: '1234', bank: cib);
    final tB = await insert(
        type: TransactionType.purchase, amount: 300000, last4: '5678', bank: cib);

    final learned = await controller().save(draft(t1, '1234'));
    final cardA = (learned!.resolution as Resolved).card;

    expect((await dbRow(tA.id)).cardId, cardA.id);
    expect((await dbRow(tB.id)).cardId, isNull,
        reason: 'a different last4 is a different card');
    // No cross-bank: the NBE row is untouched.
    final nbeRow = await insert(
        type: TransactionType.purchase, amount: 400000, last4: '1234', bank: nbe);
    await controller().save(draft(t1, '1234'));
    expect((await dbRow(nbeRow.id)).cardId, isNull,
        reason: 'NBE+1234 must never join the CIB card');
  });
}