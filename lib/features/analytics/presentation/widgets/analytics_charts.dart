import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/money_formatter.dart';
import '../../../../../data/models/analytics_model.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}

class SpendingTrendChart extends StatelessWidget {
  final List<MonthlyReport> months;
  const SpendingTrendChart({super.key, required this.months});

  @override
  Widget build(BuildContext context) {
    // Show up to 6 most recent months, oldest → newest.
    final data = months.take(6).toList().reversed.toList();
    if (data.length < 2) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('—')),
      );
    }
    final maxExpense = data
        .map((m) => m.totalExpensesMinor)
        .fold<int>(0, (a, b) => a > b ? a : b);
    final maxY = (maxExpense / 100).ceilToDouble() + 1;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: data.asMap().entries.map((entry) {
            final i = entry.key;
            final m = entry.value;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: m.totalExpensesMinor / 100.0,
                  color: const Color(0xFF6366F1),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox();
                  return Text('${data[i].month}',
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class MonthSummaryCard extends StatelessWidget {
  final MonthlyReport month;
  const MonthSummaryCard({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${month.month}/${month.year}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _SummaryRow(l['totalSpending'], month.totalExpensesMinor),
            _SummaryRow(l['cardPurchase'], month.cardExpensesMinor),
            _SummaryRow(l['cashSpending'], month.cashExpensesMinor),
            _SummaryRow(l['atmWithdrawals'], month.atmWithdrawalsMinor),
            _SummaryRow(l['income'], month.totalIncomeMinor),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final int minor;
  const _SummaryRow(this.label, this.minor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(formatMoney(minor),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class ItemStatsSection extends StatelessWidget {
  final List<MonthlyItemStatistic> stats;
  const ItemStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    // Most purchased (by quantity) and highest spending (by total).
    final mostPurchased = (List<MonthlyItemStatistic>.from(stats)
          ..sort((a, b) => b.quantity.compareTo(a.quantity)))
        .first;
    final highestSpending = (List<MonthlyItemStatistic>.from(stats)
          ..sort(
              (a, b) => b.totalSpendingMinor.compareTo(a.totalSpendingMinor)))
        .first;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _HighlightRow(
                    l['mostPurchasedItem'], '${mostPurchased.quantity}'),
                const SizedBox(height: 8),
                _HighlightRow(l['highestSpendingItem'],
                    formatMoney(highestSpending.totalSpendingMinor)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Per-item breakdown.
        ...stats.map((s) => Card(
              child: ListTile(
                title: Text('${l['item']} ${s.itemId.substring(0, 8)}',
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(
                    '${s.purchaseEvents} ${l['numberOfPurchases']} · ${s.quantity} ${l['quantity']}'),
                trailing: Text(formatMoney(s.totalSpendingMinor),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )),
      ],
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final String label;
  final String value;
  const _HighlightRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
      ],
    );
  }
}
