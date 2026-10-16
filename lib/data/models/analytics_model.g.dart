// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: $enumDecode(_$AlertTypeEnumMap, json['type']),
      severity: $enumDecodeNullable(_$AlertSeverityEnumMap, json['severity']) ??
          AlertSeverity.info,
      itemId: json['item_id'] as String?,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      isRead: json['is_read'] as bool? ?? false,
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'item_id': instance.itemId,
      'category_id': instance.categoryId,
      'title': instance.title,
      'message': instance.message,
      'data': instance.data,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$AlertTypeEnumMap = {
  AlertType.high_item_usage: 'high_item_usage',
  AlertType.budget_warning: 'budget_warning',
  AlertType.high_spending: 'high_spending',
  AlertType.subscription_detected: 'subscription_detected',
  AlertType.cash_difference: 'cash_difference',
  AlertType.saving_opportunity: 'saving_opportunity',
};

const _$AlertSeverityEnumMap = {
  AlertSeverity.info: 'info',
  AlertSeverity.warning: 'warning',
  AlertSeverity.critical: 'critical',
};

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      icon: json['icon'] as String?,
      criteria: json['criteria'] as Map<String, dynamic>? ?? const {},
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'icon': instance.icon,
      'criteria': instance.criteria,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$UserBadgeImpl _$$UserBadgeImplFromJson(Map<String, dynamic> json) =>
    _$UserBadgeImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      badgeId: json['badge_id'] as String,
      earnedAt: _dateTimeFromJsonRequired(json['earned_at']),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserBadgeImplToJson(_$UserBadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'badge_id': instance.badgeId,
      'earned_at': instance.earnedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

_$MonthlyReportImpl _$$MonthlyReportImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyReportImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalIncomeMinor: (json['total_income_minor'] as num?)?.toInt() ?? 0,
      totalExpensesMinor: (json['total_expenses_minor'] as num?)?.toInt() ?? 0,
      cardExpensesMinor: (json['card_expenses_minor'] as num?)?.toInt() ?? 0,
      cashExpensesMinor: (json['cash_expenses_minor'] as num?)?.toInt() ?? 0,
      atmWithdrawalsMinor:
          (json['atm_withdrawals_minor'] as num?)?.toInt() ?? 0,
      topCategoryId: json['top_category_id'] as String?,
      topItemId: json['top_item_id'] as String?,
      topMerchantId: json['top_merchant_id'] as String?,
      potentialSavingsMinor:
          (json['potential_savings_minor'] as num?)?.toInt() ?? 0,
      actualSavingsMinor: (json['actual_savings_minor'] as num?)?.toInt() ?? 0,
      generatedAt: _dateTimeFromJson(json['generated_at']),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$MonthlyReportImplToJson(_$MonthlyReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'year': instance.year,
      'month': instance.month,
      'total_income_minor': instance.totalIncomeMinor,
      'total_expenses_minor': instance.totalExpensesMinor,
      'card_expenses_minor': instance.cardExpensesMinor,
      'cash_expenses_minor': instance.cashExpensesMinor,
      'atm_withdrawals_minor': instance.atmWithdrawalsMinor,
      'top_category_id': instance.topCategoryId,
      'top_item_id': instance.topItemId,
      'top_merchant_id': instance.topMerchantId,
      'potential_savings_minor': instance.potentialSavingsMinor,
      'actual_savings_minor': instance.actualSavingsMinor,
      'generated_at': instance.generatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$MonthlyItemStatisticImpl _$$MonthlyItemStatisticImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyItemStatisticImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      purchaseEvents: (json['purchase_events'] as num?)?.toInt() ?? 0,
      totalSpendingMinor: (json['total_spending_minor'] as num?)?.toInt() ?? 0,
      averagePriceMinor: (json['average_price_minor'] as num?)?.toInt() ?? 0,
      previousQuantity: (json['previous_quantity'] as num?)?.toInt() ?? 0,
      previousSpendingMinor:
          (json['previous_spending_minor'] as num?)?.toInt() ?? 0,
      usageChangePercentage:
          (json['usage_change_percentage'] as num?)?.toDouble() ?? 0.0,
      spendingChangePercentage:
          (json['spending_change_percentage'] as num?)?.toDouble() ?? 0.0,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$MonthlyItemStatisticImplToJson(
        _$MonthlyItemStatisticImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'year': instance.year,
      'month': instance.month,
      'quantity': instance.quantity,
      'purchase_events': instance.purchaseEvents,
      'total_spending_minor': instance.totalSpendingMinor,
      'average_price_minor': instance.averagePriceMinor,
      'previous_quantity': instance.previousQuantity,
      'previous_spending_minor': instance.previousSpendingMinor,
      'usage_change_percentage': instance.usageChangePercentage,
      'spending_change_percentage': instance.spendingChangePercentage,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      isRead: json['is_read'] as bool? ?? false,
      scheduledFor: _dateTimeFromJson(json['scheduled_for']),
      sentAt: _dateTimeFromJson(json['sent_at']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'data': instance.data,
      'is_read': instance.isRead,
      'scheduled_for': instance.scheduledFor?.toIso8601String(),
      'sent_at': instance.sentAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      action: json['action'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String?,
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>?,
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'action': instance.action,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'old_data': instance.oldData,
      'new_data': instance.newData,
      'created_at': instance.createdAt?.toIso8601String(),
    };
