import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/money_formatter.dart';
import '../../../../../data/models/money_model.dart';

/// Monthly incomes for a specific month.
final monthlyIncomesProvider = FutureProvider.autoDispose
    .family<List<MonthlyIncome>, ({String userId, int year, int month})>(
        (ref, params) async {
  return ref
      .watch(moneyRepositoryProvider)
      .getMonthlyIncomes(params.userId, year: params.year, month: params.month);
});

/// The three core money figures of the Floosy product model:
///
///   My Balance        — total bank money (income + incoming transfers)
///   Deducted Money    — purchases + sent transfers + confirmed cash spending
///   Pocket Cash       — ATM withdrawals minus confirmed cash spending
///
/// Plus the monthly income (salary) editor for the current month.
class MoneySummarySection extends ConsumerWidget {
  final MoneySummary summary;
  final String userId;

  const MoneySummarySection({
    super.key,
    required this.summary,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final incomesAsync = ref.watch(monthlyIncomesProvider(
      (userId: userId, year: now.year, month: now.month),
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // My Balance — the hero figure.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance,
                      color: Colors.white70, size: 20),
                  const SizedBox(width: 6),
                  Text(AppLocalizations.s(context)['myBalance'],
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14)),
                  const Spacer(),
                  // Bank accounts breakdown — each bank keeps its identity.
                  if (summary.accounts.isNotEmpty)
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.expand_more,
                          color: Colors.white70, size: 20),
                      onSelected: (_) {},
                      itemBuilder: (context) => summary.accounts
                          .map((a) => PopupMenuItem<int>(
                                enabled: false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(a.account.name,
                                            overflow: TextOverflow.ellipsis)),
                                    Text(formatMoney(a.balanceMinor)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formatMoney(summary.myBalanceMinor),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Deducted Money + Pocket Cash side by side.
        Row(
          children: [
            Expanded(
              child: _MoneyCard(
                title: AppLocalizations.s(context)['deductedMoney'],
                value: formatMoney(summary.deductedMinor),
                icon: Icons.trending_down,
                color: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MoneyCard(
                title: AppLocalizations.s(context)['pocketCashLabel'],
                value: formatMoney(summary.pocketCashMinor),
                icon: Icons.account_balance_wallet,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Monthly income (salary) strip.
        incomesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => const SizedBox.shrink(),
          data: (incomes) => _MonthlyIncomeStrip(
            monthlyIncomeMinor: summary.monthlyIncomeMinor,
            incomes: incomes,
            userId: userId,
          ),
        ),
      ],
    );
  }
}

class _MoneyCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MoneyCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Strip that shows the current month's income with an add/edit action.
class _MonthlyIncomeStrip extends ConsumerWidget {
  final int monthlyIncomeMinor;
  final List<MonthlyIncome> incomes;
  final String userId;

  const _MonthlyIncomeStrip({
    required this.monthlyIncomeMinor,
    required this.incomes,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.s(context);
    final now = DateTime.now();

    return Card(
      child: ListTile(
        leading: const Icon(Icons.payments_outlined, color: Color(0xFF10B981)),
        title: Text(l['addMonthlySalary'],
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${l['income']}: ${formatMoney(monthlyIncomeMinor)}',
        ),
        trailing: const Icon(Icons.add_circle_outline),
        onTap: () => _showIncomeDialog(context, ref, now.year, now.month),
      ),
    );
  }

  Future<void> _showIncomeDialog(
      BuildContext context, WidgetRef ref, int year, int month) async {
    final l = AppLocalizations.s(context);
    final labelController = TextEditingController();
    final amountController = TextEditingController();
    final repo = ref.read(moneyRepositoryProvider);

    // If there is an existing income for this month, prefill for editing.
    if (incomes.isNotEmpty) {
      labelController.text = incomes.first.label ?? '';
      amountController.text =
          (incomes.first.amountMinor / 100).toStringAsFixed(0);
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l['addMonthlySalary']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: InputDecoration(labelText: l['incomeLabel']),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l['amountEGP']),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l['save']),
          ),
        ],
      ),
    );

    if (saved != true) return;
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) return;

    try {
      await repo.addMonthlyIncome(
        userId: userId,
        year: year,
        month: month,
        label: labelController.text.trim().isEmpty
            ? null
            : labelController.text.trim(),
        amountMinor: (amount * 100).round(),
      );
      ref.invalidate(moneySummaryProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['saveIncome'])),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['error'])),
        );
      }
    }
  }
}
