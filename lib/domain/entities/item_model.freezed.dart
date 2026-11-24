// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Item {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'name_ar') String? get nameAr; String? get description;@JsonKey(name: 'price_minor') int get priceMinor; String get currency;@JsonKey(name: 'category_id') String? get categoryId; String? get icon;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_archived') bool get isArchived;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Item;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Item;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.nameAr,_this.description,_this.priceMinor,_this.currency,_this.categoryId,_this.icon,_this.imageUrl,_this.isActive,_this.isArchived,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Item;
  return 'Item(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, nameAr: ${_this.nameAr}, description: ${_this.description}, priceMinor: ${_this.priceMinor}, currency: ${_this.currency}, categoryId: ${_this.categoryId}, icon: ${_this.icon}, imageUrl: ${_this.imageUrl}, isActive: ${_this.isActive}, isArchived: ${_this.isArchived}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'name_ar') String? nameAr, String? description,@JsonKey(name: 'price_minor') int priceMinor, String currency,@JsonKey(name: 'category_id') String? categoryId, String? icon,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_archived') bool isArchived,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? priceMinor = null,Object? currency = null,Object? categoryId = freezed,Object? icon = freezed,Object? imageUrl = freezed,Object? isActive = null,Object? isArchived = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'price_minor')  int priceMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_archived')  bool isArchived, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.description,_that.priceMinor,_that.currency,_that.categoryId,_that.icon,_that.imageUrl,_that.isActive,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'price_minor')  int priceMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_archived')  bool isArchived, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.description,_that.priceMinor,_that.currency,_that.categoryId,_that.icon,_that.imageUrl,_that.isActive,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'price_minor')  int priceMinor,  String currency, @JsonKey(name: 'category_id')  String? categoryId,  String? icon, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_archived')  bool isArchived, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.description,_that.priceMinor,_that.currency,_that.categoryId,_that.icon,_that.imageUrl,_that.isActive,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Item implements Item {
  const _Item({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'name_ar') this.nameAr, this.description, @JsonKey(name: 'price_minor') required this.priceMinor, this.currency = 'EGP', @JsonKey(name: 'category_id') this.categoryId, this.icon, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'is_archived') this.isArchived = false, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String? nameAr;
@override final  String? description;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override final  String? icon;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_archived') final  bool isArchived;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,nameAr,description,priceMinor,currency,categoryId,icon,imageUrl,isActive,isArchived,createdAt,updatedAt);
}

@override
String toString() {
    return 'Item(id: $id, userId: $userId, name: $name, nameAr: $nameAr, description: $description, priceMinor: $priceMinor, currency: $currency, categoryId: $categoryId, icon: $icon, imageUrl: $imageUrl, isActive: $isActive, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'name_ar') String? nameAr, String? description,@JsonKey(name: 'price_minor') int priceMinor, String currency,@JsonKey(name: 'category_id') String? categoryId, String? icon,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_archived') bool isArchived,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? priceMinor = null,Object? currency = null,Object? categoryId = freezed,Object? icon = freezed,Object? imageUrl = freezed,Object? isActive = null,Object? isArchived = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ItemPriceHistory {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'price_minor') int get priceMinor;@JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired) DateTime get effectiveFrom;@JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson) DateTime? get effectiveTo;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of ItemPriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemPriceHistoryCopyWith<ItemPriceHistory> get copyWith => _$ItemPriceHistoryCopyWithImpl<ItemPriceHistory>(this as ItemPriceHistory, _$identity);

  /// Serializes this ItemPriceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemPriceHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemPriceHistory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.effectiveFrom, _this.effectiveFrom) || other.effectiveFrom == _this.effectiveFrom)&&(identical(other.effectiveTo, _this.effectiveTo) || other.effectiveTo == _this.effectiveTo)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemPriceHistory;
  return Object.hash(runtimeType,_this.id,_this.itemId,_this.priceMinor,_this.effectiveFrom,_this.effectiveTo,_this.createdAt);
}

