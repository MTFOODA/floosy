import '../entities/budget_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class BudgetRepository {
  Future<List<Budget>> getBudgets(String userId);

  Future<List<Budget>> getActiveBudgets(String userId);

  Future<Budget?> getBudget(String budgetId);

  Future<Budget> createBudget({
    required String userId,
    required String name,
    required int amountMinor,
    required String currency,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Budget> updateBudget(Budget budget);

  Future<void> deleteBudget(String budgetId);

  Future<BudgetCategory> setBudgetCategory({
    required String budgetId,
    required String categoryId,
    required int limitMinor,
  });

  Future<List<BudgetCategory>> getBudgetCategories(String budgetId);

  Future<void> removeBudgetCategory({
    required String budgetId,
    required String categoryId,
  });

  Future<Map<String, int>> getCurrentSpending(String budgetId);

  Future<bool> isCategoryExceeded({
    required String budgetId,
    required String categoryId,
    required int currentSpending,
  });

  Future<void> deactivateBudget(String budgetId);
}
