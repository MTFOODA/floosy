// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String? get nameAr => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_minor')
  int get priceMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_archived')
  bool get isArchived => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? description,
      @JsonKey(name: 'price_minor') int priceMinor,
      String currency,
      @JsonKey(name: 'category_id') String? categoryId,
      String? icon,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? priceMinor = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? isArchived = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priceMinor: null == priceMinor
          ? _value.priceMinor
          : priceMinor // ignore: cast_nullable_to_non_nullable
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
          _$ItemImpl value, $Res Function(_$ItemImpl) then) =
      __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? description,
      @JsonKey(name: 'price_minor') int priceMinor,
      String currency,
      @JsonKey(name: 'category_id') String? categoryId,
      String? icon,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? priceMinor = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? isArchived = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ItemImpl(
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priceMinor: null == priceMinor
          ? _value.priceMinor
          : priceMinor // ignore: cast_nullable_to_non_nullable
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
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
class _$ItemImpl implements _Item {
  const _$ItemImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'name_ar') this.nameAr,
      this.description,
      @JsonKey(name: 'price_minor') required this.priceMinor,
      this.currency = 'EGP',
      @JsonKey(name: 'category_id') this.categoryId,
      this.icon,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_archived') this.isArchived = false,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

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
  final String? description;
  @override
  @JsonKey(name: 'price_minor')
  final int priceMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Item(id: $id, userId: $userId, name: $name, nameAr: $nameAr, description: $description, priceMinor: $priceMinor, currency: $currency, categoryId: $categoryId, icon: $icon, imageUrl: $imageUrl, isActive: $isActive, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priceMinor, priceMinor) ||
                other.priceMinor == priceMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
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
      description,
      priceMinor,
      currency,
      categoryId,
      icon,
      imageUrl,
      isActive,
      isArchived,
      createdAt,
      updatedAt);

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(
      this,
    );
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'name_ar') final String? nameAr,
      final String? description,
      @JsonKey(name: 'price_minor') required final int priceMinor,
      final String currency,
      @JsonKey(name: 'category_id') final String? categoryId,
      final String? icon,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_archived') final bool isArchived,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

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
  String? get description;
  @override
  @JsonKey(name: 'price_minor')
  int get priceMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_archived')
  bool get isArchived;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItemPriceHistory _$ItemPriceHistoryFromJson(Map<String, dynamic> json) {
  return _ItemPriceHistory.fromJson(json);
}