@override
String toString() {
  final _this = this as ItemPriceHistory;
  return 'ItemPriceHistory(id: ${_this.id}, itemId: ${_this.itemId}, priceMinor: ${_this.priceMinor}, effectiveFrom: ${_this.effectiveFrom}, effectiveTo: ${_this.effectiveTo}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ItemPriceHistoryCopyWith<$Res>  {
  factory $ItemPriceHistoryCopyWith(ItemPriceHistory value, $Res Function(ItemPriceHistory) _then) = _$ItemPriceHistoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired) DateTime effectiveFrom,@JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson) DateTime? effectiveTo,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$ItemPriceHistoryCopyWithImpl<$Res>
    implements $ItemPriceHistoryCopyWith<$Res> {
  _$ItemPriceHistoryCopyWithImpl(this._self, this._then);

  final ItemPriceHistory _self;
  final $Res Function(ItemPriceHistory) _then;

/// Create a copy of ItemPriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? priceMinor = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? createdAt = freezed,}) {
  return _then(ItemPriceHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemPriceHistory].
extension ItemPriceHistoryPatterns on ItemPriceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemPriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemPriceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemPriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _ItemPriceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemPriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ItemPriceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)  DateTime effectiveFrom, @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)  DateTime? effectiveTo, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemPriceHistory() when $default != null:
return $default(_that.id,_that.itemId,_that.priceMinor,_that.effectiveFrom,_that.effectiveTo,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)  DateTime effectiveFrom, @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)  DateTime? effectiveTo, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ItemPriceHistory():
return $default(_that.id,_that.itemId,_that.priceMinor,_that.effectiveFrom,_that.effectiveTo,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)  DateTime effectiveFrom, @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)  DateTime? effectiveTo, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemPriceHistory() when $default != null:
return $default(_that.id,_that.itemId,_that.priceMinor,_that.effectiveFrom,_that.effectiveTo,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemPriceHistory implements ItemPriceHistory {
  const _ItemPriceHistory({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'price_minor') required this.priceMinor, @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired) required this.effectiveFrom, @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson) this.effectiveTo, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _ItemPriceHistory.fromJson(Map<String, dynamic> json) => _$ItemPriceHistoryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired) final  DateTime effectiveFrom;
@override@JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson) final  DateTime? effectiveTo;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of ItemPriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemPriceHistoryCopyWith<_ItemPriceHistory> get copyWith => __$ItemPriceHistoryCopyWithImpl<_ItemPriceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemPriceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemPriceHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,itemId,priceMinor,effectiveFrom,effectiveTo,createdAt);
}

