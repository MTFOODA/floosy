// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIConversation {

 String get id;@JsonKey(name: 'user_id') String get userId; String? get title;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIConversationCopyWith<AIConversation> get copyWith => _$AIConversationCopyWithImpl<AIConversation>(this as AIConversation, _$identity);

  /// Serializes this AIConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AIConversation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIConversation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AIConversation;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.title,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AIConversation;
  return 'AIConversation(id: ${_this.id}, userId: ${_this.userId}, title: ${_this.title}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AIConversationCopyWith<$Res>  {
  factory $AIConversationCopyWith(AIConversation value, $Res Function(AIConversation) _then) = _$AIConversationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? title,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$AIConversationCopyWithImpl<$Res>
    implements $AIConversationCopyWith<$Res> {
  _$AIConversationCopyWithImpl(this._self, this._then);

  final AIConversation _self;
  final $Res Function(AIConversation) _then;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(AIConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIConversation].
extension AIConversationPatterns on AIConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIConversation value)  $default,){
final _that = this;
switch (_that) {
case _AIConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIConversation value)?  $default,){
final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? title, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? title, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AIConversation():
return $default(_that.id,_that.userId,_that.title,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String? title, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIConversation implements AIConversation {
  const _AIConversation({required this.id, @JsonKey(name: 'user_id') required this.userId, this.title, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _AIConversation.fromJson(Map<String, dynamic> json) => _$AIConversationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String? title;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIConversationCopyWith<_AIConversation> get copyWith => __$AIConversationCopyWithImpl<_AIConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIConversationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,title,createdAt,updatedAt);
}

@override
String toString() {
    return 'AIConversation(id: $id, userId: $userId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AIConversationCopyWith<$Res> implements $AIConversationCopyWith<$Res> {
  factory _$AIConversationCopyWith(_AIConversation value, $Res Function(_AIConversation) _then) = __$AIConversationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? title,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$AIConversationCopyWithImpl<$Res>
    implements _$AIConversationCopyWith<$Res> {
  __$AIConversationCopyWithImpl(this._self, this._then);

  final _AIConversation _self;
  final $Res Function(_AIConversation) _then;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AIConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AIMessage {

 String get id;@JsonKey(name: 'conversation_id') String get conversationId;@JsonKey(name: 'user_id') String get userId; AIMessageRole get role; String? get content;@JsonKey(name: 'tool_name') String? get toolName;@JsonKey(name: 'tool_arguments') Map<String, dynamic>? get toolArguments;@JsonKey(name: 'tool_result') Map<String, dynamic>? get toolResult;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIMessageCopyWith<AIMessage> get copyWith => _$AIMessageCopyWithImpl<AIMessage>(this as AIMessage, _$identity);

  /// Serializes this AIMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AIMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.toolName, _this.toolName) || other.toolName == _this.toolName)&&const DeepCollectionEquality().equals(other.toolArguments, _this.toolArguments)&&const DeepCollectionEquality().equals(other.toolResult, _this.toolResult)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AIMessage;
  return Object.hash(runtimeType,_this.id,_this.conversationId,_this.userId,_this.role,_this.content,_this.toolName,const DeepCollectionEquality().hash(_this.toolArguments),const DeepCollectionEquality().hash(_this.toolResult),_this.createdAt);
}

@override
String toString() {
  final _this = this as AIMessage;
  return 'AIMessage(id: ${_this.id}, conversationId: ${_this.conversationId}, userId: ${_this.userId}, role: ${_this.role}, content: ${_this.content}, toolName: ${_this.toolName}, toolArguments: ${_this.toolArguments}, toolResult: ${_this.toolResult}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AIMessageCopyWith<$Res>  {
  factory $AIMessageCopyWith(AIMessage value, $Res Function(AIMessage) _then) = _$AIMessageCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId, AIMessageRole role, String? content,@JsonKey(name: 'tool_name') String? toolName,@JsonKey(name: 'tool_arguments') Map<String, dynamic>? toolArguments,@JsonKey(name: 'tool_result') Map<String, dynamic>? toolResult,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$AIMessageCopyWithImpl<$Res>
    implements $AIMessageCopyWith<$Res> {
  _$AIMessageCopyWithImpl(this._self, this._then);

  final AIMessage _self;
  final $Res Function(AIMessage) _then;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? role = null,Object? content = freezed,Object? toolName = freezed,Object? toolArguments = freezed,Object? toolResult = freezed,Object? createdAt = freezed,}) {
  return _then(AIMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AIMessageRole,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolArguments: freezed == toolArguments ? _self.toolArguments : toolArguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolResult: freezed == toolResult ? _self.toolResult : toolResult // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIMessage].
extension AIMessagePatterns on AIMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIMessage value)  $default,){
final _that = this;
switch (_that) {
case _AIMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId,  AIMessageRole role,  String? content, @JsonKey(name: 'tool_name')  String? toolName, @JsonKey(name: 'tool_arguments')  Map<String, dynamic>? toolArguments, @JsonKey(name: 'tool_result')  Map<String, dynamic>? toolResult, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.content,_that.toolName,_that.toolArguments,_that.toolResult,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId,  AIMessageRole role,  String? content, @JsonKey(name: 'tool_name')  String? toolName, @JsonKey(name: 'tool_arguments')  Map<String, dynamic>? toolArguments, @JsonKey(name: 'tool_result')  Map<String, dynamic>? toolResult, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AIMessage():
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.content,_that.toolName,_that.toolArguments,_that.toolResult,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId,  AIMessageRole role,  String? content, @JsonKey(name: 'tool_name')  String? toolName, @JsonKey(name: 'tool_arguments')  Map<String, dynamic>? toolArguments, @JsonKey(name: 'tool_result')  Map<String, dynamic>? toolResult, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.content,_that.toolName,_that.toolArguments,_that.toolResult,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIMessage implements AIMessage {
  const _AIMessage({required this.id, @JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'user_id') required this.userId, required this.role, this.content, @JsonKey(name: 'tool_name') this.toolName, @JsonKey(name: 'tool_arguments')  Map<String, dynamic>? toolArguments, @JsonKey(name: 'tool_result')  Map<String, dynamic>? toolResult, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt}): _toolArguments = toolArguments,_toolResult = toolResult;
  factory _AIMessage.fromJson(Map<String, dynamic> json) => _$AIMessageFromJson(json);

@override final  String id;
@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  AIMessageRole role;
@override final  String? content;
@override@JsonKey(name: 'tool_name') final  String? toolName;
 final  Map<String, dynamic>? _toolArguments;
@override@JsonKey(name: 'tool_arguments') Map<String, dynamic>? get toolArguments {
  final value = _toolArguments;
  if (value == null) return null;
  if (_toolArguments is EqualUnmodifiableMapView) return _toolArguments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _toolResult;
@override@JsonKey(name: 'tool_result') Map<String, dynamic>? get toolResult {
  final value = _toolResult;
  if (value == null) return null;
  if (_toolResult is EqualUnmodifiableMapView) return _toolResult;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIMessageCopyWith<_AIMessage> get copyWith => __$AIMessageCopyWithImpl<_AIMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other.toolArguments, _toolArguments)&&const DeepCollectionEquality().equals(other.toolResult, _toolResult)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,conversationId,userId,role,content,toolName,const DeepCollectionEquality().hash(_toolArguments),const DeepCollectionEquality().hash(_toolResult),createdAt);
}

@override
String toString() {
    return 'AIMessage(id: $id, conversationId: $conversationId, userId: $userId, role: $role, content: $content, toolName: $toolName, toolArguments: $toolArguments, toolResult: $toolResult, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AIMessageCopyWith<$Res> implements $AIMessageCopyWith<$Res> {
  factory _$AIMessageCopyWith(_AIMessage value, $Res Function(_AIMessage) _then) = __$AIMessageCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId, AIMessageRole role, String? content,@JsonKey(name: 'tool_name') String? toolName,@JsonKey(name: 'tool_arguments') Map<String, dynamic>? toolArguments,@JsonKey(name: 'tool_result') Map<String, dynamic>? toolResult,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$AIMessageCopyWithImpl<$Res>
    implements _$AIMessageCopyWith<$Res> {
  __$AIMessageCopyWithImpl(this._self, this._then);

  final _AIMessage _self;
  final $Res Function(_AIMessage) _then;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? role = null,Object? content = freezed,Object? toolName = freezed,Object? toolArguments = freezed,Object? toolResult = freezed,Object? createdAt = freezed,}) {
  return _then(_AIMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AIMessageRole,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,toolArguments: freezed == toolArguments ? _self._toolArguments : toolArguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolResult: freezed == toolResult ? _self._toolResult : toolResult // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AIAction {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'conversation_id') String? get conversationId;@JsonKey(name: 'tool_name') String get toolName; Map<String, dynamic> get arguments; AIActionStatus get status; Map<String, dynamic>? get result;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson) DateTime? get confirmedAt;@JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson) DateTime? get completedAt;
/// Create a copy of AIAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIActionCopyWith<AIAction> get copyWith => _$AIActionCopyWithImpl<AIAction>(this as AIAction, _$identity);

  /// Serializes this AIAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AIAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIAction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.toolName, _this.toolName) || other.toolName == _this.toolName)&&const DeepCollectionEquality().equals(other.arguments, _this.arguments)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.result, _this.result)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.confirmedAt, _this.confirmedAt) || other.confirmedAt == _this.confirmedAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AIAction;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.conversationId,_this.toolName,const DeepCollectionEquality().hash(_this.arguments),_this.status,const DeepCollectionEquality().hash(_this.result),_this.createdAt,_this.confirmedAt,_this.completedAt);
}

@override
String toString() {
  final _this = this as AIAction;
  return 'AIAction(id: ${_this.id}, userId: ${_this.userId}, conversationId: ${_this.conversationId}, toolName: ${_this.toolName}, arguments: ${_this.arguments}, status: ${_this.status}, result: ${_this.result}, createdAt: ${_this.createdAt}, confirmedAt: ${_this.confirmedAt}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $AIActionCopyWith<$Res>  {
  factory $AIActionCopyWith(AIAction value, $Res Function(AIAction) _then) = _$AIActionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'conversation_id') String? conversationId,@JsonKey(name: 'tool_name') String toolName, Map<String, dynamic> arguments, AIActionStatus status, Map<String, dynamic>? result,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson) DateTime? confirmedAt,@JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson) DateTime? completedAt
});




}
/// @nodoc
class _$AIActionCopyWithImpl<$Res>
    implements $AIActionCopyWith<$Res> {
  _$AIActionCopyWithImpl(this._self, this._then);

  final AIAction _self;
  final $Res Function(AIAction) _then;

/// Create a copy of AIAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? conversationId = freezed,Object? toolName = null,Object? arguments = null,Object? status = null,Object? result = freezed,Object? createdAt = freezed,Object? confirmedAt = freezed,Object? completedAt = freezed,}) {
  return _then(AIAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,toolName: null == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AIActionStatus,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIAction].
extension AIActionPatterns on AIAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIAction value)  $default,){
final _that = this;
switch (_that) {
case _AIAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIAction value)?  $default,){
final _that = this;
switch (_that) {
case _AIAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  String? conversationId, @JsonKey(name: 'tool_name')  String toolName,  Map<String, dynamic> arguments,  AIActionStatus status,  Map<String, dynamic>? result, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)  DateTime? confirmedAt, @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIAction() when $default != null:
return $default(_that.id,_that.userId,_that.conversationId,_that.toolName,_that.arguments,_that.status,_that.result,_that.createdAt,_that.confirmedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  String? conversationId, @JsonKey(name: 'tool_name')  String toolName,  Map<String, dynamic> arguments,  AIActionStatus status,  Map<String, dynamic>? result, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)  DateTime? confirmedAt, @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _AIAction():
return $default(_that.id,_that.userId,_that.conversationId,_that.toolName,_that.arguments,_that.status,_that.result,_that.createdAt,_that.confirmedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  String? conversationId, @JsonKey(name: 'tool_name')  String toolName,  Map<String, dynamic> arguments,  AIActionStatus status,  Map<String, dynamic>? result, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)  DateTime? confirmedAt, @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _AIAction() when $default != null:
return $default(_that.id,_that.userId,_that.conversationId,_that.toolName,_that.arguments,_that.status,_that.result,_that.createdAt,_that.confirmedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIAction implements AIAction {
  const _AIAction({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'conversation_id') this.conversationId, @JsonKey(name: 'tool_name') required this.toolName,  Map<String, dynamic> arguments = const {}, this.status = AIActionStatus.pending_confirmation,  Map<String, dynamic>? result, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson) this.confirmedAt, @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson) this.completedAt}): _arguments = arguments,_result = result;
  factory _AIAction.fromJson(Map<String, dynamic> json) => _$AIActionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'conversation_id') final  String? conversationId;
