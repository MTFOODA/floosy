// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'amount_minor') int get amountMinor; String get currency; String get period;@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime get startDate;@JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired) DateTime get endDate;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Budget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Budget;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.amountMinor,_this.currency,_this.period,_this.startDate,_this.endDate,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Budget;
  return 'Budget(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, period: ${_this.period}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'amount_minor') int amountMinor, String currency, String period,@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime startDate,@JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired) DateTime endDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? amountMinor = null,Object? currency = null,Object? period = null,Object? startDate = null,Object? endDate = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency,  String period, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)  DateTime endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.amountMinor,_that.currency,_that.period,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency,  String period, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)  DateTime endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.id,_that.userId,_that.name,_that.amountMinor,_that.currency,_that.period,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency,  String period, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired)  DateTime endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.amountMinor,_that.currency,_that.period,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Budget implements Budget {
  const _Budget({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'amount_minor') required this.amountMinor, this.currency = 'EGP', this.period = 'monthly', @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) required this.startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired) required this.endDate, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String period;
@override@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) final  DateTime startDate;
@override@JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired) final  DateTime endDate;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,amountMinor,currency,period,startDate,endDate,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'Budget(id: $id, userId: $userId, name: $name, amountMinor: $amountMinor, currency: $currency, period: $period, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'amount_minor') int amountMinor, String currency, String period,@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime startDate,@JsonKey(name: 'end_date', fromJson: _dateTimeFromJsonRequired) DateTime endDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? amountMinor = null,Object? currency = null,Object? period = null,Object? startDate = null,Object? endDate = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BudgetCategory {

 String get id;@JsonKey(name: 'budget_id') String get budgetId;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'limit_minor') int get limitMinor;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of BudgetCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCategoryCopyWith<BudgetCategory> get copyWith => _$BudgetCategoryCopyWithImpl<BudgetCategory>(this as BudgetCategory, _$identity);

  /// Serializes this BudgetCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BudgetCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.budgetId, _this.budgetId) || other.budgetId == _this.budgetId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.limitMinor, _this.limitMinor) || other.limitMinor == _this.limitMinor)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BudgetCategory;
  return Object.hash(runtimeType,_this.id,_this.budgetId,_this.categoryId,_this.limitMinor,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as BudgetCategory;
  return 'BudgetCategory(id: ${_this.id}, budgetId: ${_this.budgetId}, categoryId: ${_this.categoryId}, limitMinor: ${_this.limitMinor}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BudgetCategoryCopyWith<$Res>  {
  factory $BudgetCategoryCopyWith(BudgetCategory value, $Res Function(BudgetCategory) _then) = _$BudgetCategoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'budget_id') String budgetId,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'limit_minor') int limitMinor,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$BudgetCategoryCopyWithImpl<$Res>
    implements $BudgetCategoryCopyWith<$Res> {
  _$BudgetCategoryCopyWithImpl(this._self, this._then);

  final BudgetCategory _self;
  final $Res Function(BudgetCategory) _then;

/// Create a copy of BudgetCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? budgetId = null,Object? categoryId = null,Object? limitMinor = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(BudgetCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,budgetId: null == budgetId ? _self.budgetId : budgetId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetCategory].
extension BudgetCategoryPatterns on BudgetCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetCategory value)  $default,){
final _that = this;
switch (_that) {
case _BudgetCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetCategory value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'budget_id')  String budgetId, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'limit_minor')  int limitMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetCategory() when $default != null:
return $default(_that.id,_that.budgetId,_that.categoryId,_that.limitMinor,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'budget_id')  String budgetId, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'limit_minor')  int limitMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BudgetCategory():
return $default(_that.id,_that.budgetId,_that.categoryId,_that.limitMinor,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'budget_id')  String budgetId, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'limit_minor')  int limitMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BudgetCategory() when $default != null:
return $default(_that.id,_that.budgetId,_that.categoryId,_that.limitMinor,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetCategory implements BudgetCategory {
  const _BudgetCategory({required this.id, @JsonKey(name: 'budget_id') required this.budgetId, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'limit_minor') required this.limitMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _BudgetCategory.fromJson(Map<String, dynamic> json) => _$BudgetCategoryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'budget_id') final  String budgetId;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'limit_minor') final  int limitMinor;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of BudgetCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCategoryCopyWith<_BudgetCategory> get copyWith => __$BudgetCategoryCopyWithImpl<_BudgetCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.budgetId, budgetId) || other.budgetId == budgetId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitMinor, limitMinor) || other.limitMinor == limitMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,budgetId,categoryId,limitMinor,createdAt,updatedAt);
}

