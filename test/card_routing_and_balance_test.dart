import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

/// Local-only transaction repository: exercises the real Drift table so the
/// `card_id` / `card_last4` columns are genuinely persisted and re-read.
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
  late DetectedCardRepository cardRepo;
  late MoneyRepository moneyRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    moneyLocal = MoneyLocalDataSource(database);
    txnLocal = TransactionLocalDataSource(database);
    cardRepo = DetectedCardRepository(local: DetectedCardLocalDataSource());
    moneyRepo = MoneyRepository(
      remote: _Remote(),
      local: moneyLocal,
      transactionRepository: _LocalOnlyTransactionRepository(txnLocal),
      cashWalletRepository: _Cash(),
      expenseRepository: _Expenses(),
      detectedCardRepository: cardRepo,
    );
  });
  tearDown(() => database.close());

  var seq = 0;

  /// Records a transaction already bound to a resolved card, exactly the way
  /// the SMS pipeline now writes it (card_id stamped at creation time).
  Future<void> addFor(String last4, TransactionType type, int amount,
      {String? bankName}) async {
    final card = (await cardRepo.getCards(user)).firstWhere(
        (c) => c.last4 == last4 && (bankName == null || c.bankName == bankName));
    final id = 't${seq++}';
    await moneyRepo.recordSmsTransaction(
      userId: user,
      transaction: Transaction(
        id: id,
        userId: user,
        type: type,
        source: TransactionSource.sms,
        amountMinor: amount,
        cardLast4: last4,
        cardId: card.id,
        transactionDate: DateTime.now(),
        fingerprint: 'fp-$id',
      ),
    );
  }

  /// Records a transaction with NO card at all - the ambiguous case.
  Future<void> addUnassigned(TransactionType type, int amount) async {
    final id = 'u${seq++}';
    await moneyRepo.recordSmsTransaction(
      userId: user,
      transaction: Transaction(
        id: id,
        userId: user,
        type: type,
        source: TransactionSource.sms,
        amountMinor: amount,
        transactionDate: DateTime.now(),
        fingerprint: 'fp-$id',
      ),
    );
  }

  Future<DetectedCard> debit(String last4, {String? bank}) =>
      cardRepo.upsertCard(userId: user, last4: last4, bankName: bank);

  // ── Scenario 1 — two debit cards ────────────────────────────────────────
  test('S1: a purchase on Card A reduces A and leaves Card B untouched',
      () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.income, 1000000);
    await addFor('2222', TransactionType.income, 500000);

    await addFor('1111', TransactionType.purchase, 100000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 900000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 100000);
    // Card B is completely unchanged.
    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 500000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222'), 0);
  });

  // ── Scenario 2 — deposit ────────────────────────────────────────────────
  test('S2: a deposit increases only the card it belongs to', () async {
    await debit('1111');
    await debit('2222');
    await addFor('2222', TransactionType.transfer_in, 300000);
    await addFor('2222', TransactionType.income, 200000);

    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 0);
  });

  // ── Scenario 3 — received transfer ──────────────────────────────────────
  test('S3: a received transfer increases only Card A', () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.transfer_in, 750000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 750000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 0);
  });

  // ── Scenario 4 — outgoing transfer ──────────────────────────────────────
  test('S4: an outgoing transfer reduces Card B and raises its Deducted Money',
      () async {
    await debit('1111');
    await debit('2222');
    await addFor('2222', TransactionType.income, 1000000);
    await addFor('1111', TransactionType.income, 1000000);

    await addFor('2222', TransactionType.transfer_out, 400000);

    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 600000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222'), 400000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1000000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 0);
  });

  // ── Scenario 5 — ATM withdrawal ─────────────────────────────────────────
  test('S5: an ATM withdrawal moves My Balance into Card A Pocket Cash only',
      () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.income, 1000000);
    await addFor('2222', TransactionType.income, 1000000);

    await addFor('1111', TransactionType.atm_withdrawal, 200000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 800000);
    expect(await moneyRepo.getPocketCashForCard(user, '1111'), 200000);
    // An ATM withdrawal is NOT Deducted Money.
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 0);
    // Card B is untouched.
    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 1000000);
    expect(await moneyRepo.getPocketCashForCard(user, '2222'), 0);
  });

  // ── Scenario 6 — pocket-cash expense ────────────────────────────────────
  test('S6: a Pocket-Cash expense reduces only that card Pocket Cash', () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.atm_withdrawal, 500000);
    await addFor('2222', TransactionType.atm_withdrawal, 500000);

    await addFor('1111', TransactionType.cash_expense, 120000);

    expect(await moneyRepo.getPocketCashForCard(user, '1111'), 380000);
    expect(await moneyRepo.getPocketCashForCard(user, '2222'), 500000);
  });

  // ── Scenario 7 — ambiguous transaction ──────────────────────────────────
  test('S7: a transaction with no card number is unassigned and affects nobody',
      () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.income, 1000000);
    await addFor('2222', TransactionType.income, 1000000);

    await addUnassigned(TransactionType.purchase, 250000);
    await addUnassigned(TransactionType.income, 999000);

    // It touches no card.
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1000000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 1000000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 0);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222'), 0);

    // It is still visible through the unresolved (red-dot) mechanism.
    final unresolved = await moneyRepo.getUnassignedTransactions(user);
    expect(unresolved.length, 2);

    // Resolving the card later routes it to the right card and clears the dot.
    final rows = await txnLocal.getTransactionsByUserId(user);
    final purchase = rows.firstWhere((t) =>
        t.amountMinor == 250000 && t.type == TransactionType.purchase);
    final cardA = (await cardRepo.getCards(user)).firstWhere((c) => c.last4 == '1111');
    await moneyRepo.local.updateTransactionCardId(purchase.id, cardA.id);

    final stillUnresolved = await moneyRepo.getUnassignedTransactions(user);
    expect(stillUnresolved.any((t) => t.id == purchase.id), isFalse);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 750000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 250000);
  });

  // ── Scenario 8 — credit card without a Fixed Amount ────────────────────
  test('S8: a credit card with no Fixed Amount reads 0 and disables "+"',
      () async {
    final card = await debit('1111');
    // Flagged as a credit card but NO Fixed Amount configured yet.
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: 0,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: false,
    );

    // Even with a real deposit on this card, a credit card with no Fixed
    // Amount is 0: no stale limit, no debit-style ledger sum.
    await addFor('1111', TransactionType.income, 1000000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 0);
    expect(await moneyRepo.getFixedAmountForCard(user, '1111'), 0);
    expect(await moneyRepo.getMaxAddableForCard(user, '1111'), 0);
    expect(await moneyRepo.canAddBalanceForCard(user, '1111'), isFalse);
    // A payment cannot be added before the limit is configured.
    await expectLater(
      moneyRepo.addBalanceManually(
          userId: user, cardLast4: '1111', amountMinor: 100000),
      throwsA(isA<CreditLimitExceededException>()),
    );
  });

  // ── Scenario 9 — credit card with a Fixed Amount ───────────────────────
  test('S9: Fixed Amount 20000 gives My Balance 20000, a 3000 purchase 17000',
      () async {
    await debit('1111');
    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 2000000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 2000000);
    expect(await moneyRepo.getFixedAmountForCard(user, '1111'), 2000000);

    await addFor('1111', TransactionType.purchase, 300000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1700000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 300000);

    await addFor('1111', TransactionType.purchase, 200000);

    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1500000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 500000);
  });

  // ── Scenario 10 — credit-card payment ceiling ──────────────────────────
  test('S10: with Fixed Amount 20000 and balance 15000, at most 5000 is added',
      () async {
    await debit('1111');
    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 2000000);
    await addFor('1111', TransactionType.purchase, 500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1500000);

    // Exactly the headroom is allowed.
    expect(await moneyRepo.getMaxAddableForCard(user, '1111'), 500000);
    await moneyRepo.addBalanceManually(
        userId: user, cardLast4: '1111', amountMinor: 500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 2000000);

    // Anything beyond it is refused - My Balance can never exceed the limit.
    for (final tooMuch in [600000, 1000000, 2000000]) {
      await expectLater(
        moneyRepo.addBalanceManually(
            userId: user, cardLast4: '1111', amountMinor: tooMuch),
        throwsA(isA<CreditLimitExceededException>()),
        reason: 'adding $tooMuch must be rejected',
      );
      expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 2000000);
    }
  });

  // ── Scenario 11 — Fixed Amount increased ───────────────────────────────
  test('S11: raising the Fixed Amount 20000 -> 25000 updates My Balance at once',
      () async {
    await debit('1111');
    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 2000000);
    await addFor('1111', TransactionType.purchase, 500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1500000);

    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 2500000);

    expect(await moneyRepo.getFixedAmountForCard(user, '1111'), 2500000);
    // Recalculated from the new limit and the card's own history (25k - 5k).
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 2000000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 500000);
  });

  // ── Scenario 12 — Fixed Amount decreased ───────────────────────────────
  test('S12: lowering the Fixed Amount 25000 -> 18000 recalculates immediately',
      () async {
    await debit('1111');
    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 2500000);
    await addFor('1111', TransactionType.purchase, 500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 2000000);

    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '1111', fixedAmountMinor: 1800000);

    expect(await moneyRepo.getFixedAmountForCard(user, '1111'), 1800000);
    // The stale 25000-derived figure is gone: 18000 - 5000 spent.
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1300000);
    // And the balance can never exceed the (reduced) Fixed Amount.
    await expectLater(
      moneyRepo.addBalanceManually(
          userId: user, cardLast4: '1111', amountMinor: 500001),
      throwsA(isA<CreditLimitExceededException>()),
    );
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 1300000);
  });

  // ── Scenario 13 — three cards, every amount isolated ───────────────────
  test('S13: three cards keep every amount strictly isolated', () async {
    await debit('1111');
    await debit('2222');
    await debit('3333');

    await addFor('1111', TransactionType.income, 1000000);
    await addFor('2222', TransactionType.income, 2000000);
    await addFor('3333', TransactionType.income, 3000000);

    await addFor('1111', TransactionType.purchase, 100000);
    await addFor('2222', TransactionType.transfer_out, 200000);
    await addFor('3333', TransactionType.transfer_in, 500000);
    await addFor('1111', TransactionType.atm_withdrawal, 150000);
    await addFor('2222', TransactionType.atm_withdrawal, 250000);
    await addFor('3333', TransactionType.atm_withdrawal, 350000);
    await addFor('1111', TransactionType.cash_expense, 50000);
    await addFor('3333', TransactionType.cash_expense, 100000);

    // A: 10000 - 1000 purchase - 1500 ATM = 7500; pocket 1500 - 500 = 1000
    expect(await moneyRepo.getMyBalanceForCard(user, '1111'), 750000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 150000);
    expect(await moneyRepo.getPocketCashForCard(user, '1111'), 100000);

    // B: 20000 - 2000 transfer out - 2500 ATM = 15500
    expect(await moneyRepo.getMyBalanceForCard(user, '2222'), 1550000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222'), 200000);
    expect(await moneyRepo.getPocketCashForCard(user, '2222'), 250000);

    // C: 30000 + 5000 in - 3500 ATM = 31500; pocket 3500 - 1000 = 2500
    expect(await moneyRepo.getMyBalanceForCard(user, '3333'), 3150000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '3333'), 100000);
    expect(await moneyRepo.getPocketCashForCard(user, '3333'), 250000);
  });

  // ── Ownership rules ────────────────────────────────────────────────────
  test('ownership: the selected/last/default card is never a fallback',
      () async {
    final a = await debit('1111');
    final b = await debit('2222');

    final orphan = Transaction(
      id: 'orphan',
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 700000,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-orphan',
    );
    await moneyRepo.recordSmsTransaction(userId: user, transaction: orphan);

    // An unowned row belongs to nobody, whichever card is "current".
    expect(CardOwnership.belongsToCard(orphan, a, [a, b]), isFalse);
    expect(CardOwnership.belongsToCard(orphan, b, [a, b]), isFalse);
    expect(CardOwnership.isUnassigned(orphan, [a, b]), isTrue);

    // Once bound, it belongs to exactly that one card.
    final bound = orphan.copyWith(cardId: b.id, cardLast4: '2222');
    expect(CardOwnership.belongsToCard(bound, a, [a, b]), isFalse);
    expect(CardOwnership.belongsToCard(bound, b, [a, b]), isTrue);
  });

  test('ownership: an explicit card_id always beats a conflicting last4',
      () async {
    await debit('1111');
    final b = await debit('2222');

    // A row whose last4 says 1111 but whose card_id points at card B.
    final conflicting = Transaction(
      id: 'conflicting',
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 1000,
      cardLast4: '1111',
      cardId: b.id,
      transactionDate: DateTime.now(),
      fingerprint: 'fp-conflicting',
    );
    await moneyRepo.recordSmsTransaction(userId: user, transaction: conflicting);

    // card_id is the persisted, authoritative identity.
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1111'), 0);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2222'), 1000);
  });

  test('ownership: an ambiguous last4 is never guessed between two cards',
      () async {
    // Two DIFFERENT cards that happen to share a last4.
    final f = await cardRepo
        .upsertCard(userId: user, last4: '1234', bankName: 'Faisal Bank');
    final x = await cardRepo
        .upsertCard(userId: user, last4: '1234', bankName: 'AlexBank');
    final all = <DetectedCard>[f, x];

    // A row carrying only the ambiguous last4 cannot be attributed.
    final ambiguous = Transaction(
      id: 'ambiguous',
      userId: user,
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 5000,
      cardLast4: '1234',
      transactionDate: DateTime.now(),
      fingerprint: 'fp-ambiguous',
    );
    expect(CardOwnership.last4IsUnambiguous('1234', all), isFalse);
    expect(CardOwnership.belongsToCard(ambiguous, f, all), isFalse);
    expect(CardOwnership.belongsToCard(ambiguous, x, all), isFalse);
    expect(CardOwnership.isUnassigned(ambiguous, all), isTrue);

    // An ambiguous identity yields zeros rather than splitting the money.
    expect(await moneyRepo.getDeductedMoneyForCard(user, '1234'), 0);
    // Qualifying with a bank resolves the identity unambiguously.
    expect(
      await moneyRepo.getDeductedMoneyForCard(user, '1234',
          bankName: 'Faisal Bank'),
      0,
    );
  });

  test('data integrity: switching cards never mutates another card', () async {
    await debit('1111');
    await debit('2222');
    await addFor('1111', TransactionType.income, 1000000);
    await addFor('2222', TransactionType.income, 2000000);

    final a1 = await moneyRepo.getCardBalance(user, '1111');
    final b1 = await moneyRepo.getCardBalance(user, '2222');

    // Read B repeatedly, then A again: both are stable and independent.
    await moneyRepo.getCardBalance(user, '2222');
    await moneyRepo.getCardBalance(user, '2222');
    final a2 = await moneyRepo.getCardBalance(user, '1111');
    final b2 = await moneyRepo.getCardBalance(user, '2222');

    expect(a2.myBalanceMinor, a1.myBalanceMinor);
    expect(b2.myBalanceMinor, b1.myBalanceMinor);
    expect(a2.myBalanceMinor, 1000000);
    expect(b2.myBalanceMinor, 2000000);
  });
}
