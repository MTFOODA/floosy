import 'package:freezed_annotation/freezed_annotation.dart';

// Enum values mirror the PostgreSQL enum values 1:1 (snake_case).
// ignore_for_file: constant_identifier_names
part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

DateTime _dateTimeFromJsonRequired(dynamic value) =>
    DateTime.parse(value.toString()).toUtc();

enum AlertType {
  high_item_usage,
  budget_warning,
  high_spending,
  subscription_detected,
  cash_difference,
  saving_opportunity
}

enum AlertSeverity { info, warning, critical }

@freezed
class Alert with _$Alert {
  const factory Alert({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required AlertType type,
    @Default(AlertSeverity.info) AlertSeverity severity,
    @JsonKey(name: 'item_id') String? itemId,
    @JsonKey(name: 'category_id') String? categoryId,
    required String title,
    required String message,
    @Default({}) Map<String, dynamic> data,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String code,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    String? description,
    @JsonKey(name: 'description_ar') String? descriptionAr,
    String? icon,
    @Default({}) Map<String, dynamic> criteria,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

@freezed
class UserBadge with _$UserBadge {
  const factory UserBadge({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'badge_id') required String badgeId,
    @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
    required DateTime earnedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _UserBadge;

  factory UserBadge.fromJson(Map<String, dynamic> json) =>
      _$UserBadgeFromJson(json);
}

@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int year,
    required int month,
    @JsonKey(name: 'total_income_minor') @Default(0) int totalIncomeMinor,
    @JsonKey(name: 'total_expenses_minor') @Default(0) int totalExpensesMinor,
    @JsonKey(name: 'card_expenses_minor') @Default(0) int cardExpensesMinor,
    @JsonKey(name: 'cash_expenses_minor') @Default(0) int cashExpensesMinor,
    @JsonKey(name: 'atm_withdrawals_minor') @Default(0) int atmWithdrawalsMinor,
    @JsonKey(name: 'top_category_id') String? topCategoryId,
    @JsonKey(name: 'top_item_id') String? topItemId,
    @JsonKey(name: 'top_merchant_id') String? topMerchantId,
    @JsonKey(name: 'potential_savings_minor')
    @Default(0)
    int potentialSavingsMinor,
    @JsonKey(name: 'actual_savings_minor') @Default(0) int actualSavingsMinor,
    @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
    DateTime? generatedAt,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}

@freezed
class MonthlyItemStatistic with _$MonthlyItemStatistic {
  const factory MonthlyItemStatistic({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'item_id') required String itemId,
    required int year,
    required int month,
    @Default(0) int quantity,
    @JsonKey(name: 'purchase_events') @Default(0) int purchaseEvents,
    @JsonKey(name: 'total_spending_minor') @Default(0) int totalSpendingMinor,
    @JsonKey(name: 'average_price_minor') @Default(0) int averagePriceMinor,
    @JsonKey(name: 'previous_quantity') @Default(0) int previousQuantity,
    @JsonKey(name: 'previous_spending_minor')
    @Default(0)
    int previousSpendingMinor,
    @JsonKey(name: 'usage_change_percentage')
    @Default(0.0)
    double usageChangePercentage,
    @JsonKey(name: 'spending_change_percentage')
    @Default(0.0)
    double spendingChangePercentage,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _MonthlyItemStatistic;

  factory MonthlyItemStatistic.fromJson(Map<String, dynamic> json) =>
      _$MonthlyItemStatisticFromJson(json);
}

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required String title,
    required String message,
    @Default({}) Map<String, dynamic> data,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
    DateTime? scheduledFor,
    @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? sentAt,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    required String action,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') String? entityId,
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
