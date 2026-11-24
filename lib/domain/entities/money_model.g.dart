// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyIncome _$MonthlyIncomeFromJson(Map<String, dynamic> json) =>
    _MonthlyIncome(
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

Map<String, dynamic> _$MonthlyIncomeToJson(_MonthlyIncome instance) =>
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

_UserBankAccount _$UserBankAccountFromJson(Map<String, dynamic> json) =>
    _UserBankAccount(
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

Map<String, dynamic> _$UserBankAccountToJson(_UserBankAccount instance) =>
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

_BankAccountMovement _$BankAccountMovementFromJson(Map<String, dynamic> json) =>
    _BankAccountMovement(
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

Map<String, dynamic> _$BankAccountMovementToJson(
  _BankAccountMovement instance,
) => <String, dynamic>{
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
