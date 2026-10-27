// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      language: json['language'] as String? ?? 'ar',
      currency: json['currency'] as String? ?? 'EGP',
      defaultBankId: json['default_bank_id'] as String?,
      smsTrackingEnabled: json['sms_tracking_enabled'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      biometricLockEnabled: json['biometric_lock_enabled'] as bool? ?? false,
      hideBalances: json['hide_balances'] as bool? ?? false,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'language': instance.language,
      'currency': instance.currency,
      'default_bank_id': instance.defaultBankId,
      'sms_tracking_enabled': instance.smsTrackingEnabled,
      'notifications_enabled': instance.notificationsEnabled,
      'biometric_lock_enabled': instance.biometricLockEnabled,
      'hide_balances': instance.hideBalances,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$BankImpl _$$BankImplFromJson(Map<String, dynamic> json) => _$BankImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      code: json['code'] as String?,
      logoUrl: json['logo_url'] as String?,
      country: json['country'] as String? ?? 'EG',
      currency: json['currency'] as String? ?? 'EGP',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$BankImplToJson(_$BankImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'code': instance.code,
      'logo_url': instance.logoUrl,
      'country': instance.country,
      'currency': instance.currency,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$BankSMSPatternImpl _$$BankSMSPatternImplFromJson(Map<String, dynamic> json) =>
    _$BankSMSPatternImpl(
      id: json['id'] as String,
      bankId: json['bank_id'] as String,
      senderPattern: json['sender_pattern'] as String,
      purchasePatterns: json['purchasePatterns'] as List<dynamic>? ?? const [],
      atmPatterns: json['atmPatterns'] as List<dynamic>? ?? const [],
      refundPatterns: json['refundPatterns'] as List<dynamic>? ?? const [],
      incomePatterns: json['incomePatterns'] as List<dynamic>? ?? const [],
      reversalPatterns: json['reversalPatterns'] as List<dynamic>? ?? const [],
      amountPattern: json['amount_pattern'] as String?,
      merchantPattern: json['merchant_pattern'] as String?,
      cardPattern: json['card_pattern'] as String?,
      datePattern: json['date_pattern'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$BankSMSPatternImplToJson(
        _$BankSMSPatternImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank_id': instance.bankId,
      'sender_pattern': instance.senderPattern,
      'purchasePatterns': instance.purchasePatterns,
      'atmPatterns': instance.atmPatterns,
      'refundPatterns': instance.refundPatterns,
      'incomePatterns': instance.incomePatterns,
      'reversalPatterns': instance.reversalPatterns,
      'amount_pattern': instance.amountPattern,
      'merchant_pattern': instance.merchantPattern,
      'card_pattern': instance.cardPattern,
      'date_pattern': instance.datePattern,
      'is_active': instance.isActive,
      'version': instance.version,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
