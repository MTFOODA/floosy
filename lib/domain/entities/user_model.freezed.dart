// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id;@JsonKey(name: 'full_name') String? get fullName; String? get email; String? get phone;@JsonKey(name: 'avatar_url') String? get avatarUrl; String get language; String get currency;@JsonKey(name: 'default_bank_id') String? get defaultBankId;@JsonKey(name: 'sms_tracking_enabled') bool get smsTrackingEnabled;@JsonKey(name: 'notifications_enabled') bool get notificationsEnabled;@JsonKey(name: 'biometric_lock_enabled') bool get biometricLockEnabled;@JsonKey(name: 'hide_balances') bool get hideBalances;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.defaultBankId, _this.defaultBankId) || other.defaultBankId == _this.defaultBankId)&&(identical(other.smsTrackingEnabled, _this.smsTrackingEnabled) || other.smsTrackingEnabled == _this.smsTrackingEnabled)&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled)&&(identical(other.biometricLockEnabled, _this.biometricLockEnabled) || other.biometricLockEnabled == _this.biometricLockEnabled)&&(identical(other.hideBalances, _this.hideBalances) || other.hideBalances == _this.hideBalances)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.email,_this.phone,_this.avatarUrl,_this.language,_this.currency,_this.defaultBankId,_this.smsTrackingEnabled,_this.notificationsEnabled,_this.biometricLockEnabled,_this.hideBalances,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, fullName: ${_this.fullName}, email: ${_this.email}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl}, language: ${_this.language}, currency: ${_this.currency}, defaultBankId: ${_this.defaultBankId}, smsTrackingEnabled: ${_this.smsTrackingEnabled}, notificationsEnabled: ${_this.notificationsEnabled}, biometricLockEnabled: ${_this.biometricLockEnabled}, hideBalances: ${_this.hideBalances}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName, String? email, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl, String language, String currency,@JsonKey(name: 'default_bank_id') String? defaultBankId,@JsonKey(name: 'sms_tracking_enabled') bool smsTrackingEnabled,@JsonKey(name: 'notifications_enabled') bool notificationsEnabled,@JsonKey(name: 'biometric_lock_enabled') bool biometricLockEnabled,@JsonKey(name: 'hide_balances') bool hideBalances,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = freezed,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? language = null,Object? currency = null,Object? defaultBankId = freezed,Object? smsTrackingEnabled = null,Object? notificationsEnabled = null,Object? biometricLockEnabled = null,Object? hideBalances = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultBankId: freezed == defaultBankId ? _self.defaultBankId : defaultBankId // ignore: cast_nullable_to_non_nullable
as String?,smsTrackingEnabled: null == smsTrackingEnabled ? _self.smsTrackingEnabled : smsTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockEnabled: null == biometricLockEnabled ? _self.biometricLockEnabled : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,hideBalances: null == hideBalances ? _self.hideBalances : hideBalances // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName,  String? email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String language,  String currency, @JsonKey(name: 'default_bank_id')  String? defaultBankId, @JsonKey(name: 'sms_tracking_enabled')  bool smsTrackingEnabled, @JsonKey(name: 'notifications_enabled')  bool notificationsEnabled, @JsonKey(name: 'biometric_lock_enabled')  bool biometricLockEnabled, @JsonKey(name: 'hide_balances')  bool hideBalances, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.avatarUrl,_that.language,_that.currency,_that.defaultBankId,_that.smsTrackingEnabled,_that.notificationsEnabled,_that.biometricLockEnabled,_that.hideBalances,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName,  String? email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String language,  String currency, @JsonKey(name: 'default_bank_id')  String? defaultBankId, @JsonKey(name: 'sms_tracking_enabled')  bool smsTrackingEnabled, @JsonKey(name: 'notifications_enabled')  bool notificationsEnabled, @JsonKey(name: 'biometric_lock_enabled')  bool biometricLockEnabled, @JsonKey(name: 'hide_balances')  bool hideBalances, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.avatarUrl,_that.language,_that.currency,_that.defaultBankId,_that.smsTrackingEnabled,_that.notificationsEnabled,_that.biometricLockEnabled,_that.hideBalances,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String? fullName,  String? email,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String language,  String currency, @JsonKey(name: 'default_bank_id')  String? defaultBankId, @JsonKey(name: 'sms_tracking_enabled')  bool smsTrackingEnabled, @JsonKey(name: 'notifications_enabled')  bool notificationsEnabled, @JsonKey(name: 'biometric_lock_enabled')  bool biometricLockEnabled, @JsonKey(name: 'hide_balances')  bool hideBalances, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.avatarUrl,_that.language,_that.currency,_that.defaultBankId,_that.smsTrackingEnabled,_that.notificationsEnabled,_that.biometricLockEnabled,_that.hideBalances,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, @JsonKey(name: 'full_name') this.fullName, this.email, this.phone, @JsonKey(name: 'avatar_url') this.avatarUrl, this.language = 'ar', this.currency = 'EGP', @JsonKey(name: 'default_bank_id') this.defaultBankId, @JsonKey(name: 'sms_tracking_enabled') this.smsTrackingEnabled = false, @JsonKey(name: 'notifications_enabled') this.notificationsEnabled = true, @JsonKey(name: 'biometric_lock_enabled') this.biometricLockEnabled = false, @JsonKey(name: 'hide_balances') this.hideBalances = false, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey() final  String language;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'default_bank_id') final  String? defaultBankId;
@override@JsonKey(name: 'sms_tracking_enabled') final  bool smsTrackingEnabled;
@override@JsonKey(name: 'notifications_enabled') final  bool notificationsEnabled;
@override@JsonKey(name: 'biometric_lock_enabled') final  bool biometricLockEnabled;
@override@JsonKey(name: 'hide_balances') final  bool hideBalances;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.language, language) || other.language == language)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.defaultBankId, defaultBankId) || other.defaultBankId == defaultBankId)&&(identical(other.smsTrackingEnabled, smsTrackingEnabled) || other.smsTrackingEnabled == smsTrackingEnabled)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.biometricLockEnabled, biometricLockEnabled) || other.biometricLockEnabled == biometricLockEnabled)&&(identical(other.hideBalances, hideBalances) || other.hideBalances == hideBalances)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,email,phone,avatarUrl,language,currency,defaultBankId,smsTrackingEnabled,notificationsEnabled,biometricLockEnabled,hideBalances,createdAt,updatedAt);
}

