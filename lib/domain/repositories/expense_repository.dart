import '../entities/transaction_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class ExpenseRepository {
  Future<Expense> createExpenseRecord(Expense expense);

  Future<void> recordItemUsages(List<ItemUsage> usages);

  Future<List<Expense>> getExpenses(String userId);

  Future<Expense?> getExpense(String expenseId);

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
  });

  Future<Expense> updateExpense(Expense expense);

  Future<void> deleteExpense(String expenseId);

  Future<List<Expense>> getMonthlyExpenses({
    required String userId,
    required int year,
    required int month,
  });

  Future<List<Expense>> getExpensesByCategory({
    required String userId,
    required String categoryId,
  });

  Future<int> getTotalExpenses({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> addExpenseItems({
    required String expenseId,
    required List<ExpenseItem> items,
  });

  Future<List<ExpenseItem>> getExpenseItems(String expenseId);
}
