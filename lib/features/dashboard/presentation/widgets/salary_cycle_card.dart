import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/state/load_state.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/common/finance_panel.dart';
import '../../../../domain/entities/salary_plan.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../cubit/salary_plan_cubit.dart';

/// Live view of the selected account during its salary cycle. It shares the
/// same ledger as My Balance and never creates a second movement.
class SalaryCycleCard extends StatelessWidget {
  final int currentBalanceMinor;
  final DetectedCard? selectedCard;
  const SalaryCycleCard({
    super.key,
    required this.currentBalanceMinor,
    this.selectedCard,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    if (selectedCard?.isCreditCard == true) {
      // Salary is a debit-account feature, not an unavailable credit-card
      // action. Keep the dashboard focused by not rendering the section.
      return const SizedBox.shrink();
    }
    final state = context.watch<SalaryPlanCubit>().state;
    final summary = state.value;
    if (summary == null || !summary.isConfigured) {
      // The card-management screen is the single entry point for creating a
      // salary plan. The dashboard stays quiet for cards without one.
      return const SizedBox.shrink();
    }
    return _ConfiguredSalaryCard(
      summary: summary!,
      currentBalanceMinor: currentBalanceMinor,
    );
  }
}

class _ConfiguredSalaryCard extends StatelessWidget {
  final SalaryCycleSummary summary;
  final int currentBalanceMinor;
  const _ConfiguredSalaryCard({
    required this.summary,
    required this.currentBalanceMinor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final symbol = l.currencySymbol('EGP');
    final total = summary.salaryMinor;
    final progress = total == 0
        ? 0.0
        : (summary.allocatedSpendMinor / total).clamp(0.0, 1.0).toDouble();
    return FinancePanel(
      colors: const [Color(0xFF07324D), Color(0xFF0E857B)],
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Color(0xFF72F2DE),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l['salaryCycle'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Text(
            _range(context, summary),
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Amount(
                  label: l['cycleAccountBalance'],
                  amount: currentBalanceMinor,
                  symbol: symbol,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _Amount(
                  label: l['monthlySalary'],
                  amount: total,
                  symbol: symbol,
                  dim: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              color: const Color(0xFF36DEC9),
              backgroundColor: Colors.white.withValues(alpha: .16),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '${l['salaryCycleActivity']}: ${summary.purchaseCount} ${l['salaryPurchases']} · ${summary.withdrawalCount} ${l['salaryWithdrawals']} · ${summary.transferCount} ${l['salaryTransfers']}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 3),
          Text(
            l['salaryMyBalanceHint'],
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _range(BuildContext context, SalaryCycleSummary value) {
    final l = AppLocalizations.s(context);
    final months = [for (var i = 1; i <= 12; i++) l['mo$i']];
    final end = value.endExclusive.subtract(const Duration(days: 1));
    return '${value.start.day} ${months[value.start.month - 1]} ${value.start.year} – ${end.day} ${months[end.month - 1]} ${end.year}';
  }
}

class _Amount extends StatelessWidget {
  final String label;
  final int amount;
  final String symbol;
  final bool dim;
  const _Amount({
    required this.label,
    required this.amount,
    required this.symbol,
    this.dim = false,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: dim ? .62 : .78),
          fontSize: 11,
        ),
      ),
      const SizedBox(height: 2),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          formatMoney(amount, symbol: symbol),
          style: TextStyle(
            color: Colors.white,
            fontSize: dim ? 16 : 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}