@override
String toString() {
    return 'BudgetCategory(id: $id, budgetId: $budgetId, categoryId: $categoryId, limitMinor: $limitMinor, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetCategoryCopyWith<$Res> implements $BudgetCategoryCopyWith<$Res> {
  factory _$BudgetCategoryCopyWith(_BudgetCategory value, $Res Function(_BudgetCategory) _then) = __$BudgetCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'budget_id') String budgetId,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'limit_minor') int limitMinor,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$BudgetCategoryCopyWithImpl<$Res>
    implements _$BudgetCategoryCopyWith<$Res> {
  __$BudgetCategoryCopyWithImpl(this._self, this._then);

  final _BudgetCategory _self;
  final $Res Function(_BudgetCategory) _then;

/// Create a copy of BudgetCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? budgetId = null,Object? categoryId = null,Object? limitMinor = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BudgetCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,budgetId: null == budgetId ? _self.budgetId : budgetId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RecurringExpense {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'name_ar') String? get nameAr;@JsonKey(name: 'amount_minor') int get amountMinor; String get currency;@JsonKey(name: 'category_id') String? get categoryId; String? get icon; RecurringFrequency get frequency;@JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired) DateTime get nextDueDate;@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime get startDate;@JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? get endDate;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringExpenseCopyWith<RecurringExpense> get copyWith => _$RecurringExpenseCopyWithImpl<RecurringExpense>(this as RecurringExpense, _$identity);

  /// Serializes this RecurringExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecurringExpense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringExpense&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.nextDueDate, _this.nextDueDate) || other.nextDueDate == _this.nextDueDate)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecurringExpense;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.nameAr,_this.amountMinor,_this.currency,_this.categoryId,_this.icon,_this.frequency,_this.nextDueDate,_this.startDate,_this.endDate,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as RecurringExpense;
  return 'RecurringExpense(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, nameAr: ${_this.nameAr}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, categoryId: ${_this.categoryId}, icon: ${_this.icon}, frequency: ${_this.frequency}, nextDueDate: ${_this.nextDueDate}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RecurringExpenseCopyWith<$Res>  {
  factory $RecurringExpenseCopyWith(RecurringExpense value, $Res Function(RecurringExpense) _then) = _$RecurringExpenseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'name_ar') String? nameAr,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'category_id') String? categoryId, String? icon, RecurringFrequency frequency,@JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired) DateTime nextDueDate,@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime startDate,@JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? endDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._self, this._then);

  final RecurringExpense _self;
  final $Res Function(RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? nameAr = freezed,Object? amountMinor = null,Object? currency = null,Object? categoryId = freezed,Object? icon = freezed,Object? frequency = null,Object? nextDueDate = null,Object? startDate = null,Object? endDate = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(RecurringExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringExpense].
extension RecurringExpensePatterns on RecurringExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringExpense value)  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringExpense value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon,  RecurringFrequency frequency, @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)  DateTime nextDueDate, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)  DateTime? endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.amountMinor,_that.currency,_that.categoryId,_that.icon,_that.frequency,_that.nextDueDate,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon,  RecurringFrequency frequency, @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)  DateTime nextDueDate, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)  DateTime? endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense():
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.amountMinor,_that.currency,_that.categoryId,_that.icon,_that.frequency,_that.nextDueDate,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon,  RecurringFrequency frequency, @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired)  DateTime nextDueDate, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired)  DateTime startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson)  DateTime? endDate, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.amountMinor,_that.currency,_that.categoryId,_that.icon,_that.frequency,_that.nextDueDate,_that.startDate,_that.endDate,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringExpense implements RecurringExpense {
  const _RecurringExpense({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'name_ar') this.nameAr, @JsonKey(name: 'amount_minor') required this.amountMinor, this.currency = 'EGP', @JsonKey(name: 'category_id') this.categoryId, this.icon, required this.frequency, @JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired) required this.nextDueDate, @JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) required this.startDate, @JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) this.endDate, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _RecurringExpense.fromJson(Map<String, dynamic> json) => _$RecurringExpenseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String? nameAr;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override final  String? icon;