/// @nodoc
mixin _$ItemPriceHistory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_minor')
  int get priceMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
  DateTime get effectiveFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
  DateTime? get effectiveTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ItemPriceHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemPriceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemPriceHistoryCopyWith<ItemPriceHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemPriceHistoryCopyWith<$Res> {
  factory $ItemPriceHistoryCopyWith(
          ItemPriceHistory value, $Res Function(ItemPriceHistory) then) =
      _$ItemPriceHistoryCopyWithImpl<$Res, ItemPriceHistory>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'price_minor') int priceMinor,
      @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
      DateTime effectiveFrom,
      @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
      DateTime? effectiveTo,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$ItemPriceHistoryCopyWithImpl<$Res, $Val extends ItemPriceHistory>
    implements $ItemPriceHistoryCopyWith<$Res> {
  _$ItemPriceHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemPriceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? priceMinor = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      priceMinor: null == priceMinor
          ? _value.priceMinor
          : priceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      effectiveFrom: null == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemPriceHistoryImplCopyWith<$Res>
    implements $ItemPriceHistoryCopyWith<$Res> {
  factory _$$ItemPriceHistoryImplCopyWith(_$ItemPriceHistoryImpl value,
          $Res Function(_$ItemPriceHistoryImpl) then) =
      __$$ItemPriceHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'price_minor') int priceMinor,
      @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
      DateTime effectiveFrom,
      @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
      DateTime? effectiveTo,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$ItemPriceHistoryImplCopyWithImpl<$Res>
    extends _$ItemPriceHistoryCopyWithImpl<$Res, _$ItemPriceHistoryImpl>
    implements _$$ItemPriceHistoryImplCopyWith<$Res> {
  __$$ItemPriceHistoryImplCopyWithImpl(_$ItemPriceHistoryImpl _value,
      $Res Function(_$ItemPriceHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemPriceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? priceMinor = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ItemPriceHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      priceMinor: null == priceMinor
          ? _value.priceMinor
          : priceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      effectiveFrom: null == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemPriceHistoryImpl implements _ItemPriceHistory {
  const _$ItemPriceHistoryImpl(
      {required this.id,
      @JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'price_minor') required this.priceMinor,
      @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
      required this.effectiveFrom,
      @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
      this.effectiveTo,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$ItemPriceHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemPriceHistoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'price_minor')
  final int priceMinor;
  @override
  @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
  final DateTime effectiveFrom;
  @override
  @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
  final DateTime? effectiveTo;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ItemPriceHistory(id: $id, itemId: $itemId, priceMinor: $priceMinor, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemPriceHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.priceMinor, priceMinor) ||
                other.priceMinor == priceMinor) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, itemId, priceMinor,
      effectiveFrom, effectiveTo, createdAt);

  /// Create a copy of ItemPriceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemPriceHistoryImplCopyWith<_$ItemPriceHistoryImpl> get copyWith =>
      __$$ItemPriceHistoryImplCopyWithImpl<_$ItemPriceHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemPriceHistoryImplToJson(
      this,
    );
  }
}

abstract class _ItemPriceHistory implements ItemPriceHistory {
  const factory _ItemPriceHistory(
      {required final String id,
      @JsonKey(name: 'item_id') required final String itemId,
      @JsonKey(name: 'price_minor') required final int priceMinor,
      @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
      required final DateTime effectiveFrom,
      @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
      final DateTime? effectiveTo,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$ItemPriceHistoryImpl;

  factory _ItemPriceHistory.fromJson(Map<String, dynamic> json) =
      _$ItemPriceHistoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'price_minor')
  int get priceMinor;
  @override
  @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
  DateTime get effectiveFrom;
  @override
  @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
  DateTime? get effectiveTo;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of ItemPriceHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemPriceHistoryImplCopyWith<_$ItemPriceHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String? get nameAr => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_system')
  bool get isSystem => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? icon,
      @JsonKey(name: 'parent_id') String? parentId,
      String type,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? nameAr = freezed,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? type = null,
    Object? isSystem = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? icon,
      @JsonKey(name: 'parent_id') String? parentId,
      String type,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? nameAr = freezed,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? type = null,
    Object? isSystem = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {required this.id,
      @JsonKey(name: 'user_id') this.userId,
      required this.name,
      @JsonKey(name: 'name_ar') this.nameAr,
      this.icon,
      @JsonKey(name: 'parent_id') this.parentId,
      this.type = 'expense',
      @JsonKey(name: 'is_system') this.isSystem = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'is_system')
  final bool isSystem;
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
    return 'Category(id: $id, userId: $userId, name: $name, nameAr: $nameAr, icon: $icon, parentId: $parentId, type: $type, isSystem: $isSystem, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, nameAr, icon,
      parentId, type, isSystem, isActive, createdAt, updatedAt);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(
      this,
    );
  }
}

