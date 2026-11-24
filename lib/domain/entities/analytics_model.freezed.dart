// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Alert {

 String get id;@JsonKey(name: 'user_id') String get userId; AlertType get type; AlertSeverity get severity;@JsonKey(name: 'item_id') String? get itemId;@JsonKey(name: 'category_id') String? get categoryId; String get title; String get message; Map<String, dynamic> get data;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCopyWith<Alert> get copyWith => _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Alert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alert&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Alert;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.type,_this.severity,_this.itemId,_this.categoryId,_this.title,_this.message,const DeepCollectionEquality().hash(_this.data),_this.isRead,_this.createdAt);
}

@override
String toString() {
  final _this = this as Alert;
  return 'Alert(id: ${_this.id}, userId: ${_this.userId}, type: ${_this.type}, severity: ${_this.severity}, itemId: ${_this.itemId}, categoryId: ${_this.categoryId}, title: ${_this.title}, message: ${_this.message}, data: ${_this.data}, isRead: ${_this.isRead}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res>  {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) = _$AlertCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, AlertType type, AlertSeverity severity,@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'category_id') String? categoryId, String title, String message, Map<String, dynamic> data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$AlertCopyWithImpl<$Res>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? severity = null,Object? itemId = freezed,Object? categoryId = freezed,Object? title = null,Object? message = null,Object? data = null,Object? isRead = null,Object? createdAt = freezed,}) {
  return _then(Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Alert].
extension AlertPatterns on Alert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alert value)  $default,){
final _that = this;
switch (_that) {
case _Alert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alert value)?  $default,){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  AlertType type,  AlertSeverity severity, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.severity,_that.itemId,_that.categoryId,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  AlertType type,  AlertSeverity severity, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Alert():
return $default(_that.id,_that.userId,_that.type,_that.severity,_that.itemId,_that.categoryId,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  AlertType type,  AlertSeverity severity, @JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'category_id')  String? categoryId,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.severity,_that.itemId,_that.categoryId,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alert implements Alert {
  const _Alert({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.type, this.severity = AlertSeverity.info, @JsonKey(name: 'item_id') this.itemId, @JsonKey(name: 'category_id') this.categoryId, required this.title, required this.message,  Map<String, dynamic> data = const {}, @JsonKey(name: 'is_read') this.isRead = false, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt}): _data = data;
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  AlertType type;
@override@JsonKey() final  AlertSeverity severity;
@override@JsonKey(name: 'item_id') final  String? itemId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override final  String title;
@override final  String message;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCopyWith<_Alert> get copyWith => __$AlertCopyWithImpl<_Alert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,type,severity,itemId,categoryId,title,message,const DeepCollectionEquality().hash(_data),isRead,createdAt);
}

@override
String toString() {
    return 'Alert(id: $id, userId: $userId, type: $type, severity: $severity, itemId: $itemId, categoryId: $categoryId, title: $title, message: $message, data: $data, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) = __$AlertCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, AlertType type, AlertSeverity severity,@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'category_id') String? categoryId, String title, String message, Map<String, dynamic> data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$AlertCopyWithImpl<$Res>
    implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? severity = null,Object? itemId = freezed,Object? categoryId = freezed,Object? title = null,Object? message = null,Object? data = null,Object? isRead = null,Object? createdAt = freezed,}) {
  return _then(_Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Badge {

 String get id; String get code; String get name;@JsonKey(name: 'name_ar') String? get nameAr; String? get description;@JsonKey(name: 'description_ar') String? get descriptionAr; String? get icon; Map<String, dynamic> get criteria;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of Badge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeCopyWith<Badge> get copyWith => _$BadgeCopyWithImpl<Badge>(this as Badge, _$identity);

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Badge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Badge&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.descriptionAr, _this.descriptionAr) || other.descriptionAr == _this.descriptionAr)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&const DeepCollectionEquality().equals(other.criteria, _this.criteria)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Badge;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.nameAr,_this.description,_this.descriptionAr,_this.icon,const DeepCollectionEquality().hash(_this.criteria),_this.createdAt);
}

@override
String toString() {
  final _this = this as Badge;
  return 'Badge(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, nameAr: ${_this.nameAr}, description: ${_this.description}, descriptionAr: ${_this.descriptionAr}, icon: ${_this.icon}, criteria: ${_this.criteria}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BadgeCopyWith<$Res>  {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) _then) = _$BadgeCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name,@JsonKey(name: 'name_ar') String? nameAr, String? description,@JsonKey(name: 'description_ar') String? descriptionAr, String? icon, Map<String, dynamic> criteria,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$BadgeCopyWithImpl<$Res>
    implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._self, this._then);

  final Badge _self;
  final $Res Function(Badge) _then;

/// Create a copy of Badge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? icon = freezed,Object? criteria = null,Object? createdAt = freezed,}) {
  return _then(Badge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,criteria: null == criteria ? _self.criteria : criteria // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Badge].
extension BadgePatterns on Badge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Badge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Badge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Badge value)  $default,){
final _that = this;
switch (_that) {
case _Badge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Badge value)?  $default,){
final _that = this;
switch (_that) {
case _Badge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'description_ar')  String? descriptionAr,  String? icon,  Map<String, dynamic> criteria, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Badge() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.criteria,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'description_ar')  String? descriptionAr,  String? icon,  Map<String, dynamic> criteria, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Badge():
return $default(_that.id,_that.code,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.criteria,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name, @JsonKey(name: 'name_ar')  String? nameAr,  String? description, @JsonKey(name: 'description_ar')  String? descriptionAr,  String? icon,  Map<String, dynamic> criteria, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Badge() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.criteria,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Badge implements Badge {
  const _Badge({required this.id, required this.code, required this.name, @JsonKey(name: 'name_ar') this.nameAr, this.description, @JsonKey(name: 'description_ar') this.descriptionAr, this.icon,  Map<String, dynamic> criteria = const {}, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt}): _criteria = criteria;
  factory _Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String? nameAr;
@override final  String? description;
@override@JsonKey(name: 'description_ar') final  String? descriptionAr;
@override final  String? icon;
 final  Map<String, dynamic> _criteria;
@override@JsonKey() Map<String, dynamic> get criteria {
  if (_criteria is EqualUnmodifiableMapView) return _criteria;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_criteria);
}

@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of Badge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeCopyWith<_Badge> get copyWith => __$BadgeCopyWithImpl<_Badge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Badge&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.criteria, _criteria)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,nameAr,description,descriptionAr,icon,const DeepCollectionEquality().hash(_criteria),createdAt);
}

