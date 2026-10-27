// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  AlertType get type => throw _privateConstructorUsedError;
  AlertSeverity get severity => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String? get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      AlertType type,
      AlertSeverity severity,
      @JsonKey(name: 'item_id') String? itemId,
      @JsonKey(name: 'category_id') String? categoryId,
      String title,
      String message,
      Map<String, dynamic> data,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? severity = null,
    Object? itemId = freezed,
    Object? categoryId = freezed,
    Object? title = null,
    Object? message = null,
    Object? data = null,
    Object? isRead = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
          _$AlertImpl value, $Res Function(_$AlertImpl) then) =
      __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      AlertType type,
      AlertSeverity severity,
      @JsonKey(name: 'item_id') String? itemId,
      @JsonKey(name: 'category_id') String? categoryId,
      String title,
      String message,
      Map<String, dynamic> data,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
      _$AlertImpl _value, $Res Function(_$AlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? severity = null,
    Object? itemId = freezed,
    Object? categoryId = freezed,
    Object? title = null,
    Object? message = null,
    Object? data = null,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$AlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertImpl implements _Alert {
  const _$AlertImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.type,
      this.severity = AlertSeverity.info,
      @JsonKey(name: 'item_id') this.itemId,
      @JsonKey(name: 'category_id') this.categoryId,
      required this.title,
      required this.message,
      final Map<String, dynamic> data = const {},
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt})
      : _data = data;

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final AlertType type;
  @override
  @JsonKey()
  final AlertSeverity severity;
  @override
  @JsonKey(name: 'item_id')
  final String? itemId;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  final String title;
  @override
  final String message;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Alert(id: $id, userId: $userId, type: $type, severity: $severity, itemId: $itemId, categoryId: $categoryId, title: $title, message: $message, data: $data, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      severity,
      itemId,
      categoryId,
      title,
      message,
      const DeepCollectionEquality().hash(_data),
      isRead,
      createdAt);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(
      this,
    );
  }
}

