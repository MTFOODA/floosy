import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Transactions implements TransactionRepository {
  final rows = <Transaction>[];
  @override
  Future<List<Transaction>> getTransactions(
          {required String userId,
          bool syncWithRemote = true,
          int limit = 100}) async =>
      rows.where((t) => t.userId == userId).toList();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Local implements MoneyLocalDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
  test('purchase reduces only its card balance: 10000 - 1200 = 8800 EGP',
      () async {
    final transactions = _Transactions();
    final repository = MoneyRepository(
        remote: _Remote(),
        local: _Local(),
        transactionRepository: transactions,
        cashWalletRepository: _Cash(),
        expenseRepository: _Expenses());
    void add(String id, String card, TransactionType type, int amount) {
      transactions.rows.add(Transaction(
          id: id,
          userId: 'user',
          type: type,
          source: TransactionSource.sms,
          amountMinor: amount,
          cardLast4: card,
          transactionDate: DateTime(2026, 9, 12),
          fingerprint: id));
    }

    add('opening-a', '2307', TransactionType.income, 1000000);
    add('opening-b', '9999', TransactionType.income, 800000);
    expect(await repository.getMyBalanceForCard('user', '2307'), 1000000);
    add('purchase-a', '2307', TransactionType.purchase, 120000);
    expect(await repository.getMyBalanceForCard('user', '2307'), 880000);
    expect(await repository.getMyBalanceForCard('user', '9999'), 800000);
  });

  test('bank + last4 keeps same-last4 balances isolated', () async {
    SharedPreferences.setMockInitialValues({});
    final cardRepo =
        DetectedCardRepository(local: DetectedCardLocalDataSource());
    final faisal = await cardRepo.upsertCard(
        userId: 'user', last4: '1234', bankName: 'Faisal Bank');
    final alex = await cardRepo.upsertCard(
        userId: 'user', last4: '1234', bankName: 'AlexBank');
    final transactions = _Transactions()
      ..rows.addAll([
        Transaction(
            id: 'f',
            userId: 'user',
            type: TransactionType.income,
            source: TransactionSource.sms,
            amountMinor: 100,
            cardLast4: '1234',
            cardId: faisal.id,
            transactionDate: DateTime(2026, 9, 12),
            fingerprint: 'f'),
        Transaction(
            id: 'a',
            userId: 'user',
            type: TransactionType.income,
            source: TransactionSource.sms,
            amountMinor: 200,
            cardLast4: '1234',
            cardId: alex.id,
            transactionDate: DateTime(2026, 9, 12),
            fingerprint: 'a'),
      ]);
    final repository = MoneyRepository(
      remote: _Remote(),
      local: _Local(),
      transactionRepository: transactions,
      cashWalletRepository: _Cash(),
      expenseRepository: _Expenses(),
      detectedCardRepository: cardRepo,
    );

    expect(
        await repository.getMyBalanceForCard('user', '1234',
            bankName: 'Faisal Bank'),
        100);
    expect(
        await repository.getMyBalanceForCard('user', '1234',
            bankName: 'AlexBank'),
        200);
  });
}
