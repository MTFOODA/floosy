// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyIncome _$MonthlyIncomeFromJson(Map<String, dynamic> json) {
  return _MonthlyIncome.fromJson(json);
}

/// @nodoc
mixin _$MonthlyIncome {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account_id')
  String? get bankAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MonthlyIncome to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyIncomeCopyWith<MonthlyIncome> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyIncomeCopyWith<$Res> {
  factory $MonthlyIncomeCopyWith(
          MonthlyIncome value, $Res Function(MonthlyIncome) then) =
      _$MonthlyIncomeCopyWithImpl<$Res, MonthlyIncome>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int year,
      int month,
      String? label,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'bank_account_id') String? bankAccountId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$MonthlyIncomeCopyWithImpl<$Res, $Val extends MonthlyIncome>
    implements $MonthlyIncomeCopyWith<$Res> {
  _$MonthlyIncomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? year = null,
    Object? month = null,
    Object? label = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? bankAccountId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountId: freezed == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$MonthlyIncomeImplCopyWith<$Res>
    implements $MonthlyIncomeCopyWith<$Res> {
  factory _$$MonthlyIncomeImplCopyWith(
          _$MonthlyIncomeImpl value, $Res Function(_$MonthlyIncomeImpl) then) =
      __$$MonthlyIncomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int year,
      int month,
      String? label,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'bank_account_id') String? bankAccountId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$MonthlyIncomeImplCopyWithImpl<$Res>
    extends _$MonthlyIncomeCopyWithImpl<$Res, _$MonthlyIncomeImpl>
    implements _$$MonthlyIncomeImplCopyWith<$Res> {
  __$$MonthlyIncomeImplCopyWithImpl(
      _$MonthlyIncomeImpl _value, $Res Function(_$MonthlyIncomeImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? year = null,
    Object? month = null,
    Object? label = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? bankAccountId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MonthlyIncomeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountId: freezed == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$MonthlyIncomeImpl implements _MonthlyIncome {
  const _$MonthlyIncomeImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.year,
      required this.month,
      this.label,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.currency = 'EGP',
      @JsonKey(name: 'bank_account_id') this.bankAccountId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$MonthlyIncomeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyIncomeImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final int year;
  @override
  final int month;
  @override
  final String? label;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'bank_account_id')
  final String? bankAccountId;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MonthlyIncome(id: $id, userId: $userId, year: $year, month: $month, label: $label, amountMinor: $amountMinor, currency: $currency, bankAccountId: $bankAccountId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyIncomeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bankAccountId, bankAccountId) ||
                other.bankAccountId == bankAccountId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, year, month, label,
      amountMinor, currency, bankAccountId, createdAt, updatedAt);

  /// Create a copy of MonthlyIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyIncomeImplCopyWith<_$MonthlyIncomeImpl> get copyWith =>
      __$$MonthlyIncomeImplCopyWithImpl<_$MonthlyIncomeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyIncomeImplToJson(
      this,
    );
  }
}

abstract class _MonthlyIncome implements MonthlyIncome {
  const factory _MonthlyIncome(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final int year,
      required final int month,
      final String? label,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String currency,
      @JsonKey(name: 'bank_account_id') final String? bankAccountId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$MonthlyIncomeImpl;

  factory _MonthlyIncome.fromJson(Map<String, dynamic> json) =
      _$MonthlyIncomeImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  int get year;
  @override
  int get month;
  @override
  String? get label;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'bank_account_id')
  String? get bankAccountId;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of MonthlyIncome
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyIncomeImplCopyWith<_$MonthlyIncomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBankAccount _$UserBankAccountFromJson(Map<String, dynamic> json) {
  return _UserBankAccount.fromJson(json);
}

/// @nodoc
mixin _$UserBankAccount {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_id')
  String? get bankId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_last4')
  String? get accountLast4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_balance_minor')
  int get openingBalanceMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserBankAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBankAccountCopyWith<UserBankAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBankAccountCopyWith<$Res> {
  factory $UserBankAccountCopyWith(
          UserBankAccount value, $Res Function(UserBankAccount) then) =
      _$UserBankAccountCopyWithImpl<$Res, UserBankAccount>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'bank_id') String? bankId,
      @JsonKey(name: 'account_last4') String? accountLast4,
      @JsonKey(name: 'opening_balance_minor') int openingBalanceMinor,
      String currency,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$UserBankAccountCopyWithImpl<$Res, $Val extends UserBankAccount>
    implements $UserBankAccountCopyWith<$Res> {
  _$UserBankAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? bankId = freezed,
    Object? accountLast4 = freezed,
    Object? openingBalanceMinor = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountLast4: freezed == accountLast4
          ? _value.accountLast4
          : accountLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      openingBalanceMinor: null == openingBalanceMinor
          ? _value.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$UserBankAccountImplCopyWith<$Res>
    implements $UserBankAccountCopyWith<$Res> {
  factory _$$UserBankAccountImplCopyWith(_$UserBankAccountImpl value,
          $Res Function(_$UserBankAccountImpl) then) =
      __$$UserBankAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'bank_id') String? bankId,
      @JsonKey(name: 'account_last4') String? accountLast4,
      @JsonKey(name: 'opening_balance_minor') int openingBalanceMinor,
      String currency,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserBankAccountImplCopyWithImpl<$Res>
    extends _$UserBankAccountCopyWithImpl<$Res, _$UserBankAccountImpl>
    implements _$$UserBankAccountImplCopyWith<$Res> {
  __$$UserBankAccountImplCopyWithImpl(
      _$UserBankAccountImpl _value, $Res Function(_$UserBankAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? bankId = freezed,
    Object? accountLast4 = freezed,
    Object? openingBalanceMinor = null,
    Object? currency = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserBankAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountLast4: freezed == accountLast4
          ? _value.accountLast4
          : accountLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      openingBalanceMinor: null == openingBalanceMinor
          ? _value.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$UserBankAccountImpl implements _UserBankAccount {
  const _$UserBankAccountImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'bank_id') this.bankId,
      @JsonKey(name: 'account_last4') this.accountLast4,
      @JsonKey(name: 'opening_balance_minor') this.openingBalanceMinor = 0,
      this.currency = 'EGP',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$UserBankAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBankAccountImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'bank_id')
  final String? bankId;
  @override
  @JsonKey(name: 'account_last4')
  final String? accountLast4;
  @override
  @JsonKey(name: 'opening_balance_minor')
  final int openingBalanceMinor;
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
    return 'UserBankAccount(id: $id, userId: $userId, name: $name, bankId: $bankId, accountLast4: $accountLast4, openingBalanceMinor: $openingBalanceMinor, currency: $currency, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBankAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.accountLast4, accountLast4) ||
                other.accountLast4 == accountLast4) &&
            (identical(other.openingBalanceMinor, openingBalanceMinor) ||
                other.openingBalanceMinor == openingBalanceMinor) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      bankId,
      accountLast4,
      openingBalanceMinor,
      currency,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBankAccountImplCopyWith<_$UserBankAccountImpl> get copyWith =>
      __$$UserBankAccountImplCopyWithImpl<_$UserBankAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBankAccountImplToJson(
      this,
    );
  }
}

abstract class _UserBankAccount implements UserBankAccount {
  const factory _UserBankAccount(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'bank_id') final String? bankId,
      @JsonKey(name: 'account_last4') final String? accountLast4,
      @JsonKey(name: 'opening_balance_minor') final int openingBalanceMinor,
      final String currency,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$UserBankAccountImpl;

  factory _UserBankAccount.fromJson(Map<String, dynamic> json) =
      _$UserBankAccountImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'bank_id')
  String? get bankId;
  @override
  @JsonKey(name: 'account_last4')
  String? get accountLast4;
  @override
  @JsonKey(name: 'opening_balance_minor')
  int get openingBalanceMinor;
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

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBankAccountImplCopyWith<_$UserBankAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BankAccountMovement _$BankAccountMovementFromJson(Map<String, dynamic> json) {
  return _BankAccountMovement.fromJson(json);
}

/// @nodoc
mixin _$BankAccountMovement {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'in' | 'out'
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String? get referenceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get movementDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BankAccountMovement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankAccountMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankAccountMovementCopyWith<BankAccountMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankAccountMovementCopyWith<$Res> {
  factory $BankAccountMovementCopyWith(
          BankAccountMovement value, $Res Function(BankAccountMovement) then) =
      _$BankAccountMovementCopyWithImpl<$Res, BankAccountMovement>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'user_id') String userId,
      String type,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String? description,
      @JsonKey(name: 'reference_type') String? referenceType,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$BankAccountMovementCopyWithImpl<$Res, $Val extends BankAccountMovement>
    implements $BankAccountMovementCopyWith<$Res> {
  _$BankAccountMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankAccountMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? userId = null,
    Object? type = null,
    Object? amountMinor = null,
    Object? description = freezed,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? movementDate = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      movementDate: null == movementDate
          ? _value.movementDate
          : movementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankAccountMovementImplCopyWith<$Res>
    implements $BankAccountMovementCopyWith<$Res> {
  factory _$$BankAccountMovementImplCopyWith(_$BankAccountMovementImpl value,
          $Res Function(_$BankAccountMovementImpl) then) =
      __$$BankAccountMovementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'user_id') String userId,
      String type,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String? description,
      @JsonKey(name: 'reference_type') String? referenceType,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$BankAccountMovementImplCopyWithImpl<$Res>
    extends _$BankAccountMovementCopyWithImpl<$Res, _$BankAccountMovementImpl>
    implements _$$BankAccountMovementImplCopyWith<$Res> {
  __$$BankAccountMovementImplCopyWithImpl(_$BankAccountMovementImpl _value,
      $Res Function(_$BankAccountMovementImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankAccountMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? userId = null,
    Object? type = null,
    Object? amountMinor = null,
    Object? description = freezed,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? movementDate = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BankAccountMovementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      movementDate: null == movementDate
          ? _value.movementDate
          : movementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankAccountMovementImpl implements _BankAccountMovement {
  const _$BankAccountMovementImpl(
      {required this.id,
      @JsonKey(name: 'account_id') required this.accountId,
      @JsonKey(name: 'user_id') required this.userId,
      required this.type,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.description,
      @JsonKey(name: 'reference_type') this.referenceType,
      @JsonKey(name: 'reference_id') this.referenceId,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      required this.movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$BankAccountMovementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankAccountMovementImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String type;
// 'in' | 'out'
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  final String? description;
  @override
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime movementDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BankAccountMovement(id: $id, accountId: $accountId, userId: $userId, type: $type, amountMinor: $amountMinor, description: $description, referenceType: $referenceType, referenceId: $referenceId, movementDate: $movementDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankAccountMovementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.movementDate, movementDate) ||
                other.movementDate == movementDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      userId,
      type,
      amountMinor,
      description,
      referenceType,
      referenceId,
      movementDate,
      createdAt);

  /// Create a copy of BankAccountMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankAccountMovementImplCopyWith<_$BankAccountMovementImpl> get copyWith =>
      __$$BankAccountMovementImplCopyWithImpl<_$BankAccountMovementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankAccountMovementImplToJson(
      this,
    );
  }
}

abstract class _BankAccountMovement implements BankAccountMovement {
  const factory _BankAccountMovement(
      {required final String id,
      @JsonKey(name: 'account_id') required final String accountId,
      @JsonKey(name: 'user_id') required final String userId,
      required final String type,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String? description,
      @JsonKey(name: 'reference_type') final String? referenceType,
      @JsonKey(name: 'reference_id') final String? referenceId,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$BankAccountMovementImpl;

  factory _BankAccountMovement.fromJson(Map<String, dynamic> json) =
      _$BankAccountMovementImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get type; // 'in' | 'out'
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String? get description;
  @override
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get movementDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of BankAccountMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankAccountMovementImplCopyWith<_$BankAccountMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
