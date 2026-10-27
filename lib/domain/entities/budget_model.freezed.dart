// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Budget _$BudgetFromJson(Map<String, dynamic> json) {
  return _Budget.fromJson(json);
}

/// @nodoc
mixin _$Budget {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetCopyWith<Budget> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) then) =
      _$BudgetCopyWithImpl<$Res, Budget>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      String period,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
      DateTime endDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res, $Val extends Budget>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
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
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
abstract class _$$BudgetImplCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$$BudgetImplCopyWith(
          _$BudgetImpl value, $Res Function(_$BudgetImpl) then) =
      __$$BudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      String period,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
      DateTime endDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$BudgetImplCopyWithImpl<$Res>
    extends _$BudgetCopyWithImpl<$Res, _$BudgetImpl>
    implements _$$BudgetImplCopyWith<$Res> {
  __$$BudgetImplCopyWithImpl(
      _$BudgetImpl _value, $Res Function(_$BudgetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BudgetImpl(
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
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _$BudgetImpl implements _Budget {
  const _$BudgetImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.currency = 'EGP',
      this.period = 'monthly',
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      required this.startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
      required this.endDate,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$BudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String period;
  @override
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime endDate;
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
    return 'Budget(id: $id, userId: $userId, name: $name, amountMinor: $amountMinor, currency: $currency, period: $period, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, amountMinor,
      currency, period, startDate, endDate, isActive, createdAt, updatedAt);

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      __$$BudgetImplCopyWithImpl<_$BudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetImplToJson(
      this,
    );
  }
}

abstract class _Budget implements Budget {
  const factory _Budget(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String currency,
      final String period,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime endDate,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$BudgetImpl;

  factory _Budget.fromJson(Map<String, dynamic> json) = _$BudgetImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String get currency;
  @override
  String get period;
  @override
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get endDate;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BudgetCategory _$BudgetCategoryFromJson(Map<String, dynamic> json) {
  return _BudgetCategory.fromJson(json);
}

/// @nodoc
mixin _$BudgetCategory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_id')
  String get budgetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit_minor')
  int get limitMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BudgetCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetCategoryCopyWith<BudgetCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCategoryCopyWith<$Res> {
  factory $BudgetCategoryCopyWith(
          BudgetCategory value, $Res Function(BudgetCategory) then) =
      _$BudgetCategoryCopyWithImpl<$Res, BudgetCategory>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'limit_minor') int limitMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$BudgetCategoryCopyWithImpl<$Res, $Val extends BudgetCategory>
    implements $BudgetCategoryCopyWith<$Res> {
  _$BudgetCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? categoryId = null,
    Object? limitMinor = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      limitMinor: null == limitMinor
          ? _value.limitMinor
          : limitMinor // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BudgetCategoryImplCopyWith<$Res>
    implements $BudgetCategoryCopyWith<$Res> {
  factory _$$BudgetCategoryImplCopyWith(_$BudgetCategoryImpl value,
          $Res Function(_$BudgetCategoryImpl) then) =
      __$$BudgetCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'limit_minor') int limitMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$BudgetCategoryImplCopyWithImpl<$Res>
    extends _$BudgetCategoryCopyWithImpl<$Res, _$BudgetCategoryImpl>
    implements _$$BudgetCategoryImplCopyWith<$Res> {
  __$$BudgetCategoryImplCopyWithImpl(
      _$BudgetCategoryImpl _value, $Res Function(_$BudgetCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? categoryId = null,
    Object? limitMinor = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BudgetCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      limitMinor: null == limitMinor
          ? _value.limitMinor
          : limitMinor // ignore: cast_nullable_to_non_nullable
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
class _$BudgetCategoryImpl implements _BudgetCategory {
  const _$BudgetCategoryImpl(
      {required this.id,
      @JsonKey(name: 'budget_id') required this.budgetId,
      @JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'limit_minor') required this.limitMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$BudgetCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetCategoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'limit_minor')
  final int limitMinor;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BudgetCategory(id: $id, budgetId: $budgetId, categoryId: $categoryId, limitMinor: $limitMinor, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.limitMinor, limitMinor) ||
                other.limitMinor == limitMinor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, budgetId, categoryId, limitMinor, createdAt, updatedAt);

  /// Create a copy of BudgetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetCategoryImplCopyWith<_$BudgetCategoryImpl> get copyWith =>
      __$$BudgetCategoryImplCopyWithImpl<_$BudgetCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetCategoryImplToJson(
      this,
    );
  }
}

abstract class _BudgetCategory implements BudgetCategory {
  const factory _BudgetCategory(
      {required final String id,
      @JsonKey(name: 'budget_id') required final String budgetId,
      @JsonKey(name: 'category_id') required final String categoryId,
      @JsonKey(name: 'limit_minor') required final int limitMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$BudgetCategoryImpl;

  factory _BudgetCategory.fromJson(Map<String, dynamic> json) =
      _$BudgetCategoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'limit_minor')
  int get limitMinor;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of BudgetCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetCategoryImplCopyWith<_$BudgetCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) {
  return _RecurringExpense.fromJson(json);
}

/// @nodoc
mixin _$RecurringExpense {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String? get nameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  RecurringFrequency get frequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get nextDueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RecurringExpense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringExpenseCopyWith<RecurringExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringExpenseCopyWith<$Res> {
  factory $RecurringExpenseCopyWith(
          RecurringExpense value, $Res Function(RecurringExpense) then) =
      _$RecurringExpenseCopyWithImpl<$Res, RecurringExpense>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'category_id') String? categoryId,
      String? icon,
      RecurringFrequency frequency,
      @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
      DateTime nextDueDate,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? endDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res, $Val extends RecurringExpense>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? frequency = null,
    Object? nextDueDate = null,
    Object? startDate = null,
    Object? endDate = freezed,
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
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurringFrequency,
      nextDueDate: null == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$RecurringExpenseImplCopyWith<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  factory _$$RecurringExpenseImplCopyWith(_$RecurringExpenseImpl value,
          $Res Function(_$RecurringExpenseImpl) then) =
      __$$RecurringExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'category_id') String? categoryId,
      String? icon,
      RecurringFrequency frequency,
      @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
      DateTime nextDueDate,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? endDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$RecurringExpenseImplCopyWithImpl<$Res>
    extends _$RecurringExpenseCopyWithImpl<$Res, _$RecurringExpenseImpl>
    implements _$$RecurringExpenseImplCopyWith<$Res> {
  __$$RecurringExpenseImplCopyWithImpl(_$RecurringExpenseImpl _value,
      $Res Function(_$RecurringExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? frequency = null,
    Object? nextDueDate = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RecurringExpenseImpl(
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
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurringFrequency,
      nextDueDate: null == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$RecurringExpenseImpl implements _RecurringExpense {
  const _$RecurringExpenseImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'name_ar') this.nameAr,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.currency = 'EGP',
      @JsonKey(name: 'category_id') this.categoryId,
      this.icon,
      required this.frequency,
      @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
      required this.nextDueDate,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      required this.startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) this.endDate,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$RecurringExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringExpenseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  final String? icon;
  @override
  final RecurringFrequency frequency;
  @override
  @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime nextDueDate;
  @override
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)
  final DateTime? endDate;
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
    return 'RecurringExpense(id: $id, userId: $userId, name: $name, nameAr: $nameAr, amountMinor: $amountMinor, currency: $currency, categoryId: $categoryId, icon: $icon, frequency: $frequency, nextDueDate: $nextDueDate, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.nextDueDate, nextDueDate) ||
                other.nextDueDate == nextDueDate) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
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
      nameAr,
      amountMinor,
      currency,
      categoryId,
      icon,
      frequency,
      nextDueDate,
      startDate,
      endDate,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringExpenseImplCopyWith<_$RecurringExpenseImpl> get copyWith =>
      __$$RecurringExpenseImplCopyWithImpl<_$RecurringExpenseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringExpenseImplToJson(
      this,
    );
  }
}

abstract class _RecurringExpense implements RecurringExpense {
  const factory _RecurringExpense(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'name_ar') final String? nameAr,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String currency,
      @JsonKey(name: 'category_id') final String? categoryId,
      final String? icon,
      required final RecurringFrequency frequency,
      @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime nextDueDate,
      @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime startDate,
      @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)
      final DateTime? endDate,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$RecurringExpenseImpl;

  factory _RecurringExpense.fromJson(Map<String, dynamic> json) =
      _$RecurringExpenseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_ar')
  String? get nameAr;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  String? get icon;
  @override
  RecurringFrequency get frequency;
  @override
  @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get nextDueDate;
  @override
  @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)
  DateTime? get endDate;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringExpenseImplCopyWith<_$RecurringExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringExpenseOccurrence _$RecurringExpenseOccurrenceFromJson(
    Map<String, dynamic> json) {
  return _RecurringExpenseOccurrence.fromJson(json);
}

/// @nodoc
mixin _$RecurringExpenseOccurrence {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurring_expense_id')
  String get recurringExpenseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  RecurringOccurrenceStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecurringExpenseOccurrence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringExpenseOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringExpenseOccurrenceCopyWith<RecurringExpenseOccurrence>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringExpenseOccurrenceCopyWith<$Res> {
  factory $RecurringExpenseOccurrenceCopyWith(RecurringExpenseOccurrence value,
          $Res Function(RecurringExpenseOccurrence) then) =
      _$RecurringExpenseOccurrenceCopyWithImpl<$Res,
          RecurringExpenseOccurrence>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'recurring_expense_id') String recurringExpenseId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
      DateTime scheduledDate,
      @JsonKey(name: 'amount_minor') int amountMinor,
      RecurringOccurrenceStatus status,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$RecurringExpenseOccurrenceCopyWithImpl<$Res,
        $Val extends RecurringExpenseOccurrence>
    implements $RecurringExpenseOccurrenceCopyWith<$Res> {
  _$RecurringExpenseOccurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringExpenseOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recurringExpenseId = null,
    Object? userId = null,
    Object? scheduledDate = null,
    Object? amountMinor = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recurringExpenseId: null == recurringExpenseId
          ? _value.recurringExpenseId
          : recurringExpenseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecurringOccurrenceStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurringExpenseOccurrenceImplCopyWith<$Res>
    implements $RecurringExpenseOccurrenceCopyWith<$Res> {
  factory _$$RecurringExpenseOccurrenceImplCopyWith(
          _$RecurringExpenseOccurrenceImpl value,
          $Res Function(_$RecurringExpenseOccurrenceImpl) then) =
      __$$RecurringExpenseOccurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'recurring_expense_id') String recurringExpenseId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
      DateTime scheduledDate,
      @JsonKey(name: 'amount_minor') int amountMinor,
      RecurringOccurrenceStatus status,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$RecurringExpenseOccurrenceImplCopyWithImpl<$Res>
    extends _$RecurringExpenseOccurrenceCopyWithImpl<$Res,
        _$RecurringExpenseOccurrenceImpl>
    implements _$$RecurringExpenseOccurrenceImplCopyWith<$Res> {
  __$$RecurringExpenseOccurrenceImplCopyWithImpl(
      _$RecurringExpenseOccurrenceImpl _value,
      $Res Function(_$RecurringExpenseOccurrenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecurringExpenseOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recurringExpenseId = null,
    Object? userId = null,
    Object? scheduledDate = null,
    Object? amountMinor = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$RecurringExpenseOccurrenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recurringExpenseId: null == recurringExpenseId
          ? _value.recurringExpenseId
          : recurringExpenseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecurringOccurrenceStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringExpenseOccurrenceImpl implements _RecurringExpenseOccurrence {
  const _$RecurringExpenseOccurrenceImpl(
      {required this.id,
      @JsonKey(name: 'recurring_expense_id') required this.recurringExpenseId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
      required this.scheduledDate,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.status = RecurringOccurrenceStatus.pending,
      @JsonKey(name: 'transaction_id') this.transactionId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$RecurringExpenseOccurrenceImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RecurringExpenseOccurrenceImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'recurring_expense_id')
  final String recurringExpenseId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime scheduledDate;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final RecurringOccurrenceStatus status;
  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'RecurringExpenseOccurrence(id: $id, recurringExpenseId: $recurringExpenseId, userId: $userId, scheduledDate: $scheduledDate, amountMinor: $amountMinor, status: $status, transactionId: $transactionId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringExpenseOccurrenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recurringExpenseId, recurringExpenseId) ||
                other.recurringExpenseId == recurringExpenseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, recurringExpenseId, userId,
      scheduledDate, amountMinor, status, transactionId, createdAt);

  /// Create a copy of RecurringExpenseOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringExpenseOccurrenceImplCopyWith<_$RecurringExpenseOccurrenceImpl>
      get copyWith => __$$RecurringExpenseOccurrenceImplCopyWithImpl<
          _$RecurringExpenseOccurrenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringExpenseOccurrenceImplToJson(
      this,
    );
  }
}

abstract class _RecurringExpenseOccurrence
    implements RecurringExpenseOccurrence {
  const factory _RecurringExpenseOccurrence(
      {required final String id,
      @JsonKey(name: 'recurring_expense_id')
      required final String recurringExpenseId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime scheduledDate,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final RecurringOccurrenceStatus status,
      @JsonKey(name: 'transaction_id') final String? transactionId,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$RecurringExpenseOccurrenceImpl;

  factory _RecurringExpenseOccurrence.fromJson(Map<String, dynamic> json) =
      _$RecurringExpenseOccurrenceImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'recurring_expense_id')
  String get recurringExpenseId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get scheduledDate;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  RecurringOccurrenceStatus get status;
  @override
  @JsonKey(name: 'transaction_id')
  String? get transactionId;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of RecurringExpenseOccurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringExpenseOccurrenceImplCopyWith<_$RecurringExpenseOccurrenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SavingGoal _$SavingGoalFromJson(Map<String, dynamic> json) {
  return _SavingGoal.fromJson(json);
}

/// @nodoc
mixin _$SavingGoal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_amount_minor')
  int get targetAmountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_amount_minor')
  int get currentAmountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SavingGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavingGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavingGoalCopyWith<SavingGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavingGoalCopyWith<$Res> {
  factory $SavingGoalCopyWith(
          SavingGoal value, $Res Function(SavingGoal) then) =
      _$SavingGoalCopyWithImpl<$Res, SavingGoal>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'target_amount_minor') int targetAmountMinor,
      @JsonKey(name: 'current_amount_minor') int currentAmountMinor,
      String currency,
      @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
      DateTime? targetDate,
      String status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$SavingGoalCopyWithImpl<$Res, $Val extends SavingGoal>
    implements $SavingGoalCopyWith<$Res> {
  _$SavingGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavingGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? targetAmountMinor = null,
    Object? currentAmountMinor = null,
    Object? currency = null,
    Object? targetDate = freezed,
    Object? status = null,
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
      targetAmountMinor: null == targetAmountMinor
          ? _value.targetAmountMinor
          : targetAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currentAmountMinor: null == currentAmountMinor
          ? _value.currentAmountMinor
          : currentAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$SavingGoalImplCopyWith<$Res>
    implements $SavingGoalCopyWith<$Res> {
  factory _$$SavingGoalImplCopyWith(
          _$SavingGoalImpl value, $Res Function(_$SavingGoalImpl) then) =
      __$$SavingGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'target_amount_minor') int targetAmountMinor,
      @JsonKey(name: 'current_amount_minor') int currentAmountMinor,
      String currency,
      @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
      DateTime? targetDate,
      String status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$SavingGoalImplCopyWithImpl<$Res>
    extends _$SavingGoalCopyWithImpl<$Res, _$SavingGoalImpl>
    implements _$$SavingGoalImplCopyWith<$Res> {
  __$$SavingGoalImplCopyWithImpl(
      _$SavingGoalImpl _value, $Res Function(_$SavingGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavingGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? targetAmountMinor = null,
    Object? currentAmountMinor = null,
    Object? currency = null,
    Object? targetDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SavingGoalImpl(
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
      targetAmountMinor: null == targetAmountMinor
          ? _value.targetAmountMinor
          : targetAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currentAmountMinor: null == currentAmountMinor
          ? _value.currentAmountMinor
          : currentAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$SavingGoalImpl implements _SavingGoal {
  const _$SavingGoalImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'target_amount_minor') required this.targetAmountMinor,
      @JsonKey(name: 'current_amount_minor') this.currentAmountMinor = 0,
      this.currency = 'EGP',
      @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
      this.targetDate,
      this.status = 'active',
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$SavingGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavingGoalImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'target_amount_minor')
  final int targetAmountMinor;
  @override
  @JsonKey(name: 'current_amount_minor')
  final int currentAmountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
  final DateTime? targetDate;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SavingGoal(id: $id, userId: $userId, name: $name, targetAmountMinor: $targetAmountMinor, currentAmountMinor: $currentAmountMinor, currency: $currency, targetDate: $targetDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavingGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmountMinor, targetAmountMinor) ||
                other.targetAmountMinor == targetAmountMinor) &&
            (identical(other.currentAmountMinor, currentAmountMinor) ||
                other.currentAmountMinor == currentAmountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.status, status) || other.status == status) &&
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
      targetAmountMinor,
      currentAmountMinor,
      currency,
      targetDate,
      status,
      createdAt,
      updatedAt);

  /// Create a copy of SavingGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavingGoalImplCopyWith<_$SavingGoalImpl> get copyWith =>
      __$$SavingGoalImplCopyWithImpl<_$SavingGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavingGoalImplToJson(
      this,
    );
  }
}

abstract class _SavingGoal implements SavingGoal {
  const factory _SavingGoal(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'target_amount_minor')
      required final int targetAmountMinor,
      @JsonKey(name: 'current_amount_minor') final int currentAmountMinor,
      final String currency,
      @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
      final DateTime? targetDate,
      final String status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$SavingGoalImpl;

  factory _SavingGoal.fromJson(Map<String, dynamic> json) =
      _$SavingGoalImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'target_amount_minor')
  int get targetAmountMinor;
  @override
  @JsonKey(name: 'current_amount_minor')
  int get currentAmountMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)
  DateTime? get targetDate;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of SavingGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavingGoalImplCopyWith<_$SavingGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavingRecommendation _$SavingRecommendationFromJson(Map<String, dynamic> json) {
  return _SavingRecommendation.fromJson(json);
}

/// @nodoc
mixin _$SavingRecommendation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String? get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'baseline_amount_minor')
  int get baselineAmountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_amount_minor')
  int get currentAmountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'reduction_percentage')
  double get reductionPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_saving_minor')
  int get estimatedSavingMinor => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  RecommendationStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SavingRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavingRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavingRecommendationCopyWith<SavingRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavingRecommendationCopyWith<$Res> {
  factory $SavingRecommendationCopyWith(SavingRecommendation value,
          $Res Function(SavingRecommendation) then) =
      _$SavingRecommendationCopyWithImpl<$Res, SavingRecommendation>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String? itemId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'baseline_amount_minor') int baselineAmountMinor,
      @JsonKey(name: 'current_amount_minor') int currentAmountMinor,
      @JsonKey(name: 'reduction_percentage') double reductionPercentage,
      @JsonKey(name: 'estimated_saving_minor') int estimatedSavingMinor,
      int month,
      int year,
      RecommendationStatus status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$SavingRecommendationCopyWithImpl<$Res,
        $Val extends SavingRecommendation>
    implements $SavingRecommendationCopyWith<$Res> {
  _$SavingRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavingRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = freezed,
    Object? categoryId = freezed,
    Object? baselineAmountMinor = null,
    Object? currentAmountMinor = null,
    Object? reductionPercentage = null,
    Object? estimatedSavingMinor = null,
    Object? month = null,
    Object? year = null,
    Object? status = null,
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
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      baselineAmountMinor: null == baselineAmountMinor
          ? _value.baselineAmountMinor
          : baselineAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currentAmountMinor: null == currentAmountMinor
          ? _value.currentAmountMinor
          : currentAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      reductionPercentage: null == reductionPercentage
          ? _value.reductionPercentage
          : reductionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedSavingMinor: null == estimatedSavingMinor
          ? _value.estimatedSavingMinor
          : estimatedSavingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecommendationStatus,
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
abstract class _$$SavingRecommendationImplCopyWith<$Res>
    implements $SavingRecommendationCopyWith<$Res> {
  factory _$$SavingRecommendationImplCopyWith(_$SavingRecommendationImpl value,
          $Res Function(_$SavingRecommendationImpl) then) =
      __$$SavingRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String? itemId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'baseline_amount_minor') int baselineAmountMinor,
      @JsonKey(name: 'current_amount_minor') int currentAmountMinor,
      @JsonKey(name: 'reduction_percentage') double reductionPercentage,
      @JsonKey(name: 'estimated_saving_minor') int estimatedSavingMinor,
      int month,
      int year,
      RecommendationStatus status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$SavingRecommendationImplCopyWithImpl<$Res>
    extends _$SavingRecommendationCopyWithImpl<$Res, _$SavingRecommendationImpl>
    implements _$$SavingRecommendationImplCopyWith<$Res> {
  __$$SavingRecommendationImplCopyWithImpl(_$SavingRecommendationImpl _value,
      $Res Function(_$SavingRecommendationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavingRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = freezed,
    Object? categoryId = freezed,
    Object? baselineAmountMinor = null,
    Object? currentAmountMinor = null,
    Object? reductionPercentage = null,
    Object? estimatedSavingMinor = null,
    Object? month = null,
    Object? year = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SavingRecommendationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      baselineAmountMinor: null == baselineAmountMinor
          ? _value.baselineAmountMinor
          : baselineAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currentAmountMinor: null == currentAmountMinor
          ? _value.currentAmountMinor
          : currentAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      reductionPercentage: null == reductionPercentage
          ? _value.reductionPercentage
          : reductionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedSavingMinor: null == estimatedSavingMinor
          ? _value.estimatedSavingMinor
          : estimatedSavingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecommendationStatus,
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
class _$SavingRecommendationImpl implements _SavingRecommendation {
  const _$SavingRecommendationImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'item_id') this.itemId,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'baseline_amount_minor') required this.baselineAmountMinor,
      @JsonKey(name: 'current_amount_minor') required this.currentAmountMinor,
      @JsonKey(name: 'reduction_percentage') required this.reductionPercentage,
      @JsonKey(name: 'estimated_saving_minor')
      required this.estimatedSavingMinor,
      required this.month,
      required this.year,
      this.status = RecommendationStatus.active,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$SavingRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavingRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'item_id')
  final String? itemId;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'baseline_amount_minor')
  final int baselineAmountMinor;
  @override
  @JsonKey(name: 'current_amount_minor')
  final int currentAmountMinor;
  @override
  @JsonKey(name: 'reduction_percentage')
  final double reductionPercentage;
  @override
  @JsonKey(name: 'estimated_saving_minor')
  final int estimatedSavingMinor;
  @override
  final int month;
  @override
  final int year;
  @override
  @JsonKey()
  final RecommendationStatus status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SavingRecommendation(id: $id, userId: $userId, itemId: $itemId, categoryId: $categoryId, baselineAmountMinor: $baselineAmountMinor, currentAmountMinor: $currentAmountMinor, reductionPercentage: $reductionPercentage, estimatedSavingMinor: $estimatedSavingMinor, month: $month, year: $year, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavingRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.baselineAmountMinor, baselineAmountMinor) ||
                other.baselineAmountMinor == baselineAmountMinor) &&
            (identical(other.currentAmountMinor, currentAmountMinor) ||
                other.currentAmountMinor == currentAmountMinor) &&
            (identical(other.reductionPercentage, reductionPercentage) ||
                other.reductionPercentage == reductionPercentage) &&
            (identical(other.estimatedSavingMinor, estimatedSavingMinor) ||
                other.estimatedSavingMinor == estimatedSavingMinor) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.status, status) || other.status == status) &&
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
      itemId,
      categoryId,
      baselineAmountMinor,
      currentAmountMinor,
      reductionPercentage,
      estimatedSavingMinor,
      month,
      year,
      status,
      createdAt,
      updatedAt);

  /// Create a copy of SavingRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavingRecommendationImplCopyWith<_$SavingRecommendationImpl>
      get copyWith =>
          __$$SavingRecommendationImplCopyWithImpl<_$SavingRecommendationImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavingRecommendationImplToJson(
      this,
    );
  }
}

abstract class _SavingRecommendation implements SavingRecommendation {
  const factory _SavingRecommendation(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'item_id') final String? itemId,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'baseline_amount_minor')
      required final int baselineAmountMinor,
      @JsonKey(name: 'current_amount_minor')
      required final int currentAmountMinor,
      @JsonKey(name: 'reduction_percentage')
      required final double reductionPercentage,
      @JsonKey(name: 'estimated_saving_minor')
      required final int estimatedSavingMinor,
      required final int month,
      required final int year,
      final RecommendationStatus status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$SavingRecommendationImpl;

  factory _SavingRecommendation.fromJson(Map<String, dynamic> json) =
      _$SavingRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'item_id')
  String? get itemId;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'baseline_amount_minor')
  int get baselineAmountMinor;
  @override
  @JsonKey(name: 'current_amount_minor')
  int get currentAmountMinor;
  @override
  @JsonKey(name: 'reduction_percentage')
  double get reductionPercentage;
  @override
  @JsonKey(name: 'estimated_saving_minor')
  int get estimatedSavingMinor;
  @override
  int get month;
  @override
  int get year;
  @override
  RecommendationStatus get status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of SavingRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavingRecommendationImplCopyWith<_$SavingRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
