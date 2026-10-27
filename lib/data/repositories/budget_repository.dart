import '../../domain/repositories/budget_repository.dart' as domain;
import '../../domain/entities/budget_model.dart';
import '../remote/datasources/budget_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class BudgetRepository implements domain.BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepository({required this.remoteDataSource});

  /// Get all budgets for a user
  @override
  Future<List<Budget>> getBudgets(String userId) async {
    try {
      return await remoteDataSource.getBudgets(userId);
    } catch (e) {
      logError('Error getting budgets: $e');
      return [];
    }
  }

  /// Get active budgets for a user
  @override
  Future<List<Budget>> getActiveBudgets(String userId) async {
    try {
      final budgets = await remoteDataSource.getBudgets(userId);
      final now = DateTime.now();
      return budgets
          .where((b) =>
              b.isActive && b.startDate.isBefore(now) && b.endDate.isAfter(now))
          .toList();
    } catch (e) {
      logError('Error getting active budgets: $e');
      return [];
    }
  }

  /// Get budget by ID
  @override
  Future<Budget?> getBudget(String budgetId) async {
    try {
      return await remoteDataSource.getBudget(budgetId);
    } catch (e) {
      logError('Error getting budget: $e');
      return null;
    }
  }

  /// Create a new budget
  @override
  Future<Budget> createBudget({
    required String userId,
    required String name,
    required int amountMinor,
    required String currency,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final budget = Budget(
      id: '',
      userId: userId,
      name: name,
      amountMinor: amountMinor,
      currency: currency,
      period: period,
      startDate: startDate,
      endDate: endDate,
      isActive: true,
    );

    try {
      return await remoteDataSource.createBudget(budget);
    } catch (e) {
      logError('Error creating budget: $e');
      rethrow;
    }
  }

  /// Update a budget
  @override
  Future<Budget> updateBudget(Budget budget) async {
    try {
      return await remoteDataSource.updateBudget(budget);
    } catch (e) {
      logError('Error updating budget: $e');
      rethrow;
    }
  }

  /// Delete a budget
  @override
  Future<void> deleteBudget(String budgetId) async {
    try {
      await remoteDataSource.deleteBudget(budgetId);
    } catch (e) {
      logError('Error deleting budget: $e');
      rethrow;
    }
  }

  /// Set budget limit for a category
  @override
  Future<BudgetCategory> setBudgetCategory({
    required String budgetId,
    required String categoryId,
    required int limitMinor,
  }) async {
    try {
      return await remoteDataSource.setBudgetCategory(
        budgetId,
        categoryId,
        limitMinor,
      );
    } catch (e) {
      logError('Error setting budget category: $e');
      rethrow;
    }
  }

  /// Get budget categories
  @override
  Future<List<BudgetCategory>> getBudgetCategories(String budgetId) async {
    try {
      return await remoteDataSource.getBudgetCategories(budgetId);
    } catch (e) {
      logError('Error getting budget categories: $e');
      return [];
    }
  }

  /// Remove a category from budget
  @override
  Future<void> removeBudgetCategory({
    required String budgetId,
    required String categoryId,
  }) async {
    try {
      await remoteDataSource.removeBudgetCategory(budgetId, categoryId);
    } catch (e) {
      logError('Error removing budget category: $e');
      rethrow;
    }
  }

  /// Get current spending against budget
  @override
  Future<Map<String, int>> getCurrentSpending(String budgetId) async {
    try {
      return await remoteDataSource.getCurrentSpending(budgetId);
    } catch (e) {
      logError('Error getting current spending: $e');
      return {};
    }
  }

  /// Check if budget category is exceeded
  @override
  Future<bool> isCategoryExceeded({
    required String budgetId,
    required String categoryId,
    required int currentSpending,
  }) async {
    try {
      final categories = await getBudgetCategories(budgetId);
      BudgetCategory? category;
      for (final c in categories) {
        if (c.categoryId == categoryId) {
          category = c;
          break;
        }
      }

      if (category == null) return false;
      return currentSpending > category.limitMinor;
    } catch (e) {
      logError('Error checking category exceeded: $e');
      return false;
    }
  }

  /// Deactivate a budget
  @override
  Future<void> deactivateBudget(String budgetId) async {
    try {
      final budget = await remoteDataSource.getBudget(budgetId);
      if (budget != null) {
        await remoteDataSource.updateBudget(budget.copyWith(isActive: false));
      }
    } catch (e) {
      logError('Error deactivating budget: $e');
      rethrow;
    }
  }
}
