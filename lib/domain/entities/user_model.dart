import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default('ar') String language,
    @Default('EGP') String currency,
    @JsonKey(name: 'default_bank_id') String? defaultBankId,
    @JsonKey(name: 'sms_tracking_enabled')
    @Default(false)
    bool smsTrackingEnabled,
    @JsonKey(name: 'notifications_enabled')
    @Default(true)
    bool notificationsEnabled,
    @JsonKey(name: 'biometric_lock_enabled')
    @Default(false)
    bool biometricLockEnabled,
    @JsonKey(name: 'hide_balances') @Default(false) bool hideBalances,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class Bank with _$Bank {
  const factory Bank({
    required String id,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    String? code,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @Default('EG') String country,
    @Default('EGP') String currency,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
}

@freezed
class BankSMSPattern with _$BankSMSPattern {
  const factory BankSMSPattern({
    required String id,
    @JsonKey(name: 'bank_id') required String bankId,
    @JsonKey(name: 'sender_pattern') required String senderPattern,
    @Default([]) List<dynamic> purchasePatterns,
    @Default([]) List<dynamic> atmPatterns,
    @Default([]) List<dynamic> refundPatterns,
    @Default([]) List<dynamic> incomePatterns,
    @Default([]) List<dynamic> reversalPatterns,
    @JsonKey(name: 'amount_pattern') String? amountPattern,
    @JsonKey(name: 'merchant_pattern') String? merchantPattern,
    @JsonKey(name: 'card_pattern') String? cardPattern,
    @JsonKey(name: 'date_pattern') String? datePattern,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(1) int version,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _BankSMSPattern;

  factory BankSMSPattern.fromJson(Map<String, dynamic> json) =>
      _$BankSMSPatternFromJson(json);
}
