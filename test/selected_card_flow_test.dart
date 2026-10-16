import 'dart:io' show File;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/localization/preferences_provider.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/models/detected_card_model.dart';
import 'package:floosy/data/local/datasources/expense_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/remote/datasources/cash_wallet_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/expense_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

/// [TransactionRepository] that only writes LOCALLY — the Add Balance tests
/// verify the business logic path (`MoneyRepository.addBalanceManually` →
/// Drift transaction row) without a remote round-trip timeout.
class _LocalOnlyTransactionRepository extends TransactionRepository {
  final TransactionLocalDataSource local;

  _LocalOnlyTransactionRepository(this.local)
      : super(TransactionRemoteDataSource(_dummyClient()), local);

  @override
  Future<Transaction> createTransaction({
    required Transaction transaction,
  }) async {
    await local.insertTransaction(transaction);
    return transaction;
  }
}

/// Card → selection → money flow tests.
///
/// The card's stable identity is `card_last4` everywhere: detected cards,
/// the persisted selection, and every card-scoped money query.
void main() {
  group('SelectedCardNotifier.reconcile — selection logic (card_last4)', () {
    test('first detected card becomes the selection when nothing is saved',
        () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = SelectedCardNotifier();
      await notifier.ready;

      await notifier.reconcile(['1234', '5678']);

      expect(notifier.state, '1234');
    });

    test('a saved selection is preserved (user choice wins) on rebuild',
        () async {
      SharedPreferences.setMockInitialValues(
          {PrefsKeys.selectedCardLast4: '5678'});
      final notifier = SelectedCardNotifier();
      await notifier.ready;

      await notifier.reconcile(['1234', '5678']);

      expect(notifier.state, '5678');
    });

    test('a saved card that no longer exists falls back to first and persists',
        () async {
      SharedPreferences.setMockInitialValues(
          {PrefsKeys.selectedCardLast4: '5678'});
      final notifier = SelectedCardNotifier();
      await notifier.ready;

      await notifier.reconcile(['1234', '9999']);

      expect(notifier.state, '1234');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(PrefsKeys.selectedCardLast4), '1234');
    });

    test('no detected cards clears the selection', () async {
      SharedPreferences.setMockInitialValues(
          {PrefsKeys.selectedCardLast4: '5678'});
      final notifier = SelectedCardNotifier();
      await notifier.ready;

      await notifier.reconcile([]);

      expect(notifier.state, null);
    });

    test('same last4 cards select by bank and survive restart', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = SelectedCardNotifier();
      await notifier.ready;
      final cards = [
        DetectedCard(
            id: 'f', userId: 'u1', last4: '1234', bankName: 'Faisal Bank'),
        DetectedCard(
            id: 'a', userId: 'u1', last4: '1234', bankName: 'AlexBank'),
        DetectedCard(
            id: 'g', userId: 'u1', last4: '5678', bankName: 'Faisal Bank'),
      ];

      await notifier.setSelectedCard('1234', bankName: 'Faisal Bank');
      await notifier.reconcileCards(cards);
      expect(notifier.state, '1234');
      expect(notifier.bankName, 'Faisal Bank');

      await notifier.setSelectedCard('1234', bankName: 'AlexBank');
      expect(notifier.state, '1234');
      expect(notifier.bankName, 'AlexBank');

      final restored = SelectedCardNotifier();
      await restored.ready;
      expect(restored.state, '1234');
      expect(restored.bankName, 'AlexBank');
    });

    test('legacy last4-only selection is not assigned to an arbitrary bank',
        () async {
      SharedPreferences.setMockInitialValues(
          {PrefsKeys.selectedCardLast4: '1234'});
      final notifier = SelectedCardNotifier();
      await notifier.ready;
      await notifier.reconcileCards([
        DetectedCard(
            id: 'f', userId: 'u1', last4: '1234', bankName: 'Faisal Bank'),
        DetectedCard(
            id: 'a', userId: 'u1', last4: '1234', bankName: 'AlexBank'),
      ]);
      expect(notifier.state, isNull);
      expect(notifier.bankName, isNull);
    });
  });

  group('Card-scoped money queries (real Drift datasource, card_last4)', () {
    late db.AppDatabase database;
    late MoneyLocalDataSource money;
    late TransactionLocalDataSource transactions;

    setUp(() {
      database = db.AppDatabase(NativeDatabase.memory());
      money = MoneyLocalDataSource(database);
      transactions = TransactionLocalDataSource(database);
    });

    tearDown(() => database.close());

    Future<void> addTxn(
      String id,
      TransactionType type,
      int amountMinor,
      String cardLast4,
    ) async {
      await transactions.insertTransaction(Transaction(
        id: id,
        userId: 'user-1',
        type: type,
        source: TransactionSource.sms,
        amountMinor: amountMinor,
        currency: 'EGP',
        transactionDate: DateTime(2026, 9, 15, 12),
        cardLast4: cardLast4,
        fingerprint: 'fp-$id',
        status: TransactionStatus.confirmed,
      ));
    }

    test('Deducted is isolated per card (Test 4)', () async {
      await addTxn('a', TransactionType.purchase, 100, '1234');
      await addTxn('b', TransactionType.purchase, 200, '5678');
      await addTxn('c', TransactionType.purchase, 999, '9999');

      expect(await money.getDeductedForCard('user-1', '1234', 2026, 9), 100);
      expect(await money.getDeductedForCard('user-1', '5678', 2026, 9), 200);
      // No cross-card leakage.
      expect(await money.getDeductedForCard('user-1', '9876', 2026, 9), 0);
    });

    test('My Balance (incoming) is isolated per card (Test 5)', () async {
      await addTxn('e', TransactionType.income, 500, '1234');
      await addTxn('f', TransactionType.transfer_in, 300, '5678');
      await addTxn('g', TransactionType.income, 999, '9999');

      expect(await money.getIncomingForCard('user-1', '1234', 2026, 9), 500);
      expect(await money.getIncomingForCard('user-1', '5678', 2026, 9), 300);
    });

    test('Pocket Cash is isolated per card (Test 6)', () async {
      await addTxn('h', TransactionType.atm_withdrawal, 250, '1234');
      await addTxn('i', TransactionType.atm_withdrawal, 125, '5678');
      // Cash spending reduces ONLY the matching card's pocket cash.
      await addTxn('j', TransactionType.cash_expense, 50, '1234');

      expect(
          await money.getAtmWithdrawalsForCard('user-1', '1234', 2026, 9), 250);
      expect(
          await money.getAtmWithdrawalsForCard('user-1', '5678', 2026, 9), 125);
      expect(await money.getCardCashSpending('user-1', '1234', 2026, 9), 50);
      expect(await money.getCardCashSpending('user-1', '5678', 2026, 9), 0);
    });
  });

  group('Add Balance lifecycle + card isolation', () {
    late db.AppDatabase database;
    late MoneyLocalDataSource money;
    late TransactionLocalDataSource transactions;
    late MoneyRepository repo;

    setUp(() {
      database = db.AppDatabase(NativeDatabase.memory());
      money = MoneyLocalDataSource(database);
      transactions = TransactionLocalDataSource(database);
      repo = MoneyRepository(
        remote: MoneyRemoteDataSource(_dummyClient()),
        local: money,
        transactionRepository: _LocalOnlyTransactionRepository(transactions),
        cashWalletRepository: CashWalletRepository(
          remoteDataSource: CashWalletRemoteDataSource(_dummyClient()),
        ),
        expenseRepository: ExpenseRepository(
          remoteDataSource: ExpenseRemoteDataSource(_dummyClient()),
          localDataSource: ExpenseLocalDataSource(database),
        ),
      );
    });

    tearDown(() => database.close());

    test(
        'addBalanceManually is callable with explicit values (no WidgetRef) '
        'and stamps card_last4 so the selected card My Balance increases',
        () async {
      // Regression for:
      //   Bad state: Cannot use "ref" after the widget was disposed.
      // The repository operation accepts plain immutable parameters
      // (userId + cardLast4 + amount) — exactly like the Dashboard's
      // _showAddBalanceDialog captures them BEFORE the async dialog gap —
      // and never needs a widget/provider reference after the gap.
      await repo.addBalanceManually(
        userId: 'user-1',
        cardLast4: '1234',
        amountMinor: 50000,
        currency: 'EGP',
        note: 'Top-up CIB',
      );

      // The income transaction is persisted for the correct card.
      final now = DateTime.now();
      expect(
        await money.getIncomingForCard('user-1', '1234', now.year, now.month),
        50000,
      );
      // My Balance for the selected card = incoming − deducted.
      expect(await repo.getMyBalanceForCard('user-1', '1234'), 50000);
    });

    test('manual top-ups are isolated per card_last4', () async {
      // Scenario A: +500 on card 1234.
      await repo.addBalanceManually(
        userId: 'user-1',
        cardLast4: '1234',
        amountMinor: 50000,
      );
      // Scenario B: +300 on card 5678.
      await repo.addBalanceManually(
        userId: 'user-1',
        cardLast4: '5678',
        amountMinor: 30000,
      );

      final now = DateTime.now();
      // Card A got exactly its +500.
      expect(
        await repo.getMyBalanceForCard('user-1', '1234'),
        50000,
      );
      // Card B got exactly its +300 — no cross-card leakage.
      expect(
        await repo.getMyBalanceForCard('user-1', '5678'),
        30000,
      );
      // A non-selected card must not see either top-up.
      expect(
        await repo.getMyBalanceForCard('user-1', '9999'),
        0,
      );
      // Local-backed card-scoped query agrees.
      expect(
        await money.getIncomingForCard('user-1', '1234', now.year, now.month),
        50000,
      );
      expect(
        await money.getIncomingForCard('user-1', '5678', now.year, now.month),
        30000,
      );
    });
  });

  group('WidgetRef regression guard', () {
    test('no ProviderElement → WidgetRef cast exists in providers.dart', () {
      // Root cause of the previous
      // "_TypeError (type 'AutoDisposeFutureProviderElement<MoneySummary>'
      //  is not a subtype of type 'WidgetRef' in type cast)" crash.
      final src = File('lib/core/providers.dart').readAsStringSync();
      expect(src.contains('as WidgetRef'), false);
    });

    test('moneyRepositoryProvider injects the detected-card repository', () {
      // Root cause of the credit-card Fixed-Amount limit being ignored and of
      // a credit card's My Balance never using its own opening value:
      // `moneyRepositoryProvider` built a MoneyRepository WITHOUT
      // `detectedCardRepository`, so `_findCardByLast4` always returned null
      // and every card-scoped rule (credit-limit enforcement, Pocket-Cash
      // eligibility, credit-card opening balance) was silently skipped.
      final src = File('lib/core/providers.dart').readAsStringSync();
      final start = src.indexOf('final moneyRepositoryProvider');
      expect(start, greaterThanOrEqualTo(0));
      final block = src.substring(start, src.indexOf('});', start));
      expect(
        block.contains('detectedCardRepository:'),
        isTrue,
        reason: 'moneyRepositoryProvider must pass detectedCardRepository so '
            'card-scoped credit-card rules are enforced.',
      );
    });
  });
}
