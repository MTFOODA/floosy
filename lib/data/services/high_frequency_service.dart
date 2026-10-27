import '../local/datasources/money_local_datasource.dart';
import '../../domain/entities/item_model.dart';

/// Analyzes reusable-item usage and decides when an item is being consumed
/// "unusually frequently" this month. Uses the user's own history as the
/// baseline (average of the previous months with actual usage) so the alert
/// never fires from an arbitrary `count > 5` rule and never flags planned
/// recurring expenses (they are not tracked as reusable items).
class HighFrequencyService {
  final MoneyLocalDataSource local;

  HighFrequencyService(this.local);

  static const double _usageRatioThreshold = 1.5;
  static const int _minCurrentQuantity = 4;
  static const int _minSurplus = 2;

  Future<ItemUsageAnalysis> analyzeItem({
    required String userId,
    required Item item,
    int currentYear = 0,
    int currentMonth = 0,
  }) async {
    final now = DateTime.now();
    final year = currentYear == 0 ? now.year : currentYear;
    final month = currentMonth == 0 ? now.month : currentMonth;

    final currentUsages =
        await local.getItemUsages(userId, year: year, month: month);
    final currentQuantity = currentUsages
        .where((u) => u.itemId == item.id)
        .fold<int>(0, (sum, u) => sum + u.quantity);
    final currentSpending = currentUsages
        .where((u) => u.itemId == item.id)
        .fold<int>(0, (sum, u) => sum + u.totalAmountMinor);

    // Baseline = average monthly quantity over the previous months that have
    // actual usage data (up to 3 months).
    final baselineQuantities = <double>[];
    for (var back = 1; back <= 3; back++) {
      final dt = DateTime(year, month - back);
      final usages =
          await local.getItemUsages(userId, year: dt.year, month: dt.month);
      final qty = usages
          .where((u) => u.itemId == item.id)
          .fold<int>(0, (sum, u) => sum + u.quantity);
      if (qty > 0) baselineQuantities.add(qty.toDouble());
    }

    final hasBaseline = baselineQuantities.isNotEmpty;
    final baselineAvg = hasBaseline
        ? baselineQuantities.reduce((a, b) => a + b) / baselineQuantities.length
        : 0.0;

    final isHigh = hasBaseline &&
        currentQuantity >= _minCurrentQuantity &&
        baselineAvg > 0 &&
        currentQuantity >= baselineAvg * _usageRatioThreshold &&
        (currentQuantity - baselineAvg) >= _minSurplus;

    return ItemUsageAnalysis(
      itemId: item.id,
      currentQuantity: currentQuantity,
      currentSpendingMinor: currentSpending,
      baselineAverage: baselineAvg,
      isHigh: isHigh,
    );
  }

  /// Convenience check used by item cards on the dashboard.
  /// [analyzeItem] only needs the item id, so a minimal shell item works.
  Future<bool> isHighFrequency({
    required String userId,
    required String itemId,
  }) async {
    final shellItem = Item(
      id: itemId,
      userId: userId,
      name: '',
      priceMinor: 0,
    );
    final analysis = await analyzeItem(userId: userId, item: shellItem);
    return analysis.isHigh;
  }

  /// Projected saving for a reduction target based on real spending:
  /// `potentialSaving = currentMonthlySpending × reductionPercentage`.
  static int projectedSaving(int currentSpendingMinor, double reductionPct) {
    if (reductionPct <= 0) return 0;
    final saving = currentSpendingMinor * (reductionPct / 100.0);
    return saving.round();
  }

  /// Whether the user actually earned the achievement badge this month:
  /// current usage dropped to (or below) the target-reduced baseline.
  static bool achievedTarget({
    required int currentQuantity,
    required double baselineAverage,
    required double reductionPct,
  }) {
    if (baselineAverage <= 0 || reductionPct <= 0) return false;
    final target = baselineAverage * (1 - reductionPct / 100.0);
    return currentQuantity <= target;
  }
}

class ItemUsageAnalysis {
  final String itemId;
  final int currentQuantity;
  final int currentSpendingMinor;

  /// Average monthly quantity over the user's previous usage months.
  final double baselineAverage;

  /// True when the item is being consumed unusually frequently this month.
  final bool isHigh;

  const ItemUsageAnalysis({
    required this.itemId,
    required this.currentQuantity,
    required this.currentSpendingMinor,
    required this.baselineAverage,
    required this.isHigh,
  });
}