@override final  RecurringFrequency frequency;
@override@JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired) final  DateTime nextDueDate;
@override@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) final  DateTime startDate;
@override@JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) final  DateTime? endDate;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringExpenseCopyWith<_RecurringExpense> get copyWith => __$RecurringExpenseCopyWithImpl<_RecurringExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,nameAr,amountMinor,currency,categoryId,icon,frequency,nextDueDate,startDate,endDate,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'RecurringExpense(id: $id, userId: $userId, name: $name, nameAr: $nameAr, amountMinor: $amountMinor, currency: $currency, categoryId: $categoryId, icon: $icon, frequency: $frequency, nextDueDate: $nextDueDate, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecurringExpenseCopyWith<$Res> implements $RecurringExpenseCopyWith<$Res> {
  factory _$RecurringExpenseCopyWith(_RecurringExpense value, $Res Function(_RecurringExpense) _then) = __$RecurringExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'name_ar') String? nameAr,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'category_id') String? categoryId, String? icon, RecurringFrequency frequency,@JsonKey(name: 'next_due_date', fromJson: _dateTimeFromJsonRequired) DateTime nextDueDate,@JsonKey(name: 'start_date', fromJson: _dateTimeFromJsonRequired) DateTime startDate,@JsonKey(name: 'end_date', fromJson: _dateTimeFromJson) DateTime? endDate,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$RecurringExpenseCopyWithImpl<$Res>
    implements _$RecurringExpenseCopyWith<$Res> {
  __$RecurringExpenseCopyWithImpl(this._self, this._then);

  final _RecurringExpense _self;
  final $Res Function(_RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? nameAr = freezed,Object? amountMinor = null,Object? currency = null,Object? categoryId = freezed,Object? icon = freezed,Object? frequency = null,Object? nextDueDate = null,Object? startDate = null,Object? endDate = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_RecurringExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RecurringExpenseOccurrence {

 String get id;@JsonKey(name: 'recurring_expense_id') String get recurringExpenseId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired) DateTime get scheduledDate;@JsonKey(name: 'amount_minor') int get amountMinor; RecurringOccurrenceStatus get status;@JsonKey(name: 'transaction_id') String? get transactionId;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of RecurringExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringExpenseOccurrenceCopyWith<RecurringExpenseOccurrence> get copyWith => _$RecurringExpenseOccurrenceCopyWithImpl<RecurringExpenseOccurrence>(this as RecurringExpenseOccurrence, _$identity);

  /// Serializes this RecurringExpenseOccurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecurringExpenseOccurrence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringExpenseOccurrence&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recurringExpenseId, _this.recurringExpenseId) || other.recurringExpenseId == _this.recurringExpenseId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.scheduledDate, _this.scheduledDate) || other.scheduledDate == _this.scheduledDate)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecurringExpenseOccurrence;
  return Object.hash(runtimeType,_this.id,_this.recurringExpenseId,_this.userId,_this.scheduledDate,_this.amountMinor,_this.status,_this.transactionId,_this.createdAt);
}

@override
String toString() {
  final _this = this as RecurringExpenseOccurrence;
  return 'RecurringExpenseOccurrence(id: ${_this.id}, recurringExpenseId: ${_this.recurringExpenseId}, userId: ${_this.userId}, scheduledDate: ${_this.scheduledDate}, amountMinor: ${_this.amountMinor}, status: ${_this.status}, transactionId: ${_this.transactionId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RecurringExpenseOccurrenceCopyWith<$Res>  {
  factory $RecurringExpenseOccurrenceCopyWith(RecurringExpenseOccurrence value, $Res Function(RecurringExpenseOccurrence) _then) = _$RecurringExpenseOccurrenceCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'recurring_expense_id') String recurringExpenseId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired) DateTime scheduledDate,@JsonKey(name: 'amount_minor') int amountMinor, RecurringOccurrenceStatus status,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$RecurringExpenseOccurrenceCopyWithImpl<$Res>
    implements $RecurringExpenseOccurrenceCopyWith<$Res> {
  _$RecurringExpenseOccurrenceCopyWithImpl(this._self, this._then);

  final RecurringExpenseOccurrence _self;
  final $Res Function(RecurringExpenseOccurrence) _then;

/// Create a copy of RecurringExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recurringExpenseId = null,Object? userId = null,Object? scheduledDate = null,Object? amountMinor = null,Object? status = null,Object? transactionId = freezed,Object? createdAt = freezed,}) {
  return _then(RecurringExpenseOccurrence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recurringExpenseId: null == recurringExpenseId ? _self.recurringExpenseId : recurringExpenseId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringOccurrenceStatus,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringExpenseOccurrence].
extension RecurringExpenseOccurrencePatterns on RecurringExpenseOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringExpenseOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringExpenseOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringExpenseOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'recurring_expense_id')  String recurringExpenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)  DateTime scheduledDate, @JsonKey(name: 'amount_minor')  int amountMinor,  RecurringOccurrenceStatus status, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence() when $default != null:
return $default(_that.id,_that.recurringExpenseId,_that.userId,_that.scheduledDate,_that.amountMinor,_that.status,_that.transactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'recurring_expense_id')  String recurringExpenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)  DateTime scheduledDate, @JsonKey(name: 'amount_minor')  int amountMinor,  RecurringOccurrenceStatus status, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence():
return $default(_that.id,_that.recurringExpenseId,_that.userId,_that.scheduledDate,_that.amountMinor,_that.status,_that.transactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'recurring_expense_id')  String recurringExpenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired)  DateTime scheduledDate, @JsonKey(name: 'amount_minor')  int amountMinor,  RecurringOccurrenceStatus status, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RecurringExpenseOccurrence() when $default != null:
return $default(_that.id,_that.recurringExpenseId,_that.userId,_that.scheduledDate,_that.amountMinor,_that.status,_that.transactionId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringExpenseOccurrence implements RecurringExpenseOccurrence {
  const _RecurringExpenseOccurrence({required this.id, @JsonKey(name: 'recurring_expense_id') required this.recurringExpenseId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired) required this.scheduledDate, @JsonKey(name: 'amount_minor') required this.amountMinor, this.status = RecurringOccurrenceStatus.pending, @JsonKey(name: 'transaction_id') this.transactionId, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _RecurringExpenseOccurrence.fromJson(Map<String, dynamic> json) => _$RecurringExpenseOccurrenceFromJson(json);

@override final  String id;
@override@JsonKey(name: 'recurring_expense_id') final  String recurringExpenseId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired) final  DateTime scheduledDate;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  RecurringOccurrenceStatus status;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of RecurringExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringExpenseOccurrenceCopyWith<_RecurringExpenseOccurrence> get copyWith => __$RecurringExpenseOccurrenceCopyWithImpl<_RecurringExpenseOccurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringExpenseOccurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringExpenseOccurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.recurringExpenseId, recurringExpenseId) || other.recurringExpenseId == recurringExpenseId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.status, status) || other.status == status)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,recurringExpenseId,userId,scheduledDate,amountMinor,status,transactionId,createdAt);
}

