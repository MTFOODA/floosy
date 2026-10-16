import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../data/models/budget_model.dart';
import '../../../../theme/app_theme.dart';

/// Formats minor units into a display string.
String formatMoney(int minor, String currency) {
  final value = minor / 100;
  return '$currency ${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}';
}

/// Async list of the user's budgets with computed spending.
final budgetsProvider =
    FutureProvider.autoDispose<List<BudgetWithSpending>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  final repo = ref.watch(budgetRepositoryProvider);
  final budgets = await repo.getActiveBudgets(userId);
  final result = <BudgetWithSpending>[];
  for (final budget in budgets) {
    final spending = await repo.getCurrentSpending(budget.id);
    final totalSpent = spending.values.fold<int>(0, (a, b) => a + b);
    result.add(BudgetWithSpending(
      budget: budget,
      spendingByCategory: spending,
      totalSpentMinor: totalSpent,
    ));
  }
  return result;
});

class BudgetWithSpending {
  final Budget budget;
  final Map<String, int> spendingByCategory;
  final int totalSpentMinor;

  const BudgetWithSpending({
    required this.budget,
    required this.spendingByCategory,
    required this.totalSpentMinor,
  });

  double get usedPercentage => budget.amountMinor == 0
      ? 0
      : (totalSpentMinor / budget.amountMinor * 100).clamp(0, 999);

  int get remainingMinor => budget.amountMinor - totalSpentMinor;
}

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.s(context);
    final budgetsAsync = ref.watch(budgetsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l['budgets'])),
      body: budgetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppTheme.errorColor),
              const SizedBox(height: 12),
              Text(l['failedToLoad'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(budgetsProvider),
                child: Text(l['retry']),
              ),
            ],
          ),
        ),
        data: (budgets) => budgets.isEmpty
            ? const _EmptyBudgetsView()
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(budgetsProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: budgets.length,
                  itemBuilder: (context, index) =>
                      _BudgetCard(data: budgets[index]),
                ),
              ),
      ),
    );
  }
}

class _EmptyBudgetsView extends StatelessWidget {
  const _EmptyBudgetsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.savings_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            l['noBudgets'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            l['noBudgetsSubtitle'],
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetWithSpending data;

  const _BudgetCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final pct = data.usedPercentage;
    final color = pct >= 90
        ? AppTheme.errorColor
        : pct >= 70
            ? AppTheme.warningColor
            : AppTheme.successColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.budget.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (pct / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${formatMoney(data.totalSpentMinor, data.budget.currency)} / '
                  '${formatMoney(data.budget.amountMinor, data.budget.currency)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  data.remainingMinor >= 0
                      ? '${l['remaining']}: ${formatMoney(data.remainingMinor, data.budget.currency)}'
                      : '${l['budgetOverspent']}: ${formatMoney(-data.remainingMinor, data.budget.currency)}',
                  style: TextStyle(
                      color: data.remainingMinor >= 0
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