@override
String toString() {
    return 'Badge(id: $id, code: $code, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, criteria: $criteria, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BadgeCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$BadgeCopyWith(_Badge value, $Res Function(_Badge) _then) = __$BadgeCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name,@JsonKey(name: 'name_ar') String? nameAr, String? description,@JsonKey(name: 'description_ar') String? descriptionAr, String? icon, Map<String, dynamic> criteria,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$BadgeCopyWithImpl<$Res>
    implements _$BadgeCopyWith<$Res> {
  __$BadgeCopyWithImpl(this._self, this._then);

  final _Badge _self;
  final $Res Function(_Badge) _then;

/// Create a copy of Badge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? icon = freezed,Object? criteria = null,Object? createdAt = freezed,}) {
  return _then(_Badge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,criteria: null == criteria ? _self._criteria : criteria // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UserBadge {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'badge_id') String get badgeId;@JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired) DateTime get earnedAt; Map<String, dynamic> get metadata;
/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserBadgeCopyWith<UserBadge> get copyWith => _$UserBadgeCopyWithImpl<UserBadge>(this as UserBadge, _$identity);

  /// Serializes this UserBadge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserBadge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserBadge&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.badgeId, _this.badgeId) || other.badgeId == _this.badgeId)&&(identical(other.earnedAt, _this.earnedAt) || other.earnedAt == _this.earnedAt)&&const DeepCollectionEquality().equals(other.metadata, _this.metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserBadge;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.badgeId,_this.earnedAt,const DeepCollectionEquality().hash(_this.metadata));
}

@override
String toString() {
  final _this = this as UserBadge;
  return 'UserBadge(id: ${_this.id}, userId: ${_this.userId}, badgeId: ${_this.badgeId}, earnedAt: ${_this.earnedAt}, metadata: ${_this.metadata})';
}


}

/// @nodoc
abstract mixin class $UserBadgeCopyWith<$Res>  {
  factory $UserBadgeCopyWith(UserBadge value, $Res Function(UserBadge) _then) = _$UserBadgeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'badge_id') String badgeId,@JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired) DateTime earnedAt, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$UserBadgeCopyWithImpl<$Res>
    implements $UserBadgeCopyWith<$Res> {
  _$UserBadgeCopyWithImpl(this._self, this._then);

  final UserBadge _self;
  final $Res Function(UserBadge) _then;

/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? badgeId = null,Object? earnedAt = null,Object? metadata = null,}) {
  return _then(UserBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,badgeId: null == badgeId ? _self.badgeId : badgeId // ignore: cast_nullable_to_non_nullable
as String,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserBadge].
extension UserBadgePatterns on UserBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserBadge value)  $default,){
final _that = this;
switch (_that) {
case _UserBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserBadge value)?  $default,){
final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'badge_id')  String badgeId, @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)  DateTime earnedAt,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
return $default(_that.id,_that.userId,_that.badgeId,_that.earnedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'badge_id')  String badgeId, @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)  DateTime earnedAt,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _UserBadge():
return $default(_that.id,_that.userId,_that.badgeId,_that.earnedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'badge_id')  String badgeId, @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired)  DateTime earnedAt,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
return $default(_that.id,_that.userId,_that.badgeId,_that.earnedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserBadge implements UserBadge {
  const _UserBadge({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'badge_id') required this.badgeId, @JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired) required this.earnedAt,  Map<String, dynamic> metadata = const {}}): _metadata = metadata;
  factory _UserBadge.fromJson(Map<String, dynamic> json) => _$UserBadgeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'badge_id') final  String badgeId;
@override@JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired) final  DateTime earnedAt;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserBadgeCopyWith<_UserBadge> get copyWith => __$UserBadgeCopyWithImpl<_UserBadge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserBadgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.badgeId, badgeId) || other.badgeId == badgeId)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&const DeepCollectionEquality().equals(other.metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,badgeId,earnedAt,const DeepCollectionEquality().hash(_metadata));
}

