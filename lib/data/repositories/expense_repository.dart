import '../models/transaction_model.dart';
import '../remote/datasources/expense_remote_datasource.dart';
import '../local/datasources/expense_local_datasource.dart';
import '../../core/utils/app_logger.dart';

class ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;
  final ExpenseLocalDataSource? localDataSource;

  ExpenseRepository({
    required this.remoteDataSource,
    this.localDataSource,
  });

  /// Create an expense and persist it offline-first. When [localDataSource]
  /// is available the row is written locally first, then synced to Supabase.
  Future<Expense> createExpenseRecord(Expense expense) async {
    try {
      if (localDataSource != null) {
        await localDataSource!.insertExpense(expense);
      }
      return await remoteDataSource.createExpense(expense);
    } catch (e) {
      logError('Error creating expense record: $e');
      return expense;
    }
  }

  /// Sync item-usage rows to Supabase (best effort). Local persistence of item
  /// usage is handled inside the money engine's atomic transaction.
  Future<void> recordItemUsages(List<ItemUsage> usages) async {
    for (final usage in usages) {
      try {
        await remoteDataSource.createItemUsage(usage);
      } catch (e) {
        logError('Failed to sync item usage', e);
      }
    }
  }

  /// Get all expenses for a user
  Future<List<Expense>> getExpenses(String userId) async {
    try {
      return await remoteDataSource.getExpenses(userId);
    } catch (e) {
      logError('Error getting expenses: $e');
      return [];
    }
  }

  /// Get expense by ID
  Future<Expense?> getExpense(String expenseId) async {
    try {
      return await remoteDataSource.getExpense(expenseId);
    } catch (e) {
      logError('Error getting expense: $e');
      return null;
    }
  }

  /// Create a new expense
  Future<Expense> createExpense({
    required String userId,
    required String categoryId,
    required int amountMinor,
    required String currency,
    required DateTime expenseDate,
    required PaymentMethod paymentMethod,
    String? transactionId,
    String? merchantId,
    String? notes,
  }) async {
    final expense = Expense(
      id: '',
      userId: userId,
      transactionId: transactionId,
      categoryId: categoryId,
      amountMinor: amountMinor,
      currency: currency,
      expenseDate: expenseDate,
      paymentMethod: paymentMethod,
      merchantId: merchantId,
      notes: notes,
    );

    try {
      return await remoteDataSource.createExpense(expense);
    } catch (e) {
      logError('Error creating expense: $e');
      rethrow;
    }
  }

  /// Update an existing expense
  Future<Expense> updateExpense(Expense expense) async {
    try {
      return await remoteDataSource.updateExpense(expense);
    } catch (e) {
      logError('Error updating expense: $e');
      rethrow;
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await remoteDataSource.deleteExpense(expenseId);
    } catch (e) {
      logError('Error deleting expense: $e');
      rethrow;
    }
  }

  /// Get expenses for a specific month
  Future<List<Expense>> getMonthlyExpenses({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final expenses = await remoteDataSource.getExpenses(userId);
      return expenses
          .where(
              (e) => e.expenseDate.year == year && e.expenseDate.month == month)
          .toList();
    } catch (e) {
      logError('Error getting monthly expenses: $e');
      return [];
    }
  }

  /// Get expenses by category
  Future<List<Expense>> getExpensesByCategory({
    required String userId,
    required String categoryId,
  }) async {
    try {
      final expenses = await remoteDataSource.getExpenses(userId);
      return expenses.where((e) => e.categoryId == categoryId).toList();
    } catch (e) {
      logError('Error getting expenses by category: $e');
      return [];
    }
  }

  /// Get total expenses for a user in a date range
  Future<int> getTotalExpenses({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await remoteDataSource.getExpenses(userId);
      return expenses
          .where((e) =>
              e.expenseDate.isAfter(startDate) &&
              e.expenseDate.isBefore(endDate))
          .fold<int>(0, (sum, e) => sum + e.amountMinor);
    } catch (e) {
      logError('Error getting total expenses: $e');
      return 0;
    }
  }

  /// Create expense items for an expense
  Future<void> addExpenseItems({
    required String expenseId,
    required List<ExpenseItem> items,
  }) async {
    try {
      for (final item in items) {
        await remoteDataSource.createExpenseItem(item);
      }
    } catch (e) {
      logError('Error adding expense items: $e');
      rethrow;
    }
  }

  /// Get items in an expense
  Future<List<ExpenseItem>> getExpenseItems(String expenseId) async {
    try {
      return await remoteDataSource.getExpenseItems(expenseId);
    } catch (e) {
      logError('Error getting expense items: $e');
      return [];
    }
  }
}
