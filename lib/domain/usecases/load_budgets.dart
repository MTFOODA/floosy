import '../entities/budget_with_spending.dart';
import '../repositories/budget_repository.dart';

class LoadBudgets {
  final BudgetRepository _repository;
  const LoadBudgets(this._repository);
  Future<List<BudgetWithSpending>> call(String userId) async {
    final budgets = await _repository.getActiveBudgets(userId);
    final result = <BudgetWithSpending>[];
    for (final budget in budgets) {
      final spending = await _repository.getCurrentSpending(budget.id);
      result.add(BudgetWithSpending(
          budget: budget,
          spendingByCategory: Map.unmodifiable(spending),
          totalSpentMinor:
              spending.values.fold(0, (sum, value) => sum + value)));
    }
    return List.unmodifiable(result);
  }
}