@override
String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, phone: $phone, avatarUrl: $avatarUrl, language: $language, currency: $currency, defaultBankId: $defaultBankId, smsTrackingEnabled: $smsTrackingEnabled, notificationsEnabled: $notificationsEnabled, biometricLockEnabled: $biometricLockEnabled, hideBalances: $hideBalances, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName, String? email, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl, String language, String currency,@JsonKey(name: 'default_bank_id') String? defaultBankId,@JsonKey(name: 'sms_tracking_enabled') bool smsTrackingEnabled,@JsonKey(name: 'notifications_enabled') bool notificationsEnabled,@JsonKey(name: 'biometric_lock_enabled') bool biometricLockEnabled,@JsonKey(name: 'hide_balances') bool hideBalances,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = freezed,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? language = null,Object? currency = null,Object? defaultBankId = freezed,Object? smsTrackingEnabled = null,Object? notificationsEnabled = null,Object? biometricLockEnabled = null,Object? hideBalances = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultBankId: freezed == defaultBankId ? _self.defaultBankId : defaultBankId // ignore: cast_nullable_to_non_nullable
as String?,smsTrackingEnabled: null == smsTrackingEnabled ? _self.smsTrackingEnabled : smsTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockEnabled: null == biometricLockEnabled ? _self.biometricLockEnabled : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,hideBalances: null == hideBalances ? _self.hideBalances : hideBalances // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Bank {

 String get id; String get name;@JsonKey(name: 'name_ar') String? get nameAr; String? get code;@JsonKey(name: 'logo_url') String? get logoUrl; String get country; String get currency;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Bank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankCopyWith<Bank> get copyWith => _$BankCopyWithImpl<Bank>(this as Bank, _$identity);

  /// Serializes this Bank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Bank;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bank&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Bank;
  return Object.hash(runtimeType,_this.id,_this.name,_this.nameAr,_this.code,_this.logoUrl,_this.country,_this.currency,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Bank;
  return 'Bank(id: ${_this.id}, name: ${_this.name}, nameAr: ${_this.nameAr}, code: ${_this.code}, logoUrl: ${_this.logoUrl}, country: ${_this.country}, currency: ${_this.currency}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BankCopyWith<$Res>  {
  factory $BankCopyWith(Bank value, $Res Function(Bank) _then) = _$BankCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'name_ar') String? nameAr, String? code,@JsonKey(name: 'logo_url') String? logoUrl, String country, String currency,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$BankCopyWithImpl<$Res>
    implements $BankCopyWith<$Res> {
  _$BankCopyWithImpl(this._self, this._then);

  final Bank _self;
  final $Res Function(Bank) _then;

/// Create a copy of Bank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = freezed,Object? code = freezed,Object? logoUrl = freezed,Object? country = null,Object? currency = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Bank(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Bank].
extension BankPatterns on Bank {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bank() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bank value)  $default,){
final _that = this;
switch (_that) {
case _Bank():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bank value)?  $default,){
final _that = this;
switch (_that) {
case _Bank() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? code, @JsonKey(name: 'logo_url')  String? logoUrl,  String country,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bank() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.code,_that.logoUrl,_that.country,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? code, @JsonKey(name: 'logo_url')  String? logoUrl,  String country,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Bank():
return $default(_that.id,_that.name,_that.nameAr,_that.code,_that.logoUrl,_that.country,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? code, @JsonKey(name: 'logo_url')  String? logoUrl,  String country,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Bank() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.code,_that.logoUrl,_that.country,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bank implements Bank {
  const _Bank({required this.id, required this.name, @JsonKey(name: 'name_ar') this.nameAr, this.code, @JsonKey(name: 'logo_url') this.logoUrl, this.country = 'EG', this.currency = 'EGP', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String? nameAr;
@override final  String? code;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey() final  String country;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Bank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankCopyWith<_Bank> get copyWith => __$BankCopyWithImpl<_Bank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bank&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.code, code) || other.code == code)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,nameAr,code,logoUrl,country,currency,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'Bank(id: $id, name: $name, nameAr: $nameAr, code: $code, logoUrl: $logoUrl, country: $country, currency: $currency, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BankCopyWith<$Res> implements $BankCopyWith<$Res> {
  factory _$BankCopyWith(_Bank value, $Res Function(_Bank) _then) = __$BankCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'name_ar') String? nameAr, String? code,@JsonKey(name: 'logo_url') String? logoUrl, String country, String currency,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$BankCopyWithImpl<$Res>
    implements _$BankCopyWith<$Res> {
  __$BankCopyWithImpl(this._self, this._then);

  final _Bank _self;
  final $Res Function(_Bank) _then;

/// Create a copy of Bank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = freezed,Object? code = freezed,Object? logoUrl = freezed,Object? country = null,Object? currency = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Bank(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BankSMSPattern {

 String get id;@JsonKey(name: 'bank_id') String get bankId;@JsonKey(name: 'sender_pattern') String get senderPattern; List<dynamic> get purchasePatterns; List<dynamic> get atmPatterns; List<dynamic> get refundPatterns; List<dynamic> get incomePatterns; List<dynamic> get reversalPatterns;@JsonKey(name: 'amount_pattern') String? get amountPattern;@JsonKey(name: 'merchant_pattern') String? get merchantPattern;@JsonKey(name: 'card_pattern') String? get cardPattern;@JsonKey(name: 'date_pattern') String? get datePattern;@JsonKey(name: 'is_active') bool get isActive; int get version;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of BankSMSPattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSMSPatternCopyWith<BankSMSPattern> get copyWith => _$BankSMSPatternCopyWithImpl<BankSMSPattern>(this as BankSMSPattern, _$identity);

  /// Serializes this BankSMSPattern to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BankSMSPattern;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSMSPattern&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.bankId, _this.bankId) || other.bankId == _this.bankId)&&(identical(other.senderPattern, _this.senderPattern) || other.senderPattern == _this.senderPattern)&&const DeepCollectionEquality().equals(other.purchasePatterns, _this.purchasePatterns)&&const DeepCollectionEquality().equals(other.atmPatterns, _this.atmPatterns)&&const DeepCollectionEquality().equals(other.refundPatterns, _this.refundPatterns)&&const DeepCollectionEquality().equals(other.incomePatterns, _this.incomePatterns)&&const DeepCollectionEquality().equals(other.reversalPatterns, _this.reversalPatterns)&&(identical(other.amountPattern, _this.amountPattern) || other.amountPattern == _this.amountPattern)&&(identical(other.merchantPattern, _this.merchantPattern) || other.merchantPattern == _this.merchantPattern)&&(identical(other.cardPattern, _this.cardPattern) || other.cardPattern == _this.cardPattern)&&(identical(other.datePattern, _this.datePattern) || other.datePattern == _this.datePattern)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BankSMSPattern;
  return Object.hash(runtimeType,_this.id,_this.bankId,_this.senderPattern,const DeepCollectionEquality().hash(_this.purchasePatterns),const DeepCollectionEquality().hash(_this.atmPatterns),const DeepCollectionEquality().hash(_this.refundPatterns),const DeepCollectionEquality().hash(_this.incomePatterns),const DeepCollectionEquality().hash(_this.reversalPatterns),_this.amountPattern,_this.merchantPattern,_this.cardPattern,_this.datePattern,_this.isActive,_this.version,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as BankSMSPattern;
  return 'BankSMSPattern(id: ${_this.id}, bankId: ${_this.bankId}, senderPattern: ${_this.senderPattern}, purchasePatterns: ${_this.purchasePatterns}, atmPatterns: ${_this.atmPatterns}, refundPatterns: ${_this.refundPatterns}, incomePatterns: ${_this.incomePatterns}, reversalPatterns: ${_this.reversalPatterns}, amountPattern: ${_this.amountPattern}, merchantPattern: ${_this.merchantPattern}, cardPattern: ${_this.cardPattern}, datePattern: ${_this.datePattern}, isActive: ${_this.isActive}, version: ${_this.version}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BankSMSPatternCopyWith<$Res>  {
  factory $BankSMSPatternCopyWith(BankSMSPattern value, $Res Function(BankSMSPattern) _then) = _$BankSMSPatternCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'bank_id') String bankId,@JsonKey(name: 'sender_pattern') String senderPattern, List<dynamic> purchasePatterns, List<dynamic> atmPatterns, List<dynamic> refundPatterns, List<dynamic> incomePatterns, List<dynamic> reversalPatterns,@JsonKey(name: 'amount_pattern') String? amountPattern,@JsonKey(name: 'merchant_pattern') String? merchantPattern,@JsonKey(name: 'card_pattern') String? cardPattern,@JsonKey(name: 'date_pattern') String? datePattern,@JsonKey(name: 'is_active') bool isActive, int version,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$BankSMSPatternCopyWithImpl<$Res>
    implements $BankSMSPatternCopyWith<$Res> {
  _$BankSMSPatternCopyWithImpl(this._self, this._then);

  final BankSMSPattern _self;
  final $Res Function(BankSMSPattern) _then;

/// Create a copy of BankSMSPattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bankId = null,Object? senderPattern = null,Object? purchasePatterns = null,Object? atmPatterns = null,Object? refundPatterns = null,Object? incomePatterns = null,Object? reversalPatterns = null,Object? amountPattern = freezed,Object? merchantPattern = freezed,Object? cardPattern = freezed,Object? datePattern = freezed,Object? isActive = null,Object? version = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(BankSMSPattern(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,senderPattern: null == senderPattern ? _self.senderPattern : senderPattern // ignore: cast_nullable_to_non_nullable
as String,purchasePatterns: null == purchasePatterns ? _self.purchasePatterns : purchasePatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,atmPatterns: null == atmPatterns ? _self.atmPatterns : atmPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,refundPatterns: null == refundPatterns ? _self.refundPatterns : refundPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,incomePatterns: null == incomePatterns ? _self.incomePatterns : incomePatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,reversalPatterns: null == reversalPatterns ? _self.reversalPatterns : reversalPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,amountPattern: freezed == amountPattern ? _self.amountPattern : amountPattern // ignore: cast_nullable_to_non_nullable
as String?,merchantPattern: freezed == merchantPattern ? _self.merchantPattern : merchantPattern // ignore: cast_nullable_to_non_nullable
as String?,cardPattern: freezed == cardPattern ? _self.cardPattern : cardPattern // ignore: cast_nullable_to_non_nullable
as String?,datePattern: freezed == datePattern ? _self.datePattern : datePattern // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BankSMSPattern].
extension BankSMSPatternPatterns on BankSMSPattern {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSMSPattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSMSPattern() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSMSPattern value)  $default,){
final _that = this;
switch (_that) {
case _BankSMSPattern():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSMSPattern value)?  $default,){
final _that = this;
switch (_that) {
case _BankSMSPattern() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'bank_id')  String bankId, @JsonKey(name: 'sender_pattern')  String senderPattern,  List<dynamic> purchasePatterns,  List<dynamic> atmPatterns,  List<dynamic> refundPatterns,  List<dynamic> incomePatterns,  List<dynamic> reversalPatterns, @JsonKey(name: 'amount_pattern')  String? amountPattern, @JsonKey(name: 'merchant_pattern')  String? merchantPattern, @JsonKey(name: 'card_pattern')  String? cardPattern, @JsonKey(name: 'date_pattern')  String? datePattern, @JsonKey(name: 'is_active')  bool isActive,  int version, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSMSPattern() when $default != null:
return $default(_that.id,_that.bankId,_that.senderPattern,_that.purchasePatterns,_that.atmPatterns,_that.refundPatterns,_that.incomePatterns,_that.reversalPatterns,_that.amountPattern,_that.merchantPattern,_that.cardPattern,_that.datePattern,_that.isActive,_that.version,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'bank_id')  String bankId, @JsonKey(name: 'sender_pattern')  String senderPattern,  List<dynamic> purchasePatterns,  List<dynamic> atmPatterns,  List<dynamic> refundPatterns,  List<dynamic> incomePatterns,  List<dynamic> reversalPatterns, @JsonKey(name: 'amount_pattern')  String? amountPattern, @JsonKey(name: 'merchant_pattern')  String? merchantPattern, @JsonKey(name: 'card_pattern')  String? cardPattern, @JsonKey(name: 'date_pattern')  String? datePattern, @JsonKey(name: 'is_active')  bool isActive,  int version, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BankSMSPattern():
return $default(_that.id,_that.bankId,_that.senderPattern,_that.purchasePatterns,_that.atmPatterns,_that.refundPatterns,_that.incomePatterns,_that.reversalPatterns,_that.amountPattern,_that.merchantPattern,_that.cardPattern,_that.datePattern,_that.isActive,_that.version,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'bank_id')  String bankId, @JsonKey(name: 'sender_pattern')  String senderPattern,  List<dynamic> purchasePatterns,  List<dynamic> atmPatterns,  List<dynamic> refundPatterns,  List<dynamic> incomePatterns,  List<dynamic> reversalPatterns, @JsonKey(name: 'amount_pattern')  String? amountPattern, @JsonKey(name: 'merchant_pattern')  String? merchantPattern, @JsonKey(name: 'card_pattern')  String? cardPattern, @JsonKey(name: 'date_pattern')  String? datePattern, @JsonKey(name: 'is_active')  bool isActive,  int version, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BankSMSPattern() when $default != null:
return $default(_that.id,_that.bankId,_that.senderPattern,_that.purchasePatterns,_that.atmPatterns,_that.refundPatterns,_that.incomePatterns,_that.reversalPatterns,_that.amountPattern,_that.merchantPattern,_that.cardPattern,_that.datePattern,_that.isActive,_that.version,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSMSPattern implements BankSMSPattern {
  const _BankSMSPattern({required this.id, @JsonKey(name: 'bank_id') required this.bankId, @JsonKey(name: 'sender_pattern') required this.senderPattern,  List<dynamic> purchasePatterns = const [],  List<dynamic> atmPatterns = const [],  List<dynamic> refundPatterns = const [],  List<dynamic> incomePatterns = const [],  List<dynamic> reversalPatterns = const [], @JsonKey(name: 'amount_pattern') this.amountPattern, @JsonKey(name: 'merchant_pattern') this.merchantPattern, @JsonKey(name: 'card_pattern') this.cardPattern, @JsonKey(name: 'date_pattern') this.datePattern, @JsonKey(name: 'is_active') this.isActive = true, this.version = 1, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt}): _purchasePatterns = purchasePatterns,_atmPatterns = atmPatterns,_refundPatterns = refundPatterns,_incomePatterns = incomePatterns,_reversalPatterns = reversalPatterns;
  factory _BankSMSPattern.fromJson(Map<String, dynamic> json) => _$BankSMSPatternFromJson(json);

@override final  String id;
@override@JsonKey(name: 'bank_id') final  String bankId;
@override@JsonKey(name: 'sender_pattern') final  String senderPattern;
 final  List<dynamic> _purchasePatterns;
@override@JsonKey() List<dynamic> get purchasePatterns {
  if (_purchasePatterns is EqualUnmodifiableListView) return _purchasePatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purchasePatterns);
}

 final  List<dynamic> _atmPatterns;
@override@JsonKey() List<dynamic> get atmPatterns {
  if (_atmPatterns is EqualUnmodifiableListView) return _atmPatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_atmPatterns);
}

 final  List<dynamic> _refundPatterns;
@override@JsonKey() List<dynamic> get refundPatterns {
  if (_refundPatterns is EqualUnmodifiableListView) return _refundPatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_refundPatterns);
}

 final  List<dynamic> _incomePatterns;
@override@JsonKey() List<dynamic> get incomePatterns {
  if (_incomePatterns is EqualUnmodifiableListView) return _incomePatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomePatterns);
}

 final  List<dynamic> _reversalPatterns;
@override@JsonKey() List<dynamic> get reversalPatterns {
  if (_reversalPatterns is EqualUnmodifiableListView) return _reversalPatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reversalPatterns);
}

@override@JsonKey(name: 'amount_pattern') final  String? amountPattern;
@override@JsonKey(name: 'merchant_pattern') final  String? merchantPattern;
@override@JsonKey(name: 'card_pattern') final  String? cardPattern;
@override@JsonKey(name: 'date_pattern') final  String? datePattern;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey() final  int version;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of BankSMSPattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSMSPatternCopyWith<_BankSMSPattern> get copyWith => __$BankSMSPatternCopyWithImpl<_BankSMSPattern>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSMSPatternToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSMSPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.senderPattern, senderPattern) || other.senderPattern == senderPattern)&&const DeepCollectionEquality().equals(other.purchasePatterns, _purchasePatterns)&&const DeepCollectionEquality().equals(other.atmPatterns, _atmPatterns)&&const DeepCollectionEquality().equals(other.refundPatterns, _refundPatterns)&&const DeepCollectionEquality().equals(other.incomePatterns, _incomePatterns)&&const DeepCollectionEquality().equals(other.reversalPatterns, _reversalPatterns)&&(identical(other.amountPattern, amountPattern) || other.amountPattern == amountPattern)&&(identical(other.merchantPattern, merchantPattern) || other.merchantPattern == merchantPattern)&&(identical(other.cardPattern, cardPattern) || other.cardPattern == cardPattern)&&(identical(other.datePattern, datePattern) || other.datePattern == datePattern)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,bankId,senderPattern,const DeepCollectionEquality().hash(_purchasePatterns),const DeepCollectionEquality().hash(_atmPatterns),const DeepCollectionEquality().hash(_refundPatterns),const DeepCollectionEquality().hash(_incomePatterns),const DeepCollectionEquality().hash(_reversalPatterns),amountPattern,merchantPattern,cardPattern,datePattern,isActive,version,createdAt,updatedAt);
}