@override
String toString() {
    return 'UserBadge(id: $id, userId: $userId, badgeId: $badgeId, earnedAt: $earnedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$UserBadgeCopyWith<$Res> implements $UserBadgeCopyWith<$Res> {
  factory _$UserBadgeCopyWith(_UserBadge value, $Res Function(_UserBadge) _then) = __$UserBadgeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'badge_id') String badgeId,@JsonKey(name: 'earned_at', fromJson: _dateTimeFromJsonRequired) DateTime earnedAt, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$UserBadgeCopyWithImpl<$Res>
    implements _$UserBadgeCopyWith<$Res> {
  __$UserBadgeCopyWithImpl(this._self, this._then);

  final _UserBadge _self;
  final $Res Function(_UserBadge) _then;

/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? badgeId = null,Object? earnedAt = null,Object? metadata = null,}) {
  return _then(_UserBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,badgeId: null == badgeId ? _self.badgeId : badgeId // ignore: cast_nullable_to_non_nullable
as String,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$MonthlyReport {

 String get id;@JsonKey(name: 'user_id') String get userId; int get year; int get month;@JsonKey(name: 'total_income_minor') int get totalIncomeMinor;@JsonKey(name: 'total_expenses_minor') int get totalExpensesMinor;@JsonKey(name: 'card_expenses_minor') int get cardExpensesMinor;@JsonKey(name: 'cash_expenses_minor') int get cashExpensesMinor;@JsonKey(name: 'atm_withdrawals_minor') int get atmWithdrawalsMinor;@JsonKey(name: 'top_category_id') String? get topCategoryId;@JsonKey(name: 'top_item_id') String? get topItemId;@JsonKey(name: 'top_merchant_id') String? get topMerchantId;@JsonKey(name: 'potential_savings_minor') int get potentialSavingsMinor;@JsonKey(name: 'actual_savings_minor') int get actualSavingsMinor;@JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson) DateTime? get generatedAt;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);

  /// Serializes this MonthlyReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.totalIncomeMinor, _this.totalIncomeMinor) || other.totalIncomeMinor == _this.totalIncomeMinor)&&(identical(other.totalExpensesMinor, _this.totalExpensesMinor) || other.totalExpensesMinor == _this.totalExpensesMinor)&&(identical(other.cardExpensesMinor, _this.cardExpensesMinor) || other.cardExpensesMinor == _this.cardExpensesMinor)&&(identical(other.cashExpensesMinor, _this.cashExpensesMinor) || other.cashExpensesMinor == _this.cashExpensesMinor)&&(identical(other.atmWithdrawalsMinor, _this.atmWithdrawalsMinor) || other.atmWithdrawalsMinor == _this.atmWithdrawalsMinor)&&(identical(other.topCategoryId, _this.topCategoryId) || other.topCategoryId == _this.topCategoryId)&&(identical(other.topItemId, _this.topItemId) || other.topItemId == _this.topItemId)&&(identical(other.topMerchantId, _this.topMerchantId) || other.topMerchantId == _this.topMerchantId)&&(identical(other.potentialSavingsMinor, _this.potentialSavingsMinor) || other.potentialSavingsMinor == _this.potentialSavingsMinor)&&(identical(other.actualSavingsMinor, _this.actualSavingsMinor) || other.actualSavingsMinor == _this.actualSavingsMinor)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyReport;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.year,_this.month,_this.totalIncomeMinor,_this.totalExpensesMinor,_this.cardExpensesMinor,_this.cashExpensesMinor,_this.atmWithdrawalsMinor,_this.topCategoryId,_this.topItemId,_this.topMerchantId,_this.potentialSavingsMinor,_this.actualSavingsMinor,_this.generatedAt,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MonthlyReport;
  return 'MonthlyReport(id: ${_this.id}, userId: ${_this.userId}, year: ${_this.year}, month: ${_this.month}, totalIncomeMinor: ${_this.totalIncomeMinor}, totalExpensesMinor: ${_this.totalExpensesMinor}, cardExpensesMinor: ${_this.cardExpensesMinor}, cashExpensesMinor: ${_this.cashExpensesMinor}, atmWithdrawalsMinor: ${_this.atmWithdrawalsMinor}, topCategoryId: ${_this.topCategoryId}, topItemId: ${_this.topItemId}, topMerchantId: ${_this.topMerchantId}, potentialSavingsMinor: ${_this.potentialSavingsMinor}, actualSavingsMinor: ${_this.actualSavingsMinor}, generatedAt: ${_this.generatedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, int year, int month,@JsonKey(name: 'total_income_minor') int totalIncomeMinor,@JsonKey(name: 'total_expenses_minor') int totalExpensesMinor,@JsonKey(name: 'card_expenses_minor') int cardExpensesMinor,@JsonKey(name: 'cash_expenses_minor') int cashExpensesMinor,@JsonKey(name: 'atm_withdrawals_minor') int atmWithdrawalsMinor,@JsonKey(name: 'top_category_id') String? topCategoryId,@JsonKey(name: 'top_item_id') String? topItemId,@JsonKey(name: 'top_merchant_id') String? topMerchantId,@JsonKey(name: 'potential_savings_minor') int potentialSavingsMinor,@JsonKey(name: 'actual_savings_minor') int actualSavingsMinor,@JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson) DateTime? generatedAt,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? month = null,Object? totalIncomeMinor = null,Object? totalExpensesMinor = null,Object? cardExpensesMinor = null,Object? cashExpensesMinor = null,Object? atmWithdrawalsMinor = null,Object? topCategoryId = freezed,Object? topItemId = freezed,Object? topMerchantId = freezed,Object? potentialSavingsMinor = null,Object? actualSavingsMinor = null,Object? generatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(MonthlyReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncomeMinor: null == totalIncomeMinor ? _self.totalIncomeMinor : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
as int,totalExpensesMinor: null == totalExpensesMinor ? _self.totalExpensesMinor : totalExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,cardExpensesMinor: null == cardExpensesMinor ? _self.cardExpensesMinor : cardExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,cashExpensesMinor: null == cashExpensesMinor ? _self.cashExpensesMinor : cashExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,atmWithdrawalsMinor: null == atmWithdrawalsMinor ? _self.atmWithdrawalsMinor : atmWithdrawalsMinor // ignore: cast_nullable_to_non_nullable
as int,topCategoryId: freezed == topCategoryId ? _self.topCategoryId : topCategoryId // ignore: cast_nullable_to_non_nullable
as String?,topItemId: freezed == topItemId ? _self.topItemId : topItemId // ignore: cast_nullable_to_non_nullable
as String?,topMerchantId: freezed == topMerchantId ? _self.topMerchantId : topMerchantId // ignore: cast_nullable_to_non_nullable
as String?,potentialSavingsMinor: null == potentialSavingsMinor ? _self.potentialSavingsMinor : potentialSavingsMinor // ignore: cast_nullable_to_non_nullable
as int,actualSavingsMinor: null == actualSavingsMinor ? _self.actualSavingsMinor : actualSavingsMinor // ignore: cast_nullable_to_non_nullable
as int,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month, @JsonKey(name: 'total_income_minor')  int totalIncomeMinor, @JsonKey(name: 'total_expenses_minor')  int totalExpensesMinor, @JsonKey(name: 'card_expenses_minor')  int cardExpensesMinor, @JsonKey(name: 'cash_expenses_minor')  int cashExpensesMinor, @JsonKey(name: 'atm_withdrawals_minor')  int atmWithdrawalsMinor, @JsonKey(name: 'top_category_id')  String? topCategoryId, @JsonKey(name: 'top_item_id')  String? topItemId, @JsonKey(name: 'top_merchant_id')  String? topMerchantId, @JsonKey(name: 'potential_savings_minor')  int potentialSavingsMinor, @JsonKey(name: 'actual_savings_minor')  int actualSavingsMinor, @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)  DateTime? generatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.month,_that.totalIncomeMinor,_that.totalExpensesMinor,_that.cardExpensesMinor,_that.cashExpensesMinor,_that.atmWithdrawalsMinor,_that.topCategoryId,_that.topItemId,_that.topMerchantId,_that.potentialSavingsMinor,_that.actualSavingsMinor,_that.generatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month, @JsonKey(name: 'total_income_minor')  int totalIncomeMinor, @JsonKey(name: 'total_expenses_minor')  int totalExpensesMinor, @JsonKey(name: 'card_expenses_minor')  int cardExpensesMinor, @JsonKey(name: 'cash_expenses_minor')  int cashExpensesMinor, @JsonKey(name: 'atm_withdrawals_minor')  int atmWithdrawalsMinor, @JsonKey(name: 'top_category_id')  String? topCategoryId, @JsonKey(name: 'top_item_id')  String? topItemId, @JsonKey(name: 'top_merchant_id')  String? topMerchantId, @JsonKey(name: 'potential_savings_minor')  int potentialSavingsMinor, @JsonKey(name: 'actual_savings_minor')  int actualSavingsMinor, @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)  DateTime? generatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.id,_that.userId,_that.year,_that.month,_that.totalIncomeMinor,_that.totalExpensesMinor,_that.cardExpensesMinor,_that.cashExpensesMinor,_that.atmWithdrawalsMinor,_that.topCategoryId,_that.topItemId,_that.topMerchantId,_that.potentialSavingsMinor,_that.actualSavingsMinor,_that.generatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  int year,  int month, @JsonKey(name: 'total_income_minor')  int totalIncomeMinor, @JsonKey(name: 'total_expenses_minor')  int totalExpensesMinor, @JsonKey(name: 'card_expenses_minor')  int cardExpensesMinor, @JsonKey(name: 'cash_expenses_minor')  int cashExpensesMinor, @JsonKey(name: 'atm_withdrawals_minor')  int atmWithdrawalsMinor, @JsonKey(name: 'top_category_id')  String? topCategoryId, @JsonKey(name: 'top_item_id')  String? topItemId, @JsonKey(name: 'top_merchant_id')  String? topMerchantId, @JsonKey(name: 'potential_savings_minor')  int potentialSavingsMinor, @JsonKey(name: 'actual_savings_minor')  int actualSavingsMinor, @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson)  DateTime? generatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.id,_that.userId,_that.year,_that.month,_that.totalIncomeMinor,_that.totalExpensesMinor,_that.cardExpensesMinor,_that.cashExpensesMinor,_that.atmWithdrawalsMinor,_that.topCategoryId,_that.topItemId,_that.topMerchantId,_that.potentialSavingsMinor,_that.actualSavingsMinor,_that.generatedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyReport implements MonthlyReport {
  const _MonthlyReport({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.year, required this.month, @JsonKey(name: 'total_income_minor') this.totalIncomeMinor = 0, @JsonKey(name: 'total_expenses_minor') this.totalExpensesMinor = 0, @JsonKey(name: 'card_expenses_minor') this.cardExpensesMinor = 0, @JsonKey(name: 'cash_expenses_minor') this.cashExpensesMinor = 0, @JsonKey(name: 'atm_withdrawals_minor') this.atmWithdrawalsMinor = 0, @JsonKey(name: 'top_category_id') this.topCategoryId, @JsonKey(name: 'top_item_id') this.topItemId, @JsonKey(name: 'top_merchant_id') this.topMerchantId, @JsonKey(name: 'potential_savings_minor') this.potentialSavingsMinor = 0, @JsonKey(name: 'actual_savings_minor') this.actualSavingsMinor = 0, @JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson) this.generatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _MonthlyReport.fromJson(Map<String, dynamic> json) => _$MonthlyReportFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  int year;
@override final  int month;
@override@JsonKey(name: 'total_income_minor') final  int totalIncomeMinor;
@override@JsonKey(name: 'total_expenses_minor') final  int totalExpensesMinor;
@override@JsonKey(name: 'card_expenses_minor') final  int cardExpensesMinor;
@override@JsonKey(name: 'cash_expenses_minor') final  int cashExpensesMinor;
@override@JsonKey(name: 'atm_withdrawals_minor') final  int atmWithdrawalsMinor;
@override@JsonKey(name: 'top_category_id') final  String? topCategoryId;
@override@JsonKey(name: 'top_item_id') final  String? topItemId;
@override@JsonKey(name: 'top_merchant_id') final  String? topMerchantId;
@override@JsonKey(name: 'potential_savings_minor') final  int potentialSavingsMinor;
@override@JsonKey(name: 'actual_savings_minor') final  int actualSavingsMinor;
@override@JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson) final  DateTime? generatedAt;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncomeMinor, totalIncomeMinor) || other.totalIncomeMinor == totalIncomeMinor)&&(identical(other.totalExpensesMinor, totalExpensesMinor) || other.totalExpensesMinor == totalExpensesMinor)&&(identical(other.cardExpensesMinor, cardExpensesMinor) || other.cardExpensesMinor == cardExpensesMinor)&&(identical(other.cashExpensesMinor, cashExpensesMinor) || other.cashExpensesMinor == cashExpensesMinor)&&(identical(other.atmWithdrawalsMinor, atmWithdrawalsMinor) || other.atmWithdrawalsMinor == atmWithdrawalsMinor)&&(identical(other.topCategoryId, topCategoryId) || other.topCategoryId == topCategoryId)&&(identical(other.topItemId, topItemId) || other.topItemId == topItemId)&&(identical(other.topMerchantId, topMerchantId) || other.topMerchantId == topMerchantId)&&(identical(other.potentialSavingsMinor, potentialSavingsMinor) || other.potentialSavingsMinor == potentialSavingsMinor)&&(identical(other.actualSavingsMinor, actualSavingsMinor) || other.actualSavingsMinor == actualSavingsMinor)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,year,month,totalIncomeMinor,totalExpensesMinor,cardExpensesMinor,cashExpensesMinor,atmWithdrawalsMinor,topCategoryId,topItemId,topMerchantId,potentialSavingsMinor,actualSavingsMinor,generatedAt,createdAt,updatedAt);
}