@override
String toString() {
    return 'ItemPriceHistory(id: $id, itemId: $itemId, priceMinor: $priceMinor, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ItemPriceHistoryCopyWith<$Res> implements $ItemPriceHistoryCopyWith<$Res> {
  factory _$ItemPriceHistoryCopyWith(_ItemPriceHistory value, $Res Function(_ItemPriceHistory) _then) = __$ItemPriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired) DateTime effectiveFrom,@JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson) DateTime? effectiveTo,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$ItemPriceHistoryCopyWithImpl<$Res>
    implements _$ItemPriceHistoryCopyWith<$Res> {
  __$ItemPriceHistoryCopyWithImpl(this._self, this._then);

  final _ItemPriceHistory _self;
  final $Res Function(_ItemPriceHistory) _then;

/// Create a copy of ItemPriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? priceMinor = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? createdAt = freezed,}) {
  return _then(_ItemPriceHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Category {

 String get id;@JsonKey(name: 'user_id') String? get userId; String get name;@JsonKey(name: 'name_ar') String? get nameAr; String? get icon;@JsonKey(name: 'parent_id') String? get parentId; String get type;@JsonKey(name: 'is_system') bool get isSystem;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Category;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Category;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.nameAr,_this.icon,_this.parentId,_this.type,_this.isSystem,_this.isActive,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Category;
  return 'Category(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, nameAr: ${_this.nameAr}, icon: ${_this.icon}, parentId: ${_this.parentId}, type: ${_this.type}, isSystem: ${_this.isSystem}, isActive: ${_this.isActive}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String name,@JsonKey(name: 'name_ar') String? nameAr, String? icon,@JsonKey(name: 'parent_id') String? parentId, String type,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? nameAr = freezed,Object? icon = freezed,Object? parentId = freezed,Object? type = null,Object? isSystem = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? icon, @JsonKey(name: 'parent_id')  String? parentId,  String type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.icon,_that.parentId,_that.type,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? icon, @JsonKey(name: 'parent_id')  String? parentId,  String type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.icon,_that.parentId,_that.type,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? icon, @JsonKey(name: 'parent_id')  String? parentId,  String type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.nameAr,_that.icon,_that.parentId,_that.type,_that.isSystem,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, @JsonKey(name: 'user_id') this.userId, required this.name, @JsonKey(name: 'name_ar') this.nameAr, this.icon, @JsonKey(name: 'parent_id') this.parentId, this.type = 'expense', @JsonKey(name: 'is_system') this.isSystem = false, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String? nameAr;
@override final  String? icon;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey() final  String type;
@override@JsonKey(name: 'is_system') final  bool isSystem;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,nameAr,icon,parentId,type,isSystem,isActive,createdAt,updatedAt);
}

@override
String toString() {
    return 'Category(id: $id, userId: $userId, name: $name, nameAr: $nameAr, icon: $icon, parentId: $parentId, type: $type, isSystem: $isSystem, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String name,@JsonKey(name: 'name_ar') String? nameAr, String? icon,@JsonKey(name: 'parent_id') String? parentId, String type,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? nameAr = freezed,Object? icon = freezed,Object? parentId = freezed,Object? type = null,Object? isSystem = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Merchant {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'normalized_name') String get normalizedName;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantCopyWith<Merchant> get copyWith => _$MerchantCopyWithImpl<Merchant>(this as Merchant, _$identity);

  /// Serializes this Merchant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Merchant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Merchant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.normalizedName, _this.normalizedName) || other.normalizedName == _this.normalizedName)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Merchant;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.normalizedName,_this.categoryId,_this.logoUrl,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Merchant;
  return 'Merchant(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, normalizedName: ${_this.normalizedName}, categoryId: ${_this.categoryId}, logoUrl: ${_this.logoUrl}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MerchantCopyWith<$Res>  {
  factory $MerchantCopyWith(Merchant value, $Res Function(Merchant) _then) = _$MerchantCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'normalized_name') String normalizedName,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$MerchantCopyWithImpl<$Res>
    implements $MerchantCopyWith<$Res> {
  _$MerchantCopyWithImpl(this._self, this._then);

  final Merchant _self;
  final $Res Function(Merchant) _then;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? normalizedName = null,Object? categoryId = freezed,Object? logoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Merchant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Merchant].
extension MerchantPatterns on Merchant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Merchant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Merchant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Merchant value)  $default,){
final _that = this;
switch (_that) {
case _Merchant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Merchant value)?  $default,){
final _that = this;
switch (_that) {
case _Merchant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'normalized_name')  String normalizedName, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Merchant() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.normalizedName,_that.categoryId,_that.logoUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'normalized_name')  String normalizedName, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Merchant():
return $default(_that.id,_that.userId,_that.name,_that.normalizedName,_that.categoryId,_that.logoUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'normalized_name')  String normalizedName, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Merchant() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.normalizedName,_that.categoryId,_that.logoUrl,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Merchant implements Merchant {
  const _Merchant({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'normalized_name') required this.normalizedName, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Merchant.fromJson(Map<String, dynamic> json) => _$MerchantFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'normalized_name') final  String normalizedName;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantCopyWith<_Merchant> get copyWith => __$MerchantCopyWithImpl<_Merchant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Merchant&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,normalizedName,categoryId,logoUrl,createdAt,updatedAt);
}

