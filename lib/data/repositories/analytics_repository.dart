import '../models/analytics_model.dart';
import '../models/budget_model.dart';
import '../remote/datasources/analytics_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepository({required this.remoteDataSource});

  /// Get monthly report for a user
  Future<MonthlyReport?> getMonthlyReport({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      return await remoteDataSource.getMonthlyReport(
        userId: userId,
        year: year,
        month: month,
      );
    } catch (e) {
      logError('Error getting monthly report: $e');
      return null;
    }
  }

  /// Get all monthly reports for a user
  Future<List<MonthlyReport>> getMonthlyReports(String userId) async {
    try {
      return await remoteDataSource.getMonthlyReports(userId);
    } catch (e) {
      logError('Error getting monthly reports: $e');
      return [];
    }
  }

  /// Get item statistics for a month
  Future<List<MonthlyItemStatistic>> getItemStatistics({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      return await remoteDataSource.getItemStatistics(
        userId: userId,
        year: year,
        month: month,
      );
    } catch (e) {
      logError('Error getting item statistics: $e');
      return [];
    }
  }

  /// Get top spending items for a month
  Future<List<MonthlyItemStatistic>> getTopItems({
    required String userId,
    required int year,
    required int month,
    int limit = 5,
  }) async {
    try {
      final stats = await getItemStatistics(
        userId: userId,
        year: year,
        month: month,
      );
      stats
          .sort((a, b) => b.totalSpendingMinor.compareTo(a.totalSpendingMinor));
      return stats.take(limit).toList();
    } catch (e) {
      logError('Error getting top items: $e');
      return [];
    }
  }

  /// Get saving recommendations for a user
  Future<List<SavingRecommendation>> getSavingRecommendations(
      String userId) async {
    try {
      return await remoteDataSource.getSavingRecommendations(userId);
    } catch (e) {
      logError('Error getting saving recommendations: $e');
      return [];
    }
  }

  /// Get saving goals for a user
  Future<List<SavingGoal>> getSavingGoals(String userId) async {
    try {
      return await remoteDataSource.getSavingGoals(userId);
    } catch (e) {
      logError('Error getting saving goals: $e');
      return [];
    }
  }

  /// Create a new saving goal
  Future<SavingGoal> createSavingGoal({
    required String userId,
    required String name,
    required int targetAmountMinor,
    required String currency,
    required DateTime targetDate,
  }) async {
    final goal = SavingGoal(
      id: '',
      userId: userId,
      name: name,
      targetAmountMinor: targetAmountMinor,
      currentAmountMinor: 0,
      currency: currency,
      targetDate: targetDate,
      status: 'active',
    );

    try {
      return await remoteDataSource.createSavingGoal(goal);
    } catch (e) {
      logError('Error creating saving goal: $e');
      rethrow;
    }
  }

  /// Get monthly spending trends
  Future<Map<int, int>> getMonthlySpendingTrends({
    required String userId,
    required int year,
  }) async {
    try {
      final reports = await getMonthlyReports(userId);
      final trends = <int, int>{};

      for (final report in reports) {
        if (report.year == year) {
          trends[report.month] = report.totalExpensesMinor;
        }
      }

      return trends;
    } catch (e) {
      logError('Error getting spending trends: $e');
      return {};
    }
  }

  /// Compare spending between two months
  Future<SpendingComparison?> compareMonths({
    required String userId,
    required int year1,
    required int month1,
    required int year2,
    required int month2,
  }) async {
    try {
      final report1 = await getMonthlyReport(
        userId: userId,
        year: year1,
        month: month1,
      );
      final report2 = await getMonthlyReport(
        userId: userId,
        year: year2,
        month: month2,
      );

      if (report1 == null || report2 == null) return null;

      final difference =
          report2.totalExpensesMinor - report1.totalExpensesMinor;
      final percentChange = report1.totalExpensesMinor > 0
          ? (difference / report1.totalExpensesMinor * 100)
          : 0.0;

      return SpendingComparison(
        month1Spending: report1.totalExpensesMinor,
        month2Spending: report2.totalExpensesMinor,
        difference: difference,
        percentageChange: percentChange,
        isIncreased: difference > 0,
      );
    } catch (e) {
      logError('Error comparing months: $e');
      return null;
    }
  }

  /// Get alerts for a user
  Future<List<Alert>> getAlerts(String userId) async {
    try {
      return await remoteDataSource.getAlerts(userId);
    } catch (e) {
      logError('Error getting alerts: $e');
      return [];
    }
  }

  /// Get unread alerts
  Future<List<Alert>> getUnreadAlerts(String userId) async {
    try {
      final alerts = await getAlerts(userId);
      return alerts.where((a) => !a.isRead).toList();
    } catch (e) {
      logError('Error getting unread alerts: $e');
      return [];
    }
  }

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    try {
      await remoteDataSource.markAlertAsRead(alertId);
    } catch (e) {
      logError('Error marking alert as read: $e');
      rethrow;
    }
  }

  /// Create a new alert
  Future<Alert> createAlert({
    required String userId,
    required AlertType type,
    AlertSeverity severity = AlertSeverity.info,
    required String title,
    required String message,
    String? itemId,
    String? categoryId,
    Map<String, dynamic>? data,
  }) async {
    final alert = Alert(
      id: '',
      userId: userId,
      type: type,
      severity: severity,
      itemId: itemId,
      categoryId: categoryId,
      title: title,
      message: message,
      data: data ?? const {},
      isRead: false,
    );

    try {
      return await remoteDataSource.createAlert(alert);
    } catch (e) {
      logError('Error creating alert: $e');
      rethrow;
    }
  }
}

class SpendingComparison {
  final int month1Spending;
  final int month2Spending;
  final int difference;
  final double percentageChange;
  final bool isIncreased;

  SpendingComparison({
    required this.month1Spending,
    required this.month2Spending,
    required this.difference,
    required this.percentageChange,
    required this.isIncreased,
  });
}
