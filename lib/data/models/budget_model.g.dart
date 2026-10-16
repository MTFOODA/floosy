// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetImpl _$$BudgetImplFromJson(Map<String, dynamic> json) => _$BudgetImpl(
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

Map<String, dynamic> _$$BudgetImplToJson(_$BudgetImpl instance) =>
    <String, dynamic>{
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

_$BudgetCategoryImpl _$$BudgetCategoryImplFromJson(Map<String, dynamic> json) =>
    _$BudgetCategoryImpl(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      categoryId: json['category_id'] as String,
      limitMinor: (json['limit_minor'] as num).toInt(),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$BudgetCategoryImplToJson(
        _$BudgetCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'category_id': instance.categoryId,
      'limit_minor': instance.limitMinor,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$RecurringExpenseImpl _$$RecurringExpenseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecurringExpenseImpl(
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

Map<String, dynamic> _$$RecurringExpenseImplToJson(
        _$RecurringExpenseImpl instance) =>
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

_$RecurringExpenseOccurrenceImpl _$$RecurringExpenseOccurrenceImplFromJson(
        Map<String, dynamic> json) =>
    _$RecurringExpenseOccurrenceImpl(
      id: json['id'] as String,
      recurringExpenseId: json['recurring_expense_id'] as String,
      userId: json['user_id'] as String,
      scheduledDate: _dateTimeFromJsonRequired(json['scheduled_date']),
      amountMinor: (json['amount_minor'] as num).toInt(),
      status: $enumDecodeNullable(
              _$RecurringOccurrenceStatusEnumMap, json['status']) ??
          RecurringOccurrenceStatus.pending,
      transactionId: json['transaction_id'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$RecurringExpenseOccurrenceImplToJson(
        _$RecurringExpenseOccurrenceImpl instance) =>
    <String, dynamic>{
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

_$SavingGoalImpl _$$SavingGoalImplFromJson(Map<String, dynamic> json) =>
    _$SavingGoalImpl(
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

Map<String, dynamic> _$$SavingGoalImplToJson(_$SavingGoalImpl instance) =>
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

_$SavingRecommendationImpl _$$SavingRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$SavingRecommendationImpl(
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

Map<String, dynamic> _$$SavingRecommendationImplToJson(
        _$SavingRecommendationImpl instance) =>
    <String, dynamic>{
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