@override
String toString() {
    return 'MonthlyReport(id: $id, userId: $userId, year: $year, month: $month, totalIncomeMinor: $totalIncomeMinor, totalExpensesMinor: $totalExpensesMinor, cardExpensesMinor: $cardExpensesMinor, cashExpensesMinor: $cashExpensesMinor, atmWithdrawalsMinor: $atmWithdrawalsMinor, topCategoryId: $topCategoryId, topItemId: $topItemId, topMerchantId: $topMerchantId, potentialSavingsMinor: $potentialSavingsMinor, actualSavingsMinor: $actualSavingsMinor, generatedAt: $generatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, int year, int month,@JsonKey(name: 'total_income_minor') int totalIncomeMinor,@JsonKey(name: 'total_expenses_minor') int totalExpensesMinor,@JsonKey(name: 'card_expenses_minor') int cardExpensesMinor,@JsonKey(name: 'cash_expenses_minor') int cashExpensesMinor,@JsonKey(name: 'atm_withdrawals_minor') int atmWithdrawalsMinor,@JsonKey(name: 'top_category_id') String? topCategoryId,@JsonKey(name: 'top_item_id') String? topItemId,@JsonKey(name: 'top_merchant_id') String? topMerchantId,@JsonKey(name: 'potential_savings_minor') int potentialSavingsMinor,@JsonKey(name: 'actual_savings_minor') int actualSavingsMinor,@JsonKey(name: 'generated_at', fromJson: _dateTimeFromJson) DateTime? generatedAt,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? year = null,Object? month = null,Object? totalIncomeMinor = null,Object? totalExpensesMinor = null,Object? cardExpensesMinor = null,Object? cashExpensesMinor = null,Object? atmWithdrawalsMinor = null,Object? topCategoryId = freezed,Object? topItemId = freezed,Object? topMerchantId = freezed,Object? potentialSavingsMinor = null,Object? actualSavingsMinor = null,Object? generatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MonthlyReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncomeMinor: null == totalIncomeMinor ? _self.totalIncomeMinor : totalIncomeMinor // ignore: cast_nullable_to_non_nullable
as int,totalExpensesMinor: null == totalExpensesMinor ? _self.totalExpensesMinor : totalExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,cardExpensesMinor: null == cardExpensesMinor ? _self.cardExpensesMinor : cardExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,cashExpensesMinor: null == cashExpensesMinor ? _self.cashExpensesMinor : cashExpensesMinor // ignore: cast_nullable_to_non_nullable
as int,atmWithdrawalsMinor: null == atmWithdrawalsMinor ? _self.atmWithdrawalsMinor : atmWithdrawalsMinor // ignore: cast_nullable_to_non_nullable
as int,topCategoryId: freezed == topCategoryId ? _self.topCategoryId : topCategoryId // ignore: cast_nullable_to_non_nullable
as String?,topItemId: freezed == topItemId ? _self.topItemId : topItemId // ignore: cast_nullable_to_non_nullable
as String?,topMerchantId: freezed == topMerchantId ? _self.topMerchantId : topMerchantId // ignore: cast_nullable_to_non_nullable
as String?,potentialSavingsMinor: null == potentialSavingsMinor ? _self.potentialSavingsMinor : potentialSavingsMinor // ignore: cast_nullable_to_non_nullable
as int,actualSavingsMinor: null == actualSavingsMinor ? _self.actualSavingsMinor : actualSavingsMinor // ignore: cast_nullable_to_non_nullable
as int,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MonthlyItemStatistic {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'item_id') String get itemId; int get year; int get month; int get quantity;@JsonKey(name: 'purchase_events') int get purchaseEvents;@JsonKey(name: 'total_spending_minor') int get totalSpendingMinor;@JsonKey(name: 'average_price_minor') int get averagePriceMinor;@JsonKey(name: 'previous_quantity') int get previousQuantity;@JsonKey(name: 'previous_spending_minor') int get previousSpendingMinor;@JsonKey(name: 'usage_change_percentage') double get usageChangePercentage;@JsonKey(name: 'spending_change_percentage') double get spendingChangePercentage;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of MonthlyItemStatistic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyItemStatisticCopyWith<MonthlyItemStatistic> get copyWith => _$MonthlyItemStatisticCopyWithImpl<MonthlyItemStatistic>(this as MonthlyItemStatistic, _$identity);

  /// Serializes this MonthlyItemStatistic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyItemStatistic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyItemStatistic&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.purchaseEvents, _this.purchaseEvents) || other.purchaseEvents == _this.purchaseEvents)&&(identical(other.totalSpendingMinor, _this.totalSpendingMinor) || other.totalSpendingMinor == _this.totalSpendingMinor)&&(identical(other.averagePriceMinor, _this.averagePriceMinor) || other.averagePriceMinor == _this.averagePriceMinor)&&(identical(other.previousQuantity, _this.previousQuantity) || other.previousQuantity == _this.previousQuantity)&&(identical(other.previousSpendingMinor, _this.previousSpendingMinor) || other.previousSpendingMinor == _this.previousSpendingMinor)&&(identical(other.usageChangePercentage, _this.usageChangePercentage) || other.usageChangePercentage == _this.usageChangePercentage)&&(identical(other.spendingChangePercentage, _this.spendingChangePercentage) || other.spendingChangePercentage == _this.spendingChangePercentage)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyItemStatistic;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.itemId,_this.year,_this.month,_this.quantity,_this.purchaseEvents,_this.totalSpendingMinor,_this.averagePriceMinor,_this.previousQuantity,_this.previousSpendingMinor,_this.usageChangePercentage,_this.spendingChangePercentage,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MonthlyItemStatistic;
  return 'MonthlyItemStatistic(id: ${_this.id}, userId: ${_this.userId}, itemId: ${_this.itemId}, year: ${_this.year}, month: ${_this.month}, quantity: ${_this.quantity}, purchaseEvents: ${_this.purchaseEvents}, totalSpendingMinor: ${_this.totalSpendingMinor}, averagePriceMinor: ${_this.averagePriceMinor}, previousQuantity: ${_this.previousQuantity}, previousSpendingMinor: ${_this.previousSpendingMinor}, usageChangePercentage: ${_this.usageChangePercentage}, spendingChangePercentage: ${_this.spendingChangePercentage}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MonthlyItemStatisticCopyWith<$Res>  {
  factory $MonthlyItemStatisticCopyWith(MonthlyItemStatistic value, $Res Function(MonthlyItemStatistic) _then) = _$MonthlyItemStatisticCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId, int year, int month, int quantity,@JsonKey(name: 'purchase_events') int purchaseEvents,@JsonKey(name: 'total_spending_minor') int totalSpendingMinor,@JsonKey(name: 'average_price_minor') int averagePriceMinor,@JsonKey(name: 'previous_quantity') int previousQuantity,@JsonKey(name: 'previous_spending_minor') int previousSpendingMinor,@JsonKey(name: 'usage_change_percentage') double usageChangePercentage,@JsonKey(name: 'spending_change_percentage') double spendingChangePercentage,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$MonthlyItemStatisticCopyWithImpl<$Res>
    implements $MonthlyItemStatisticCopyWith<$Res> {
  _$MonthlyItemStatisticCopyWithImpl(this._self, this._then);

  final MonthlyItemStatistic _self;
  final $Res Function(MonthlyItemStatistic) _then;

/// Create a copy of MonthlyItemStatistic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? year = null,Object? month = null,Object? quantity = null,Object? purchaseEvents = null,Object? totalSpendingMinor = null,Object? averagePriceMinor = null,Object? previousQuantity = null,Object? previousSpendingMinor = null,Object? usageChangePercentage = null,Object? spendingChangePercentage = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(MonthlyItemStatistic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,purchaseEvents: null == purchaseEvents ? _self.purchaseEvents : purchaseEvents // ignore: cast_nullable_to_non_nullable
as int,totalSpendingMinor: null == totalSpendingMinor ? _self.totalSpendingMinor : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,averagePriceMinor: null == averagePriceMinor ? _self.averagePriceMinor : averagePriceMinor // ignore: cast_nullable_to_non_nullable
as int,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as int,previousSpendingMinor: null == previousSpendingMinor ? _self.previousSpendingMinor : previousSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,usageChangePercentage: null == usageChangePercentage ? _self.usageChangePercentage : usageChangePercentage // ignore: cast_nullable_to_non_nullable
as double,spendingChangePercentage: null == spendingChangePercentage ? _self.spendingChangePercentage : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyItemStatistic].
extension MonthlyItemStatisticPatterns on MonthlyItemStatistic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyItemStatistic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyItemStatistic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyItemStatistic value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyItemStatistic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyItemStatistic value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyItemStatistic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId,  int year,  int month,  int quantity, @JsonKey(name: 'purchase_events')  int purchaseEvents, @JsonKey(name: 'total_spending_minor')  int totalSpendingMinor, @JsonKey(name: 'average_price_minor')  int averagePriceMinor, @JsonKey(name: 'previous_quantity')  int previousQuantity, @JsonKey(name: 'previous_spending_minor')  int previousSpendingMinor, @JsonKey(name: 'usage_change_percentage')  double usageChangePercentage, @JsonKey(name: 'spending_change_percentage')  double spendingChangePercentage, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyItemStatistic() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.year,_that.month,_that.quantity,_that.purchaseEvents,_that.totalSpendingMinor,_that.averagePriceMinor,_that.previousQuantity,_that.previousSpendingMinor,_that.usageChangePercentage,_that.spendingChangePercentage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId,  int year,  int month,  int quantity, @JsonKey(name: 'purchase_events')  int purchaseEvents, @JsonKey(name: 'total_spending_minor')  int totalSpendingMinor, @JsonKey(name: 'average_price_minor')  int averagePriceMinor, @JsonKey(name: 'previous_quantity')  int previousQuantity, @JsonKey(name: 'previous_spending_minor')  int previousSpendingMinor, @JsonKey(name: 'usage_change_percentage')  double usageChangePercentage, @JsonKey(name: 'spending_change_percentage')  double spendingChangePercentage, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MonthlyItemStatistic():
return $default(_that.id,_that.userId,_that.itemId,_that.year,_that.month,_that.quantity,_that.purchaseEvents,_that.totalSpendingMinor,_that.averagePriceMinor,_that.previousQuantity,_that.previousSpendingMinor,_that.usageChangePercentage,_that.spendingChangePercentage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId,  int year,  int month,  int quantity, @JsonKey(name: 'purchase_events')  int purchaseEvents, @JsonKey(name: 'total_spending_minor')  int totalSpendingMinor, @JsonKey(name: 'average_price_minor')  int averagePriceMinor, @JsonKey(name: 'previous_quantity')  int previousQuantity, @JsonKey(name: 'previous_spending_minor')  int previousSpendingMinor, @JsonKey(name: 'usage_change_percentage')  double usageChangePercentage, @JsonKey(name: 'spending_change_percentage')  double spendingChangePercentage, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyItemStatistic() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.year,_that.month,_that.quantity,_that.purchaseEvents,_that.totalSpendingMinor,_that.averagePriceMinor,_that.previousQuantity,_that.previousSpendingMinor,_that.usageChangePercentage,_that.spendingChangePercentage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyItemStatistic implements MonthlyItemStatistic {
  const _MonthlyItemStatistic({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'item_id') required this.itemId, required this.year, required this.month, this.quantity = 0, @JsonKey(name: 'purchase_events') this.purchaseEvents = 0, @JsonKey(name: 'total_spending_minor') this.totalSpendingMinor = 0, @JsonKey(name: 'average_price_minor') this.averagePriceMinor = 0, @JsonKey(name: 'previous_quantity') this.previousQuantity = 0, @JsonKey(name: 'previous_spending_minor') this.previousSpendingMinor = 0, @JsonKey(name: 'usage_change_percentage') this.usageChangePercentage = 0.0, @JsonKey(name: 'spending_change_percentage') this.spendingChangePercentage = 0.0, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _MonthlyItemStatistic.fromJson(Map<String, dynamic> json) => _$MonthlyItemStatisticFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'item_id') final  String itemId;
@override final  int year;
@override final  int month;
@override@JsonKey() final  int quantity;
@override@JsonKey(name: 'purchase_events') final  int purchaseEvents;
@override@JsonKey(name: 'total_spending_minor') final  int totalSpendingMinor;
@override@JsonKey(name: 'average_price_minor') final  int averagePriceMinor;
@override@JsonKey(name: 'previous_quantity') final  int previousQuantity;
@override@JsonKey(name: 'previous_spending_minor') final  int previousSpendingMinor;
@override@JsonKey(name: 'usage_change_percentage') final  double usageChangePercentage;
@override@JsonKey(name: 'spending_change_percentage') final  double spendingChangePercentage;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of MonthlyItemStatistic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyItemStatisticCopyWith<_MonthlyItemStatistic> get copyWith => __$MonthlyItemStatisticCopyWithImpl<_MonthlyItemStatistic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyItemStatisticToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyItemStatistic&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.purchaseEvents, purchaseEvents) || other.purchaseEvents == purchaseEvents)&&(identical(other.totalSpendingMinor, totalSpendingMinor) || other.totalSpendingMinor == totalSpendingMinor)&&(identical(other.averagePriceMinor, averagePriceMinor) || other.averagePriceMinor == averagePriceMinor)&&(identical(other.previousQuantity, previousQuantity) || other.previousQuantity == previousQuantity)&&(identical(other.previousSpendingMinor, previousSpendingMinor) || other.previousSpendingMinor == previousSpendingMinor)&&(identical(other.usageChangePercentage, usageChangePercentage) || other.usageChangePercentage == usageChangePercentage)&&(identical(other.spendingChangePercentage, spendingChangePercentage) || other.spendingChangePercentage == spendingChangePercentage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,itemId,year,month,quantity,purchaseEvents,totalSpendingMinor,averagePriceMinor,previousQuantity,previousSpendingMinor,usageChangePercentage,spendingChangePercentage,createdAt,updatedAt);
}