abstract class _Alert implements Alert {
  const factory _Alert(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final AlertType type,
      final AlertSeverity severity,
      @JsonKey(name: 'item_id') final String? itemId,
      @JsonKey(name: 'category_id') final String? categoryId,
      required final String title,
      required final String message,
      final Map<String, dynamic> data,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  AlertType get type;
  @override
  AlertSeverity get severity;
  @override
  @JsonKey(name: 'item_id')
  String? get itemId;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  String get title;
  @override
  String get message;
  @override
  Map<String, dynamic> get data;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return _Badge.fromJson(json);
}

/// @nodoc
mixin _$Badge {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String? get nameAr => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_ar')
  String? get descriptionAr => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  Map<String, dynamic> get criteria => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeCopyWith<Badge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeCopyWith<$Res> {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) then) =
      _$BadgeCopyWithImpl<$Res, Badge>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? description,
      @JsonKey(name: 'description_ar') String? descriptionAr,
      String? icon,
      Map<String, dynamic> criteria,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$BadgeCopyWithImpl<$Res, $Val extends Badge>
    implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? descriptionAr = freezed,
    Object? icon = freezed,
    Object? criteria = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
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
      descriptionAr: freezed == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeImplCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$$BadgeImplCopyWith(
          _$BadgeImpl value, $Res Function(_$BadgeImpl) then) =
      __$$BadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      @JsonKey(name: 'name_ar') String? nameAr,
      String? description,
      @JsonKey(name: 'description_ar') String? descriptionAr,
      String? icon,
      Map<String, dynamic> criteria,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$BadgeImplCopyWithImpl<$Res>
    extends _$BadgeCopyWithImpl<$Res, _$BadgeImpl>
    implements _$$BadgeImplCopyWith<$Res> {
  __$$BadgeImplCopyWithImpl(
      _$BadgeImpl _value, $Res Function(_$BadgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? descriptionAr = freezed,
    Object? icon = freezed,
    Object? criteria = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BadgeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
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
      descriptionAr: freezed == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: null == criteria
          ? _value._criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeImpl implements _Badge {
  const _$BadgeImpl(
      {required this.id,
      required this.code,
      required this.name,
      @JsonKey(name: 'name_ar') this.nameAr,
      this.description,
      @JsonKey(name: 'description_ar') this.descriptionAr,
      this.icon,
      final Map<String, dynamic> criteria = const {},
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt})
      : _criteria = criteria;

  factory _$BadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @override
  final String? description;
  @override
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  @override
  final String? icon;
  final Map<String, dynamic> _criteria;
  @override
  @JsonKey()
  Map<String, dynamic> get criteria {
    if (_criteria is EqualUnmodifiableMapView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_criteria);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Badge(id: $id, code: $code, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, criteria: $criteria, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.descriptionAr, descriptionAr) ||
                other.descriptionAr == descriptionAr) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      name,
      nameAr,
      description,
      descriptionAr,
      icon,
      const DeepCollectionEquality().hash(_criteria),
      createdAt);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      __$$BadgeImplCopyWithImpl<_$BadgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeImplToJson(
      this,
    );
  }
}

abstract class _Badge implements Badge {
  const factory _Badge(
      {required final String id,
      required final String code,
      required final String name,
      @JsonKey(name: 'name_ar') final String? nameAr,
      final String? description,
      @JsonKey(name: 'description_ar') final String? descriptionAr,
      final String? icon,
      final Map<String, dynamic> criteria,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$BadgeImpl;

  factory _Badge.fromJson(Map<String, dynamic> json) = _$BadgeImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_ar')
  String? get nameAr;
  @override
  String? get description;
  @override
  @JsonKey(name: 'description_ar')
  String? get descriptionAr;
  @override
  String? get icon;
  @override
  Map<String, dynamic> get criteria;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBadge _$UserBadgeFromJson(Map<String, dynamic> json) {
  return _UserBadge.fromJson(json);
}

/// @nodoc
mixin _$UserBadge {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'badge_id')
  String get badgeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
  DateTime get earnedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this UserBadge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBadgeCopyWith<UserBadge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBadgeCopyWith<$Res> {
  factory $UserBadgeCopyWith(UserBadge value, $Res Function(UserBadge) then) =
      _$UserBadgeCopyWithImpl<$Res, UserBadge>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'badge_id') String badgeId,
      @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
      DateTime earnedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$UserBadgeCopyWithImpl<$Res, $Val extends UserBadge>
    implements $UserBadgeCopyWith<$Res> {
  _$UserBadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? badgeId = null,
    Object? earnedAt = null,
    Object? metadata = null,
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
      badgeId: null == badgeId
          ? _value.badgeId
          : badgeId // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBadgeImplCopyWith<$Res>
    implements $UserBadgeCopyWith<$Res> {
  factory _$$UserBadgeImplCopyWith(
          _$UserBadgeImpl value, $Res Function(_$UserBadgeImpl) then) =
      __$$UserBadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'badge_id') String badgeId,
      @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
      DateTime earnedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$UserBadgeImplCopyWithImpl<$Res>
    extends _$UserBadgeCopyWithImpl<$Res, _$UserBadgeImpl>
    implements _$$UserBadgeImplCopyWith<$Res> {
  __$$UserBadgeImplCopyWithImpl(
      _$UserBadgeImpl _value, $Res Function(_$UserBadgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? badgeId = null,
    Object? earnedAt = null,
    Object? metadata = null,
  }) {
    return _then(_$UserBadgeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      badgeId: null == badgeId
          ? _value.badgeId
          : badgeId // ignore: cast_nullable_to_non_nullable
              as String,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBadgeImpl implements _UserBadge {
  const _$UserBadgeImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'badge_id') required this.badgeId,
      @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
      required this.earnedAt,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$UserBadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBadgeImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'badge_id')
  final String badgeId;
  @override
  @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
  final DateTime earnedAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'UserBadge(id: $id, userId: $userId, badgeId: $badgeId, earnedAt: $earnedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBadgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.badgeId, badgeId) || other.badgeId == badgeId) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, badgeId, earnedAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBadgeImplCopyWith<_$UserBadgeImpl> get copyWith =>
      __$$UserBadgeImplCopyWithImpl<_$UserBadgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBadgeImplToJson(
      this,
    );
  }
}

abstract class _UserBadge implements UserBadge {
  const factory _UserBadge(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'badge_id') required final String badgeId,
      @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
      required final DateTime earnedAt,
      final Map<String, dynamic> metadata}) = _$UserBadgeImpl;

  factory _UserBadge.fromJson(Map<String, dynamic> json) =
      _$UserBadgeImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'badge_id')
  String get badgeId;
  @override
  @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)
  DateTime get earnedAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBadgeImplCopyWith<_$UserBadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) {
  return _MonthlyReport.fromJson(json);
}

/// @nodoc
mixin _$MonthlyReport {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_income_minor')
  int get totalIncomeMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses_minor')
  int get totalExpensesMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_expenses_minor')
  int get cardExpensesMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_expenses_minor')
  int get cashExpensesMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'atm_withdrawals_minor')
  int get atmWithdrawalsMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_category_id')
  String? get topCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_item_id')
  String? get topItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_merchant_id')
  String? get topMerchantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'potential_savings_minor')
  int get potentialSavingsMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_savings_minor')
  int get actualSavingsMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MonthlyReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyReportCopyWith<MonthlyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyReportCopyWith<$Res> {
  factory $MonthlyReportCopyWith(
          MonthlyReport value, $Res Function(MonthlyReport) then) =
      _$MonthlyReportCopyWithImpl<$Res, MonthlyReport>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int year,
      int month,
      @JsonKey(name: 'total_income_minor') int totalIncomeMinor,
      @JsonKey(name: 'total_expenses_minor') int totalExpensesMinor,
      @JsonKey(name: 'card_expenses_minor') int cardExpensesMinor,
      @JsonKey(name: 'cash_expenses_minor') int cashExpensesMinor,
      @JsonKey(name: 'atm_withdrawals_minor') int atmWithdrawalsMinor,
      @JsonKey(name: 'top_category_id') String? topCategoryId,
      @JsonKey(name: 'top_item_id') String? topItemId,
      @JsonKey(name: 'top_merchant_id') String? topMerchantId,
      @JsonKey(name: 'potential_savings_minor') int potentialSavingsMinor,
      @JsonKey(name: 'actual_savings_minor') int actualSavingsMinor,
      @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
      DateTime? generatedAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res, $Val extends MonthlyReport>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? year = null,
    Object? month = null,
    Object? totalIncomeMinor = null,
    Object? totalExpensesMinor = null,
    Object? cardExpensesMinor = null,
    Object? cashExpensesMinor = null,
    Object? atmWithdrawalsMinor = null,
    Object? topCategoryId = freezed,
    Object? topItemId = freezed,
    Object? topMerchantId = freezed,
    Object? potentialSavingsMinor = null,
    Object? actualSavingsMinor = null,
    Object? generatedAt = freezed,
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
      totalIncomeMinor: null == totalIncomeMinor
          ? _value.totalIncomeMinor
          : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpensesMinor: null == totalExpensesMinor
          ? _value.totalExpensesMinor
          : totalExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cardExpensesMinor: null == cardExpensesMinor
          ? _value.cardExpensesMinor
          : cardExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cashExpensesMinor: null == cashExpensesMinor
          ? _value.cashExpensesMinor
          : cashExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      atmWithdrawalsMinor: null == atmWithdrawalsMinor
          ? _value.atmWithdrawalsMinor
          : atmWithdrawalsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      topCategoryId: freezed == topCategoryId
          ? _value.topCategoryId
          : topCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      topItemId: freezed == topItemId
          ? _value.topItemId
          : topItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      topMerchantId: freezed == topMerchantId
          ? _value.topMerchantId
          : topMerchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      potentialSavingsMinor: null == potentialSavingsMinor
          ? _value.potentialSavingsMinor
          : potentialSavingsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      actualSavingsMinor: null == actualSavingsMinor
          ? _value.actualSavingsMinor
          : actualSavingsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$MonthlyReportImplCopyWith<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  factory _$$MonthlyReportImplCopyWith(
          _$MonthlyReportImpl value, $Res Function(_$MonthlyReportImpl) then) =
      __$$MonthlyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int year,
      int month,
      @JsonKey(name: 'total_income_minor') int totalIncomeMinor,
      @JsonKey(name: 'total_expenses_minor') int totalExpensesMinor,
      @JsonKey(name: 'card_expenses_minor') int cardExpensesMinor,
      @JsonKey(name: 'cash_expenses_minor') int cashExpensesMinor,
      @JsonKey(name: 'atm_withdrawals_minor') int atmWithdrawalsMinor,
      @JsonKey(name: 'top_category_id') String? topCategoryId,
      @JsonKey(name: 'top_item_id') String? topItemId,
      @JsonKey(name: 'top_merchant_id') String? topMerchantId,
      @JsonKey(name: 'potential_savings_minor') int potentialSavingsMinor,
      @JsonKey(name: 'actual_savings_minor') int actualSavingsMinor,
      @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
      DateTime? generatedAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$MonthlyReportImplCopyWithImpl<$Res>
    extends _$MonthlyReportCopyWithImpl<$Res, _$MonthlyReportImpl>
    implements _$$MonthlyReportImplCopyWith<$Res> {
  __$$MonthlyReportImplCopyWithImpl(
      _$MonthlyReportImpl _value, $Res Function(_$MonthlyReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? year = null,
    Object? month = null,
    Object? totalIncomeMinor = null,
    Object? totalExpensesMinor = null,
    Object? cardExpensesMinor = null,
    Object? cashExpensesMinor = null,
    Object? atmWithdrawalsMinor = null,
    Object? topCategoryId = freezed,
    Object? topItemId = freezed,
    Object? topMerchantId = freezed,
    Object? potentialSavingsMinor = null,
    Object? actualSavingsMinor = null,
    Object? generatedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MonthlyReportImpl(
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
      totalIncomeMinor: null == totalIncomeMinor
          ? _value.totalIncomeMinor
          : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpensesMinor: null == totalExpensesMinor
          ? _value.totalExpensesMinor
          : totalExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cardExpensesMinor: null == cardExpensesMinor
          ? _value.cardExpensesMinor
          : cardExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cashExpensesMinor: null == cashExpensesMinor
          ? _value.cashExpensesMinor
          : cashExpensesMinor // ignore: cast_nullable_to_non_nullable
              as int,
      atmWithdrawalsMinor: null == atmWithdrawalsMinor
          ? _value.atmWithdrawalsMinor
          : atmWithdrawalsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      topCategoryId: freezed == topCategoryId
          ? _value.topCategoryId
          : topCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      topItemId: freezed == topItemId
          ? _value.topItemId
          : topItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      topMerchantId: freezed == topMerchantId
          ? _value.topMerchantId
          : topMerchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      potentialSavingsMinor: null == potentialSavingsMinor
          ? _value.potentialSavingsMinor
          : potentialSavingsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      actualSavingsMinor: null == actualSavingsMinor
          ? _value.actualSavingsMinor
          : actualSavingsMinor // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$MonthlyReportImpl implements _MonthlyReport {
  const _$MonthlyReportImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.year,
      required this.month,
      @JsonKey(name: 'total_income_minor') this.totalIncomeMinor = 0,
      @JsonKey(name: 'total_expenses_minor') this.totalExpensesMinor = 0,
      @JsonKey(name: 'card_expenses_minor') this.cardExpensesMinor = 0,
      @JsonKey(name: 'cash_expenses_minor') this.cashExpensesMinor = 0,
      @JsonKey(name: 'atm_withdrawals_minor') this.atmWithdrawalsMinor = 0,
      @JsonKey(name: 'top_category_id') this.topCategoryId,
      @JsonKey(name: 'top_item_id') this.topItemId,
      @JsonKey(name: 'top_merchant_id') this.topMerchantId,
      @JsonKey(name: 'potential_savings_minor') this.potentialSavingsMinor = 0,
      @JsonKey(name: 'actual_savings_minor') this.actualSavingsMinor = 0,
      @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
      this.generatedAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$MonthlyReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyReportImplFromJson(json);

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
  @JsonKey(name: 'total_income_minor')
  final int totalIncomeMinor;
  @override
  @JsonKey(name: 'total_expenses_minor')
  final int totalExpensesMinor;
  @override
  @JsonKey(name: 'card_expenses_minor')
  final int cardExpensesMinor;
  @override
  @JsonKey(name: 'cash_expenses_minor')
  final int cashExpensesMinor;
  @override
  @JsonKey(name: 'atm_withdrawals_minor')
  final int atmWithdrawalsMinor;
  @override
  @JsonKey(name: 'top_category_id')
  final String? topCategoryId;
  @override
  @JsonKey(name: 'top_item_id')
  final String? topItemId;
  @override
  @JsonKey(name: 'top_merchant_id')
  final String? topMerchantId;
  @override
  @JsonKey(name: 'potential_savings_minor')
  final int potentialSavingsMinor;
  @override
  @JsonKey(name: 'actual_savings_minor')
  final int actualSavingsMinor;
  @override
  @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
  final DateTime? generatedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MonthlyReport(id: $id, userId: $userId, year: $year, month: $month, totalIncomeMinor: $totalIncomeMinor, totalExpensesMinor: $totalExpensesMinor, cardExpensesMinor: $cardExpensesMinor, cashExpensesMinor: $cashExpensesMinor, atmWithdrawalsMinor: $atmWithdrawalsMinor, topCategoryId: $topCategoryId, topItemId: $topItemId, topMerchantId: $topMerchantId, potentialSavingsMinor: $potentialSavingsMinor, actualSavingsMinor: $actualSavingsMinor, generatedAt: $generatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalIncomeMinor, totalIncomeMinor) ||
                other.totalIncomeMinor == totalIncomeMinor) &&
            (identical(other.totalExpensesMinor, totalExpensesMinor) ||
                other.totalExpensesMinor == totalExpensesMinor) &&
            (identical(other.cardExpensesMinor, cardExpensesMinor) ||
                other.cardExpensesMinor == cardExpensesMinor) &&
            (identical(other.cashExpensesMinor, cashExpensesMinor) ||
                other.cashExpensesMinor == cashExpensesMinor) &&
            (identical(other.atmWithdrawalsMinor, atmWithdrawalsMinor) ||
                other.atmWithdrawalsMinor == atmWithdrawalsMinor) &&
            (identical(other.topCategoryId, topCategoryId) ||
                other.topCategoryId == topCategoryId) &&
            (identical(other.topItemId, topItemId) ||
                other.topItemId == topItemId) &&
            (identical(other.topMerchantId, topMerchantId) ||
                other.topMerchantId == topMerchantId) &&
            (identical(other.potentialSavingsMinor, potentialSavingsMinor) ||
                other.potentialSavingsMinor == potentialSavingsMinor) &&
            (identical(other.actualSavingsMinor, actualSavingsMinor) ||
                other.actualSavingsMinor == actualSavingsMinor) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
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
      year,
      month,
      totalIncomeMinor,
      totalExpensesMinor,
      cardExpensesMinor,
      cashExpensesMinor,
      atmWithdrawalsMinor,
      topCategoryId,
      topItemId,
      topMerchantId,
      potentialSavingsMinor,
      actualSavingsMinor,
      generatedAt,
      createdAt,
      updatedAt);

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      __$$MonthlyReportImplCopyWithImpl<_$MonthlyReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyReportImplToJson(
      this,
    );
  }
}

abstract class _MonthlyReport implements MonthlyReport {
  const factory _MonthlyReport(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final int year,
      required final int month,
      @JsonKey(name: 'total_income_minor') final int totalIncomeMinor,
      @JsonKey(name: 'total_expenses_minor') final int totalExpensesMinor,
      @JsonKey(name: 'card_expenses_minor') final int cardExpensesMinor,
      @JsonKey(name: 'cash_expenses_minor') final int cashExpensesMinor,
      @JsonKey(name: 'atm_withdrawals_minor') final int atmWithdrawalsMinor,
      @JsonKey(name: 'top_category_id') final String? topCategoryId,
      @JsonKey(name: 'top_item_id') final String? topItemId,
      @JsonKey(name: 'top_merchant_id') final String? topMerchantId,
      @JsonKey(name: 'potential_savings_minor') final int potentialSavingsMinor,
      @JsonKey(name: 'actual_savings_minor') final int actualSavingsMinor,
      @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
      final DateTime? generatedAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$MonthlyReportImpl;

  factory _MonthlyReport.fromJson(Map<String, dynamic> json) =
      _$MonthlyReportImpl.fromJson;

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
  @JsonKey(name: 'total_income_minor')
  int get totalIncomeMinor;
  @override
  @JsonKey(name: 'total_expenses_minor')
  int get totalExpensesMinor;
  @override
  @JsonKey(name: 'card_expenses_minor')
  int get cardExpensesMinor;
  @override
  @JsonKey(name: 'cash_expenses_minor')
  int get cashExpensesMinor;
  @override
  @JsonKey(name: 'atm_withdrawals_minor')
  int get atmWithdrawalsMinor;
  @override
  @JsonKey(name: 'top_category_id')
  String? get topCategoryId;
  @override
  @JsonKey(name: 'top_item_id')
  String? get topItemId;
  @override
  @JsonKey(name: 'top_merchant_id')
  String? get topMerchantId;
  @override
  @JsonKey(name: 'potential_savings_minor')
  int get potentialSavingsMinor;
  @override
  @JsonKey(name: 'actual_savings_minor')
  int get actualSavingsMinor;
  @override
  @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)
  DateTime? get generatedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyItemStatistic _$MonthlyItemStatisticFromJson(Map<String, dynamic> json) {
  return _MonthlyItemStatistic.fromJson(json);
}

/// @nodoc
mixin _$MonthlyItemStatistic {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_events')
  int get purchaseEvents => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spending_minor')
  int get totalSpendingMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_price_minor')
  int get averagePriceMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_quantity')
  int get previousQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_spending_minor')
  int get previousSpendingMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_change_percentage')
  double get usageChangePercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'spending_change_percentage')
  double get spendingChangePercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MonthlyItemStatistic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyItemStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyItemStatisticCopyWith<MonthlyItemStatistic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyItemStatisticCopyWith<$Res> {
  factory $MonthlyItemStatisticCopyWith(MonthlyItemStatistic value,
          $Res Function(MonthlyItemStatistic) then) =
      _$MonthlyItemStatisticCopyWithImpl<$Res, MonthlyItemStatistic>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String itemId,
      int year,
      int month,
      int quantity,
      @JsonKey(name: 'purchase_events') int purchaseEvents,
      @JsonKey(name: 'total_spending_minor') int totalSpendingMinor,
      @JsonKey(name: 'average_price_minor') int averagePriceMinor,
      @JsonKey(name: 'previous_quantity') int previousQuantity,
      @JsonKey(name: 'previous_spending_minor') int previousSpendingMinor,
      @JsonKey(name: 'usage_change_percentage') double usageChangePercentage,
      @JsonKey(name: 'spending_change_percentage')
      double spendingChangePercentage,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$MonthlyItemStatisticCopyWithImpl<$Res,
        $Val extends MonthlyItemStatistic>
    implements $MonthlyItemStatisticCopyWith<$Res> {
  _$MonthlyItemStatisticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyItemStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? year = null,
    Object? month = null,
    Object? quantity = null,
    Object? purchaseEvents = null,
    Object? totalSpendingMinor = null,
    Object? averagePriceMinor = null,
    Object? previousQuantity = null,
    Object? previousSpendingMinor = null,
    Object? usageChangePercentage = null,
    Object? spendingChangePercentage = null,
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
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseEvents: null == purchaseEvents
          ? _value.purchaseEvents
          : purchaseEvents // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpendingMinor: null == totalSpendingMinor
          ? _value.totalSpendingMinor
          : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      averagePriceMinor: null == averagePriceMinor
          ? _value.averagePriceMinor
          : averagePriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      previousSpendingMinor: null == previousSpendingMinor
          ? _value.previousSpendingMinor
          : previousSpendingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      usageChangePercentage: null == usageChangePercentage
          ? _value.usageChangePercentage
          : usageChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      spendingChangePercentage: null == spendingChangePercentage
          ? _value.spendingChangePercentage
          : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
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
abstract class _$$MonthlyItemStatisticImplCopyWith<$Res>
    implements $MonthlyItemStatisticCopyWith<$Res> {
  factory _$$MonthlyItemStatisticImplCopyWith(_$MonthlyItemStatisticImpl value,
          $Res Function(_$MonthlyItemStatisticImpl) then) =
      __$$MonthlyItemStatisticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String itemId,
      int year,
      int month,
      int quantity,
      @JsonKey(name: 'purchase_events') int purchaseEvents,
      @JsonKey(name: 'total_spending_minor') int totalSpendingMinor,
      @JsonKey(name: 'average_price_minor') int averagePriceMinor,
      @JsonKey(name: 'previous_quantity') int previousQuantity,
      @JsonKey(name: 'previous_spending_minor') int previousSpendingMinor,
      @JsonKey(name: 'usage_change_percentage') double usageChangePercentage,
      @JsonKey(name: 'spending_change_percentage')
      double spendingChangePercentage,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$MonthlyItemStatisticImplCopyWithImpl<$Res>
    extends _$MonthlyItemStatisticCopyWithImpl<$Res, _$MonthlyItemStatisticImpl>
    implements _$$MonthlyItemStatisticImplCopyWith<$Res> {
  __$$MonthlyItemStatisticImplCopyWithImpl(_$MonthlyItemStatisticImpl _value,
      $Res Function(_$MonthlyItemStatisticImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyItemStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? year = null,
    Object? month = null,
    Object? quantity = null,
    Object? purchaseEvents = null,
    Object? totalSpendingMinor = null,
    Object? averagePriceMinor = null,
    Object? previousQuantity = null,
    Object? previousSpendingMinor = null,
    Object? usageChangePercentage = null,
    Object? spendingChangePercentage = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MonthlyItemStatisticImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseEvents: null == purchaseEvents
          ? _value.purchaseEvents
          : purchaseEvents // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpendingMinor: null == totalSpendingMinor
          ? _value.totalSpendingMinor
          : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      averagePriceMinor: null == averagePriceMinor
          ? _value.averagePriceMinor
          : averagePriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      previousSpendingMinor: null == previousSpendingMinor
          ? _value.previousSpendingMinor
          : previousSpendingMinor // ignore: cast_nullable_to_non_nullable
              as int,
      usageChangePercentage: null == usageChangePercentage
          ? _value.usageChangePercentage
          : usageChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      spendingChangePercentage: null == spendingChangePercentage
          ? _value.spendingChangePercentage
          : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$MonthlyItemStatisticImpl implements _MonthlyItemStatistic {
  const _$MonthlyItemStatisticImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'item_id') required this.itemId,
      required this.year,
      required this.month,
      this.quantity = 0,
      @JsonKey(name: 'purchase_events') this.purchaseEvents = 0,
      @JsonKey(name: 'total_spending_minor') this.totalSpendingMinor = 0,
      @JsonKey(name: 'average_price_minor') this.averagePriceMinor = 0,
      @JsonKey(name: 'previous_quantity') this.previousQuantity = 0,
      @JsonKey(name: 'previous_spending_minor') this.previousSpendingMinor = 0,
      @JsonKey(name: 'usage_change_percentage')
      this.usageChangePercentage = 0.0,
      @JsonKey(name: 'spending_change_percentage')
      this.spendingChangePercentage = 0.0,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$MonthlyItemStatisticImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyItemStatisticImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  final int year;
  @override
  final int month;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey(name: 'purchase_events')
  final int purchaseEvents;
  @override
  @JsonKey(name: 'total_spending_minor')
  final int totalSpendingMinor;
  @override
  @JsonKey(name: 'average_price_minor')
  final int averagePriceMinor;
  @override
  @JsonKey(name: 'previous_quantity')
  final int previousQuantity;
  @override
  @JsonKey(name: 'previous_spending_minor')
  final int previousSpendingMinor;
  @override
  @JsonKey(name: 'usage_change_percentage')
  final double usageChangePercentage;
  @override
  @JsonKey(name: 'spending_change_percentage')
  final double spendingChangePercentage;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MonthlyItemStatistic(id: $id, userId: $userId, itemId: $itemId, year: $year, month: $month, quantity: $quantity, purchaseEvents: $purchaseEvents, totalSpendingMinor: $totalSpendingMinor, averagePriceMinor: $averagePriceMinor, previousQuantity: $previousQuantity, previousSpendingMinor: $previousSpendingMinor, usageChangePercentage: $usageChangePercentage, spendingChangePercentage: $spendingChangePercentage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyItemStatisticImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.purchaseEvents, purchaseEvents) ||
                other.purchaseEvents == purchaseEvents) &&
            (identical(other.totalSpendingMinor, totalSpendingMinor) ||
                other.totalSpendingMinor == totalSpendingMinor) &&
            (identical(other.averagePriceMinor, averagePriceMinor) ||
                other.averagePriceMinor == averagePriceMinor) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.previousSpendingMinor, previousSpendingMinor) ||
                other.previousSpendingMinor == previousSpendingMinor) &&
            (identical(other.usageChangePercentage, usageChangePercentage) ||
                other.usageChangePercentage == usageChangePercentage) &&
            (identical(
                    other.spendingChangePercentage, spendingChangePercentage) ||
                other.spendingChangePercentage == spendingChangePercentage) &&
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
      year,
      month,
      quantity,
      purchaseEvents,
      totalSpendingMinor,
      averagePriceMinor,
      previousQuantity,
      previousSpendingMinor,
      usageChangePercentage,
      spendingChangePercentage,
      createdAt,
      updatedAt);

  /// Create a copy of MonthlyItemStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyItemStatisticImplCopyWith<_$MonthlyItemStatisticImpl>
      get copyWith =>
          __$$MonthlyItemStatisticImplCopyWithImpl<_$MonthlyItemStatisticImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyItemStatisticImplToJson(
      this,
    );
  }
}

abstract class _MonthlyItemStatistic implements MonthlyItemStatistic {
  const factory _MonthlyItemStatistic(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'item_id') required final String itemId,
      required final int year,
      required final int month,
      final int quantity,
      @JsonKey(name: 'purchase_events') final int purchaseEvents,
      @JsonKey(name: 'total_spending_minor') final int totalSpendingMinor,
      @JsonKey(name: 'average_price_minor') final int averagePriceMinor,
      @JsonKey(name: 'previous_quantity') final int previousQuantity,
      @JsonKey(name: 'previous_spending_minor') final int previousSpendingMinor,
      @JsonKey(name: 'usage_change_percentage')
      final double usageChangePercentage,
      @JsonKey(name: 'spending_change_percentage')
      final double spendingChangePercentage,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$MonthlyItemStatisticImpl;

  factory _MonthlyItemStatistic.fromJson(Map<String, dynamic> json) =
      _$MonthlyItemStatisticImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  int get year;
  @override
  int get month;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'purchase_events')
  int get purchaseEvents;
  @override
  @JsonKey(name: 'total_spending_minor')
  int get totalSpendingMinor;
  @override
  @JsonKey(name: 'average_price_minor')
  int get averagePriceMinor;
  @override
  @JsonKey(name: 'previous_quantity')
  int get previousQuantity;
  @override
  @JsonKey(name: 'previous_spending_minor')
  int get previousSpendingMinor;
  @override
  @JsonKey(name: 'usage_change_percentage')
  double get usageChangePercentage;
  @override
  @JsonKey(name: 'spending_change_percentage')
  double get spendingChangePercentage;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of MonthlyItemStatistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyItemStatisticImplCopyWith<_$MonthlyItemStatisticImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
  DateTime? get scheduledFor => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
          AppNotification value, $Res Function(AppNotification) then) =
      _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String type,
      String title,
      String message,
      Map<String, dynamic> data,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
      DateTime? scheduledFor,
      @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? sentAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? data = null,
    Object? isRead = null,
    Object? scheduledFor = freezed,
    Object? sentAt = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(_$AppNotificationImpl value,
          $Res Function(_$AppNotificationImpl) then) =
      __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String type,
      String title,
      String message,
      Map<String, dynamic> data,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
      DateTime? scheduledFor,
      @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? sentAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
      _$AppNotificationImpl _value, $Res Function(_$AppNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? data = null,
    Object? isRead = null,
    Object? scheduledFor = freezed,
    Object? sentAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AppNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
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
class _$AppNotificationImpl implements _AppNotification {
  const _$AppNotificationImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.type,
      required this.title,
      required this.message,
      final Map<String, dynamic> data = const {},
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
      this.scheduledFor,
      @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) this.sentAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt})
      : _data = data;

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String message;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
  final DateTime? scheduledFor;
  @override
  @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)
  final DateTime? sentAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, message: $message, data: $data, isRead: $isRead, scheduledFor: $scheduledFor, sentAt: $sentAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      message,
      const DeepCollectionEquality().hash(_data),
      isRead,
      scheduledFor,
      sentAt,
      createdAt);

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(
      this,
    );
  }
}