abstract class _Category implements Category {
  const factory _Category(
      {required final String id,
      @JsonKey(name: 'user_id') final String? userId,
      required final String name,
      @JsonKey(name: 'name_ar') final String? nameAr,
      final String? icon,
      @JsonKey(name: 'parent_id') final String? parentId,
      final String type,
      @JsonKey(name: 'is_system') final bool isSystem,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_ar')
  String? get nameAr;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  String get type;
  @override
  @JsonKey(name: 'is_system')
  bool get isSystem;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Merchant _$MerchantFromJson(Map<String, dynamic> json) {
  return _Merchant.fromJson(json);
}

/// @nodoc
mixin _$Merchant {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'normalized_name')
  String get normalizedName => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Merchant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantCopyWith<Merchant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantCopyWith<$Res> {
  factory $MerchantCopyWith(Merchant value, $Res Function(Merchant) then) =
      _$MerchantCopyWithImpl<$Res, Merchant>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$MerchantCopyWithImpl<$Res, $Val extends Merchant>
    implements $MerchantCopyWith<$Res> {
  _$MerchantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? normalizedName = null,
    Object? categoryId = freezed,
    Object? logoUrl = freezed,
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
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MerchantImplCopyWith<$Res>
    implements $MerchantCopyWith<$Res> {
  factory _$$MerchantImplCopyWith(
          _$MerchantImpl value, $Res Function(_$MerchantImpl) then) =
      __$$MerchantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'logo_url') String? logoUrl,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$MerchantImplCopyWithImpl<$Res>
    extends _$MerchantCopyWithImpl<$Res, _$MerchantImpl>
    implements _$$MerchantImplCopyWith<$Res> {
  __$$MerchantImplCopyWithImpl(
      _$MerchantImpl _value, $Res Function(_$MerchantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? normalizedName = null,
    Object? categoryId = freezed,
    Object? logoUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MerchantImpl(
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
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
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
class _$MerchantImpl implements _Merchant {
  const _$MerchantImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'normalized_name') required this.normalizedName,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'logo_url') this.logoUrl,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$MerchantImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'normalized_name')
  final String normalizedName;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Merchant(id: $id, userId: $userId, name: $name, normalizedName: $normalizedName, categoryId: $categoryId, logoUrl: $logoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.normalizedName, normalizedName) ||
                other.normalizedName == normalizedName) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, normalizedName,
      categoryId, logoUrl, createdAt, updatedAt);

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantImplCopyWith<_$MerchantImpl> get copyWith =>
      __$$MerchantImplCopyWithImpl<_$MerchantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantImplToJson(
      this,
    );
  }
}

abstract class _Merchant implements Merchant {
  const factory _Merchant(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      @JsonKey(name: 'normalized_name') required final String normalizedName,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'logo_url') final String? logoUrl,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$MerchantImpl;

  factory _Merchant.fromJson(Map<String, dynamic> json) =
      _$MerchantImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'normalized_name')
  String get normalizedName;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantImplCopyWith<_$MerchantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashWallet _$CashWalletFromJson(Map<String, dynamic> json) {
  return _CashWallet.fromJson(json);
}

/// @nodoc
mixin _$CashWallet {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CashWallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashWalletCopyWith<CashWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashWalletCopyWith<$Res> {
  factory $CashWalletCopyWith(
          CashWallet value, $Res Function(CashWallet) then) =
      _$CashWalletCopyWithImpl<$Res, CashWallet>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String currency,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$CashWalletCopyWithImpl<$Res, $Val extends CashWallet>
    implements $CashWalletCopyWith<$Res> {
  _$CashWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? currency = null,
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
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CashWalletImplCopyWith<$Res>
    implements $CashWalletCopyWith<$Res> {
  factory _$$CashWalletImplCopyWith(
          _$CashWalletImpl value, $Res Function(_$CashWalletImpl) then) =
      __$$CashWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String currency,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$CashWalletImplCopyWithImpl<$Res>
    extends _$CashWalletCopyWithImpl<$Res, _$CashWalletImpl>
    implements _$$CashWalletImplCopyWith<$Res> {
  __$$CashWalletImplCopyWithImpl(
      _$CashWalletImpl _value, $Res Function(_$CashWalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? currency = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CashWalletImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
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
class _$CashWalletImpl implements _CashWallet {
  const _$CashWalletImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      this.currency = 'EGP',
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$CashWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashWalletImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CashWallet(id: $id, userId: $userId, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashWalletImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, currency, createdAt, updatedAt);

  /// Create a copy of CashWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashWalletImplCopyWith<_$CashWalletImpl> get copyWith =>
      __$$CashWalletImplCopyWithImpl<_$CashWalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashWalletImplToJson(
      this,
    );
  }
}

abstract class _CashWallet implements CashWallet {
  const factory _CashWallet(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      final String currency,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$CashWalletImpl;

  factory _CashWallet.fromJson(Map<String, dynamic> json) =
      _$CashWalletImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get currency;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of CashWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashWalletImplCopyWith<_$CashWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashMovement _$CashMovementFromJson(Map<String, dynamic> json) {
  return _CashMovement.fromJson(json);
}

/// @nodoc
mixin _$CashMovement {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'wallet_id')
  String get walletId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String? get referenceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get movementDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CashMovement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashMovementCopyWith<CashMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashMovementCopyWith<$Res> {
  factory $CashMovementCopyWith(
          CashMovement value, $Res Function(CashMovement) then) =
      _$CashMovementCopyWithImpl<$Res, CashMovement>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'wallet_id') String walletId,
      String type,
      @JsonKey(name: 'amount_minor') int amountMinor,
      @JsonKey(name: 'reference_type') String? referenceType,
      @JsonKey(name: 'reference_id') String? referenceId,
      String? description,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$CashMovementCopyWithImpl<$Res, $Val extends CashMovement>
    implements $CashMovementCopyWith<$Res> {
  _$CashMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? walletId = null,
    Object? type = null,
    Object? amountMinor = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? description = freezed,
    Object? movementDate = null,
    Object? createdAt = freezed,
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
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CashMovementImplCopyWith<$Res>
    implements $CashMovementCopyWith<$Res> {
  factory _$$CashMovementImplCopyWith(
          _$CashMovementImpl value, $Res Function(_$CashMovementImpl) then) =
      __$$CashMovementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'wallet_id') String walletId,
      String type,
      @JsonKey(name: 'amount_minor') int amountMinor,
      @JsonKey(name: 'reference_type') String? referenceType,
      @JsonKey(name: 'reference_id') String? referenceId,
      String? description,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$CashMovementImplCopyWithImpl<$Res>
    extends _$CashMovementCopyWithImpl<$Res, _$CashMovementImpl>
    implements _$$CashMovementImplCopyWith<$Res> {
  __$$CashMovementImplCopyWithImpl(
      _$CashMovementImpl _value, $Res Function(_$CashMovementImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? walletId = null,
    Object? type = null,
    Object? amountMinor = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? description = freezed,
    Object? movementDate = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$CashMovementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
class _$CashMovementImpl implements _CashMovement {
  const _$CashMovementImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'wallet_id') required this.walletId,
      required this.type,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      @JsonKey(name: 'reference_type') this.referenceType,
      @JsonKey(name: 'reference_id') this.referenceId,
      this.description,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      required this.movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$CashMovementImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashMovementImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'wallet_id')
  final String walletId;
  @override
  final String type;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime movementDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CashMovement(id: $id, userId: $userId, walletId: $walletId, type: $type, amountMinor: $amountMinor, referenceType: $referenceType, referenceId: $referenceId, description: $description, movementDate: $movementDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashMovementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
      userId,
      walletId,
      type,
      amountMinor,
      referenceType,
      referenceId,
      description,
      movementDate,
      createdAt);

  /// Create a copy of CashMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashMovementImplCopyWith<_$CashMovementImpl> get copyWith =>
      __$$CashMovementImplCopyWithImpl<_$CashMovementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashMovementImplToJson(
      this,
    );
  }
}

abstract class _CashMovement implements CashMovement {
  const factory _CashMovement(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'wallet_id') required final String walletId,
      required final String type,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      @JsonKey(name: 'reference_type') final String? referenceType,
      @JsonKey(name: 'reference_id') final String? referenceId,
      final String? description,
      @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime movementDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$CashMovementImpl;

  factory _CashMovement.fromJson(Map<String, dynamic> json) =
      _$CashMovementImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'wallet_id')
  String get walletId;
  @override
  String get type;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get movementDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of CashMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashMovementImplCopyWith<_$CashMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
