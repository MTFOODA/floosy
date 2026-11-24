// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyIncome {

 String get id;@JsonKey(name: 'user_id') String get userId; int get year; int get month; String? get label;@JsonKey(name: 'amount_minor') int get amountMinor; String get currency;@JsonKey(name: 'bank_account_id') String? get bankAccountId;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of MonthlyIncome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyIncomeCopyWith<MonthlyIncome> get copyWith => _$MonthlyIncomeCopyWithImpl<MonthlyIncome>(this as MonthlyIncome, _$identity);

  /// Serializes this MonthlyIncome to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyIncome;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyIncome&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.bankAccountId, _this.bankAccountId) || other.bankAccountId == _this.bankAccountId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyIncome;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.year,_this.month,_this.label,_this.amountMinor,_this.currency,_this.bankAccountId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MonthlyIncome;
  return 'MonthlyIncome(id: ${_this.id}, userId: ${_this.userId}, year: ${_this.year}, month: ${_this.month}, label: ${_this.label}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, bankAccountId: ${_this.bankAccountId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MonthlyIncomeCopyWith<$Res>  {
  factory $MonthlyIncomeCopyWith(MonthlyIncome value, $Res Function(MonthlyIncome) _then) = _$MonthlyIncomeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, int year, int month, String? label,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'bank_account_id') String? bankAccountId,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$MonthlyIncomeCopyWithImpl<$Res>
    implements $MonthlyIncomeCopyWith<$Res> {
  _$MonthlyIncomeCopyWithImpl(this._self, this._then);

  final MonthlyIncome _self;
  final $Res Function(MonthlyIncome) _then;

/// Create a copy of MonthlyIncome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? month = null,Object? label = freezed,Object? amountMinor = null,Object? currency = null,Object? bankAccountId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(MonthlyIncome(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,bankAccountId: freezed == bankAccountId ? _self.bankAccountId : bankAccountId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyIncome].
extension MonthlyIncomePatterns on MonthlyIncome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyIncome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyIncome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyIncome value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyIncome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyIncome value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyIncome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month,  String? label, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'bank_account_id')  String? bankAccountId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyIncome() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.month,_that.label,_that.amountMinor,_that.currency,_that.bankAccountId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month,  String? label, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'bank_account_id')  String? bankAccountId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MonthlyIncome():
return $default(_that.id,_that.userId,_that.year,_that.month,_that.label,_that.amountMinor,_that.currency,_that.bankAccountId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month,  String? label, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'bank_account_id')  String? bankAccountId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyIncome() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.month,_that.label,_that.amountMinor,_that.currency,_that.bankAccountId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyIncome implements MonthlyIncome {
  const _MonthlyIncome({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.year, required this.month, this.label, @JsonKey(name: 'amount_minor') required this.amountMinor, this.currency = 'EGP', @JsonKey(name: 'bank_account_id') this.bankAccountId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _MonthlyIncome.fromJson(Map<String, dynamic> json) => _$MonthlyIncomeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  int year;
@override final  int month;
@override final  String? label;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'bank_account_id') final  String? bankAccountId;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of MonthlyIncome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyIncomeCopyWith<_MonthlyIncome> get copyWith => __$MonthlyIncomeCopyWithImpl<_MonthlyIncome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyIncomeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyIncome&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.bankAccountId, bankAccountId) || other.bankAccountId == bankAccountId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,year,month,label,amountMinor,currency,bankAccountId,createdAt,updatedAt);
}

