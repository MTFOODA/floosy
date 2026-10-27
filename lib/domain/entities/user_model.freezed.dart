// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_bank_id')
  String? get defaultBankId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sms_tracking_enabled')
  bool get smsTrackingEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'notifications_enabled')
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'biometric_lock_enabled')
  bool get biometricLockEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'hide_balances')
  bool get hideBalances => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'full_name') String? fullName,
      String? email,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String language,
      String currency,
      @JsonKey(name: 'default_bank_id') String? defaultBankId,
      @JsonKey(name: 'sms_tracking_enabled') bool smsTrackingEnabled,
      @JsonKey(name: 'notifications_enabled') bool notificationsEnabled,
      @JsonKey(name: 'biometric_lock_enabled') bool biometricLockEnabled,
      @JsonKey(name: 'hide_balances') bool hideBalances,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? language = null,
    Object? currency = null,
    Object? defaultBankId = freezed,
    Object? smsTrackingEnabled = null,
    Object? notificationsEnabled = null,
    Object? biometricLockEnabled = null,
    Object? hideBalances = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      defaultBankId: freezed == defaultBankId
          ? _value.defaultBankId
          : defaultBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      smsTrackingEnabled: null == smsTrackingEnabled
          ? _value.smsTrackingEnabled
          : smsTrackingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricLockEnabled: null == biometricLockEnabled
          ? _value.biometricLockEnabled
          : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hideBalances: null == hideBalances
          ? _value.hideBalances
          : hideBalances // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'full_name') String? fullName,
      String? email,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String language,
      String currency,
      @JsonKey(name: 'default_bank_id') String? defaultBankId,
      @JsonKey(name: 'sms_tracking_enabled') bool smsTrackingEnabled,
      @JsonKey(name: 'notifications_enabled') bool notificationsEnabled,
      @JsonKey(name: 'biometric_lock_enabled') bool biometricLockEnabled,
      @JsonKey(name: 'hide_balances') bool hideBalances,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? language = null,
    Object? currency = null,
    Object? defaultBankId = freezed,
    Object? smsTrackingEnabled = null,
    Object? notificationsEnabled = null,
    Object? biometricLockEnabled = null,
    Object? hideBalances = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      defaultBankId: freezed == defaultBankId
          ? _value.defaultBankId
          : defaultBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      smsTrackingEnabled: null == smsTrackingEnabled
          ? _value.smsTrackingEnabled
          : smsTrackingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricLockEnabled: null == biometricLockEnabled
          ? _value.biometricLockEnabled
          : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hideBalances: null == hideBalances
          ? _value.hideBalances
          : hideBalances // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      @JsonKey(name: 'full_name') this.fullName,
      this.email,
      this.phone,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.language = 'ar',
      this.currency = 'EGP',
      @JsonKey(name: 'default_bank_id') this.defaultBankId,
      @JsonKey(name: 'sms_tracking_enabled') this.smsTrackingEnabled = false,
      @JsonKey(name: 'notifications_enabled') this.notificationsEnabled = true,
      @JsonKey(name: 'biometric_lock_enabled')
      this.biometricLockEnabled = false,
      @JsonKey(name: 'hide_balances') this.hideBalances = false,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'default_bank_id')
  final String? defaultBankId;
  @override
  @JsonKey(name: 'sms_tracking_enabled')
  final bool smsTrackingEnabled;
  @override
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;
  @override
  @JsonKey(name: 'biometric_lock_enabled')
  final bool biometricLockEnabled;
  @override
  @JsonKey(name: 'hide_balances')
  final bool hideBalances;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, phone: $phone, avatarUrl: $avatarUrl, language: $language, currency: $currency, defaultBankId: $defaultBankId, smsTrackingEnabled: $smsTrackingEnabled, notificationsEnabled: $notificationsEnabled, biometricLockEnabled: $biometricLockEnabled, hideBalances: $hideBalances, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.defaultBankId, defaultBankId) ||
                other.defaultBankId == defaultBankId) &&
            (identical(other.smsTrackingEnabled, smsTrackingEnabled) ||
                other.smsTrackingEnabled == smsTrackingEnabled) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.biometricLockEnabled, biometricLockEnabled) ||
                other.biometricLockEnabled == biometricLockEnabled) &&
            (identical(other.hideBalances, hideBalances) ||
                other.hideBalances == hideBalances) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      email,
      phone,
      avatarUrl,
      language,
      currency,
      defaultBankId,
      smsTrackingEnabled,
      notificationsEnabled,
      biometricLockEnabled,
      hideBalances,
      createdAt,
      updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      @JsonKey(name: 'full_name') final String? fullName,
      final String? email,
      final String? phone,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      final String language,
      final String currency,
      @JsonKey(name: 'default_bank_id') final String? defaultBankId,
      @JsonKey(name: 'sms_tracking_enabled') final bool smsTrackingEnabled,
      @JsonKey(name: 'notifications_enabled') final bool notificationsEnabled,
      @JsonKey(name: 'biometric_lock_enabled') final bool biometricLockEnabled,
      @JsonKey(name: 'hide_balances') final bool hideBalances,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  String get language;
  @override
  String get currency;
  @override
  @JsonKey(name: 'default_bank_id')
  String? get defaultBankId;
  @override
  @JsonKey(name: 'sms_tracking_enabled')
  bool get smsTrackingEnabled;
  @override
  @JsonKey(name: 'notifications_enabled')
  bool get notificationsEnabled;
  @override
  @JsonKey(name: 'biometric_lock_enabled')
  bool get biometricLockEnabled;
  @override
  @JsonKey(name: 'hide_balances')
  bool get hideBalances;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bank _$BankFromJson(Map<String, dynamic> json) {
  return _Bank.fromJson(json);
}