@override
String toString() {
    return 'MonthlyItemStatistic(id: $id, userId: $userId, itemId: $itemId, year: $year, month: $month, quantity: $quantity, purchaseEvents: $purchaseEvents, totalSpendingMinor: $totalSpendingMinor, averagePriceMinor: $averagePriceMinor, previousQuantity: $previousQuantity, previousSpendingMinor: $previousSpendingMinor, usageChangePercentage: $usageChangePercentage, spendingChangePercentage: $spendingChangePercentage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MonthlyItemStatisticCopyWith<$Res> implements $MonthlyItemStatisticCopyWith<$Res> {
  factory _$MonthlyItemStatisticCopyWith(_MonthlyItemStatistic value, $Res Function(_MonthlyItemStatistic) _then) = __$MonthlyItemStatisticCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId, int year, int month, int quantity,@JsonKey(name: 'purchase_events') int purchaseEvents,@JsonKey(name: 'total_spending_minor') int totalSpendingMinor,@JsonKey(name: 'average_price_minor') int averagePriceMinor,@JsonKey(name: 'previous_quantity') int previousQuantity,@JsonKey(name: 'previous_spending_minor') int previousSpendingMinor,@JsonKey(name: 'usage_change_percentage') double usageChangePercentage,@JsonKey(name: 'spending_change_percentage') double spendingChangePercentage,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$MonthlyItemStatisticCopyWithImpl<$Res>
    implements _$MonthlyItemStatisticCopyWith<$Res> {
  __$MonthlyItemStatisticCopyWithImpl(this._self, this._then);

  final _MonthlyItemStatistic _self;
  final $Res Function(_MonthlyItemStatistic) _then;

/// Create a copy of MonthlyItemStatistic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? year = null,Object? month = null,Object? quantity = null,Object? purchaseEvents = null,Object? totalSpendingMinor = null,Object? averagePriceMinor = null,Object? previousQuantity = null,Object? previousSpendingMinor = null,Object? usageChangePercentage = null,Object? spendingChangePercentage = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MonthlyItemStatistic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,purchaseEvents: null == purchaseEvents ? _self.purchaseEvents : purchaseEvents // ignore: cast_nullable_to_non_nullable
as int,totalSpendingMinor: null == totalSpendingMinor ? _self.totalSpendingMinor : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,averagePriceMinor: null == averagePriceMinor ? _self.averagePriceMinor : averagePriceMinor // ignore: cast_nullable_to_non_nullable
as int,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as int,previousSpendingMinor: null == previousSpendingMinor ? _self.previousSpendingMinor : previousSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,usageChangePercentage: null == usageChangePercentage ? _self.usageChangePercentage : usageChangePercentage // ignore: cast_nullable_to_non_nullable
as double,spendingChangePercentage: null == spendingChangePercentage ? _self.spendingChangePercentage : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AppNotification {

 String get id;@JsonKey(name: 'user_id') String get userId; String get type; String get title; String get message; Map<String, dynamic> get data;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson) DateTime? get scheduledFor;@JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? get sentAt;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead)&&(identical(other.scheduledFor, _this.scheduledFor) || other.scheduledFor == _this.scheduledFor)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppNotification;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.type,_this.title,_this.message,const DeepCollectionEquality().hash(_this.data),_this.isRead,_this.scheduledFor,_this.sentAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as AppNotification;
  return 'AppNotification(id: ${_this.id}, userId: ${_this.userId}, type: ${_this.type}, title: ${_this.title}, message: ${_this.message}, data: ${_this.data}, isRead: ${_this.isRead}, scheduledFor: ${_this.scheduledFor}, sentAt: ${_this.sentAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String type, String title, String message, Map<String, dynamic> data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson) DateTime? scheduledFor,@JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? sentAt,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? data = null,Object? isRead = null,Object? scheduledFor = freezed,Object? sentAt = freezed,Object? createdAt = freezed,}) {
  return _then(AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)  DateTime? scheduledFor, @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)  DateTime? sentAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.scheduledFor,_that.sentAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)  DateTime? scheduledFor, @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)  DateTime? sentAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.scheduledFor,_that.sentAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String type,  String title,  String message,  Map<String, dynamic> data, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson)  DateTime? scheduledFor, @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson)  DateTime? sentAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.scheduledFor,_that.sentAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification implements AppNotification {
  const _AppNotification({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.type, required this.title, required this.message,  Map<String, dynamic> data = const {}, @JsonKey(name: 'is_read') this.isRead = false, @JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson) this.scheduledFor, @JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) this.sentAt, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt}): _data = data;
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String type;
@override final  String title;
@override final  String message;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson) final  DateTime? scheduledFor;
@override@JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) final  DateTime? sentAt;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,type,title,message,const DeepCollectionEquality().hash(_data),isRead,scheduledFor,sentAt,createdAt);
}

