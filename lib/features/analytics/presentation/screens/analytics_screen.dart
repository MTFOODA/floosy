import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:floosy/core/state/load_state.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../transactions/presentation/widgets/transaction_widgets.dart';

/// Real transactions for the Analysis screen (no mock data).

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 1;
  static const _periodKeys = [
    'periodDaily',
    'periodWeekly',
    'periodMonthly',
    'periodYearly'
  ];

  /// Outgoing transaction types that count as spending.
  static const _spendingTypes = [
    TransactionType.purchase,
    TransactionType.atm_withdrawal,
    TransactionType.cash_expense,
    TransactionType.transfer_out,
  ];

  bool _isSpending(Transaction t) => _spendingTypes.contains(t.type);

  DateTime _windowStart(int periodIndex, DateTime now) {
    switch (periodIndex) {
      case 0:
        return DateTime(now.year, now.month, now.day);
      case 1:
        return DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 6));
      case 2:
        return DateTime(now.year, now.month, 1);
      default:
        return DateTime(now.year, 1, 1);
    }
  }

  List<Transaction> _windowTx(List<Transaction> all, DateTime now) {
    final start = _windowStart(_selectedPeriod, now);
    return all
        .where((t) =>
            !t.transactionDate.isBefore(start) &&
            !t.transactionDate.isAfter(now.add(const Duration(days: 1))))
        .toList();
  }

  List<Transaction> _previousWindowTx(List<Transaction> all, DateTime now) {
    final start = _windowStart(_selectedPeriod, now);
    final prevEnd = start.subtract(const Duration(microseconds: 1));
    Duration length;
    switch (_selectedPeriod) {
      case 0:
        length = const Duration(days: 1);
        break;
      case 1:
        length = const Duration(days: 7);
        break;
      case 2:
        length = Duration(days: DateTime(now.year, now.month + 1, 0).day);
        break;
      default:
        length = const Duration(days: 365);
        break;
    }
    final prevStart = prevEnd.subtract(length);
    return all
        .where((t) =>
            !t.transactionDate.isBefore(prevStart) &&
            !t.transactionDate.isAfter(prevEnd))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final txAsync = context.watch<AnalyticsCubit>().state;
    final now = DateTime.now();
    final months = [
      l['mo1'],
      l['mo2'],
      l['mo3'],
      l['mo4'],
      l['mo5'],
      l['mo6'],
      l['mo7'],
      l['mo8'],
      l['mo9'],
      l['mo10'],
      l['mo11'],
      l['mo12']
    ];
    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(context)
              .copyWith(top: 16, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l['analysis'], style: context.fc.pageTitle),
              const SizedBox(height: 4),
              Text('${months[now.month - 1]} ${now.year}',
                  style:
                      TextStyle(fontSize: 16, color: context.fc.textSecondary)),
              const SizedBox(height: 20),
              _buildTimeSelector(l),
              const SizedBox(height: 20),
              _buildSummaryCards(txAsync, l, now),
              const SizedBox(height: 24),
              _buildSpendingTrend(txAsync, l, now),
              const SizedBox(height: 24),
              _buildCategoryDonut(txAsync, l, now),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(AppLocalizations l) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
          color: context.fc.toggleBackground,
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        children: List.generate(_periodKeys.length, (i) {
          final isActive = _selectedPeriod == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = i),
              child: AnimatedContainer(
                duration: FloosyDesign.slow,
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: isActive ? FloosyDesign.purpleGradient : null,
                    borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: Text(l[_periodKeys[i]],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? context.fc.textPrimary
                              : context.fc.textInactive)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCards(
      LoadState<List<Transaction>> txAsync, AppLocalizations l, DateTime now) {
    final all = txAsync.value ?? const <Transaction>[];
    final window = _windowTx(all, now);
    final prev = _previousWindowTx(all, now);
    final spendings = window.where(_isSpending).toList();

    final totalSpending = spendings.fold<int>(0, (s, t) => s + t.amountMinor);
    final prevTotal =
        prev.where(_isSpending).fold<int>(0, (s, t) => s + t.amountMinor);

    String totalSubtitle;
    if (prevTotal > 0 && totalSpending > 0) {
      final change = ((totalSpending - prevTotal) / prevTotal * 100).round();
      totalSubtitle = '${change > 0 ? '+' : ''}$change%';
    } else {
      totalSubtitle = l['thisMonth'];
    }

    Transaction? largest;
    for (final t in spendings) {
      if (largest == null || t.amountMinor > largest.amountMinor) largest = t;
    }
    final largestSubtitle = largest?.merchantName ??
        (largest != null ? transactionTypeLabel(l, largest.type) : '-');

    final typeCounts = <TransactionType, int>{};
    for (final t in spendings) {
      typeCounts[t.type] = (typeCounts[t.type] ?? 0) + 1;
    }
    TransactionType? mostUsedType;
    typeCounts.forEach((type, count) {
      if (mostUsedType == null || count > (typeCounts[mostUsedType] ?? 0)) {
        mostUsedType = type;
      }
    });

    final cards = <Widget>[
      _SummaryCard(
          title: l['totalSpending'],
          symbol: '💸',
          value: formatMoney(totalSpending),
          subtitle: totalSubtitle,
          subtitleColor:
              totalSubtitle.startsWith('-') ? FloosyDesign.positive : null),
      _SummaryCard(
          title: l['largestExpense'],
          symbol: '🏠',
          value: largest != null ? formatMoney(largest.amountMinor) : '0 EGP',
          subtitle: largestSubtitle),
      _SummaryCard(
          title: l['mostUsed'],
          symbol: '🛍️',
          value: mostUsedType != null
              ? transactionTypeLabel(l, mostUsedType!)
              : '-',
          subtitle: mostUsedType != null
              ? '${typeCounts[mostUsedType]} ${l['timesLabel']}'
              : l['noData']),
      _SummaryCard(
          title: l['transactionsCount'],
          symbol: '📊',
          value: '${window.length}',
          subtitle: l['thisMonth']),
    ];
    // Let each card grow with its content instead of imposing a grid aspect
    // ratio, which clips Arabic text on narrower phones.
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth < 300 ? 1 : 2;
      final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          for (final card in cards) SizedBox(width: width, child: card),
        ],
      );
    });
  }

  List<double> _weeklyBars(List<Transaction> all, DateTime now) {
    final amounts = List<double>.filled(7, 0);
    final today = DateTime(now.year, now.month, now.day);
    for (final t in all.where(_isSpending)) {
      final day = DateTime(t.transactionDate.year, t.transactionDate.month,
          t.transactionDate.day);
      final diff = today.difference(day).inDays;
      if (diff >= 0 && diff < 7) {
        amounts[6 - diff] += t.amountMinor / 100.0;
      }
    }
    final max = amounts.fold<double>(0, (m, v) => v > m ? v : m);
    if (max == 0) return List<double>.filled(7, 0);
    return amounts.map((v) => v / max).toList();
  }

  Widget _buildSpendingTrend(
      LoadState<List<Transaction>> txAsync, AppLocalizations l, DateTime now) {
    final barData = _weeklyBars(txAsync.value ?? const [], now);
    final days = [
      l['wd1'],
      l['wd2'],
      l['wd3'],
      l['wd4'],
      l['wd5'],
      l['wd6'],
      l['wd7']
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: context.fc.primarySurface,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          border: Border.all(color: context.fc.borderSubtle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l['spendingTrend'], style: context.fc.cardTitle),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(barData.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: barData[i]),
                      duration: FloosyDesign.chartAnim,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: value,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          FloosyDesign.brightPurple,
                                          FloosyDesign.primaryPurple
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(6)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(days[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11, color: context.fc.textMuted)),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDonut(
      LoadState<List<Transaction>> txAsync, AppLocalizations l, DateTime now) {
    final all = txAsync.value ?? const <Transaction>[];
    final spendings = _windowTx(all, now).where(_isSpending).toList();

    final typeTotals = <TransactionType, int>{};
    var grandTotal = 0;
    for (final t in spendings) {
      typeTotals[t.type] = (typeTotals[t.type] ?? 0) + t.amountMinor;
      grandTotal += t.amountMinor;
    }
    final sortedTypes = typeTotals.keys.toList()
      ..sort((a, b) => (typeTotals[b] ?? 0).compareTo(typeTotals[a] ?? 0));

    const donutColors = [
      FloosyDesign.primaryPurple,
      FloosyDesign.blue,
      FloosyDesign.cyan,
      FloosyDesign.positive,
      FloosyDesign.orange,
      FloosyDesign.pink,
    ];

    final categories = <_CategoryData>[];
    for (var i = 0; i < sortedTypes.length && i < 5; i++) {
      final type = sortedTypes[i];
      categories.add(_CategoryData(
          transactionTypeLabel(l, type),
          grandTotal > 0 ? (typeTotals[type] ?? 0) / grandTotal : 0.0,
          donutColors[i % donutColors.length]));
    }
    if (sortedTypes.length > 5 && grandTotal > 0) {
      var rest = 0.0;
      for (var i = 5; i < sortedTypes.length; i++) {
        rest += (typeTotals[sortedTypes[i]] ?? 0) / grandTotal;
      }
      categories.add(_CategoryData('Other', rest, donutColors[5]));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: context.fc.primarySurface,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          border: Border.all(color: context.fc.borderSubtle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l['spendingByCategory'], style: context.fc.cardTitle),
          const SizedBox(height: 20),
          if (categories.isEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pie_chart_outline_rounded,
                        size: 40, color: context.fc.textMuted),
                    const SizedBox(height: 10),
                    Text(l['noData'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, color: context.fc.textMuted)),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(builder: (context, constraints) {
              final stack = constraints.maxWidth < 360 ||
                  MediaQuery.textScalerOf(context).scale(13) > 18;
              return Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1.0),
                      duration: FloosyDesign.chartAnim,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return PieChart(PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 45,
                            sections: categories
                                .map((cat) => PieChartSectionData(
                                    value: cat.percentage * value,
                                    color: cat.color,
                                    radius: 28,
                                    showTitle: false))
                                .toList()));
                      },
                    ),
                  ),
                  SizedBox(
                    width: stack
                        ? constraints.maxWidth
                        : constraints.maxWidth - 166,
                    child: Column(
                      children: categories
                          .map((cat) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: cat.color,
                                            shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(cat.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    context.fc.textSecondary))),
                                    Text('${(cat.percentage * 100).round()}%',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: context.fc.textPrimary,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title, value, subtitle;
  final String symbol;
  final Color? subtitleColor;
  const _SummaryCard(
      {required this.title,
      required this.symbol,
      required this.value,
      required this.subtitle,
      this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: context.fc.primarySurface,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          border: Border.all(color: context.fc.borderSubtle)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Text(symbol, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 7),
            Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 11, color: context.fc.textMuted)))
          ]),
          const SizedBox(height: 6),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.fc.textPrimary))),
          const SizedBox(height: 4),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor ?? context.fc.textSecondary)),
        ],
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final double percentage;
  final Color color;
  const _CategoryData(this.name, this.percentage, this.color);
}
