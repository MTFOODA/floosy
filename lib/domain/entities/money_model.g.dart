// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyIncomeImpl _$$MonthlyIncomeImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyIncomeImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      label: json['label'] as String?,
      amountMinor: (json['amount_minor'] as num).toInt(),
      currency: json['currency'] as String? ?? 'EGP',
      bankAccountId: json['bank_account_id'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$MonthlyIncomeImplToJson(_$MonthlyIncomeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'year': instance.year,
      'month': instance.month,
      'label': instance.label,
      'amount_minor': instance.amountMinor,
      'currency': instance.currency,
      'bank_account_id': instance.bankAccountId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$UserBankAccountImpl _$$UserBankAccountImplFromJson(
        Map<String, dynamic> json) =>
    _$UserBankAccountImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      bankId: json['bank_id'] as String?,
      accountLast4: json['account_last4'] as String?,
      openingBalanceMinor:
          (json['opening_balance_minor'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$UserBankAccountImplToJson(
        _$UserBankAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'bank_id': instance.bankId,
      'account_last4': instance.accountLast4,
      'opening_balance_minor': instance.openingBalanceMinor,
      'currency': instance.currency,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$BankAccountMovementImpl _$$BankAccountMovementImplFromJson(
        Map<String, dynamic> json) =>
    _$BankAccountMovementImpl(
      id: json['id'] as String,
      accountId: json['account_id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      amountMinor: (json['amount_minor'] as num).toInt(),
      description: json['description'] as String?,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      movementDate: _dateTimeFromJsonRequired(json['movement_date']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$BankAccountMovementImplToJson(
        _$BankAccountMovementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'user_id': instance.userId,
      'type': instance.type,
      'amount_minor': instance.amountMinor,
      'description': instance.description,
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'movement_date': instance.movementDate.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
