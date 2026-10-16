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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// End-to-end credit-card + per-card balance regression tests.

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

/// [TransactionRepository] that only writes LOCALLY (no remote round-trip).
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

  Transaction txn(String id, String card, TransactionType type, int amount,
          {String userId = user}) =>
      Transaction(
        id: id,
        userId: userId,
        type: type,
        source: TransactionSource.sms,
        amountMinor: amount,
        currency: 'EGP',
        cardLast4: card,
        transactionDate: DateTime.now(),
        fingerprint: 'fp-$id',
      );

    /// Creates a card and configures it as a credit card.
  ///
  /// My Balance is DERIVED from the Fixed Amount: a freshly configured credit
  /// card with a Fixed Amount of X reads as My Balance X (Scenario 9), and a
  /// credit card with NO Fixed Amount reads as 0 (Scenario 8).
  Future<DetectedCard> creditCard(String last4, int limitEgp,
      {bool cash = false}) async {
    final card =
        await cardRepo.upsertCard(userId: user, last4: last4, bankName: 'B');
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: limitEgp * 100,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: cash,
    );
    return card;
  }

  /// Adds money through the Dashboard "+" path (a manual top-up).
  Future<void> addBalance(String last4, int amountEgp) =>
      moneyRepo.addBalanceManually(
          userId: user, cardLast4: last4, amountMinor: amountEgp * 100);

  group('Credit-card configuration & persistence (#2, #11)', () {
    test('configuration round-trips per card and survives a restart',
        () async {
      final card = await creditCard('2307', 30000, cash: true);

      final config = await cardRepo.getCreditCardConfig(user, card.id);
      expect(config, isNotNull);
      expect(config!.isCreditCard, isTrue);
      expect(config.creditLimitMinor, 3000000);
      expect(config.currentBalanceMinor, 0);
      expect(config.cashWithdrawalEnabled, isTrue);

      // Simulated app restart: a brand-new repository over the same store.
      final restarted =
          DetectedCardRepository(local: DetectedCardLocalDataSource());
      final reloaded = await restarted.getCreditCardConfig(user, card.id);
      expect(reloaded!.creditLimitMinor, 3000000);
      expect(reloaded.cashWithdrawalEnabled, isTrue);

      // A debit card has no credit config.
      final debit = await restarted.upsertCard(userId: user, last4: '5678');
      expect(await restarted.getCreditCardConfig(user, debit.id), isNull);
    });

    test('editing an existing configuration updates only that card',
        () async {
      final a = await creditCard('2307', 30000);
      await creditCard('5678', 8000);

      await cardRepo.setCreditCardConfig(
          userId: user,
          cardId: a.id,
          isCreditCard: true,
          creditLimitMinor: 5000000,
          currentBalanceMinor: 0,
          cashWithdrawalEnabled: false);

      final aConfig = await cardRepo.getCreditCardConfig(user, a.id);
      expect(aConfig!.creditLimitMinor, 5000000);
      expect(aConfig.cashWithdrawalEnabled, isFalse);
      final b = (await cardRepo.getCards(user))
          .firstWhere((c) => c.last4 == '5678');
      expect(b.creditLimitMinor, 800000);
    });
  });

  group('Per-card eye visibility (#5)', () {
    test('toggling one card never affects the other, and persists', () async {
      final a = await cardRepo.upsertCard(userId: user, last4: '2307');
      final b = await cardRepo.upsertCard(userId: user, last4: '5678');

      expect(await cardRepo.toggleCardEye(user, a.id), isFalse);
      expect(await cardRepo.getCardEyeVisible(user, a.id), isFalse);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);

      await cardRepo.toggleCardEye(user, b.id);
      expect(await cardRepo.getCardEyeVisible(user, a.id), isFalse);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isFalse);

      // Restart: both states survive independently.
      final restarted =
          DetectedCardRepository(local: DetectedCardLocalDataSource());
      expect(await restarted.getCardEyeVisible(user, a.id), isFalse);
      expect(await restarted.getCardEyeVisible(user, b.id), isFalse);
    });
  });

  group('Credit-card purchase, repayment & limits (#3, #6, #8)', () {
    test('limit 30000: add 30000, purchase 2000 -> 28000, repay -> 29000',
        () async {
      await creditCard('2307', 30000);

      // The Fixed Amount IS the available balance (Scenario 9) - no opening
      // top-up is required, and "+" has no headroom until credit is used.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 3000000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);

      // Purchase 2000 EGP (money OUT).
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 200000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2800000);
      // Deducted Money increases with the purchase.
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);
      // "+" becomes enabled again: 30000 - 28000 = 2000.
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 200000);

      // Repayment 1000 EGP via the "+" path (money IN, never a purchase).
      await addBalance('2307', 1000);
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2900000);
      // Repayment must NOT increase Deducted Money.
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);

      // Full repayment of the remaining 1000 -> back to the limit.
      await addBalance('2307', 1000);
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 3000000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);

      // Available balance can never exceed the credit limit: with credit
      // fully restored the maximum repayment is 0, so any amount throws —
      // no silent clamping.
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);
      await expectLater(
          addBalance('2307', 1),
          throwsA(isA<CreditLimitExceededException>()));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 3000000);
    });

    test('multiple purchases accumulate and each reduces the balance',
        () async {
      await creditCard('2307', 30000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 120000));
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p2', '2307', TransactionType.purchase, 50000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2830000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 170000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 170000);
    });

    test('repayment above remaining credit throws and changes nothing',
        () async {
      await creditCard('2307', 30000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 200000));
      // Available = 28000; repayment of 3000 > remaining 2000 -> throws.
      await expectLater(
          addBalance('2307', 3000),
          throwsA(isA<CreditLimitExceededException>()));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2800000);
    });
  });

  group('Per-card balance isolation (#7, #10)', () {
    test('a purchase on Card A never touches Card B (credit cards)',
        () async {
      await creditCard('2307', 30000);
      await creditCard('5678', 8000);

      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 150000));

      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2850000);
      // Card B was never touched - it still reads as its own Fixed Amount.
      expect(await moneyRepo.getMyBalanceForCard(user, '5678'), 800000);
      expect(await moneyRepo.getMaxAddableForCard(user, '5678'), 0);
    });

    test('a purchase on Card B never touches Card A (mixed credit/debit)',
        () async {
      await creditCard('2307', 30000);
      // Card B is a debit card seeded with 8000 EGP of income.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('in-b', '9999', TransactionType.income, 800000));

      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '9999', TransactionType.purchase, 120000));

      // Card A keeps its own Fixed-Amount-derived balance; Card B's debit
      // ledger is completely independent of it.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 3000000);
      expect(await moneyRepo.getMyBalanceForCard(user, '9999'), 680000);
      // A debit card has no Fixed Amount -> no "+" limit.
      expect(await moneyRepo.getMaxAddableForCard(user, '9999'), isNull);
    });
  });

  group('Pocket-Cash eligibility (#4)', () {
    test('credit card with cash withdrawal disabled never shows Pocket Cash',
        () async {
      await creditCard('2307', 30000, cash: false);
      expect(
          await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isFalse);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm1', '2307', TransactionType.atm_withdrawal, 50000));
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 0);
      // Card-scoped rules still apply: a purchase on the same card reduces
      // My Balance and raises Deducted Money. The earlier ATM row stays in
      // the ledger (it also reduces My Balance) — only Pocket Cash is gated,
      // so the surviving ATM 500 plus the purchase 2000 give 27500.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 200000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2750000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 0);
    });

    test('credit card with cash withdrawal enabled participates', () async {
      await creditCard('2307', 30000, cash: true);
      expect(await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isTrue);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm1', '2307', TransactionType.atm_withdrawal, 200000));
      // ATM rule: My Balance down by the withdrawal, Pocket Cash up by it -
      // both computed from the same transaction stream for this card only.
      // Fixed Amount 30000 - 2000 withdrawn = 28000.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 2800000);
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 200000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('cash1', '2307', TransactionType.cash_expense, 20000));
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 180000);
    });

    test('debit cards always participate (existing behaviour, #9)', () async {
      expect(await moneyRepo.isPocketCashVisibleForCard(user, '9999'), isTrue);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm1', '9999', TransactionType.atm_withdrawal, 50000));
      expect(await moneyRepo.getPocketCashForCard(user, '9999'), 50000);
    });
  });

  group('Cash-withdrawal setting is per card', () {
    test('Card A OFF keeps zero pocket cash while Card B ON accumulates',
        () async {
      await creditCard('2307', 10000, cash: false);
      await creditCard('5678', 20000, cash: true);

      expect(
          await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isFalse);
      expect(await moneyRepo.isPocketCashVisibleForCard(user, '5678'), isTrue);

      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm-a', '2307', TransactionType.atm_withdrawal, 200000));
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm-b', '5678', TransactionType.atm_withdrawal, 300000));

      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 0);
      expect(await moneyRepo.getPocketCashForCard(user, '5678'), 300000);
      // Each card is its own Fixed Amount minus its own ATM withdrawal.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);
      expect(await moneyRepo.getMyBalanceForCard(user, '5678'), 1700000);
    });

    test('toggling OFF then ON preserves history and restores the value',
        () async {
      final card = await creditCard('2307', 10000, cash: true);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm1', '2307', TransactionType.atm_withdrawal, 200000));
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 200000);

      // Toggle OFF through the same persistence the settings UI writes.
      await cardRepo.setCreditCardConfig(
        userId: user,
        cardId: card.id,
        isCreditCard: true,
        creditLimitMinor: 1000000,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: false,
      );
      expect(
          await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isFalse);
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 0);

      // Toggle back ON: no rows were deleted, so the amount shows again.
      await cardRepo.setCreditCardConfig(
        userId: user,
        cardId: card.id,
        isCreditCard: true,
        creditLimitMinor: 1000000,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: true,
      );
      expect(await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isTrue);
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 200000);

      // My Balance and Deducted Money were never coupled to the toggle: the
      // surviving ATM 2000 also counts in My Balance, so the Fixed Amount
      // 10000 - 2000 withdrawn - 2500 spent leaves 5500.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 250000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 550000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 250000);
    });

    test('new ATM rows recorded while OFF become visible after ON', () async {
      final card = await creditCard('2307', 10000, cash: false);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('atm1', '2307', TransactionType.atm_withdrawal, 200000));
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 0);

      await cardRepo.setCreditCardConfig(
        userId: user,
        cardId: card.id,
        isCreditCard: true,
        creditLimitMinor: 1000000,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: true,
      );
      expect(await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isTrue);
      expect(await moneyRepo.getPocketCashForCard(user, '2307'), 200000);
    });
  });

  group('Existing debit-card behaviour (#9)', () {
    test('debit balance: 10000 income − 1200 purchase = 8800, "+" unlimited',
        () async {
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('in1', '9999', TransactionType.income, 1000000));
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction:
              txn('p1', '9999', TransactionType.purchase, 120000));
      expect(await moneyRepo.getMyBalanceForCard(user, '9999'), 880000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '9999'), 120000);

      // No credit-limit checks for debit cards.
      await moneyRepo.addBalanceManually(
          userId: user, cardLast4: '9999', amountMinor: 5000000);
      expect(await moneyRepo.getMyBalanceForCard(user, '9999'), 5880000);
    });
  });

  group('Duplicate SMS handling (#13)', () {
    test('the same SMS fingerprint creates exactly ONE transaction', () async {
      final sms = txn('dup', '2307', TransactionType.purchase, 120000);
      expect(
          await moneyRepo.recordSmsTransaction(userId: user, transaction: sms),
          isTrue);
      // Second processing of the identical SMS is rejected.
      expect(
          await moneyRepo.recordSmsTransaction(userId: user, transaction: sms),
          isFalse);

      final rows = await txnLocal.getTransactionsByUserId(user);
      expect(rows.where((t) => t.fingerprint == 'fp-dup'), hasLength(1));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), -120000);
    });
  });

  // ── Requirement scenarios (A–I) ─────────────────────────────────────────
  group('Scenario A — new credit card', () {
    test('Fixed Amount = 10000 makes My Balance = 10000 with no "+" needed',
        () async {
      await creditCard('2307', 10000);

      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1000000);
      // The Fixed Amount IS the available balance (Scenario 9).
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
      // Nothing has been spent, so there is nothing to repay yet.
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);
      expect(await moneyRepo.canAddBalanceForCard(user, '2307'), isFalse);
    });
  });

  group('Scenario B — a payment above the Fixed Amount is rejected', () {
    test('My Balance never exceeds the Fixed Amount and "+" is disabled',
        () async {
      await creditCard('2307', 10000);

      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);
      expect(await moneyRepo.canAddBalanceForCard(user, '2307'), isFalse);
      // There is no headroom, so ANY payment is refused - no silent clamping.
      await expectLater(
          addBalance('2307', 1),
          throwsA(isA<CreditLimitExceededException>()));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
    });
  });

  group('Scenario C — headroom after credit is used', () {
    test('spending 6000 leaves My Balance = 4000 and 6000 addable', () async {
      await creditCard('2307', 10000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 600000));

      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 400000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 600000);
      expect(await moneyRepo.canAddBalanceForCard(user, '2307'), isTrue);
    });
  });

  group('Scenario D — deduction', () {
    test('My Balance = 7500, Deducted = 2500, maximum add = 2500', () async {
      await creditCard('2307', 10000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 250000));

      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 750000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 250000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 250000);
    });
  });

  group('Scenario E — restore after deduction', () {
    test('adding 2500 returns My Balance to 10000 and disables "+"',
        () async {
      await creditCard('2307', 10000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 250000));
      await addBalance('2307', 2500);

      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);
    });
  });

  group('Scenario F — Fixed Amount increased', () {
    test('10000 -> 15000 lifts My Balance to 15000 minus what was spent',
        () async {
      await creditCard('2307', 10000);
      // Spend 1,000 so there is real history to preserve across the change.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 100000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 900000);

      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '2307', fixedAmountMinor: 1500000);

      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1500000);
      // Derived, not cached: the new limit takes effect immediately while the
      // 1,000 already spent is still deducted (Scenario 11).
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1400000);
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 100000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 100000);

      // The extra headroom is genuinely usable.
      await addBalance('2307', 1000);
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1500000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);
    });
  });

  group('Scenario G — Fixed Amount decreased', () {
    test('10000 -> 6000 recalculates and never exceeds the new limit',
        () async {
      await creditCard('2307', 10000);
      // Spend 2,000 -> 8,000 available, which is above the new 6,000 limit.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 200000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);

      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '2307', fixedAmountMinor: 600000);

      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 600000);
      // CRITICAL: the stale 8,000-derived figure is gone, and My Balance can
      // never exceed the new Fixed Amount (Scenario 12).
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 400000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 200000);
      await expectLater(
          addBalance('2307', 2001),
          throwsA(isA<CreditLimitExceededException>()));
    });

    test('a decrease still above the spend lowers My Balance to the new limit',
        () async {
      await creditCard('2307', 10000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 700000));
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 300000);

      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '2307', fixedAmountMinor: 500000);

      // 50000 limit - 70000 spent. The balance follows the new limit while
      // keeping the card's own spending history.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), -200000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 700000);
    });
  });

  group('Scenario H — multiple cards', () {
    test('Card A can still add 4000 while Card B is exhausted', () async {
      await creditCard('2307', 10000);
      await creditCard('5678', 20000);
      // Card A has used 6,000 of its 10,000; Card B has used none of its 20,000.
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p-a', '2307', TransactionType.purchase, 600000));

      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 600000);
      expect(await moneyRepo.getMaxAddableForCard(user, '5678'), 0);

      // Repaying Card A leaves Card B completely untouched.
      await addBalance('2307', 4000);
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);
      expect(await moneyRepo.getMyBalanceForCard(user, '5678'), 2000000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 200000);
      expect(await moneyRepo.getMaxAddableForCard(user, '5678'), 0);
    });

    test('changing Card A Fixed Amount never touches Card B', () async {
      await creditCard('2307', 10000);
      await creditCard('5678', 20000);

      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '2307', fixedAmountMinor: 2000000);

      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 2000000);
      final b = (await cardRepo.getCards(user))
          .firstWhere((c) => c.last4 == '5678');
      expect(b.creditLimitMinor, 2000000);
      // Card B's own configuration and eye state are untouched.
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);
    });
  });

  group('Scenario I — independent eye state', () {
    test('hide A, hide C, show A — without touching money values', () async {
      final a = await cardRepo.upsertCard(userId: user, last4: '2307');
      final b = await cardRepo.upsertCard(userId: user, last4: '5678');
      final c = await cardRepo.upsertCard(userId: user, last4: '9999');
      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '2307', fixedAmountMinor: 1000000);
      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '5678', fixedAmountMinor: 1000000);
      await moneyRepo.setFixedAmountForCard(
          userId: user, cardLast4: '9999', fixedAmountMinor: 1000000);
      await moneyRepo.recordSmsTransaction(
          userId: user,
          transaction: txn('p1', '2307', TransactionType.purchase, 400000));

      // All visible.
      expect(await cardRepo.getCardEyeVisible(user, a.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, c.id), isTrue);

      final balanceBefore = await moneyRepo.getMyBalanceForCard(user, '2307');

      // Hide A.
      await cardRepo.toggleCardEye(user, a.id);
      expect(await cardRepo.getCardEyeVisible(user, a.id), isFalse);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, c.id), isTrue);

      // Hide C.
      await cardRepo.toggleCardEye(user, c.id);
      expect(await cardRepo.getCardEyeVisible(user, a.id), isFalse);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, c.id), isFalse);

      // Show A again.
      await cardRepo.toggleCardEye(user, a.id);
      expect(await cardRepo.getCardEyeVisible(user, a.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, b.id), isTrue);
      expect(await cardRepo.getCardEyeVisible(user, c.id), isFalse);

      // Financial values are completely unaffected by visibility.
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), balanceBefore);
      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1000000);
      expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 400000);
      // B and C were never spent on, so each reads as its own Fixed Amount.
      expect(await moneyRepo.getMyBalanceForCard(user, '5678'), 1000000);
      expect(await moneyRepo.getMyBalanceForCard(user, '9999'), 1000000);
    });
  });

  group('Fixed-Amount validation', () {
    test('a non-positive Fixed Amount is rejected', () async {
      await creditCard('2307', 10000);
      await expectLater(
        moneyRepo.setFixedAmountForCard(
            userId: user, cardLast4: '2307', fixedAmountMinor: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('an unknown card is rejected', () async {
      await expectLater(
        moneyRepo.setFixedAmountForCard(
            userId: user, cardLast4: '0000', fixedAmountMinor: 100000),
        throwsA(isA<StateError>()),
      );
    });
  });
}