@override
String toString() {
    return 'RecurringExpenseOccurrence(id: $id, recurringExpenseId: $recurringExpenseId, userId: $userId, scheduledDate: $scheduledDate, amountMinor: $amountMinor, status: $status, transactionId: $transactionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RecurringExpenseOccurrenceCopyWith<$Res> implements $RecurringExpenseOccurrenceCopyWith<$Res> {
  factory _$RecurringExpenseOccurrenceCopyWith(_RecurringExpenseOccurrence value, $Res Function(_RecurringExpenseOccurrence) _then) = __$RecurringExpenseOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'recurring_expense_id') String recurringExpenseId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'scheduled_date', fromJson: _dateTimeFromJsonRequired) DateTime scheduledDate,@JsonKey(name: 'amount_minor') int amountMinor, RecurringOccurrenceStatus status,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$RecurringExpenseOccurrenceCopyWithImpl<$Res>
    implements _$RecurringExpenseOccurrenceCopyWith<$Res> {
  __$RecurringExpenseOccurrenceCopyWithImpl(this._self, this._then);

  final _RecurringExpenseOccurrence _self;
  final $Res Function(_RecurringExpenseOccurrence) _then;

/// Create a copy of RecurringExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recurringExpenseId = null,Object? userId = null,Object? scheduledDate = null,Object? amountMinor = null,Object? status = null,Object? transactionId = freezed,Object? createdAt = freezed,}) {
  return _then(_RecurringExpenseOccurrence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recurringExpenseId: null == recurringExpenseId ? _self.recurringExpenseId : recurringExpenseId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringOccurrenceStatus,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SavingGoal {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'target_amount_minor') int get targetAmountMinor;@JsonKey(name: 'current_amount_minor') int get currentAmountMinor; String get currency;@JsonKey(name: 'target_date', fromJson: _dateTimeFromJson) DateTime? get targetDate; String get status;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingGoalCopyWith<SavingGoal> get copyWith => _$SavingGoalCopyWithImpl<SavingGoal>(this as SavingGoal, _$identity);

  /// Serializes this SavingGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SavingGoal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingGoal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.targetAmountMinor, _this.targetAmountMinor) || other.targetAmountMinor == _this.targetAmountMinor)&&(identical(other.currentAmountMinor, _this.currentAmountMinor) || other.currentAmountMinor == _this.currentAmountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.targetDate, _this.targetDate) || other.targetDate == _this.targetDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SavingGoal;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.targetAmountMinor,_this.currentAmountMinor,_this.currency,_this.targetDate,_this.status,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SavingGoal;
  return 'SavingGoal(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, targetAmountMinor: ${_this.targetAmountMinor}, currentAmountMinor: ${_this.currentAmountMinor}, currency: ${_this.currency}, targetDate: ${_this.targetDate}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SavingGoalCopyWith<$Res>  {
  factory $SavingGoalCopyWith(SavingGoal value, $Res Function(SavingGoal) _then) = _$SavingGoalCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'target_amount_minor') int targetAmountMinor,@JsonKey(name: 'current_amount_minor') int currentAmountMinor, String currency,@JsonKey(name: 'target_date', fromJson: _dateTimeFromJson) DateTime? targetDate, String status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$SavingGoalCopyWithImpl<$Res>
    implements $SavingGoalCopyWith<$Res> {
  _$SavingGoalCopyWithImpl(this._self, this._then);

  final SavingGoal _self;
  final $Res Function(SavingGoal) _then;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmountMinor = null,Object? currentAmountMinor = null,Object? currency = null,Object? targetDate = freezed,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(SavingGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmountMinor: null == targetAmountMinor ? _self.targetAmountMinor : targetAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currentAmountMinor: null == currentAmountMinor ? _self.currentAmountMinor : currentAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingGoal].
extension SavingGoalPatterns on SavingGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingGoal value)  $default,){
final _that = this;
switch (_that) {
case _SavingGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingGoal value)?  $default,){
final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'target_amount_minor')  int targetAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor,  String currency, @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)  DateTime? targetDate,  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmountMinor,_that.currentAmountMinor,_that.currency,_that.targetDate,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'target_amount_minor')  int targetAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor,  String currency, @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)  DateTime? targetDate,  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SavingGoal():
return $default(_that.id,_that.userId,_that.name,_that.targetAmountMinor,_that.currentAmountMinor,_that.currency,_that.targetDate,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'target_amount_minor')  int targetAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor,  String currency, @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson)  DateTime? targetDate,  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmountMinor,_that.currentAmountMinor,_that.currency,_that.targetDate,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingGoal implements SavingGoal {
  const _SavingGoal({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'target_amount_minor') required this.targetAmountMinor, @JsonKey(name: 'current_amount_minor') this.currentAmountMinor = 0, this.currency = 'EGP', @JsonKey(name: 'target_date', fromJson: _dateTimeFromJson) this.targetDate, this.status = 'active', @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _SavingGoal.fromJson(Map<String, dynamic> json) => _$SavingGoalFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'target_amount_minor') final  int targetAmountMinor;
@override@JsonKey(name: 'current_amount_minor') final  int currentAmountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'target_date', fromJson: _dateTimeFromJson) final  DateTime? targetDate;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingGoalCopyWith<_SavingGoal> get copyWith => __$SavingGoalCopyWithImpl<_SavingGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingGoalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmountMinor, targetAmountMinor) || other.targetAmountMinor == targetAmountMinor)&&(identical(other.currentAmountMinor, currentAmountMinor) || other.currentAmountMinor == currentAmountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,targetAmountMinor,currentAmountMinor,currency,targetDate,status,createdAt,updatedAt);
}