@override
String toString() {
    return 'MonthlyIncome(id: $id, userId: $userId, year: $year, month: $month, label: $label, amountMinor: $amountMinor, currency: $currency, bankAccountId: $bankAccountId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MonthlyIncomeCopyWith<$Res> implements $MonthlyIncomeCopyWith<$Res> {
  factory _$MonthlyIncomeCopyWith(_MonthlyIncome value, $Res Function(_MonthlyIncome) _then) = __$MonthlyIncomeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, int year, int month, String? label,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'bank_account_id') String? bankAccountId,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$MonthlyIncomeCopyWithImpl<$Res>
    implements _$MonthlyIncomeCopyWith<$Res> {
  __$MonthlyIncomeCopyWithImpl(this._self, this._then);

  final _MonthlyIncome _self;
  final $Res Function(_MonthlyIncome) _then;

/// Create a copy of MonthlyIncome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? month = null,Object? label = freezed,Object? amountMinor = null,Object? currency = null,Object? bankAccountId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MonthlyIncome(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,bankAccountId: freezed == bankAccountId ? _self.bankAccountId : bankAccountId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UserBankAccount {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'bank_id') String? get bankId;@JsonKey(name: 'account_last4') String? get accountLast4;@JsonKey(name: 'opening_balance_minor') int get openingBalanceMinor; String get currency;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of UserBankAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserBankAccountCopyWith<UserBankAccount> get copyWith => _$UserBankAccountCopyWithImpl<UserBankAccount>(this as UserBankAccount, _$identity);

  /// Serializes this UserBankAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserBankAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserBankAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.bankId, _this.bankId) || other.bankId == _this.bankId)&&(identical(other.accountLast4, _this.accountLast4) || other.accountLast4 == _this.accountLast4)&&(identical(other.openingBalanceMinor, _this.openingBalanceMinor) || other.openingBalanceMinor == _this.openingBalanceMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserBankAccount;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.bankId,_this.accountLast4,_this.openingBalanceMinor,_this.currency,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserBankAccount;
  return 'UserBankAccount(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, bankId: ${_this.bankId}, accountLast4: ${_this.accountLast4}, openingBalanceMinor: ${_this.openingBalanceMinor}, currency: ${_this.currency}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserBankAccountCopyWith<$Res>  {
  factory $UserBankAccountCopyWith(UserBankAccount value, $Res Function(UserBankAccount) _then) = _$UserBankAccountCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'bank_id') String? bankId,@JsonKey(name: 'account_last4') String? accountLast4,@JsonKey(name: 'opening_balance_minor') int openingBalanceMinor, String currency,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$UserBankAccountCopyWithImpl<$Res>
    implements $UserBankAccountCopyWith<$Res> {
  _$UserBankAccountCopyWithImpl(this._self, this._then);

  final UserBankAccount _self;
  final $Res Function(UserBankAccount) _then;

/// Create a copy of UserBankAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? bankId = freezed,Object? accountLast4 = freezed,Object? openingBalanceMinor = null,Object? currency = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(UserBankAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bankId: freezed == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String?,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,openingBalanceMinor: null == openingBalanceMinor ? _self.openingBalanceMinor : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserBankAccount].
extension UserBankAccountPatterns on UserBankAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserBankAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserBankAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserBankAccount value)  $default,){
final _that = this;
switch (_that) {
case _UserBankAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserBankAccount value)?  $default,){
final _that = this;
switch (_that) {
case _UserBankAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'account_last4')  String? accountLast4, @JsonKey(name: 'opening_balance_minor')  int openingBalanceMinor,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserBankAccount() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.bankId,_that.accountLast4,_that.openingBalanceMinor,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'account_last4')  String? accountLast4, @JsonKey(name: 'opening_balance_minor')  int openingBalanceMinor,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserBankAccount():
return $default(_that.id,_that.userId,_that.name,_that.bankId,_that.accountLast4,_that.openingBalanceMinor,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'account_last4')  String? accountLast4, @JsonKey(name: 'opening_balance_minor')  int openingBalanceMinor,  String currency, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserBankAccount() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.bankId,_that.accountLast4,_that.openingBalanceMinor,_that.currency,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserBankAccount implements UserBankAccount {
  const _UserBankAccount({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'bank_id') this.bankId, @JsonKey(name: 'account_last4') this.accountLast4, @JsonKey(name: 'opening_balance_minor') this.openingBalanceMinor = 0, this.currency = 'EGP', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _UserBankAccount.fromJson(Map<String, dynamic> json) => _$UserBankAccountFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'bank_id') final  String? bankId;
@override@JsonKey(name: 'account_last4') final  String? accountLast4;
@override@JsonKey(name: 'opening_balance_minor') final  int openingBalanceMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of UserBankAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserBankAccountCopyWith<_UserBankAccount> get copyWith => __$UserBankAccountCopyWithImpl<_UserBankAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserBankAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserBankAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.accountLast4, accountLast4) || other.accountLast4 == accountLast4)&&(identical(other.openingBalanceMinor, openingBalanceMinor) || other.openingBalanceMinor == openingBalanceMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,bankId,accountLast4,openingBalanceMinor,currency,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'UserBankAccount(id: $id, userId: $userId, name: $name, bankId: $bankId, accountLast4: $accountLast4, openingBalanceMinor: $openingBalanceMinor, currency: $currency, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserBankAccountCopyWith<$Res> implements $UserBankAccountCopyWith<$Res> {
  factory _$UserBankAccountCopyWith(_UserBankAccount value, $Res Function(_UserBankAccount) _then) = __$UserBankAccountCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'bank_id') String? bankId,@JsonKey(name: 'account_last4') String? accountLast4,@JsonKey(name: 'opening_balance_minor') int openingBalanceMinor, String currency,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$UserBankAccountCopyWithImpl<$Res>
    implements _$UserBankAccountCopyWith<$Res> {
  __$UserBankAccountCopyWithImpl(this._self, this._then);

  final _UserBankAccount _self;
  final $Res Function(_UserBankAccount) _then;

/// Create a copy of UserBankAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? bankId = freezed,Object? accountLast4 = freezed,Object? openingBalanceMinor = null,Object? currency = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserBankAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bankId: freezed == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String?,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,openingBalanceMinor: null == openingBalanceMinor ? _self.openingBalanceMinor : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BankAccountMovement {

 String get id;@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'user_id') String get userId; String get type;@JsonKey(name: 'amount_minor') int get amountMinor; String? get description;@JsonKey(name: 'reference_type') String? get referenceType;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime get movementDate;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of BankAccountMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankAccountMovementCopyWith<BankAccountMovement> get copyWith => _$BankAccountMovementCopyWithImpl<BankAccountMovement>(this as BankAccountMovement, _$identity);

  /// Serializes this BankAccountMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BankAccountMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankAccountMovement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.referenceId, _this.referenceId) || other.referenceId == _this.referenceId)&&(identical(other.movementDate, _this.movementDate) || other.movementDate == _this.movementDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BankAccountMovement;
  return Object.hash(runtimeType,_this.id,_this.accountId,_this.userId,_this.type,_this.amountMinor,_this.description,_this.referenceType,_this.referenceId,_this.movementDate,_this.createdAt);
}