@override
String toString() {
    return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, message: $message, data: $data, isRead: $isRead, scheduledFor: $scheduledFor, sentAt: $sentAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String type, String title, String message, Map<String, dynamic> data,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'scheduled_for', fromJson: _dateTimeFromJson) DateTime? scheduledFor,@JsonKey(name: 'sent_at', fromJson: _dateTimeFromJson) DateTime? sentAt,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? data = null,Object? isRead = null,Object? scheduledFor = freezed,Object? sentAt = freezed,Object? createdAt = freezed,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AuditLog {

 String get id;@JsonKey(name: 'user_id') String? get userId; String get action;@JsonKey(name: 'entity_type') String get entityType;@JsonKey(name: 'entity_id') String? get entityId;@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData;@JsonKey(name: 'new_data') Map<String, dynamic>? get newData;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogCopyWith<AuditLog> get copyWith => _$AuditLogCopyWithImpl<AuditLog>(this as AuditLog, _$identity);

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuditLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.entityType, _this.entityType) || other.entityType == _this.entityType)&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&const DeepCollectionEquality().equals(other.oldData, _this.oldData)&&const DeepCollectionEquality().equals(other.newData, _this.newData)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditLog;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.action,_this.entityType,_this.entityId,const DeepCollectionEquality().hash(_this.oldData),const DeepCollectionEquality().hash(_this.newData),_this.createdAt);
}

