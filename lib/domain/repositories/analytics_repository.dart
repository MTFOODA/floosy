import '../entities/spending_comparison.dart';
import '../entities/analytics_model.dart';
import '../entities/budget_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class AnalyticsRepository {
  Future<MonthlyReport?> getMonthlyReport({
    required String userId,
    required int year,
    required int month,
  });

  Future<List<MonthlyReport>> getMonthlyReports(String userId);

  Future<List<MonthlyItemStatistic>> getItemStatistics({
    required String userId,
    required int year,
    required int month,
  });

  Future<List<MonthlyItemStatistic>> getTopItems({
    required String userId,
    required int year,
    required int month,
    int limit = 5,
  });

  Future<List<SavingRecommendation>> getSavingRecommendations(String userId);

  Future<List<SavingGoal>> getSavingGoals(String userId);

  Future<SavingGoal> createSavingGoal({
    required String userId,
    required String name,
    required int targetAmountMinor,
    required String currency,
    required DateTime targetDate,
  });

  Future<Map<int, int>> getMonthlySpendingTrends({
    required String userId,
    required int year,
  });

  Future<SpendingComparison?> compareMonths({
    required String userId,
    required int year1,
    required int month1,
    required int year2,
    required int month2,
  });

  Future<List<Alert>> getAlerts(String userId);

  Future<List<Alert>> getUnreadAlerts(String userId);

  Future<void> markAlertAsRead(String alertId);

  Future<Alert> createAlert({
    required String userId,
    required AlertType type,
    AlertSeverity severity = AlertSeverity.info,
    required String title,
    required String message,
    String? itemId,
    String? categoryId,
    Map<String, dynamic>? data,
  });
}