@override
String toString() {
  final _this = this as BankAccountMovement;
  return 'BankAccountMovement(id: ${_this.id}, accountId: ${_this.accountId}, userId: ${_this.userId}, type: ${_this.type}, amountMinor: ${_this.amountMinor}, description: ${_this.description}, referenceType: ${_this.referenceType}, referenceId: ${_this.referenceId}, movementDate: ${_this.movementDate}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BankAccountMovementCopyWith<$Res>  {
  factory $BankAccountMovementCopyWith(BankAccountMovement value, $Res Function(BankAccountMovement) _then) = _$BankAccountMovementCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'user_id') String userId, String type,@JsonKey(name: 'amount_minor') int amountMinor, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime movementDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$BankAccountMovementCopyWithImpl<$Res>
    implements $BankAccountMovementCopyWith<$Res> {
  _$BankAccountMovementCopyWithImpl(this._self, this._then);

  final BankAccountMovement _self;
  final $Res Function(BankAccountMovement) _then;

/// Create a copy of BankAccountMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? userId = null,Object? type = null,Object? amountMinor = null,Object? description = freezed,Object? referenceType = freezed,Object? referenceId = freezed,Object? movementDate = null,Object? createdAt = freezed,}) {
  return _then(BankAccountMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BankAccountMovement].
extension BankAccountMovementPatterns on BankAccountMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankAccountMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankAccountMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankAccountMovement value)  $default,){
final _that = this;
switch (_that) {
case _BankAccountMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankAccountMovement value)?  $default,){
final _that = this;
switch (_that) {
case _BankAccountMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'user_id')  String userId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankAccountMovement() when $default != null:
return $default(_that.id,_that.accountId,_that.userId,_that.type,_that.amountMinor,_that.description,_that.referenceType,_that.referenceId,_that.movementDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'user_id')  String userId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BankAccountMovement():
return $default(_that.id,_that.accountId,_that.userId,_that.type,_that.amountMinor,_that.description,_that.referenceType,_that.referenceId,_that.movementDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'user_id')  String userId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BankAccountMovement() when $default != null:
return $default(_that.id,_that.accountId,_that.userId,_that.type,_that.amountMinor,_that.description,_that.referenceType,_that.referenceId,_that.movementDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankAccountMovement implements BankAccountMovement {
  const _BankAccountMovement({required this.id, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'user_id') required this.userId, required this.type, @JsonKey(name: 'amount_minor') required this.amountMinor, this.description, @JsonKey(name: 'reference_type') this.referenceType, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) required this.movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _BankAccountMovement.fromJson(Map<String, dynamic> json) => _$BankAccountMovementFromJson(json);

@override final  String id;
@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String type;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override final  String? description;
@override@JsonKey(name: 'reference_type') final  String? referenceType;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) final  DateTime movementDate;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of BankAccountMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankAccountMovementCopyWith<_BankAccountMovement> get copyWith => __$BankAccountMovementCopyWithImpl<_BankAccountMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankAccountMovementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankAccountMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.description, description) || other.description == description)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.movementDate, movementDate) || other.movementDate == movementDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,accountId,userId,type,amountMinor,description,referenceType,referenceId,movementDate,createdAt);
}

@override
String toString() {
    return 'BankAccountMovement(id: $id, accountId: $accountId, userId: $userId, type: $type, amountMinor: $amountMinor, description: $description, referenceType: $referenceType, referenceId: $referenceId, movementDate: $movementDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BankAccountMovementCopyWith<$Res> implements $BankAccountMovementCopyWith<$Res> {
  factory _$BankAccountMovementCopyWith(_BankAccountMovement value, $Res Function(_BankAccountMovement) _then) = __$BankAccountMovementCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'user_id') String userId, String type,@JsonKey(name: 'amount_minor') int amountMinor, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime movementDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$BankAccountMovementCopyWithImpl<$Res>
    implements _$BankAccountMovementCopyWith<$Res> {
  __$BankAccountMovementCopyWithImpl(this._self, this._then);

  final _BankAccountMovement _self;
  final $Res Function(_BankAccountMovement) _then;

/// Create a copy of BankAccountMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? userId = null,Object? type = null,Object? amountMinor = null,Object? description = freezed,Object? referenceType = freezed,Object? referenceId = freezed,Object? movementDate = null,Object? createdAt = freezed,}) {
  return _then(_BankAccountMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
