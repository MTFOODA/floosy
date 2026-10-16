import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/detected_card_model.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/services/card_ownership.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
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

  late db.AppDatabase database;
  late MoneyLocalDataSource moneyLocal;
  late TransactionLocalDataSource txnLocal;
  late SmsMessageLocalDataSource smsLocal;
  late DetectedCardRepository cardRepo;
  late MoneyRepository moneyRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    moneyLocal = MoneyLocalDataSource(database);
    txnLocal = TransactionLocalDataSource(database);
    smsLocal = SmsMessageLocalDataSource(database);
    cardRepo = DetectedCardRepository(local: DetectedCardLocalDataSource());
    moneyRepo = MoneyRepository(
      remote: _Remote(),
      local: moneyLocal,
      transactionRepository: _LocalOnlyTransactionRepository(txnLocal),
      cashWalletRepository: _Cash(),
      expenseRepository: _Expenses(),
      detectedCardRepository: cardRepo,
      smsMessageLocalDataSource: smsLocal,
    );
  });
  tearDown(() => database.close());

  var seq = 0;

  /// Creates an UNRESOLVED transaction (no card_id) that also carries an SMS
  /// detection record, which is where its bank identity comes from.
  Future<Transaction> addUnresolved(
    TransactionType type,
    int amount, {
    String? last4,
    String? bank,
  }) async {
    final id = 'u${seq++}';
    final row = Transaction(
      id: id,
      userId: user,
      type: type,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-$id',
    );
    await txnLocal.insertTransaction(row);
    if (bank != null) {
      await smsLocal.upsert(SMSMessage(
        id: 's$id',
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

  Future<DetectedCard> card(String last4, String? bank) =>
      cardRepo.upsertCard(userId: user, last4: last4, bankName: bank);

  Future<Transaction> rowById(String id) async {
    final rows = await txnLocal.getTransactionsByUserId(user);
    return rows.firstWhere((t) => t.id == id);
  }

  /// The user TEACHES the application an identity: enters [last4] on [t], which
  /// already knows its bank. Returns the learned (or reused) card.
  Future<DetectedCard> learnCard(Transaction t, String last4) async {
    final result = await moneyRepo.learnCardIdentity(
      userId: user,
      transactionId: t.id,
      last4: last4,
    );
    expect(result.isResolved, isTrue,
        reason: 'user confirmation must resolve: ${result.resolution.reason}');
    return (result.resolution as Resolved).card;
  }

  // Test A - the user TEACHES CIB + 1234 (no pre-existing card needed).
  test('A: user confirmation creates a brand new Bank + Last 4 identity',
      () async {
    // Nothing exists yet: no cards at all.
    expect(await cardRepo.getCards(user), isEmpty);
    final t = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');

    final learned = await learnCard(t, '1234');

    // A persistent card identity now exists for user + CIB + 1234.
    expect(learned.last4, '1234');
    expect(normalizeBankIdentity(learned.bankName), 'cib');
    expect((await cardRepo.getCards(user)).length, 1);
    // And the transaction is bound to it.
    expect((await rowById(t.id)).cardId, learned.id);
    // Red dot gone.
    expect(await moneyRepo.getUnassignedTransactions(user), isEmpty);
  });

  // Test B - propagation to all identical unresolved rows.
  test('B: confirming one of five identical rows resolves all five', () async {
    final rows = <Transaction>[];
    for (var i = 0; i < 5; i++) {
      rows.add(await addUnresolved(TransactionType.purchase, 1000 * (i + 1),
          last4: '1234', bank: 'CIB'));
    }

    final learned = await learnCard(rows.first, '1234');

    for (final r in rows) {
      expect((await rowById(r.id)).cardId, learned.id,
          reason: 'row ${r.id} must resolve with no extra manual work');
    }
    // Exactly one card identity was created - no duplicates.
    expect((await cardRepo.getCards(user)).length, 1);
    expect(await moneyRepo.getUnassignedTransactions(user), isEmpty);
  });

  // â”€â”€ Test 1 â€” unique Last 4 + Bank â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Test C - a different bank with the same Last 4 is NOT touched.
  test('C: CIB + 1234 learning never touches NBE + 1234', () async {
    final cibRow = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final nbeRow = await addUnresolved(TransactionType.purchase, 20000,
        last4: '1234', bank: 'NBE');

    final learned = await learnCard(cibRow, '1234');

    expect((await rowById(cibRow.id)).cardId, learned.id);
    // The NBE row is untouched and keeps its red dot.
    expect((await rowById(nbeRow.id)).cardId, isNull);
    expect((await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id),
        contains(nbeRow.id));
  });

  // Test D - a different Last 4 on the same bank is NOT touched.
  test('D: CIB + 1234 learning never touches CIB + 5678', () async {
    final t1234 = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final t5678 = await addUnresolved(TransactionType.purchase, 20000,
        last4: '5678', bank: 'CIB');

    final learned = await learnCard(t1234, '1234');

    expect((await rowById(t1234.id)).cardId, learned.id);
    expect((await rowById(t5678.id)).cardId, isNull);
    expect((await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id),
        contains(t5678.id));
  });

  // Test G - the same bank can hold several distinct cards.
  test('G: CIB + 1234 and CIB + 5678 become two independent identities',
      () async {
    final t1234 = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final t5678 = await addUnresolved(TransactionType.purchase, 20000,
        last4: '5678', bank: 'CIB');

    final cardA = await learnCard(t1234, '1234');
    final cardB = await learnCard(t5678, '5678');

    // Two distinct identities, even for the same bank.
    expect(cardA.id, isNot(cardB.id));
    expect((await cardRepo.getCards(user)).length, 2);
    expect((await rowById(t1234.id)).cardId, cardA.id);
    expect((await rowById(t5678.id)).cardId, cardB.id);
  });

  // Test F - without a bank identity nothing is learned or guessed.
  test('F: no bank identity means no 1234 -> card mapping is created',
      () async {
    final t = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234'); // no bank at all

    final result = await moneyRepo.learnCardIdentity(
      userId: user,
      transactionId: t.id,
      last4: '1234',
    );

    // Refused, with a reason the UI can surface.
    expect(result.isResolved, isFalse);
    expect((result.resolution as Unresolved).detail, 'no_bank_identity');
    // No card identity was created - in particular no bare "1234" mapping.
    expect(await cardRepo.getCards(user), isEmpty);
    expect((await rowById(t.id)).cardId, isNull);
     // The learned-identity lookup (the path SMS ingestion uses) finds nothing,
     // so a future SMS for this bank+last4 will NOT be auto-assigned to a
     // card the user never actually confirmed.
     expect(
       await moneyRepo.findLearnedCardIdentity(
           userId: user, last4: '1234', bankName: 'CIB'),
       isNull,
     );
  });

  test('T1: a unique Last 4 resolves automatically', () async {
    final cib = await card('1234', 'CIB');
    final t = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');

    final result = await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: t.id,
      last4: '1234',
    );

    expect(result.isResolved, isTrue);
    expect(result.transactionAssigned, isTrue);
    expect((await rowById(t.id)).cardId, cib.id);
  });

  // â”€â”€ Test 2 â€” same Last 4, different banks â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T2: Last 4 + a bank selects the right card among same-last4 cards',
      () async {
    final nbe = await card('1234', 'NBE');
    await card('1234', 'CIB');
    final t = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'NBE');

    final result = await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: t.id,
      last4: '1234',
      bankIdentity: 'NBE',
    );

    expect(result.isResolved, isTrue);
    expect((await rowById(t.id)).cardId, nbe.id);
  });

  // â”€â”€ Test 3 â€” Last 4 without a bank stays unresolved â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T3: Last 4 alone is ambiguous when banks share it', () async {
    await card('1234', 'CIB');
    await card('1234', 'NBE');
    final t = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234'); // no bank at all

    final result = await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: t.id,
      last4: '1234',
    );

    expect(result.isAmbiguous, isTrue);
    expect(result.transactionAssigned, isFalse);
    expect((await rowById(t.id)).cardId, isNull);
    // The red dot stays: it is still unassigned.
    final unresolved = await moneyRepo.getUnassignedTransactions(user);
    expect(unresolved.map((r) => r.id), contains(t.id));
  });

  // â”€â”€ Test 4 â€” automatic propagation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T4: resolving one transaction propagates to identical unresolved rows',
      () async {
    final cib = await card('1234', 'CIB');
    final a = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final b = await addUnresolved(TransactionType.purchase, 20000,
        last4: '1234', bank: 'CIB');
    final c = await addUnresolved(TransactionType.purchase, 30000,
        last4: '1234', bank: 'CIB');

    final result = await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: a.id,
      last4: '1234',
      bankIdentity: 'CIB',
    );

    expect(result.isResolved, isTrue);
    expect(result.totalAssigned, 3);
    // All three point at the same card with no further manual work.
    expect((await rowById(a.id)).cardId, cib.id);
    expect((await rowById(b.id)).cardId, cib.id);
    expect((await rowById(c.id)).cardId, cib.id);
    expect(await moneyRepo.getUnassignedTransactions(user), isEmpty);
  });

  // â”€â”€ Test 5 â€” never modify an existing assignment â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T5: an already-resolved transaction is never reassigned', () async {
    final cardA = await card('1234', 'CIB');
    final existing = await addUnresolved(TransactionType.purchase, 5000,
        last4: '1234', bank: 'CIB');
    // Explicitly assigned to Card A already.
    await moneyRepo.local.updateTransactionCardId(existing.id, cardA.id);
    // A second card later appears with the SAME last4.
    final cardB = await card('1234', 'Other Bank');
    final other = await addUnresolved(TransactionType.purchase, 7000,
        last4: '1234', bank: 'Other Bank');

    await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: other.id,
      last4: '1234',
      bankIdentity: 'Other Bank',
    );

    // The explicit assignment survives untouched.
    expect((await rowById(existing.id)).cardId, cardA.id);
    expect((await rowById(other.id)).cardId, cardB.id);
    expect(cardA.id, isNot(cardB.id));
  });

  // â”€â”€ Test 6 â€” ambiguous records stay unresolved, no balance impact â”€â”€â”€â”€â”€â”€â”€
  test('T6: an ambiguous identity assigns nothing and hits no balance',
      () async {
    final cib = await card('1234', 'CIB');
    final nbe = await card('1234', 'NBE');
    // Fund both cards so a leak would be visible.
    for (final c in [cib, nbe]) {
      await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction: Transaction(
          id: 'fund-${c.id}',
          userId: user,
          type: TransactionType.income,
          source: TransactionSource.sms,
          amountMinor: 1000000,
          cardLast4: c.last4,
          cardId: c.id,
          transactionDate: DateTime.now(),
          fingerprint: 'fp-fund-${c.id}',
        ),
      );
    }
    final ambiguous =
        await addUnresolved(TransactionType.purchase, 250000, last4: '1234');

    final result = await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: ambiguous.id,
      last4: '1234',
    );

    expect(result.isAmbiguous, isTrue);
    expect((await rowById(ambiguous.id)).cardId, isNull);
    // No assignment, red dot remains, and no balance moved.
    expect((await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id),
        contains(ambiguous.id));
    expect(
        await moneyRepo.getMyBalanceForCard(user, '1234', bankName: 'CIB'),
        1000000);
    expect(
        await moneyRepo.getMyBalanceForCard(user, '1234', bankName: 'NBE'),
        1000000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1234',
        bankName: 'CIB'), 0);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1234',
        bankName: 'NBE'), 0);
  });

  // â”€â”€ Test 9 â€” a bank-qualified decision must not pull in unknown-bank rows
  test('T9: a row with an unknown bank is NOT pulled in by a CIB decision',
      () async {
    final cib = await card('1234', 'CIB');
    await card('1234', 'NBE');
    final cibRow = await addUnresolved(TransactionType.transfer_in, 50000,
        last4: '1234', bank: 'CIB');
    // Same last4, but we cannot prove which bank it came from.
    final unknownBankRow = await addUnresolved(TransactionType.transfer_in, 90000,
        last4: '1234');

    await moneyRepo.resolveCardIdentityForUserInput(
      userId: user,
      transactionId: cibRow.id,
      last4: '1234',
      bankIdentity: 'CIB',
    );

    expect((await rowById(cibRow.id)).cardId, cib.id);
    // Critical: the unknown-bank row stays unresolved and keeps its red dot.
    expect((await rowById(unknownBankRow.id)).cardId, isNull);
    expect((await moneyRepo.getUnassignedTransactions(user)).map((r) => r.id),
        contains(unknownBankRow.id));
  });

  // â”€â”€ Test 7 â€” balance after propagation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T7: propagation moves balances to the correct card only', () async {
    final cardA = await card('1111', 'CIB');
    final cardB = await card('2222', 'NBE');
    // Seed each card with a known opening deposit.
    for (final c in [cardA, cardB]) {
      await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction: Transaction(
          id: 'seed-${c.id}',
          userId: user,
          type: TransactionType.income,
          source: TransactionSource.sms,
          amountMinor: 1000000,
          cardLast4: c.last4,
          cardId: c.id,
          transactionDate: DateTime.now(),
          fingerprint: 'fp-seed-${c.id}',
        ),
      );
    }

    // An unresolved incoming transfer that will be resolved to Card A.
    final incoming = await addUnresolved(TransactionType.transfer_in, 200000,
        last4: '1111', bank: 'CIB');
    // An unresolved purchase that will be resolved to Card B.
    final purchase = await addUnresolved(TransactionType.purchase, 300000,
        last4: '2222', bank: 'NBE');

    // Each unresolved row has a UNIQUE last4, so the pre-existing ownership
    // rule already attributes it to that card by last4 alone. That is the
    // deliberate, pre-existing behaviour (money on a card Floosy has not yet
    // registered still counts against it) and is unchanged by this work. What
    // the smart resolver adds is the durable, explicit card_id - and, above all,
    // the bank-qualified disambiguation a bare last4 cannot do.
    expect(await moneyRepo.getMyBalanceForCard(user, '1111', bankName: 'CIB'),
        1000000 + 200000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2222', bankName: 'NBE'),
        1000000 - 300000);
    await moneyRepo.resolveCardIdentityForUserInput(
        userId: user,
        transactionId: incoming.id,
        last4: '1111',
        bankIdentity: 'CIB');
    await moneyRepo.resolveCardIdentityForUserInput(
        userId: user,
        transactionId: purchase.id,
        last4: '2222',
        bankIdentity: 'NBE');

    // Card A: +2000 incoming. Card B untouched by it.
    expect(await moneyRepo.getMyBalanceForCard(user, '1111', bankName: 'CIB'),
        1200000);
    // Card B: -3000 purchase and +3000 Deducted Money. Card A untouched by it.
    expect(await moneyRepo.getMyBalanceForCard(user, '2222', bankName: 'NBE'),
        700000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222', bankName: 'NBE'),
        300000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111', bankName: 'CIB'),
        0);
  });

  // â”€â”€ Test 8 â€” idempotency â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T8: repeated resolution and backfill are idempotent', () async {
    final cib = await card('1234', 'CIB');
    final a = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final b = await addUnresolved(TransactionType.purchase, 20000,
        last4: '1234', bank: 'CIB');

    await moneyRepo.resolveCardIdentityForUserInput(
        userId: user, transactionId: a.id, last4: '1234');
    final balanceAfterFirst =
        await moneyRepo.getMyBalanceForCard(user, '1234', bankName: 'CIB');
    final deductedAfterFirst =
        await moneyRepo.getDeductedMoneyForCard(user, '1234', bankName: 'CIB');
    expect(balanceAfterFirst, -30000);

    // Run the same resolution repeatedly, plus a backfill sweep each time.
    for (var i = 0; i < 3; i++) {
      await moneyRepo.resolveCardIdentityForUserInput(
          userId: user, transactionId: a.id, last4: '1234');
      expect(await moneyRepo.backfillCardIdentities(user), 0,
          reason: 'backfill must be a no-op once everything is resolved');
    }

    // No duplicate updates, no balance duplication, no ownership drift.
    expect((await rowById(a.id)).cardId, cib.id);
    expect((await rowById(b.id)).cardId, cib.id);
    expect(await moneyRepo.getMyBalanceForCard(user, '1234', bankName: 'CIB'),
        balanceAfterFirst);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1234', bankName: 'CIB'),
        deductedAfterFirst);
    // Exactly two rows exist: nothing was duplicated.
    expect((await txnLocal.getTransactionsByUserId(user)).length, 2);
  });

  // â”€â”€ Backfill uses the same deterministic rules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('T10: backfill resolves provable rows and leaves ambiguous ones',
      () async {
    final cib = await card('1234', 'CIB');
    final uniqueCard = await card('1111', 'CIB');
    await card('1234', 'NBE');
    // Unique last4, no bank needed: provable.
    final unique =
        await addUnresolved(TransactionType.purchase, 10000, last4: '1111');
    // Ambiguous last4 WITH a bank that narrows it: provable.
    final qualified = await addUnresolved(TransactionType.purchase, 20000,
        last4: '1234', bank: 'CIB');
    // Ambiguous last4 with no bank: NOT provable.
    final unprovable =
        await addUnresolved(TransactionType.purchase, 30000, last4: '1234');
    // No last4 at all: NOT provable.
    final noLast4 = await addUnresolved(TransactionType.purchase, 40000);

    final repaired = await moneyRepo.backfillCardIdentities(user);

    expect(repaired, 2);
    expect((await rowById(unique.id)).cardId, uniqueCard.id);
    expect((await rowById(qualified.id)).cardId, cib.id);
    expect((await rowById(unprovable.id)).cardId, isNull);
    expect((await rowById(noLast4.id)).cardId, isNull);

    // Idempotent on a second pass.
    expect(await moneyRepo.backfillCardIdentities(user), 0);
  });

  // â”€â”€ Resolver unit rules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('resolver: normalisation and validation are strict', () {
    expect(normalizeCardLast4(' 1234 '), '1234');
    expect(normalizeCardLast4('12 34'), '1234');
    expect(normalizeCardLast4('****1234'), '1234');
    // Anything that is not exactly four digits is rejected, never repaired.
    expect(normalizeCardLast4('123'), isNull);
    expect(normalizeCardLast4('12345'), isNull);
    expect(normalizeCardLast4('abcd'), isNull);
    expect(normalizeCardLast4(''), isNull);
    expect(normalizeCardLast4(null), isNull);

    // Bank aliases collapse to one identity, with no invented mappings.
    expect(normalizeBankIdentity('CIB'), 'cib');
    expect(normalizeBankIdentity('  cib '), 'cib');
    expect(normalizeBankIdentity('CIB Bank'), 'cib');
    expect(normalizeBankIdentity(''), isNull);
    expect(normalizeBankIdentity(null), isNull);
  });

  test('resolver: three-way outcome and safe identity matching', () {
    final cib =
        DetectedCard(id: 'c1', userId: user, last4: '1234', bankName: 'CIB');
    final nbe =
        DetectedCard(id: 'c2', userId: user, last4: '1234', bankName: 'NBE');
    final other =
        DetectedCard(id: 'c3', userId: user, last4: '9999', bankName: 'CIB');
    final all = [cib, nbe, other];

    // Unique last4 -> Resolved, with or without a bank.
    expect(CardIdentityResolver.resolve(cards: all, last4: '9999'), isA<Resolved>());
    // Shared last4 + matching bank -> Resolved.
    expect(
      CardIdentityResolver.resolve(
          cards: all, last4: '1234', bankIdentity: 'NBE'),
      isA<Resolved>(),
    );
    // Shared last4, no bank -> Ambiguous (keeps the red dot).
    expect(CardIdentityResolver.resolve(cards: all, last4: '1234'), isA<Ambiguous>());
    // An unknown bank proves nothing.
    expect(
      CardIdentityResolver.resolve(
          cards: all, last4: '1234', bankIdentity: 'Some Other Bank'),
      isA<Unresolved>(),
    );
    // Unknown or malformed last4 -> Unresolved.
    expect(CardIdentityResolver.resolve(cards: all, last4: '0000'), isA<Unresolved>());
    expect(CardIdentityResolver.resolve(cards: all, last4: 'abc'), isA<Unresolved>());
    expect(CardIdentityResolver.resolve(cards: all), isA<Unresolved>());

    // identitiesMatch: equal last4 is enough only when no bank conflicts.
    expect(
      CardIdentityResolver.identitiesMatch(
          leftLast4: '1234', leftBank: 'CIB', rightLast4: '1234', rightBank: 'cib'),
      isTrue,
      reason: 'bank aliases are the same identity',
    );
    expect(
      CardIdentityResolver.identitiesMatch(
          leftLast4: '1234', leftBank: 'CIB', rightLast4: '1234', rightBank: 'NBE'),
      isFalse,
      reason: 'a bank conflict is never safe',
    );
    expect(
      CardIdentityResolver.identitiesMatch(
          leftLast4: '1234', leftBank: 'CIB', rightLast4: '1234'),
      isFalse,
      reason: 'a bank-qualified identity must NOT claim a row with no bank',
    );
    expect(
      CardIdentityResolver.identitiesMatch(
          leftLast4: '1234', leftBank: 'CIB', rightLast4: '9999'),
      isFalse,
      reason: 'a different last4 is never the same card',
    );
  });

  // â”€â”€ Red dot uses the SAME resolver as the balances â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  test('red dot agrees with the resolver verdict, never a separate rule', () {
    final cib =
        DetectedCard(id: 'c1', userId: user, last4: '1234', bankName: 'CIB');
    final nbe =
        DetectedCard(id: 'c2', userId: user, last4: '1234', bankName: 'NBE');
    final other =
        DetectedCard(id: 'c3', userId: user, last4: '9999', bankName: 'CIB');
    final all = [cib, nbe, other];

    Transaction build({String? last4, String? cardId}) => Transaction(
          id: 'x',
          userId: user,
          type: TransactionType.purchase,
          source: TransactionSource.sms,
          amountMinor: 100,
          cardLast4: last4,
          cardId: cardId,
          transactionDate: DateTime.now(),
          fingerprint: 'fp-x',
        );

    // Resolved identity -> no red dot.
    expect(CardOwnership.isUnassigned(build(last4: '9999'), all), isFalse);
    expect(
      CardOwnership.isUnassigned(build(last4: '1234', cardId: 'c1'), all),
      isFalse,
    );
    // Ambiguous -> red dot.
    expect(CardOwnership.isUnassigned(build(last4: '1234'), all), isTrue);
    // Unresolved -> red dot.
    expect(CardOwnership.isUnassigned(build(), all), isTrue);
    // A dangling card_id is unresolved, never re-homed.
    expect(
      CardOwnership.isUnassigned(build(last4: '1234', cardId: 'gone'), all),
      isTrue,
    );

    // The verdict and the red dot must never disagree, for every identity that
    // refers to a card Floosy actually knows about.
    for (final last4 in ['9999', '1234']) {
      final verdict = CardIdentityResolver.resolve(cards: all, last4: last4);
      final redDot = CardOwnership.isUnassigned(build(last4: last4), all);
      expect(redDot, isNot(verdict.isResolved),
          reason: 'resolver said ${verdict.reason} for last4=$last4');
    }

    // A last4 that matches NO known card is a deliberate, documented nuance and
    // the two questions are genuinely different:
    //   * "is this row unassigned?"      -> no: a unique last4 is attributable
    //     to the (not yet registered) card it names, so the pre-existing
    //     ownership rule still counts it against that card.
    //   * "can we WRITE a card_id?"      -> no: there is no card to point at.
    // So it gets no red dot and no fabricated card_id, which is consistent.
    final unknownCard = CardIdentityResolver.resolve(cards: all, last4: '0000');
    expect(unknownCard, isA<Unresolved>());
    expect(CardOwnership.isUnassigned(build(last4: '0000'), all), isFalse,
        reason: 'a unique last4 is attributable even before the card is known');

    // Malformed or missing last4: no attribution at all -> red dot.
    for (final bad in ['abc', '123', '12345', null]) {
      expect(CardIdentityResolver.resolve(cards: all, last4: bad),
          isA<Unresolved>());
      // isUnassigned() is last4-shaped, so a malformed last4 that is not four
      // digits simply cannot match any card.
      expect(CardOwnership.isUnassigned(build(last4: bad), all), isTrue,
          reason: 'last4=$bad cannot identify a card');
    }
    // A well-formed but unknown last4 is the one case where the two questions
    // differ, and it is asserted explicitly above.
  });

  // Test E - a FUTURE SMS is routed at ingestion using the learned identity.
  test('E: a later SMS for the learned identity is assigned at ingestion',
      () async {
    // The user has already confirmed this bank's 1234 card on an earlier
    // transaction. NOTE: the app identifies a bank by its display NAME (what
    // the SMS parser emits and what the editor pre-fills), so the learned
    // identity uses that same string - the numeric code is never involved.
    const bankName = 'Commercial International Bank';
    final first = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: bankName);
    final learned = await learnCard(first, '1234');

    final processor = SMSTransactionProcessor(
      moneyRepository: moneyRepo,
      detectedCardRepository: cardRepo,
    );

    // A brand-new SMS for the SAME bank + last4 arrives tomorrow.
    final recorded = await processor.process(
      userId: user,
      sender: 'CIB',
      smsContent: 'CIB: purchase EGP 50.00 card ****1234',
    );
    expect(recorded, isTrue);

    final rows = await txnLocal.getTransactionsByUserId(user);
    final fresh = rows.firstWhere((t) => t.amountMinor == 5000);
    // Assigned DURING ingestion - no unresolved intermediate state at all.
    expect(fresh.cardId, learned.id);
    // And the learned identity was reused, not duplicated.
    expect((await cardRepo.getCards(user)).length, 1);
    expect(await moneyRepo.getUnassignedTransactions(user), isEmpty);
  });

  // Test H - an existing explicit assignment is never moved by learning.
  test('H: learning another CIB identity never moves an assigned row',
      () async {
    final cardA = await card('1234', 'CIB');
    final pinned = await addUnresolved(TransactionType.purchase, 5000,
        last4: '1234', bank: 'CIB');
    // Explicitly pinned to Card A already.
    await moneyRepo.local.updateTransactionCardId(pinned.id, cardA.id);

    // The user now teaches a DIFFERENT CIB card: CIB + 5678.
    final other = await addUnresolved(TransactionType.purchase, 7000,
        last4: '5678', bank: 'CIB');
    final learned = await learnCard(other, '5678');

    // The pinned row is untouched, even though the new identity is also CIB.
    expect((await rowById(pinned.id)).cardId, cardA.id);
    expect((await rowById(other.id)).cardId, learned.id);
    expect(learned.id, isNot(cardA.id));
  });

  // Test I - learned identities are strictly per user.
  test('I: one user never inherits another user\'s learned identity',
      () async {
    const other = 'other-user';
    // User A learns CIB + 1234.
    final a = await addUnresolved(TransactionType.purchase, 10000,
        last4: '1234', bank: 'CIB');
    final learned = await learnCard(a, '1234');

    // User B must start from nothing: their lookup finds no card, and a new
    // transaction for the same bank+last4 is NOT routed to User A's card.
    expect(
      await moneyRepo.findLearnedCardIdentity(
          userId: other, last4: '1234', bankName: 'CIB'),
      isNull,
    );
    await txnLocal.insertTransaction(Transaction(
      id: 'b-row',
      userId: other,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 10000,
      cardLast4: '1234',
      transactionDate: DateTime.now(),
      fingerprint: 'fp-b-row',
    ));
    final bRow = (await txnLocal.getTransactionsByUserId(other)).single;
    expect(bRow.cardId, isNull,
        reason: 'user B must not inherit user A\'s card');
    // And the two users' card stores are independent.
    final bCards = await DetectedCardRepository(
        local: DetectedCardLocalDataSource()).getCards(other);
    expect(bCards, isEmpty);
    expect(learned.userId, user);
  });

  // T12 - the exact reported scenario T1..T5, asserted against the DATABASE.
  test('T12: CIB+1234 learning links B and C but not D and E', () async {
    final cardB = await card('5678', 'CIB'); // the CIB/5678 card

    // T1: CIB, no last4, no card.
    final t1 = await addUnresolved(TransactionType.purchase, 1000,
        last4: null, bank: 'CIB');
    // T2, T3: CIB + 1234, no card yet.
    final t2 = await addUnresolved(TransactionType.purchase, 2000,
        last4: '1234', bank: 'CIB');
    final t3 = await addUnresolved(TransactionType.purchase, 3000,
        last4: '1234', bank: 'CIB');
    // T4: already pinned to the CIB/5678 card.
    final t4 = await addUnresolved(TransactionType.purchase, 4000,
        last4: '5678', bank: 'CIB');
    await moneyRepo.local.updateTransactionCardId(t4.id, cardB.id);
    // T5: NBE + 1234, no card.
    final t5 = await addUnresolved(TransactionType.purchase, 5000,
        last4: '1234', bank: 'NBE');

    final cardA = await learnCard(t1, '1234');

    // Direct Drift reads - no repository caching in the way.
    Future<String?> dbCard(String id) async => (await txnLocal
        .getTransactionsByUserId(user))
        .firstWhere((r) => r.id == id)
        .cardId;

    expect(await dbCard(t1.id), cardA.id, reason: 'T1 must be assigned');
    expect(await dbCard(t2.id), cardA.id, reason: 'T2 MUST be propagated');
    expect(await dbCard(t3.id), cardA.id, reason: 'T3 MUST be propagated');
    expect(await dbCard(t4.id), cardB.id, reason: 'T4 must stay on CardB');
    expect(await dbCard(t5.id), isNull, reason: 'T5 must stay unresolved');
  });
}

