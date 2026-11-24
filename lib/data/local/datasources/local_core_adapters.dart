import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/transaction_model.dart' as model;
import '../../../domain/entities/item_model.dart';
import '../../../domain/entities/money_model.dart';
import '../../remote/datasources/transaction_remote_datasource.dart';
import '../../remote/datasources/money_remote_datasource.dart';
import '../../remote/datasources/expense_remote_datasource.dart';
import '../../remote/datasources/cash_wallet_remote_datasource.dart';
import '../../remote/datasources/item_remote_datasource.dart';
import '../database/app_database.dart' as db;
import 'private_record_store.dart';
import 'transaction_local_datasource.dart';
import 'money_local_datasource.dart';
import 'expense_local_datasource.dart';
import 'item_local_datasource.dart';

/// Transitional adapters preserve repository/money-engine contracts while all
/// implementations below operate on the same encrypted local transaction.
class LocalTransactionAdapter extends TransactionRemoteDataSource {
  final db.AppDatabase database;
  final TransactionLocalDataSource local;
  final String? Function() owner;
  LocalTransactionAdapter(super.client, this.database, this.owner)
    : local = TransactionLocalDataSource(database);
  @override
  Future<model.Transaction> createTransaction(
    model.Transaction transaction,
  ) async {
    if (transaction.userId != owner()) throw StateError('Account changed');
    final rows = await local.getTransactionsByUserId(transaction.userId);
    if (!rows.any((t) => t.id == transaction.id)) {
      await local.insertTransaction(transaction);
    }
    return transaction;
  }

  @override
  Future<List<model.Transaction>> getTransactions({
    required String userId,
    int limit = 100,
  }) async {
    if (userId != owner()) throw StateError('Account changed');
    return local.getTransactionsByUserId(userId);
  }

  Future<void> _owns(String id) async {
    if (!(await local.getTransactionsByUserId(
      owner() ?? '',
    )).any((t) => t.id == id)) {
      throw StateError('Record not found');
    }
  }

  @override
  Future<void> updateTransaction(model.Transaction transaction) async {
    await _owns(transaction.id);
    await local.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _owns(transactionId);
    await local.deleteTransaction(transactionId);
  }

  @override
  Future<void> updateTransactionCardId(
    String transactionId,
    String cardId,
  ) async {
    await _owns(transactionId);
    await (database.update(database.transactions)
          ..where((t) => t.id.equals(transactionId)))
        .write(db.TransactionsCompanion(cardId: Value(cardId)));
  }
}

class LocalItemAdapter extends ItemRemoteDataSource {
  final ItemLocalDataSource local;
  final PrivateRecordStore records;
  LocalItemAdapter(super.client, this.local, this.records);
  Future<Item> _item(String id) async {
    final item = await local.getItem(id);
    if (item == null || item.userId != records.owner) {
      throw StateError('Record not found');
    }
    return item;
  }

  @override
  Future<List<Item>> getActiveItems(String userId) async => (await getAllItems(
    userId,
  )).where((i) => i.isActive && !i.isArchived).toList();
  @override
  Future<List<Item>> getAllItems(String userId) async {
    if (userId != records.owner) throw StateError('Account changed');
    return local.getItems(userId);
  }

  @override
  Future<Item?> getItem(String itemId) async {
    final item = await local.getItem(itemId);
    return item?.userId == records.owner ? item : null;
  }

  @override
  Future<Item> createItem(Item item) async {
    if (item.userId != records.owner) throw StateError('Account changed');
    final value = item.id.isEmpty ? item.copyWith(id: const Uuid().v4()) : item;
    await local.upsertItem(value);
    return value;
  }

  @override
  Future<Item> updateItem(Item item) => createItem(item);
  @override
  Future<void> updatePrice(String itemId, int newPriceMinor) async {
    final item = await _item(itemId);
    await records.database.transaction(() async {
      final now = DateTime.now().toUtc();
      for (final old in await getPriceHistory(itemId)) {
        if (old.effectiveTo == null) {
          await records.patch('item_price_history', old.id, {
            'effective_to': now.toIso8601String(),
          });
        }
      }
      await records.put(
        'item_price_history',
        ItemPriceHistory(
          id: const Uuid().v4(),
          itemId: itemId,
          priceMinor: newPriceMinor,
          effectiveFrom: now,
        ).toJson(),
      );
      await local.updateItem(
        item.copyWith(priceMinor: newPriceMinor, updatedAt: DateTime.now()),
      );
    });
  }

  @override
  Future<List<ItemPriceHistory>> getPriceHistory(String itemId) async {
    await _item(itemId);
    return (await records.list('item_price_history'))
        .where((r) => r['item_id'] == itemId)
        .map(ItemPriceHistory.fromJson)
        .toList();
  }