@override
String toString() {
    return 'BankSMSPattern(id: $id, bankId: $bankId, senderPattern: $senderPattern, purchasePatterns: $purchasePatterns, atmPatterns: $atmPatterns, refundPatterns: $refundPatterns, incomePatterns: $incomePatterns, reversalPatterns: $reversalPatterns, amountPattern: $amountPattern, merchantPattern: $merchantPattern, cardPattern: $cardPattern, datePattern: $datePattern, isActive: $isActive, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BankSMSPatternCopyWith<$Res> implements $BankSMSPatternCopyWith<$Res> {
  factory _$BankSMSPatternCopyWith(_BankSMSPattern value, $Res Function(_BankSMSPattern) _then) = __$BankSMSPatternCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'bank_id') String bankId,@JsonKey(name: 'sender_pattern') String senderPattern, List<dynamic> purchasePatterns, List<dynamic> atmPatterns, List<dynamic> refundPatterns, List<dynamic> incomePatterns, List<dynamic> reversalPatterns,@JsonKey(name: 'amount_pattern') String? amountPattern,@JsonKey(name: 'merchant_pattern') String? merchantPattern,@JsonKey(name: 'card_pattern') String? cardPattern,@JsonKey(name: 'date_pattern') String? datePattern,@JsonKey(name: 'is_active') bool isActive, int version,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$BankSMSPatternCopyWithImpl<$Res>
    implements _$BankSMSPatternCopyWith<$Res> {
  __$BankSMSPatternCopyWithImpl(this._self, this._then);

  final _BankSMSPattern _self;
  final $Res Function(_BankSMSPattern) _then;

/// Create a copy of BankSMSPattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankId = null,Object? senderPattern = null,Object? purchasePatterns = null,Object? atmPatterns = null,Object? refundPatterns = null,Object? incomePatterns = null,Object? reversalPatterns = null,Object? amountPattern = freezed,Object? merchantPattern = freezed,Object? cardPattern = freezed,Object? datePattern = freezed,Object? isActive = null,Object? version = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BankSMSPattern(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankId: null == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String,senderPattern: null == senderPattern ? _self.senderPattern : senderPattern // ignore: cast_nullable_to_non_nullable
as String,purchasePatterns: null == purchasePatterns ? _self._purchasePatterns : purchasePatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,atmPatterns: null == atmPatterns ? _self._atmPatterns : atmPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,refundPatterns: null == refundPatterns ? _self._refundPatterns : refundPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,incomePatterns: null == incomePatterns ? _self._incomePatterns : incomePatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,reversalPatterns: null == reversalPatterns ? _self._reversalPatterns : reversalPatterns // ignore: cast_nullable_to_non_nullable
as List<dynamic>,amountPattern: freezed == amountPattern ? _self.amountPattern : amountPattern // ignore: cast_nullable_to_non_nullable
as String?,merchantPattern: freezed == merchantPattern ? _self.merchantPattern : merchantPattern // ignore: cast_nullable_to_non_nullable
as String?,cardPattern: freezed == cardPattern ? _self.cardPattern : cardPattern // ignore: cast_nullable_to_non_nullable
as String?,datePattern: freezed == datePattern ? _self.datePattern : datePattern // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