/// @nodoc
mixin _$Bank {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String? get nameAr => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Bank to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankCopyWith<Bank> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankCopyWith<$Res> {
  factory $BankCopyWith(Bank value, $Res Function(Bank) then) =
      _$BankCopyWithImpl<$Res, Bank>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? code,
      @JsonKey(name: 'logo_url') String? logoUrl,
      String country,
      String currency,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$BankCopyWithImpl<$Res, $Val extends Bank>
    implements $BankCopyWith<$Res> {
  _$BankCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? code = freezed,
    Object? logoUrl = freezed,
    Object? country = null,
    Object? currency = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankImplCopyWith<$Res> implements $BankCopyWith<$Res> {
  factory _$$BankImplCopyWith(
          _$BankImpl value, $Res Function(_$BankImpl) then) =
      __$$BankImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? code,
      @JsonKey(name: 'logo_url') String? logoUrl,
      String country,
      String currency,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$BankImplCopyWithImpl<$Res>
    extends _$BankCopyWithImpl<$Res, _$BankImpl>
    implements _$$BankImplCopyWith<$Res> {
  __$$BankImplCopyWithImpl(_$BankImpl _value, $Res Function(_$BankImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? code = freezed,
    Object? logoUrl = freezed,
    Object? country = null,
    Object? currency = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BankImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankImpl implements _Bank {
  const _$BankImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'name_ar') this.nameAr,
      this.code,
      @JsonKey(name: 'logo_url') this.logoUrl,
      this.country = 'EG',
      this.currency = 'EGP',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$BankImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @override
  final String? code;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Bank(id: $id, name: $name, nameAr: $nameAr, code: $code, logoUrl: $logoUrl, country: $country, currency: $currency, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameAr, code, logoUrl,
      country, currency, isActive, createdAt, updatedAt);

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      __$$BankImplCopyWithImpl<_$BankImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankImplToJson(
      this,
    );
  }
}

abstract class _Bank implements Bank {
  const factory _Bank(
      {required final String id,
      required final String name,
      @JsonKey(name: 'name_ar') final String? nameAr,
      final String? code,
      @JsonKey(name: 'logo_url') final String? logoUrl,
      final String country,
      final String currency,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$BankImpl;

  factory _Bank.fromJson(Map<String, dynamic> json) = _$BankImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_ar')
  String? get nameAr;
  @override
  String? get code;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  String get country;
  @override
  String get currency;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Bank
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BankSMSPattern _$BankSMSPatternFromJson(Map<String, dynamic> json) {
  return _BankSMSPattern.fromJson(json);
}

/// @nodoc
mixin _$BankSMSPattern {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_id')
  String get bankId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_pattern')
  String get senderPattern => throw _privateConstructorUsedError;
  List<dynamic> get purchasePatterns => throw _privateConstructorUsedError;
  List<dynamic> get atmPatterns => throw _privateConstructorUsedError;
  List<dynamic> get refundPatterns => throw _privateConstructorUsedError;
  List<dynamic> get incomePatterns => throw _privateConstructorUsedError;
  List<dynamic> get reversalPatterns => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_pattern')
  String? get amountPattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_pattern')
  String? get merchantPattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_pattern')
  String? get cardPattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_pattern')
  String? get datePattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BankSMSPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankSMSPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankSMSPatternCopyWith<BankSMSPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankSMSPatternCopyWith<$Res> {
  factory $BankSMSPatternCopyWith(
          BankSMSPattern value, $Res Function(BankSMSPattern) then) =
      _$BankSMSPatternCopyWithImpl<$Res, BankSMSPattern>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'bank_id') String bankId,
      @JsonKey(name: 'sender_pattern') String senderPattern,
      List<dynamic> purchasePatterns,
      List<dynamic> atmPatterns,
      List<dynamic> refundPatterns,
      List<dynamic> incomePatterns,
      List<dynamic> reversalPatterns,
      @JsonKey(name: 'amount_pattern') String? amountPattern,
      @JsonKey(name: 'merchant_pattern') String? merchantPattern,
      @JsonKey(name: 'card_pattern') String? cardPattern,
      @JsonKey(name: 'date_pattern') String? datePattern,
      @JsonKey(name: 'is_active') bool isActive,
      int version,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$BankSMSPatternCopyWithImpl<$Res, $Val extends BankSMSPattern>
    implements $BankSMSPatternCopyWith<$Res> {
  _$BankSMSPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankSMSPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankId = null,
    Object? senderPattern = null,
    Object? purchasePatterns = null,
    Object? atmPatterns = null,
    Object? refundPatterns = null,
    Object? incomePatterns = null,
    Object? reversalPatterns = null,
    Object? amountPattern = freezed,
    Object? merchantPattern = freezed,
    Object? cardPattern = freezed,
    Object? datePattern = freezed,
    Object? isActive = null,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      senderPattern: null == senderPattern
          ? _value.senderPattern
          : senderPattern // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePatterns: null == purchasePatterns
          ? _value.purchasePatterns
          : purchasePatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      atmPatterns: null == atmPatterns
          ? _value.atmPatterns
          : atmPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      refundPatterns: null == refundPatterns
          ? _value.refundPatterns
          : refundPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      incomePatterns: null == incomePatterns
          ? _value.incomePatterns
          : incomePatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      reversalPatterns: null == reversalPatterns
          ? _value.reversalPatterns
          : reversalPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      amountPattern: freezed == amountPattern
          ? _value.amountPattern
          : amountPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantPattern: freezed == merchantPattern
          ? _value.merchantPattern
          : merchantPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      cardPattern: freezed == cardPattern
          ? _value.cardPattern
          : cardPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      datePattern: freezed == datePattern
          ? _value.datePattern
          : datePattern // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankSMSPatternImplCopyWith<$Res>
    implements $BankSMSPatternCopyWith<$Res> {
  factory _$$BankSMSPatternImplCopyWith(_$BankSMSPatternImpl value,
          $Res Function(_$BankSMSPatternImpl) then) =
      __$$BankSMSPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'bank_id') String bankId,
      @JsonKey(name: 'sender_pattern') String senderPattern,
      List<dynamic> purchasePatterns,
      List<dynamic> atmPatterns,
      List<dynamic> refundPatterns,
      List<dynamic> incomePatterns,
      List<dynamic> reversalPatterns,
      @JsonKey(name: 'amount_pattern') String? amountPattern,
      @JsonKey(name: 'merchant_pattern') String? merchantPattern,
      @JsonKey(name: 'card_pattern') String? cardPattern,
      @JsonKey(name: 'date_pattern') String? datePattern,
      @JsonKey(name: 'is_active') bool isActive,
      int version,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$BankSMSPatternImplCopyWithImpl<$Res>
    extends _$BankSMSPatternCopyWithImpl<$Res, _$BankSMSPatternImpl>
    implements _$$BankSMSPatternImplCopyWith<$Res> {
  __$$BankSMSPatternImplCopyWithImpl(
      _$BankSMSPatternImpl _value, $Res Function(_$BankSMSPatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankSMSPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankId = null,
    Object? senderPattern = null,
    Object? purchasePatterns = null,
    Object? atmPatterns = null,
    Object? refundPatterns = null,
    Object? incomePatterns = null,
    Object? reversalPatterns = null,
    Object? amountPattern = freezed,
    Object? merchantPattern = freezed,
    Object? cardPattern = freezed,
    Object? datePattern = freezed,
    Object? isActive = null,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BankSMSPatternImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      senderPattern: null == senderPattern
          ? _value.senderPattern
          : senderPattern // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePatterns: null == purchasePatterns
          ? _value._purchasePatterns
          : purchasePatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      atmPatterns: null == atmPatterns
          ? _value._atmPatterns
          : atmPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      refundPatterns: null == refundPatterns
          ? _value._refundPatterns
          : refundPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      incomePatterns: null == incomePatterns
          ? _value._incomePatterns
          : incomePatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      reversalPatterns: null == reversalPatterns
          ? _value._reversalPatterns
          : reversalPatterns // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      amountPattern: freezed == amountPattern
          ? _value.amountPattern
          : amountPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantPattern: freezed == merchantPattern
          ? _value.merchantPattern
          : merchantPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      cardPattern: freezed == cardPattern
          ? _value.cardPattern
          : cardPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      datePattern: freezed == datePattern
          ? _value.datePattern
          : datePattern // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankSMSPatternImpl implements _BankSMSPattern {
  const _$BankSMSPatternImpl(
      {required this.id,
      @JsonKey(name: 'bank_id') required this.bankId,
      @JsonKey(name: 'sender_pattern') required this.senderPattern,
      final List<dynamic> purchasePatterns = const [],
      final List<dynamic> atmPatterns = const [],
      final List<dynamic> refundPatterns = const [],
      final List<dynamic> incomePatterns = const [],
      final List<dynamic> reversalPatterns = const [],
      @JsonKey(name: 'amount_pattern') this.amountPattern,
      @JsonKey(name: 'merchant_pattern') this.merchantPattern,
      @JsonKey(name: 'card_pattern') this.cardPattern,
      @JsonKey(name: 'date_pattern') this.datePattern,
      @JsonKey(name: 'is_active') this.isActive = true,
      this.version = 1,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt})
      : _purchasePatterns = purchasePatterns,
        _atmPatterns = atmPatterns,
        _refundPatterns = refundPatterns,
        _incomePatterns = incomePatterns,
        _reversalPatterns = reversalPatterns;

  factory _$BankSMSPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankSMSPatternImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'bank_id')
  final String bankId;
  @override
  @JsonKey(name: 'sender_pattern')
  final String senderPattern;
  final List<dynamic> _purchasePatterns;
  @override
  @JsonKey()
  List<dynamic> get purchasePatterns {
    if (_purchasePatterns is EqualUnmodifiableListView)
      return _purchasePatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasePatterns);
  }

  final List<dynamic> _atmPatterns;
  @override
  @JsonKey()
  List<dynamic> get atmPatterns {
    if (_atmPatterns is EqualUnmodifiableListView) return _atmPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_atmPatterns);
  }

  final List<dynamic> _refundPatterns;
  @override
  @JsonKey()
  List<dynamic> get refundPatterns {
    if (_refundPatterns is EqualUnmodifiableListView) return _refundPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_refundPatterns);
  }

  final List<dynamic> _incomePatterns;
  @override
  @JsonKey()
  List<dynamic> get incomePatterns {
    if (_incomePatterns is EqualUnmodifiableListView) return _incomePatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomePatterns);
  }

  final List<dynamic> _reversalPatterns;
  @override
  @JsonKey()
  List<dynamic> get reversalPatterns {
    if (_reversalPatterns is EqualUnmodifiableListView)
      return _reversalPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reversalPatterns);
  }

  @override
  @JsonKey(name: 'amount_pattern')
  final String? amountPattern;
  @override
  @JsonKey(name: 'merchant_pattern')
  final String? merchantPattern;
  @override
  @JsonKey(name: 'card_pattern')
  final String? cardPattern;
  @override
  @JsonKey(name: 'date_pattern')
  final String? datePattern;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BankSMSPattern(id: $id, bankId: $bankId, senderPattern: $senderPattern, purchasePatterns: $purchasePatterns, atmPatterns: $atmPatterns, refundPatterns: $refundPatterns, incomePatterns: $incomePatterns, reversalPatterns: $reversalPatterns, amountPattern: $amountPattern, merchantPattern: $merchantPattern, cardPattern: $cardPattern, datePattern: $datePattern, isActive: $isActive, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankSMSPatternImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.senderPattern, senderPattern) ||
                other.senderPattern == senderPattern) &&
            const DeepCollectionEquality()
                .equals(other._purchasePatterns, _purchasePatterns) &&
            const DeepCollectionEquality()
                .equals(other._atmPatterns, _atmPatterns) &&
            const DeepCollectionEquality()
                .equals(other._refundPatterns, _refundPatterns) &&
            const DeepCollectionEquality()
                .equals(other._incomePatterns, _incomePatterns) &&
            const DeepCollectionEquality()
                .equals(other._reversalPatterns, _reversalPatterns) &&
            (identical(other.amountPattern, amountPattern) ||
                other.amountPattern == amountPattern) &&
            (identical(other.merchantPattern, merchantPattern) ||
                other.merchantPattern == merchantPattern) &&
            (identical(other.cardPattern, cardPattern) ||
                other.cardPattern == cardPattern) &&
            (identical(other.datePattern, datePattern) ||
                other.datePattern == datePattern) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bankId,
      senderPattern,
      const DeepCollectionEquality().hash(_purchasePatterns),
      const DeepCollectionEquality().hash(_atmPatterns),
      const DeepCollectionEquality().hash(_refundPatterns),
      const DeepCollectionEquality().hash(_incomePatterns),
      const DeepCollectionEquality().hash(_reversalPatterns),
      amountPattern,
      merchantPattern,
      cardPattern,
      datePattern,
      isActive,
      version,
      createdAt,
      updatedAt);

  /// Create a copy of BankSMSPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankSMSPatternImplCopyWith<_$BankSMSPatternImpl> get copyWith =>
      __$$BankSMSPatternImplCopyWithImpl<_$BankSMSPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankSMSPatternImplToJson(
      this,
    );
  }
}

abstract class _BankSMSPattern implements BankSMSPattern {
  const factory _BankSMSPattern(
      {required final String id,
      @JsonKey(name: 'bank_id') required final String bankId,
      @JsonKey(name: 'sender_pattern') required final String senderPattern,
      final List<dynamic> purchasePatterns,
      final List<dynamic> atmPatterns,
      final List<dynamic> refundPatterns,
      final List<dynamic> incomePatterns,
      final List<dynamic> reversalPatterns,
      @JsonKey(name: 'amount_pattern') final String? amountPattern,
      @JsonKey(name: 'merchant_pattern') final String? merchantPattern,
      @JsonKey(name: 'card_pattern') final String? cardPattern,
      @JsonKey(name: 'date_pattern') final String? datePattern,
      @JsonKey(name: 'is_active') final bool isActive,
      final int version,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$BankSMSPatternImpl;

  factory _BankSMSPattern.fromJson(Map<String, dynamic> json) =
      _$BankSMSPatternImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'bank_id')
  String get bankId;
  @override
  @JsonKey(name: 'sender_pattern')
  String get senderPattern;
  @override
  List<dynamic> get purchasePatterns;
  @override
  List<dynamic> get atmPatterns;
  @override
  List<dynamic> get refundPatterns;
  @override
  List<dynamic> get incomePatterns;
  @override
  List<dynamic> get reversalPatterns;
  @override
  @JsonKey(name: 'amount_pattern')
  String? get amountPattern;
  @override
  @JsonKey(name: 'merchant_pattern')
  String? get merchantPattern;
  @override
  @JsonKey(name: 'card_pattern')
  String? get cardPattern;
  @override
  @JsonKey(name: 'date_pattern')
  String? get datePattern;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of BankSMSPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankSMSPatternImplCopyWith<_$BankSMSPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