@override@JsonKey(name: 'tool_name') final  String toolName;
 final  Map<String, dynamic> _arguments;
@override@JsonKey() Map<String, dynamic> get arguments {
  if (_arguments is EqualUnmodifiableMapView) return _arguments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_arguments);
}

@override@JsonKey() final  AIActionStatus status;
 final  Map<String, dynamic>? _result;
@override Map<String, dynamic>? get result {
  final value = _result;
  if (value == null) return null;
  if (_result is EqualUnmodifiableMapView) return _result;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson) final  DateTime? confirmedAt;
@override@JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson) final  DateTime? completedAt;

/// Create a copy of AIAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIActionCopyWith<_AIAction> get copyWith => __$AIActionCopyWithImpl<_AIAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIActionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIAction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other.arguments, _arguments)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.result, _result)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,conversationId,toolName,const DeepCollectionEquality().hash(_arguments),status,const DeepCollectionEquality().hash(_result),createdAt,confirmedAt,completedAt);
}

@override
String toString() {
    return 'AIAction(id: $id, userId: $userId, conversationId: $conversationId, toolName: $toolName, arguments: $arguments, status: $status, result: $result, createdAt: $createdAt, confirmedAt: $confirmedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$AIActionCopyWith<$Res> implements $AIActionCopyWith<$Res> {
  factory _$AIActionCopyWith(_AIAction value, $Res Function(_AIAction) _then) = __$AIActionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'conversation_id') String? conversationId,@JsonKey(name: 'tool_name') String toolName, Map<String, dynamic> arguments, AIActionStatus status, Map<String, dynamic>? result,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson) DateTime? confirmedAt,@JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson) DateTime? completedAt
});




}
/// @nodoc
class __$AIActionCopyWithImpl<$Res>
    implements _$AIActionCopyWith<$Res> {
  __$AIActionCopyWithImpl(this._self, this._then);

  final _AIAction _self;
  final $Res Function(_AIAction) _then;

/// Create a copy of AIAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? conversationId = freezed,Object? toolName = null,Object? arguments = null,Object? status = null,Object? result = freezed,Object? createdAt = freezed,Object? confirmedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_AIAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,toolName: null == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self._arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AIActionStatus,result: freezed == result ? _self._result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SyncQueueItem {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'entity_type') String get entityType;@JsonKey(name: 'entity_id') String get entityId; SyncOperation get operation; Map<String, dynamic> get payload; SyncStatus get status;@JsonKey(name: 'retry_count') int get retryCount;@JsonKey(name: 'last_error') String? get lastError;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of SyncQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncQueueItemCopyWith<SyncQueueItem> get copyWith => _$SyncQueueItemCopyWithImpl<SyncQueueItem>(this as SyncQueueItem, _$identity);

  /// Serializes this SyncQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SyncQueueItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncQueueItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.entityType, _this.entityType) || other.entityType == _this.entityType)&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&(identical(other.operation, _this.operation) || other.operation == _this.operation)&&const DeepCollectionEquality().equals(other.payload, _this.payload)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.retryCount, _this.retryCount) || other.retryCount == _this.retryCount)&&(identical(other.lastError, _this.lastError) || other.lastError == _this.lastError)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SyncQueueItem;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.entityType,_this.entityId,_this.operation,const DeepCollectionEquality().hash(_this.payload),_this.status,_this.retryCount,_this.lastError,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SyncQueueItem;
  return 'SyncQueueItem(id: ${_this.id}, userId: ${_this.userId}, entityType: ${_this.entityType}, entityId: ${_this.entityId}, operation: ${_this.operation}, payload: ${_this.payload}, status: ${_this.status}, retryCount: ${_this.retryCount}, lastError: ${_this.lastError}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SyncQueueItemCopyWith<$Res>  {
  factory $SyncQueueItemCopyWith(SyncQueueItem value, $Res Function(SyncQueueItem) _then) = _$SyncQueueItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String entityId, SyncOperation operation, Map<String, dynamic> payload, SyncStatus status,@JsonKey(name: 'retry_count') int retryCount,@JsonKey(name: 'last_error') String? lastError,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$SyncQueueItemCopyWithImpl<$Res>
    implements $SyncQueueItemCopyWith<$Res> {
  _$SyncQueueItemCopyWithImpl(this._self, this._then);

  final SyncQueueItem _self;
  final $Res Function(SyncQueueItem) _then;

/// Create a copy of SyncQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? entityType = null,Object? entityId = null,Object? operation = null,Object? payload = null,Object? status = null,Object? retryCount = null,Object? lastError = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(SyncQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncQueueItem].
extension SyncQueueItemPatterns on SyncQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _SyncQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _SyncQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId,  SyncOperation operation,  Map<String, dynamic> payload,  SyncStatus status, @JsonKey(name: 'retry_count')  int retryCount, @JsonKey(name: 'last_error')  String? lastError, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncQueueItem() when $default != null:
return $default(_that.id,_that.userId,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId,  SyncOperation operation,  Map<String, dynamic> payload,  SyncStatus status, @JsonKey(name: 'retry_count')  int retryCount, @JsonKey(name: 'last_error')  String? lastError, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SyncQueueItem():
return $default(_that.id,_that.userId,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId,  SyncOperation operation,  Map<String, dynamic> payload,  SyncStatus status, @JsonKey(name: 'retry_count')  int retryCount, @JsonKey(name: 'last_error')  String? lastError, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncQueueItem() when $default != null:
return $default(_that.id,_that.userId,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncQueueItem implements SyncQueueItem {
  const _SyncQueueItem({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'entity_type') required this.entityType, @JsonKey(name: 'entity_id') required this.entityId, required this.operation,  Map<String, dynamic> payload = const {}, this.status = SyncStatus.pending, @JsonKey(name: 'retry_count') this.retryCount = 0, @JsonKey(name: 'last_error') this.lastError, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt}): _payload = payload;
  factory _SyncQueueItem.fromJson(Map<String, dynamic> json) => _$SyncQueueItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'entity_type') final  String entityType;
@override@JsonKey(name: 'entity_id') final  String entityId;
@override final  SyncOperation operation;
 final  Map<String, dynamic> _payload;
@override@JsonKey() Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey() final  SyncStatus status;
@override@JsonKey(name: 'retry_count') final  int retryCount;
@override@JsonKey(name: 'last_error') final  String? lastError;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of SyncQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncQueueItemCopyWith<_SyncQueueItem> get copyWith => __$SyncQueueItemCopyWithImpl<_SyncQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other.payload, _payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,entityType,entityId,operation,const DeepCollectionEquality().hash(_payload),status,retryCount,lastError,createdAt,updatedAt);
}

@override
String toString() {
    return 'SyncQueueItem(id: $id, userId: $userId, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SyncQueueItemCopyWith<$Res> implements $SyncQueueItemCopyWith<$Res> {
  factory _$SyncQueueItemCopyWith(_SyncQueueItem value, $Res Function(_SyncQueueItem) _then) = __$SyncQueueItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String entityId, SyncOperation operation, Map<String, dynamic> payload, SyncStatus status,@JsonKey(name: 'retry_count') int retryCount,@JsonKey(name: 'last_error') String? lastError,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$SyncQueueItemCopyWithImpl<$Res>
    implements _$SyncQueueItemCopyWith<$Res> {
  __$SyncQueueItemCopyWithImpl(this._self, this._then);

  final _SyncQueueItem _self;
  final $Res Function(_SyncQueueItem) _then;

/// Create a copy of SyncQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? entityType = null,Object? entityId = null,Object? operation = null,Object? payload = null,Object? status = null,Object? retryCount = null,Object? lastError = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SyncQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