@override
String toString() {
    return 'SavingGoal(id: $id, userId: $userId, name: $name, targetAmountMinor: $targetAmountMinor, currentAmountMinor: $currentAmountMinor, currency: $currency, targetDate: $targetDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SavingGoalCopyWith<$Res> implements $SavingGoalCopyWith<$Res> {
  factory _$SavingGoalCopyWith(_SavingGoal value, $Res Function(_SavingGoal) _then) = __$SavingGoalCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'target_amount_minor') int targetAmountMinor,@JsonKey(name: 'current_amount_minor') int currentAmountMinor, String currency,@JsonKey(name: 'target_date', fromJson: _dateTimeFromJson) DateTime? targetDate, String status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$SavingGoalCopyWithImpl<$Res>
    implements _$SavingGoalCopyWith<$Res> {
  __$SavingGoalCopyWithImpl(this._self, this._then);

  final _SavingGoal _self;
  final $Res Function(_SavingGoal) _then;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmountMinor = null,Object? currentAmountMinor = null,Object? currency = null,Object? targetDate = freezed,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SavingGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmountMinor: null == targetAmountMinor ? _self.targetAmountMinor : targetAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currentAmountMinor: null == currentAmountMinor ? _self.currentAmountMinor : currentAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SavingRecommendation {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'item_id') String? get itemId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'baseline_amount_minor') int get baselineAmountMinor;@JsonKey(name: 'current_amount_minor') int get currentAmountMinor;@JsonKey(name: 'reduction_percentage') double get reductionPercentage;@JsonKey(name: 'estimated_saving_minor') int get estimatedSavingMinor; int get month; int get year; RecommendationStatus get status;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of SavingRecommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingRecommendationCopyWith<SavingRecommendation> get copyWith => _$SavingRecommendationCopyWithImpl<SavingRecommendation>(this as SavingRecommendation, _$identity);

  /// Serializes this SavingRecommendation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SavingRecommendation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingRecommendation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.baselineAmountMinor, _this.baselineAmountMinor) || other.baselineAmountMinor == _this.baselineAmountMinor)&&(identical(other.currentAmountMinor, _this.currentAmountMinor) || other.currentAmountMinor == _this.currentAmountMinor)&&(identical(other.reductionPercentage, _this.reductionPercentage) || other.reductionPercentage == _this.reductionPercentage)&&(identical(other.estimatedSavingMinor, _this.estimatedSavingMinor) || other.estimatedSavingMinor == _this.estimatedSavingMinor)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SavingRecommendation;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.itemId,_this.categoryId,_this.baselineAmountMinor,_this.currentAmountMinor,_this.reductionPercentage,_this.estimatedSavingMinor,_this.month,_this.year,_this.status,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SavingRecommendation;
  return 'SavingRecommendation(id: ${_this.id}, userId: ${_this.userId}, itemId: ${_this.itemId}, categoryId: ${_this.categoryId}, baselineAmountMinor: ${_this.baselineAmountMinor}, currentAmountMinor: ${_this.currentAmountMinor}, reductionPercentage: ${_this.reductionPercentage}, estimatedSavingMinor: ${_this.estimatedSavingMinor}, month: ${_this.month}, year: ${_this.year}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SavingRecommendationCopyWith<$Res>  {
  factory $SavingRecommendationCopyWith(SavingRecommendation value, $Res Function(SavingRecommendation) _then) = _$SavingRecommendationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'baseline_amount_minor') int baselineAmountMinor,@JsonKey(name: 'current_amount_minor') int currentAmountMinor,@JsonKey(name: 'reduction_percentage') double reductionPercentage,@JsonKey(name: 'estimated_saving_minor') int estimatedSavingMinor, int month, int year, RecommendationStatus status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$SavingRecommendationCopyWithImpl<$Res>
    implements $SavingRecommendationCopyWith<$Res> {
  _$SavingRecommendationCopyWithImpl(this._self, this._then);

  final SavingRecommendation _self;
  final $Res Function(SavingRecommendation) _then;

/// Create a copy of SavingRecommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemId = freezed,Object? categoryId = freezed,Object? baselineAmountMinor = null,Object? currentAmountMinor = null,Object? reductionPercentage = null,Object? estimatedSavingMinor = null,Object? month = null,Object? year = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(SavingRecommendation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,baselineAmountMinor: null == baselineAmountMinor ? _self.baselineAmountMinor : baselineAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currentAmountMinor: null == currentAmountMinor ? _self.currentAmountMinor : currentAmountMinor // ignore: cast_nullable_to_non_nullable
as int,reductionPercentage: null == reductionPercentage ? _self.reductionPercentage : reductionPercentage // ignore: cast_nullable_to_non_nullable
as double,estimatedSavingMinor: null == estimatedSavingMinor ? _self.estimatedSavingMinor : estimatedSavingMinor // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecommendationStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingRecommendation].
extension SavingRecommendationPatterns on SavingRecommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingRecommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingRecommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingRecommendation value)  $default,){
final _that = this;
switch (_that) {
case _SavingRecommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingRecommendation value)?  $default,){
final _that = this;
switch (_that) {
case _SavingRecommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'baseline_amount_minor')  int baselineAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor, @JsonKey(name: 'reduction_percentage')  double reductionPercentage, @JsonKey(name: 'estimated_saving_minor')  int estimatedSavingMinor,  int month,  int year,  RecommendationStatus status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingRecommendation() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.categoryId,_that.baselineAmountMinor,_that.currentAmountMinor,_that.reductionPercentage,_that.estimatedSavingMinor,_that.month,_that.year,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'baseline_amount_minor')  int baselineAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor, @JsonKey(name: 'reduction_percentage')  double reductionPercentage, @JsonKey(name: 'estimated_saving_minor')  int estimatedSavingMinor,  int month,  int year,  RecommendationStatus status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SavingRecommendation():
return $default(_that.id,_that.userId,_that.itemId,_that.categoryId,_that.baselineAmountMinor,_that.currentAmountMinor,_that.reductionPercentage,_that.estimatedSavingMinor,_that.month,_that.year,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'baseline_amount_minor')  int baselineAmountMinor, @JsonKey(name: 'current_amount_minor')  int currentAmountMinor, @JsonKey(name: 'reduction_percentage')  double reductionPercentage, @JsonKey(name: 'estimated_saving_minor')  int estimatedSavingMinor,  int month,  int year,  RecommendationStatus status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingRecommendation() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.categoryId,_that.baselineAmountMinor,_that.currentAmountMinor,_that.reductionPercentage,_that.estimatedSavingMinor,_that.month,_that.year,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingRecommendation implements SavingRecommendation {
  const _SavingRecommendation({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'item_id') this.itemId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'baseline_amount_minor') required this.baselineAmountMinor, @JsonKey(name: 'current_amount_minor') required this.currentAmountMinor, @JsonKey(name: 'reduction_percentage') required this.reductionPercentage, @JsonKey(name: 'estimated_saving_minor') required this.estimatedSavingMinor, required this.month, required this.year, this.status = RecommendationStatus.active, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _SavingRecommendation.fromJson(Map<String, dynamic> json) => _$SavingRecommendationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'item_id') final  String? itemId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'baseline_amount_minor') final  int baselineAmountMinor;
