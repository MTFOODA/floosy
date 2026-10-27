import '../entities/budget_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class RecurringExpenseRepository {
  Future<List<RecurringExpense>> getRecurringExpenses(String userId);

  Future<List<RecurringExpense>> getActiveRecurringExpenses(String userId);

  Future<RecurringExpense?> getRecurringExpense(String expenseId);

  Future<RecurringExpense> createRecurringExpense({
    required String userId,
    required String name,
    required String? nameAr,
    required int amountMinor,
    required String currency,
    required String categoryId,
    required RecurringFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? icon,
  });

  Future<RecurringExpense> updateRecurringExpense(RecurringExpense expense);

  Future<void> deleteRecurringExpense(String expenseId);

  Future<List<RecurringExpenseOccurrence>> getOccurrences(
      String recurringExpenseId);

  Future<void> markOccurrenceAsPaid({
    required String occurrenceId,
    required String? transactionId,
  });

  Future<List<RecurringExpense>> getUpcomingExpenses(String userId);

  Future<List<RecurringExpense>> getDueTodayExpenses(String userId);

  Future<void> pauseRecurringExpense(String expenseId);

  Future<int> getTotalMonthlyExpenses(String userId);
}
