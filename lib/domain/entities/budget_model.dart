import 'package:freezed_annotation/freezed_annotation.dart';

// Enum values mirror the PostgreSQL enum values 1:1 (snake_case).
// ignore_for_file: constant_identifier_names
part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

DateTime _dateTimeFromJsonRequired(dynamic value) =>
    DateTime.parse(value.toString()).toUtc();

@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default('EGP') String currency,
    @Default('monthly') String period,
    @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime startDate,
    @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime endDate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

@freezed
class BudgetCategory with _$BudgetCategory {
  const factory BudgetCategory({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'limit_minor') required int limitMinor,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _BudgetCategory;

  factory BudgetCategory.fromJson(Map<String, dynamic> json) =>
      _$BudgetCategoryFromJson(json);
}

enum RecurringFrequency { daily, weekly, monthly, yearly, custom }

@freezed
class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'category_id') String? categoryId,
    String? icon,
    required RecurringFrequency frequency,
    @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime nextDueDate,
    @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime startDate,
    @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? endDate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _RecurringExpense;

  factory RecurringExpense.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseFromJson(json);
}

enum RecurringOccurrenceStatus { pending, paid, skipped, cancelled }

@freezed
class RecurringExpenseOccurrence with _$RecurringExpenseOccurrence {
  const factory RecurringExpenseOccurrence({
    required String id,
    @JsonKey(name: 'recurring_expense_id') required String recurringExpenseId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime scheduledDate,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default(RecurringOccurrenceStatus.pending)
    RecurringOccurrenceStatus status,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _RecurringExpenseOccurrence;

  factory RecurringExpenseOccurrence.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseOccurrenceFromJson(json);
}

@freezed
class SavingGoal with _$SavingGoal {
  const factory SavingGoal({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'target_amount_minor') required int targetAmountMinor,
    @JsonKey(name: 'current_amount_minor') @Default(0) int currentAmountMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
    DateTime? targetDate,
    @Default('active') String status,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _SavingGoal;

  factory SavingGoal.fromJson(Map<String, dynamic> json) =>
      _$SavingGoalFromJson(json);
}

enum RecommendationStatus { active, completed, dismissed }

@freezed
class SavingRecommendation with _$SavingRecommendation {
  const factory SavingRecommendation({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'item_id') String? itemId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'baseline_amount_minor') required int baselineAmountMinor,
    @JsonKey(name: 'current_amount_minor') required int currentAmountMinor,
    @JsonKey(name: 'reduction_percentage') required double reductionPercentage,
    @JsonKey(name: 'estimated_saving_minor') required int estimatedSavingMinor,
    required int month,
    required int year,
    @Default(RecommendationStatus.active) RecommendationStatus status,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _SavingRecommendation;

  factory SavingRecommendation.fromJson(Map<String, dynamic> json) =>
      _$SavingRecommendationFromJson(json);
}