@override
String toString() {
    return 'Merchant(id: $id, userId: $userId, name: $name, normalizedName: $normalizedName, categoryId: $categoryId, logoUrl: $logoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MerchantCopyWith<$Res> implements $MerchantCopyWith<$Res> {
  factory _$MerchantCopyWith(_Merchant value, $Res Function(_Merchant) _then) = __$MerchantCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'normalized_name') String normalizedName,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$MerchantCopyWithImpl<$Res>
    implements _$MerchantCopyWith<$Res> {
  __$MerchantCopyWithImpl(this._self, this._then);

  final _Merchant _self;
  final $Res Function(_Merchant) _then;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? normalizedName = null,Object? categoryId = freezed,Object? logoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Merchant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CashWallet {

 String get id;@JsonKey(name: 'user_id') String get userId; String get currency;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of CashWallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashWalletCopyWith<CashWallet> get copyWith => _$CashWalletCopyWithImpl<CashWallet>(this as CashWallet, _$identity);

  /// Serializes this CashWallet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CashWallet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashWallet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CashWallet;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.currency,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as CashWallet;
  return 'CashWallet(id: ${_this.id}, userId: ${_this.userId}, currency: ${_this.currency}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CashWalletCopyWith<$Res>  {
  factory $CashWalletCopyWith(CashWallet value, $Res Function(CashWallet) _then) = _$CashWalletCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String currency,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CashWalletCopyWithImpl<$Res>
    implements $CashWalletCopyWith<$Res> {
  _$CashWalletCopyWithImpl(this._self, this._then);

  final CashWallet _self;
  final $Res Function(CashWallet) _then;

/// Create a copy of CashWallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? currency = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(CashWallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashWallet].
extension CashWalletPatterns on CashWallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashWallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashWallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashWallet value)  $default,){
final _that = this;
switch (_that) {
case _CashWallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashWallet value)?  $default,){
final _that = this;
switch (_that) {
case _CashWallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String currency, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashWallet() when $default != null:
return $default(_that.id,_that.userId,_that.currency,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String currency, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CashWallet():
return $default(_that.id,_that.userId,_that.currency,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String currency, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CashWallet() when $default != null:
return $default(_that.id,_that.userId,_that.currency,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashWallet implements CashWallet {
  const _CashWallet({required this.id, @JsonKey(name: 'user_id') required this.userId, this.currency = 'EGP', @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _CashWallet.fromJson(Map<String, dynamic> json) => _$CashWalletFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of CashWallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashWalletCopyWith<_CashWallet> get copyWith => __$CashWalletCopyWithImpl<_CashWallet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashWalletToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashWallet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,currency,createdAt,updatedAt);
}

@override
String toString() {
    return 'CashWallet(id: $id, userId: $userId, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CashWalletCopyWith<$Res> implements $CashWalletCopyWith<$Res> {
  factory _$CashWalletCopyWith(_CashWallet value, $Res Function(_CashWallet) _then) = __$CashWalletCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String currency,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CashWalletCopyWithImpl<$Res>
    implements _$CashWalletCopyWith<$Res> {
  __$CashWalletCopyWithImpl(this._self, this._then);

  final _CashWallet _self;
  final $Res Function(_CashWallet) _then;

/// Create a copy of CashWallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? currency = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CashWallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CashMovement {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'wallet_id') String get walletId; String get type;@JsonKey(name: 'amount_minor') int get amountMinor;@JsonKey(name: 'reference_type') String? get referenceType;@JsonKey(name: 'reference_id') String? get referenceId; String? get description;@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime get movementDate;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashMovementCopyWith<CashMovement> get copyWith => _$CashMovementCopyWithImpl<CashMovement>(this as CashMovement, _$identity);

  /// Serializes this CashMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CashMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashMovement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.referenceId, _this.referenceId) || other.referenceId == _this.referenceId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.movementDate, _this.movementDate) || other.movementDate == _this.movementDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CashMovement;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.walletId,_this.type,_this.amountMinor,_this.referenceType,_this.referenceId,_this.description,_this.movementDate,_this.createdAt);
}

@override
String toString() {
  final _this = this as CashMovement;
  return 'CashMovement(id: ${_this.id}, userId: ${_this.userId}, walletId: ${_this.walletId}, type: ${_this.type}, amountMinor: ${_this.amountMinor}, referenceType: ${_this.referenceType}, referenceId: ${_this.referenceId}, description: ${_this.description}, movementDate: ${_this.movementDate}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CashMovementCopyWith<$Res>  {
  factory $CashMovementCopyWith(CashMovement value, $Res Function(CashMovement) _then) = _$CashMovementCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'wallet_id') String walletId, String type,@JsonKey(name: 'amount_minor') int amountMinor,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId, String? description,@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime movementDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$CashMovementCopyWithImpl<$Res>
    implements $CashMovementCopyWith<$Res> {
  _$CashMovementCopyWithImpl(this._self, this._then);

  final CashMovement _self;
  final $Res Function(CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? walletId = null,Object? type = null,Object? amountMinor = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? description = freezed,Object? movementDate = null,Object? createdAt = freezed,}) {
  return _then(CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashMovement].
extension CashMovementPatterns on CashMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashMovement value)  $default,){
final _that = this;
switch (_that) {
case _CashMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashMovement value)?  $default,){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wallet_id')  String walletId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId,  String? description, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.userId,_that.walletId,_that.type,_that.amountMinor,_that.referenceType,_that.referenceId,_that.description,_that.movementDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wallet_id')  String walletId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId,  String? description, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CashMovement():
return $default(_that.id,_that.userId,_that.walletId,_that.type,_that.amountMinor,_that.referenceType,_that.referenceId,_that.description,_that.movementDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'wallet_id')  String walletId,  String type, @JsonKey(name: 'amount_minor')  int amountMinor, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId,  String? description, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)  DateTime movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.userId,_that.walletId,_that.type,_that.amountMinor,_that.referenceType,_that.referenceId,_that.description,_that.movementDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashMovement implements CashMovement {
  const _CashMovement({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'wallet_id') required this.walletId, required this.type, @JsonKey(name: 'amount_minor') required this.amountMinor, @JsonKey(name: 'reference_type') this.referenceType, @JsonKey(name: 'reference_id') this.referenceId, this.description, @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) required this.movementDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _CashMovement.fromJson(Map<String, dynamic> json) => _$CashMovementFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'wallet_id') final  String walletId;
@override final  String type;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey(name: 'reference_type') final  String? referenceType;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override final  String? description;
@override@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) final  DateTime movementDate;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashMovementCopyWith<_CashMovement> get copyWith => __$CashMovementCopyWithImpl<_CashMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashMovementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.movementDate, movementDate) || other.movementDate == movementDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,walletId,type,amountMinor,referenceType,referenceId,description,movementDate,createdAt);
}

@override
String toString() {
    return 'CashMovement(id: $id, userId: $userId, walletId: $walletId, type: $type, amountMinor: $amountMinor, referenceType: $referenceType, referenceId: $referenceId, description: $description, movementDate: $movementDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CashMovementCopyWith<$Res> implements $CashMovementCopyWith<$Res> {
  factory _$CashMovementCopyWith(_CashMovement value, $Res Function(_CashMovement) _then) = __$CashMovementCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'wallet_id') String walletId, String type,@JsonKey(name: 'amount_minor') int amountMinor,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId, String? description,@JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired) DateTime movementDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$CashMovementCopyWithImpl<$Res>
    implements _$CashMovementCopyWith<$Res> {
  __$CashMovementCopyWithImpl(this._self, this._then);

  final _CashMovement _self;
  final $Res Function(_CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? walletId = null,Object? type = null,Object? amountMinor = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? description = freezed,Object? movementDate = null,Object? createdAt = freezed,}) {
  return _then(_CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
