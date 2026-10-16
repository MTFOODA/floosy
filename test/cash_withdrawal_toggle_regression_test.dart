import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
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

  Transaction txn(String id, String card, TransactionType type, int amount) =>
      Transaction(
        id: id,
        userId: user,
        type: type,
        source: TransactionSource.sms,
        amountMinor: amount,
        currency: 'EGP',
        cardLast4: card,
        transactionDate: DateTime.now(),
        fingerprint: 'fp-$id',
      );

  test('REPRO: toggle cash withdrawal must never change My Balance', () async {
    final card = await cardRepo.upsertCard(userId: user, last4: '2307');
    // Production configure path (dialog hard-codes opening 0).
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: 1000000,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: false,
    );
    // A configured credit card's My Balance IS its Fixed Amount: no opening
    // top-up is needed, and "+" has no headroom to give yet.
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
    expect(await moneyRepo.getMaxAddableForCard(user, '2307'), 0);

    // Purchase 2,000 (SMS path).
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction:
            txn('p1', '2307', TransactionType.purchase, 200000));
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);

    // Toggle cash withdrawal ON through the EXACT production save path
    // (detected_bank_card._openCreditConfig → setFixedAmountForCard).
    await moneyRepo.setFixedAmountForCard(
        userId: user,
        cardLast4: '2307',
        fixedAmountMinor: 1000000,
        cashWithdrawalEnabled: true);

    expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1000000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000,
        reason: 'toggle must not change My Balance');
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 200000);

    // Toggle OFF and ON again.
    await moneyRepo.setFixedAmountForCard(
        userId: user,
        cardLast4: '2307',
        fixedAmountMinor: 1000000,
        cashWithdrawalEnabled: false);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);
    await moneyRepo.setFixedAmountForCard(
        userId: user,
        cardLast4: '2307',
        fixedAmountMinor: 1000000,
        cashWithdrawalEnabled: true);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 800000);

    // ATM withdrawal after enabling (real financial op — allowed to move).
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction:
            txn('atm1', '2307', TransactionType.atm_withdrawal, 200000));
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 600000);
    expect(await moneyRepo.getPocketCashForCard(user, '2307'), 200000);
  });

  test('targeted setCashWithdrawalEnabled changes ONLY the flag', () async {
    final card = await cardRepo.upsertCard(userId: user, last4: '2307');
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: 1000000,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: false,
    );
    await cardRepo.toggleCardEye(user, card.id);
    final storedBefore = (await cardRepo.getCards(user)).single;

    await cardRepo.setCashWithdrawalEnabled(user, card.id, true);

    final stored = (await cardRepo.getCards(user)).single;
    expect(stored.cashWithdrawalEnabled, isTrue);
    // Every other persisted field is byte-identical.
    expect(stored.creditLimitMinor, storedBefore.creditLimitMinor);
    expect(stored.currentBalanceMinor, storedBefore.currentBalanceMinor);
    expect(stored.isCreditCard, isTrue);
    expect(stored.last4, storedBefore.last4);
    expect(stored.bankName, storedBefore.bankName);
    expect(stored.transactionCount, storedBefore.transactionCount);
    expect(stored.id, storedBefore.id);
    expect(
        stored.appearance.eyeVisible, storedBefore.appearance.eyeVisible);
    expect(stored.createdAt, storedBefore.createdAt);
    // My Balance is DERIVED from the Fixed Amount, so it reads as the limit.
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);
  });

  test('same-limit re-save leaves My Balance and the Fixed Amount untouched',
      () async {
    final card = await cardRepo.upsertCard(userId: user, last4: '2307');
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: 1000000,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: false,
    );
    // Spend 2,000 so the balance sits below the limit and the toggle has a
    // real value it could disturb.
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction:
            txn('p1', '2307', TransactionType.purchase, 200000));
    final balanceBefore = await moneyRepo.getMyBalanceForCard(user, '2307');
    expect(balanceBefore, 800000);

    // Toggle cash withdrawal through the SAME-limit save path.
    await moneyRepo.setFixedAmountForCard(
        userId: user,
        cardLast4: '2307',
        fixedAmountMinor: 1000000,
        cashWithdrawalEnabled: true);

    final stored = (await cardRepo.getCards(user)).single;
    expect(stored.creditLimitMinor, 1000000);
    expect(stored.cashWithdrawalEnabled, isTrue);
    // No cached balance field is read any more: the figure is recomputed from
    // the Fixed Amount + this card's own ledger, so it cannot drift.
    expect(stored.currentBalanceMinor, 0);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), balanceBefore);
  });

  test('Fixed Amount change then repeated toggles preserve the state (#16)',
      () async {
    final card = await cardRepo.upsertCard(userId: user, last4: '2307');
    await cardRepo.setCreditCardConfig(
      userId: user,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: 1000000,
      currentBalanceMinor: 0,
      cashWithdrawalEnabled: false,
    );
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1000000);

    // Fixed Amount 10,000 → 15,000. My Balance is derived from the limit plus
    // this card's own ledger, so it reflects the change at once (Scenario 11).
    await moneyRepo.setFixedAmountForCard(
        userId: user, cardLast4: '2307', fixedAmountMinor: 1500000);
    expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1500000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1500000);

    // Spend 3,000 → 12,000, leaving 3,000 of headroom for a later repayment.
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction: txn('p1', '2307', TransactionType.purchase, 300000));
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1200000);
    expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 300000);

    // OFF → ON → OFF → ON: every toggle preserves Fixed Amount, My Balance
    // and Deducted exactly.
    for (final cash in [false, true, false, true]) {
      await moneyRepo.setFixedAmountForCard(
          userId: user,
          cardLast4: '2307',
          fixedAmountMinor: 1500000,
          cashWithdrawalEnabled: cash);
      expect(await moneyRepo.getFixedAmountForCard(user, '2307'), 1500000,
          reason: 'cash=$cash');
      expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 1200000,
          reason: 'cash=$cash');
      expect(await moneyRepo.getDeductedMoneyForCard(user, '2307'), 300000,
          reason: 'cash=$cash');
    }
    expect(
        await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isTrue);
  });

  test('toggling Card A never touches Card B (#13)', () async {
    await cardRepo.upsertCard(userId: user, last4: '2307');
    await cardRepo.upsertCard(userId: user, last4: '5678');
    await cardRepo.setCreditCardConfig(
        userId: user,
        cardId: (await cardRepo.getCards(user)).first.id,
        isCreditCard: true,
        creditLimitMinor: 1000000,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: false);
    await cardRepo.setCreditCardConfig(
        userId: user,
        cardId: (await cardRepo.getCards(user)).last.id,
        isCreditCard: true,
        creditLimitMinor: 2000000,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: false);
    // One spend per card, so both hold distinct non-trivial balances.
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction:
            txn('p-a', '2307', TransactionType.purchase, 300000));
    await moneyRepo.recordSmsTransaction(
        userId: user,
        transaction:
            txn('p-b', '5678', TransactionType.purchase, 500000));

    final cardA = (await cardRepo.getCards(user)).first;
    final cardB = (await cardRepo.getCards(user)).last;
    expect(cardA.last4, '2307');

    await cardRepo.setCashWithdrawalEnabled(user, cardA.id, true);

    final a = (await cardRepo.getCards(user)).firstWhere((c) => c.id == cardA.id);
    final b = (await cardRepo.getCards(user)).firstWhere((c) => c.id == cardB.id);
    expect(a.cashWithdrawalEnabled, isTrue);
    // Card B is untouched.
    expect(b.cashWithdrawalEnabled, isFalse);
    expect(b.creditLimitMinor, 2000000);
    expect(await moneyRepo.getMyBalanceForCard(user, '2307'), 700000);
    expect(await moneyRepo.getMyBalanceForCard(user, '5678'), 1500000);
    expect(await moneyRepo.isPocketCashVisibleForCard(user, '2307'), isTrue);
    expect(await moneyRepo.isPocketCashVisibleForCard(user, '5678'), isFalse);
  });
}