abstract class _AppNotification implements AppNotification {
  const factory _AppNotification(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String type,
      required final String title,
      required final String message,
      final Map<String, dynamic> data,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
      final DateTime? scheduledFor,
      @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)
      final DateTime? sentAt,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$AppNotificationImpl;

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get type;
  @override
  String get title;
  @override
  String get message;
  @override
  Map<String, dynamic> get data;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)
  DateTime? get scheduledFor;
  @override
  @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)
  DateTime? get sentAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) {
  return _AuditLog.fromJson(json);
}

/// @nodoc
mixin _$AuditLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String? get entityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogCopyWith<AuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogCopyWith<$Res> {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) then) =
      _$AuditLogCopyWithImpl<$Res, AuditLog>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String action,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String? entityId,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$AuditLogCopyWithImpl<$Res, $Val extends AuditLog>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = freezed,
    Object? oldData = freezed,
    Object? newData = freezed,
    Object? createdAt = freezed,
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
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      oldData: freezed == oldData
          ? _value.oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: freezed == newData
          ? _value.newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogImplCopyWith<$Res>
    implements $AuditLogCopyWith<$Res> {
  factory _$$AuditLogImplCopyWith(
          _$AuditLogImpl value, $Res Function(_$AuditLogImpl) then) =
      __$$AuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String action,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String? entityId,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$AuditLogImplCopyWithImpl<$Res>
    extends _$AuditLogCopyWithImpl<$Res, _$AuditLogImpl>
    implements _$$AuditLogImplCopyWith<$Res> {
  __$$AuditLogImplCopyWithImpl(
      _$AuditLogImpl _value, $Res Function(_$AuditLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = freezed,
    Object? oldData = freezed,
    Object? newData = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AuditLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String?,
      oldData: freezed == oldData
          ? _value._oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: freezed == newData
          ? _value._newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogImpl implements _AuditLog {
  const _$AuditLogImpl(
      {required this.id,
      @JsonKey(name: 'user_id') this.userId,
      required this.action,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') this.entityId,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') final Map<String, dynamic>? newData,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt})
      : _oldData = oldData,
        _newData = newData;

  factory _$AuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String action;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String? entityId;
  final Map<String, dynamic>? _oldData;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData {
    final value = _oldData;
    if (value == null) return null;
    if (_oldData is EqualUnmodifiableMapView) return _oldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData {
    final value = _newData;
    if (value == null) return null;
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AuditLog(id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, oldData: $oldData, newData: $newData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            const DeepCollectionEquality().equals(other._oldData, _oldData) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      action,
      entityType,
      entityId,
      const DeepCollectionEquality().hash(_oldData),
      const DeepCollectionEquality().hash(_newData),
      createdAt);

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      __$$AuditLogImplCopyWithImpl<_$AuditLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogImplToJson(
      this,
    );
  }
}

abstract class _AuditLog implements AuditLog {
  const factory _AuditLog(
      {required final String id,
      @JsonKey(name: 'user_id') final String? userId,
      required final String action,
      @JsonKey(name: 'entity_type') required final String entityType,
      @JsonKey(name: 'entity_id') final String? entityId,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') final Map<String, dynamic>? newData,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$AuditLogImpl;

  factory _AuditLog.fromJson(Map<String, dynamic> json) =
      _$AuditLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String get action;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String? get entityId;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