  @override
  Future<void> archiveItem(String itemId) async {
    final item = await _item(itemId);
    await local.updateItem(item.copyWith(isArchived: true, isActive: false));
  }

  @override
  Future<void> deactivateItem(String itemId) async {
    final item = await _item(itemId);
    await local.updateItem(item.copyWith(isActive: false));
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await _item(itemId);
    await local.deleteItem(itemId);
  }
}

class LocalMoneyAdapter extends MoneyRemoteDataSource {
  final db.AppDatabase database;
  final MoneyLocalDataSource local;
  final PrivateRecordStore records;
  LocalMoneyAdapter(super.client, this.database, this.records)
    : local = MoneyLocalDataSource(database);
  void _user(String user) {
    if (user != records.owner) throw StateError('Account changed');
  }

  Future<void> _account(String id) async {
    if ((await local.getBankAccount(id))?.userId != records.owner) {
      throw StateError('Record not found');
    }
  }

  @override
  Future<MonthlyIncome> createMonthlyIncome(MonthlyIncome income) async {
    _user(income.userId);
    final row = income.id.isEmpty
        ? income.copyWith(id: const Uuid().v4())
        : income;
    if (!(await local.getMonthlyIncomes(
      row.userId,
    )).any((r) => r.id == row.id)) {
      await local.insertMonthlyIncome(row);
    }
    return row;
  }

  @override
  Future<List<MonthlyIncome>> getMonthlyIncomes(
    String userId, {
    int? year,
    int? month,
  }) async {
    _user(userId);
    return local.getMonthlyIncomes(userId, year: year, month: month);
  }

  @override
  Future<void> updateMonthlyIncome(MonthlyIncome income) async {
    _user(income.userId);
    if (!(await getMonthlyIncomes(income.userId)).any((r) => r.id == income.id)) {
      throw StateError('Record not found');
    }
    await local.updateMonthlyIncome(income);
  }

  @override
  Future<void> deleteMonthlyIncome(String incomeId) async {
    if (!(await getMonthlyIncomes(records.owner)).any((r) => r.id == incomeId)) {
      throw StateError('Record not found');
    }
    await local.deleteMonthlyIncome(incomeId);
  }

  @override
  Future<UserBankAccount> createBankAccount(UserBankAccount account) async {
    _user(account.userId);
    final row = account.id.isEmpty
        ? account.copyWith(id: const Uuid().v4())
        : account;
    if (await local.getBankAccount(row.id) == null) {
      await local.insertBankAccount(row);
    }
    return row;
  }

  @override
  Future<List<UserBankAccount>> getBankAccounts(String userId) async {
    _user(userId);
    return local.getBankAccounts(userId);
  }

  @override
  Future<UserBankAccount> updateBankAccount(UserBankAccount account) async {
    _user(account.userId);
    await _account(account.id);
    await local.updateBankAccount(account);
    return account;
  }

  @override
  Future<void> deleteBankAccount(String accountId) async {
    await _account(accountId);
    await local.deleteBankAccount(accountId);
  }

  @override
  Future<List<BankAccountWithBalance>> getAccountsWithBalance(
    String userId,
  ) async => [
    for (final account in await getBankAccounts(userId))
      BankAccountWithBalance(
        account: account,
        balanceMinor: await local.getBankAccountBalance(account.id),
      ),
  ];
  @override
  Future<int> getTotalBankBalance(String userId) async =>
      (await getAccountsWithBalance(
        userId,
      )).fold<int>(0, (s, a) => s + a.balanceMinor);
  Future<bool> _transaction(String id) async =>
      (await (database.select(database.transactions)
            ..where((t) => t.id.equals(id) & t.userId.equals(records.owner)))
          .getSingleOrNull()) !=
      null;
  @override
  Future<void> updateTransactionCardId(
    String transactionId,
    String cardId,
  ) async {
    if (!await _transaction(transactionId)) {
      throw StateError('Record not found');
    }
    await local.updateTransactionCardId(transactionId, cardId);
  }

  @override
  Future<void> deleteTransactionMovements(String transactionId) async {
    if (await _transaction(transactionId)) {
      await local.deleteMovementsForTransaction(transactionId);
    }
  }

  @override
  Future<BankAccountMovement> createBankMovement(
    BankAccountMovement movement,
  ) async {
    _user(movement.userId);
    await _account(movement.accountId);
    final row = movement.id.isEmpty
        ? movement.copyWith(id: const Uuid().v4())
        : movement;
    if (!(await local.getBankMovements(
      row.userId,
    )).any((r) => r.id == row.id)) {
      await local.insertBankMovement(row);
    }
    return row;
  }

  @override
  Future<List<BankAccountMovement>> getBankMovements(String userId) async {
    _user(userId);
    return local.getBankMovements(userId);
  }
}