@override@JsonKey(name: 'current_amount_minor') final  int currentAmountMinor;
@override@JsonKey(name: 'reduction_percentage') final  double reductionPercentage;
@override@JsonKey(name: 'estimated_saving_minor') final  int estimatedSavingMinor;
@override final  int month;
@override final  int year;
@override@JsonKey() final  RecommendationStatus status;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of SavingRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingRecommendationCopyWith<_SavingRecommendation> get copyWith => __$SavingRecommendationCopyWithImpl<_SavingRecommendation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingRecommendationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingRecommendation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.baselineAmountMinor, baselineAmountMinor) || other.baselineAmountMinor == baselineAmountMinor)&&(identical(other.currentAmountMinor, currentAmountMinor) || other.currentAmountMinor == currentAmountMinor)&&(identical(other.reductionPercentage, reductionPercentage) || other.reductionPercentage == reductionPercentage)&&(identical(other.estimatedSavingMinor, estimatedSavingMinor) || other.estimatedSavingMinor == estimatedSavingMinor)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,itemId,categoryId,baselineAmountMinor,currentAmountMinor,reductionPercentage,estimatedSavingMinor,month,year,status,createdAt,updatedAt);
}

@override
String toString() {
    return 'SavingRecommendation(id: $id, userId: $userId, itemId: $itemId, categoryId: $categoryId, baselineAmountMinor: $baselineAmountMinor, currentAmountMinor: $currentAmountMinor, reductionPercentage: $reductionPercentage, estimatedSavingMinor: $estimatedSavingMinor, month: $month, year: $year, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SavingRecommendationCopyWith<$Res> implements $SavingRecommendationCopyWith<$Res> {
  factory _$SavingRecommendationCopyWith(_SavingRecommendation value, $Res Function(_SavingRecommendation) _then) = __$SavingRecommendationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'baseline_amount_minor') int baselineAmountMinor,@JsonKey(name: 'current_amount_minor') int currentAmountMinor,@JsonKey(name: 'reduction_percentage') double reductionPercentage,@JsonKey(name: 'estimated_saving_minor') int estimatedSavingMinor, int month, int year, RecommendationStatus status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$SavingRecommendationCopyWithImpl<$Res>
    implements _$SavingRecommendationCopyWith<$Res> {
  __$SavingRecommendationCopyWithImpl(this._self, this._then);

  final _SavingRecommendation _self;
  final $Res Function(_SavingRecommendation) _then;

/// Create a copy of SavingRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemId = freezed,Object? categoryId = freezed,Object? baselineAmountMinor = null,Object? currentAmountMinor = null,Object? reductionPercentage = null,Object? estimatedSavingMinor = null,Object? month = null,Object? year = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SavingRecommendation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,baselineAmountMinor: null == baselineAmountMinor ? _self.baselineAmountMinor : baselineAmountMinor // ignore: cast_nullable_to_non_nullable
as int,currentAmountMinor: null == currentAmountMinor ? _self.currentAmountMinor : currentAmountMinor // ignore: cast_nullable_to_non_nullable
as int,reductionPercentage: null == reductionPercentage ? _self.reductionPercentage : reductionPercentage // ignore: cast_nullable_to_non_nullable
as double,estimatedSavingMinor: null == estimatedSavingMinor ? _self.estimatedSavingMinor : estimatedSavingMinor // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecommendationStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
