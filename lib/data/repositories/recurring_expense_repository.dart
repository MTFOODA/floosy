import '../../domain/repositories/recurring_expense_repository.dart' as domain;
import '../../domain/entities/budget_model.dart';
import '../remote/datasources/recurring_expense_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class RecurringExpenseRepository implements domain.RecurringExpenseRepository {
  final RecurringExpenseRemoteDataSource remoteDataSource;

  RecurringExpenseRepository({required this.remoteDataSource});

  /// Get all recurring expenses for a user
  @override
  Future<List<RecurringExpense>> getRecurringExpenses(String userId) async {
    try {
      return await remoteDataSource.getRecurringExpenses(userId);
    } catch (e) {
      logError('Error getting recurring expenses: $e');
      return [];
    }
  }

  /// Get active recurring expenses for a user
  @override
  Future<List<RecurringExpense>> getActiveRecurringExpenses(
      String userId) async {
    try {
      final expenses = await remoteDataSource.getRecurringExpenses(userId);
      return expenses.where((e) => e.isActive).toList();
    } catch (e) {
      logError('Error getting active recurring expenses: $e');
      return [];
    }
  }

  /// Get recurring expense by ID
  @override
  Future<RecurringExpense?> getRecurringExpense(String expenseId) async {
    try {
      return await remoteDataSource.getRecurringExpense(expenseId);
    } catch (e) {
      logError('Error getting recurring expense: $e');
      return null;
    }
  }

  /// Create a new recurring expense
  @override
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
  }) async {
    final expense = RecurringExpense(
      id: '',
      userId: userId,
      name: name,
      nameAr: nameAr,
      amountMinor: amountMinor,
      currency: currency,
      categoryId: categoryId,
      icon: icon,
      frequency: frequency,
      nextDueDate: startDate,
      startDate: startDate,
      endDate: endDate,
      isActive: true,
    );

    try {
      return await remoteDataSource.createRecurringExpense(expense);
    } catch (e) {
      logError('Error creating recurring expense: $e');
      rethrow;
    }
  }

  /// Update a recurring expense
  @override
  Future<RecurringExpense> updateRecurringExpense(
      RecurringExpense expense) async {
    try {
      return await remoteDataSource.updateRecurringExpense(expense);
    } catch (e) {
      logError('Error updating recurring expense: $e');
      rethrow;
    }
  }

  /// Delete a recurring expense
  @override
  Future<void> deleteRecurringExpense(String expenseId) async {
    try {
      await remoteDataSource.deleteRecurringExpense(expenseId);
    } catch (e) {
      logError('Error deleting recurring expense: $e');
      rethrow;
    }
  }

  /// Get occurrences of a recurring expense
  @override
  Future<List<RecurringExpenseOccurrence>> getOccurrences(
      String recurringExpenseId) async {
    try {
      return await remoteDataSource.getOccurrences(recurringExpenseId);
    } catch (e) {
      logError('Error getting occurrences: $e');
      return [];
    }
  }

  /// Mark occurrence as paid
  @override
  Future<void> markOccurrenceAsPaid({
    required String occurrenceId,
    required String? transactionId,
  }) async {
    try {
      await remoteDataSource.markOccurrenceAsPaid(occurrenceId, transactionId);
    } catch (e) {
      logError('Error marking occurrence as paid: $e');
      rethrow;
    }
  }

  /// Get upcoming due expenses for a user
  @override
  Future<List<RecurringExpense>> getUpcomingExpenses(String userId) async {
    try {
      final expenses = await getActiveRecurringExpenses(userId);
      final now = DateTime.now();
      return expenses
          .where((e) =>
              e.nextDueDate.isBefore(now.add(const Duration(days: 30))) &&
              e.nextDueDate.isAfter(now.subtract(const Duration(days: 1))))
          .toList();
    } catch (e) {
      logError('Error getting upcoming expenses: $e');
      return [];
    }
  }

  /// Get expenses due today
  @override
  Future<List<RecurringExpense>> getDueTodayExpenses(String userId) async {
    try {
      final expenses = await getActiveRecurringExpenses(userId);
      final now = DateTime.now();
      return expenses
          .where((e) =>
              e.nextDueDate.year == now.year &&
              e.nextDueDate.month == now.month &&
              e.nextDueDate.day == now.day)
          .toList();
    } catch (e) {
      logError('Error getting today due expenses: $e');
      return [];
    }
  }

  /// Pause a recurring expense
  @override
  Future<void> pauseRecurringExpense(String expenseId) async {
    try {
      final expense = await getRecurringExpense(expenseId);
      if (expense != null) {
        await remoteDataSource.updateRecurringExpense(
          expense.copyWith(isActive: false),
        );
      }
    } catch (e) {
      logError('Error pausing recurring expense: $e');
      rethrow;
    }
  }

  /// Get total monthly recurring expenses
  @override
  Future<int> getTotalMonthlyExpenses(String userId) async {
    try {
      final expenses = await getActiveRecurringExpenses(userId);
      int total = 0;

      for (final expense in expenses) {
        final frequency = expense.frequency;
        if (frequency == RecurringFrequency.daily) {
          total += expense.amountMinor * 30;
        } else if (frequency == RecurringFrequency.weekly) {
          total += expense.amountMinor * 4;
        } else if (frequency == RecurringFrequency.monthly) {
          total += expense.amountMinor;
        } else if (frequency == RecurringFrequency.yearly) {
          total += (expense.amountMinor / 12).toInt();
        }
      }

      return total;
    } catch (e) {
      logError('Error getting total monthly expenses: $e');
      return 0;
    }
  }
}
