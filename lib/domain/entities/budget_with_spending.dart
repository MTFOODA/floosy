import 'budget_model.dart';

class BudgetWithSpending {
  final Budget budget;
  final Map<String, int> spendingByCategory;
  final int totalSpentMinor;
  const BudgetWithSpending(
      {required this.budget,
      required this.spendingByCategory,
      required this.totalSpentMinor});
  double get usedPercentage => budget.amountMinor == 0
      ? 0
      : (totalSpentMinor / budget.amountMinor * 100).clamp(0, 999);
  int get remainingMinor => budget.amountMinor - totalSpentMinor;
}