class LocalCashAdapter extends CashWalletRemoteDataSource {
  final MoneyLocalDataSource local;
  final PrivateRecordStore records;
  LocalCashAdapter(super.client, this.local, this.records);
  void _user(String user) {
    if (user != records.owner) throw StateError('Account changed');
  }

  @override
  Future<int> getCashBalance(String userId) async {
    _user(userId);
    return local.getCashBalance(userId);
  }

  @override
  Future<CashWallet> getOrCreateWallet(String userId, String currency) async {
    _user(userId);
    final existing = await local.getWallet(userId);
    if (existing != null) return existing;
    final row = CashWallet(
      id: const Uuid().v4(),
      userId: userId,
      currency: currency,
    );
    await local.insertWallet(row);
    return row;
  }

  @override
  Future<List<CashMovement>> getMovements(String userId) async {
    _user(userId);
    final wallet = await local.getWallet(userId);
    return wallet == null ? [] : local.getCashMovements(wallet.id);
  }

  @override
  Future<CashMovement> recordMovement({
    required String userId,
    required String walletId,
    required String type,
    required int amountMinor,
    required String description,
    String? referenceType,
    String? referenceId,
  }) async {
    _user(userId);
    if ((await local.getWallet(userId))?.id != walletId) {
      throw StateError('Record not found');
    }
    final row = CashMovement(
      id: const Uuid().v4(),
      userId: userId,
      walletId: walletId,
      type: type,
      amountMinor: amountMinor,
      description: description,
      referenceType: referenceType,
      referenceId: referenceId,
      movementDate: DateTime.now(),
    );
    await local.insertCashMovement(row);
    return row;
  }

  @override
  Future<void> ensureExpenseMovement(model.Transaction transaction) async {
    _user(transaction.userId);
    if ((await getMovements(transaction.userId)).any(
      (m) =>
          m.referenceType == 'transaction' && m.referenceId == transaction.id,
    )) {
      return;
    }
    final wallet = await getOrCreateWallet(
      transaction.userId,
      transaction.currency,
    );
    await local.insertCashMovement(
      CashMovement(
        id: 'cash-${transaction.id}',
        userId: transaction.userId,
        walletId: wallet.id,
        type: 'cash_expense',
        amountMinor: transaction.amountMinor,
        description: transaction.notes,
        referenceType: 'transaction',
        referenceId: transaction.id,
        movementDate: transaction.transactionDate,
      ),
    );
  }
}

class LocalExpenseAdapter extends ExpenseRemoteDataSource {
  final db.AppDatabase database;
  final ExpenseLocalDataSource local;
  final PrivateRecordStore records;
  LocalExpenseAdapter(super.client, this.database, this.records)
    : local = ExpenseLocalDataSource(database);
  @override
  Future<List<model.Expense>> getExpenses(String userId) async {
    if (userId != records.owner) throw StateError('Account changed');
    return local.getExpenses(userId);
  }

  @override
  Future<model.Expense?> getExpense(String expenseId) async =>
      (await getExpenses(
        records.owner,
      )).where((r) => r.id == expenseId).firstOrNull;
  @override
  Future<model.Expense> createExpense(model.Expense expense) async {
    if (expense.userId != records.owner) throw StateError('Account changed');
    final row = expense.id.isEmpty
        ? expense.copyWith(id: const Uuid().v4())
        : expense;
    if (await getExpense(row.id) == null) {
      await local.insertExpense(row);
    }
    return row;
  }

  @override
  Future<model.Expense> updateExpense(model.Expense expense) async {
    if (expense.userId != records.owner || await getExpense(expense.id) == null) {
      throw StateError('Record not found');
    }
    await database.transaction(() async {
      await local.deleteExpense(expense.id);
      await local.insertExpense(expense);
    });
    return expense;
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    if (await getExpense(expenseId) == null) {
      throw StateError('Record not found');
    }
    await local.deleteExpense(expenseId);
  }

  @override
  Future<void> createExpenseItem(model.ExpenseItem item) async {
    if (await getExpense(item.expenseId) == null) {
      throw StateError('Record not found');
    }
    if (!(await local.getExpenseItems(
      item.expenseId,
    )).any((r) => r.id == item.id)) {
      await local.insertExpenseItem(item);
    }
  }

  @override
  Future<void> createItemUsage(model.ItemUsage usage) async {
    if (usage.userId != records.owner) throw StateError('Account changed');
    final old = await (database.select(
      database.itemUsages,
    )..where((r) => r.id.equals(usage.id))).getSingleOrNull();
    if (old == null) {
      await MoneyLocalDataSource(database).insertItemUsage(usage);
    }
  }

  @override
  Future<List<model.ExpenseItem>> getExpenseItems(String expenseId) async {
    if (await getExpense(expenseId) == null) return [];
    return local.getExpenseItems(expenseId);
  }
}
