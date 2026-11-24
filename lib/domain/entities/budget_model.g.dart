// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  amountMinor: (json['amount_minor'] as num).toInt(),
  currency: json['currency'] as String? ?? 'EGP',
  period: json['period'] as String? ?? 'monthly',
  startDate: _dateTimeFromJsonRequired(json['start_date']),
  endDate: _dateTimeFromJsonRequired(json['end_date']),
  isActive: json['is_active'] as bool? ?? true,
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'amount_minor': instance.amountMinor,
  'currency': instance.currency,
  'period': instance.period,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_BudgetCategory _$BudgetCategoryFromJson(Map<String, dynamic> json) =>
    _BudgetCategory(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      categoryId: json['category_id'] as String,
      limitMinor: (json['limit_minor'] as num).toInt(),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$BudgetCategoryToJson(_BudgetCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'category_id': instance.categoryId,
      'limit_minor': instance.limitMinor,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) =>
    _RecurringExpense(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      amountMinor: (json['amount_minor'] as num).toInt(),
      currency: json['currency'] as String? ?? 'EGP',
      categoryId: json['category_id'] as String?,
      icon: json['icon'] as String?,
      frequency: $enumDecode(_$RecurringFrequencyEnumMap, json['frequency']),
      nextDueDate: _dateTimeFromJsonRequired(json['next_due_date']),
      startDate: _dateTimeFromJsonRequired(json['start_date']),
      endDate: _dateTimeFromJson(json['end_date']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$RecurringExpenseToJson(_RecurringExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'amount_minor': instance.amountMinor,
      'currency': instance.currency,
      'category_id': instance.categoryId,
      'icon': instance.icon,
      'frequency': _$RecurringFrequencyEnumMap[instance.frequency]!,
      'next_due_date': instance.nextDueDate.toIso8601String(),
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$RecurringFrequencyEnumMap = {
  RecurringFrequency.daily: 'daily',
  RecurringFrequency.weekly: 'weekly',
  RecurringFrequency.monthly: 'monthly',
  RecurringFrequency.yearly: 'yearly',
  RecurringFrequency.custom: 'custom',
};

_RecurringExpenseOccurrence _$RecurringExpenseOccurrenceFromJson(
  Map<String, dynamic> json,
) => _RecurringExpenseOccurrence(
  id: json['id'] as String,
  recurringExpenseId: json['recurring_expense_id'] as String,
  userId: json['user_id'] as String,
  scheduledDate: _dateTimeFromJsonRequired(json['scheduled_date']),
  amountMinor: (json['amount_minor'] as num).toInt(),
  status:
      $enumDecodeNullable(_$RecurringOccurrenceStatusEnumMap, json['status']) ??
      RecurringOccurrenceStatus.pending,
  transactionId: json['transaction_id'] as String?,
  createdAt: _dateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$RecurringExpenseOccurrenceToJson(
  _RecurringExpenseOccurrence instance,
) => <String, dynamic>{
  'id': instance.id,
  'recurring_expense_id': instance.recurringExpenseId,
  'user_id': instance.userId,
  'scheduled_date': instance.scheduledDate.toIso8601String(),
  'amount_minor': instance.amountMinor,
  'status': _$RecurringOccurrenceStatusEnumMap[instance.status]!,
  'transaction_id': instance.transactionId,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$RecurringOccurrenceStatusEnumMap = {
  RecurringOccurrenceStatus.pending: 'pending',
  RecurringOccurrenceStatus.paid: 'paid',
  RecurringOccurrenceStatus.skipped: 'skipped',
  RecurringOccurrenceStatus.cancelled: 'cancelled',
};

_SavingGoal _$SavingGoalFromJson(Map<String, dynamic> json) => _SavingGoal(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  targetAmountMinor: (json['target_amount_minor'] as num).toInt(),
  currentAmountMinor: (json['current_amount_minor'] as num?)?.toInt() ?? 0,
  currency: json['currency'] as String? ?? 'EGP',
  targetDate: _dateTimeFromJson(json['target_date']),
  status: json['status'] as String? ?? 'active',
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$SavingGoalToJson(_SavingGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'target_amount_minor': instance.targetAmountMinor,
      'current_amount_minor': instance.currentAmountMinor,
      'currency': instance.currency,
      'target_date': instance.targetDate?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_SavingRecommendation _$SavingRecommendationFromJson(
  Map<String, dynamic> json,
) => _SavingRecommendation(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  itemId: json['item_id'] as String?,
  categoryId: json['category_id'] as String?,
  baselineAmountMinor: (json['baseline_amount_minor'] as num).toInt(),
  currentAmountMinor: (json['current_amount_minor'] as num).toInt(),
  reductionPercentage: (json['reduction_percentage'] as num).toDouble(),
  estimatedSavingMinor: (json['estimated_saving_minor'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  status:
      $enumDecodeNullable(_$RecommendationStatusEnumMap, json['status']) ??
      RecommendationStatus.active,
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$SavingRecommendationToJson(
  _SavingRecommendation instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'item_id': instance.itemId,
  'category_id': instance.categoryId,
  'baseline_amount_minor': instance.baselineAmountMinor,
  'current_amount_minor': instance.currentAmountMinor,
  'reduction_percentage': instance.reductionPercentage,
  'estimated_saving_minor': instance.estimatedSavingMinor,
  'month': instance.month,
  'year': instance.year,
  'status': _$RecommendationStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$RecommendationStatusEnumMap = {
  RecommendationStatus.active: 'active',
  RecommendationStatus.completed: 'completed',
  RecommendationStatus.dismissed: 'dismissed',
};