@override
String toString() {
  final _this = this as AuditLog;
  return 'AuditLog(id: ${_this.id}, userId: ${_this.userId}, action: ${_this.action}, entityType: ${_this.entityType}, entityId: ${_this.entityId}, oldData: ${_this.oldData}, newData: ${_this.newData}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AuditLogCopyWith<$Res>  {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) _then) = _$AuditLogCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String action,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String? entityId,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$AuditLogCopyWithImpl<$Res>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._self, this._then);

  final AuditLog _self;
  final $Res Function(AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? action = null,Object? entityType = null,Object? entityId = freezed,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = freezed,}) {
  return _then(AuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,oldData: freezed == oldData ? _self.oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self.newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLog].
extension AuditLogPatterns on AuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldData,_that.newData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String? userId,  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AuditLog():
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldData,_that.newData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String? userId,  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldData,_that.newData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLog implements AuditLog {
  const _AuditLog({required this.id, @JsonKey(name: 'user_id') this.userId, required this.action, @JsonKey(name: 'entity_type') required this.entityType, @JsonKey(name: 'entity_id') this.entityId, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt}): _oldData = oldData,_newData = newData;
  factory _AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override final  String action;
@override@JsonKey(name: 'entity_type') final  String entityType;
@override@JsonKey(name: 'entity_id') final  String? entityId;
 final  Map<String, dynamic>? _oldData;
@override@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData {
  final value = _oldData;
  if (value == null) return null;
  if (_oldData is EqualUnmodifiableMapView) return _oldData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _newData;
@override@JsonKey(name: 'new_data') Map<String, dynamic>? get newData {
  final value = _newData;
  if (value == null) return null;
  if (_newData is EqualUnmodifiableMapView) return _newData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogCopyWith<_AuditLog> get copyWith => __$AuditLogCopyWithImpl<_AuditLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&const DeepCollectionEquality().equals(other.oldData, _oldData)&&const DeepCollectionEquality().equals(other.newData, _newData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,action,entityType,entityId,const DeepCollectionEquality().hash(_oldData),const DeepCollectionEquality().hash(_newData),createdAt);
}

@override
String toString() {
    return 'AuditLog(id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, oldData: $oldData, newData: $newData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AuditLogCopyWith<$Res> implements $AuditLogCopyWith<$Res> {
  factory _$AuditLogCopyWith(_AuditLog value, $Res Function(_AuditLog) _then) = __$AuditLogCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String? userId, String action,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String? entityId,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$AuditLogCopyWithImpl<$Res>
    implements _$AuditLogCopyWith<$Res> {
  __$AuditLogCopyWithImpl(this._self, this._then);

  final _AuditLog _self;
  final $Res Function(_AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? action = null,Object? entityType = null,Object? entityId = freezed,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = freezed,}) {
  return _then(_AuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,oldData: freezed == oldData ? _self._oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self._newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
