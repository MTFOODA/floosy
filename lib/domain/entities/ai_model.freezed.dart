// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIConversation _$AIConversationFromJson(Map<String, dynamic> json) {
  return _AIConversation.fromJson(json);
}

/// @nodoc
mixin _$AIConversation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AIConversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIConversationCopyWith<AIConversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIConversationCopyWith<$Res> {
  factory $AIConversationCopyWith(
          AIConversation value, $Res Function(AIConversation) then) =
      _$AIConversationCopyWithImpl<$Res, AIConversation>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String? title,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$AIConversationCopyWithImpl<$Res, $Val extends AIConversation>
    implements $AIConversationCopyWith<$Res> {
  _$AIConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
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
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AIConversationImplCopyWith<$Res>
    implements $AIConversationCopyWith<$Res> {
  factory _$$AIConversationImplCopyWith(_$AIConversationImpl value,
          $Res Function(_$AIConversationImpl) then) =
      __$$AIConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String? title,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$AIConversationImplCopyWithImpl<$Res>
    extends _$AIConversationCopyWithImpl<$Res, _$AIConversationImpl>
    implements _$$AIConversationImplCopyWith<$Res> {
  __$$AIConversationImplCopyWithImpl(
      _$AIConversationImpl _value, $Res Function(_$AIConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AIConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
class _$AIConversationImpl implements _AIConversation {
  const _$AIConversationImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      this.title,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$AIConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIConversationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String? title;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AIConversation(id: $id, userId: $userId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, title, createdAt, updatedAt);

  /// Create a copy of AIConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIConversationImplCopyWith<_$AIConversationImpl> get copyWith =>
      __$$AIConversationImplCopyWithImpl<_$AIConversationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIConversationImplToJson(
      this,
    );
  }
}

abstract class _AIConversation implements AIConversation {
  const factory _AIConversation(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      final String? title,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$AIConversationImpl;

  factory _AIConversation.fromJson(Map<String, dynamic> json) =
      _$AIConversationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String? get title;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of AIConversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIConversationImplCopyWith<_$AIConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIMessage _$AIMessageFromJson(Map<String, dynamic> json) {
  return _AIMessage.fromJson(json);
}

/// @nodoc
mixin _$AIMessage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  String get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  AIMessageRole get role => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'tool_name')
  String? get toolName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tool_arguments')
  Map<String, dynamic>? get toolArguments => throw _privateConstructorUsedError;
  @JsonKey(name: 'tool_result')
  Map<String, dynamic>? get toolResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AIMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIMessageCopyWith<AIMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIMessageCopyWith<$Res> {
  factory $AIMessageCopyWith(AIMessage value, $Res Function(AIMessage) then) =
      _$AIMessageCopyWithImpl<$Res, AIMessage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_id') String conversationId,
      @JsonKey(name: 'user_id') String userId,
      AIMessageRole role,
      String? content,
      @JsonKey(name: 'tool_name') String? toolName,
      @JsonKey(name: 'tool_arguments') Map<String, dynamic>? toolArguments,
      @JsonKey(name: 'tool_result') Map<String, dynamic>? toolResult,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$AIMessageCopyWithImpl<$Res, $Val extends AIMessage>
    implements $AIMessageCopyWith<$Res> {
  _$AIMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? role = null,
    Object? content = freezed,
    Object? toolName = freezed,
    Object? toolArguments = freezed,
    Object? toolResult = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as AIMessageRole,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      toolName: freezed == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolArguments: freezed == toolArguments
          ? _value.toolArguments
          : toolArguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolResult: freezed == toolResult
          ? _value.toolResult
          : toolResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIMessageImplCopyWith<$Res>
    implements $AIMessageCopyWith<$Res> {
  factory _$$AIMessageImplCopyWith(
          _$AIMessageImpl value, $Res Function(_$AIMessageImpl) then) =
      __$$AIMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_id') String conversationId,
      @JsonKey(name: 'user_id') String userId,
      AIMessageRole role,
      String? content,
      @JsonKey(name: 'tool_name') String? toolName,
      @JsonKey(name: 'tool_arguments') Map<String, dynamic>? toolArguments,
      @JsonKey(name: 'tool_result') Map<String, dynamic>? toolResult,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$AIMessageImplCopyWithImpl<$Res>
    extends _$AIMessageCopyWithImpl<$Res, _$AIMessageImpl>
    implements _$$AIMessageImplCopyWith<$Res> {
  __$$AIMessageImplCopyWithImpl(
      _$AIMessageImpl _value, $Res Function(_$AIMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? role = null,
    Object? content = freezed,
    Object? toolName = freezed,
    Object? toolArguments = freezed,
    Object? toolResult = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AIMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as AIMessageRole,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      toolName: freezed == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolArguments: freezed == toolArguments
          ? _value._toolArguments
          : toolArguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolResult: freezed == toolResult
          ? _value._toolResult
          : toolResult // ignore: cast_nullable_to_non_nullable
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
class _$AIMessageImpl implements _AIMessage {
  const _$AIMessageImpl(
      {required this.id,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      @JsonKey(name: 'user_id') required this.userId,
      required this.role,
      this.content,
      @JsonKey(name: 'tool_name') this.toolName,
      @JsonKey(name: 'tool_arguments')
      final Map<String, dynamic>? toolArguments,
      @JsonKey(name: 'tool_result') final Map<String, dynamic>? toolResult,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt})
      : _toolArguments = toolArguments,
        _toolResult = toolResult;

  factory _$AIMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIMessageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final AIMessageRole role;
  @override
  final String? content;
  @override
  @JsonKey(name: 'tool_name')
  final String? toolName;
  final Map<String, dynamic>? _toolArguments;
  @override
  @JsonKey(name: 'tool_arguments')
  Map<String, dynamic>? get toolArguments {
    final value = _toolArguments;
    if (value == null) return null;
    if (_toolArguments is EqualUnmodifiableMapView) return _toolArguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _toolResult;
  @override
  @JsonKey(name: 'tool_result')
  Map<String, dynamic>? get toolResult {
    final value = _toolResult;
    if (value == null) return null;
    if (_toolResult is EqualUnmodifiableMapView) return _toolResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AIMessage(id: $id, conversationId: $conversationId, userId: $userId, role: $role, content: $content, toolName: $toolName, toolArguments: $toolArguments, toolResult: $toolResult, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality()
                .equals(other._toolArguments, _toolArguments) &&
            const DeepCollectionEquality()
                .equals(other._toolResult, _toolResult) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      userId,
      role,
      content,
      toolName,
      const DeepCollectionEquality().hash(_toolArguments),
      const DeepCollectionEquality().hash(_toolResult),
      createdAt);

  /// Create a copy of AIMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIMessageImplCopyWith<_$AIMessageImpl> get copyWith =>
      __$$AIMessageImplCopyWithImpl<_$AIMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIMessageImplToJson(
      this,
    );
  }
}

abstract class _AIMessage implements AIMessage {
  const factory _AIMessage(
      {required final String id,
      @JsonKey(name: 'conversation_id') required final String conversationId,
      @JsonKey(name: 'user_id') required final String userId,
      required final AIMessageRole role,
      final String? content,
      @JsonKey(name: 'tool_name') final String? toolName,
      @JsonKey(name: 'tool_arguments')
      final Map<String, dynamic>? toolArguments,
      @JsonKey(name: 'tool_result') final Map<String, dynamic>? toolResult,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$AIMessageImpl;

  factory _AIMessage.fromJson(Map<String, dynamic> json) =
      _$AIMessageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'conversation_id')
  String get conversationId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  AIMessageRole get role;
  @override
  String? get content;
  @override
  @JsonKey(name: 'tool_name')
  String? get toolName;
  @override
  @JsonKey(name: 'tool_arguments')
  Map<String, dynamic>? get toolArguments;
  @override
  @JsonKey(name: 'tool_result')
  Map<String, dynamic>? get toolResult;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of AIMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIMessageImplCopyWith<_$AIMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIAction _$AIActionFromJson(Map<String, dynamic> json) {
  return _AIAction.fromJson(json);
}

/// @nodoc
mixin _$AIAction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  String? get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tool_name')
  String get toolName => throw _privateConstructorUsedError;
  Map<String, dynamic> get arguments => throw _privateConstructorUsedError;
  AIActionStatus get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this AIAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIActionCopyWith<AIAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIActionCopyWith<$Res> {
  factory $AIActionCopyWith(AIAction value, $Res Function(AIAction) then) =
      _$AIActionCopyWithImpl<$Res, AIAction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'conversation_id') String? conversationId,
      @JsonKey(name: 'tool_name') String toolName,
      Map<String, dynamic> arguments,
      AIActionStatus status,
      Map<String, dynamic>? result,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
      DateTime? confirmedAt,
      @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
      DateTime? completedAt});
}

/// @nodoc
class _$AIActionCopyWithImpl<$Res, $Val extends AIAction>
    implements $AIActionCopyWith<$Res> {
  _$AIActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? conversationId = freezed,
    Object? toolName = null,
    Object? arguments = null,
    Object? status = null,
    Object? result = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
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
      conversationId: freezed == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String?,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: null == arguments
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AIActionStatus,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIActionImplCopyWith<$Res>
    implements $AIActionCopyWith<$Res> {
  factory _$$AIActionImplCopyWith(
          _$AIActionImpl value, $Res Function(_$AIActionImpl) then) =
      __$$AIActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'conversation_id') String? conversationId,
      @JsonKey(name: 'tool_name') String toolName,
      Map<String, dynamic> arguments,
      AIActionStatus status,
      Map<String, dynamic>? result,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
      DateTime? confirmedAt,
      @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
      DateTime? completedAt});
}

/// @nodoc
class __$$AIActionImplCopyWithImpl<$Res>
    extends _$AIActionCopyWithImpl<$Res, _$AIActionImpl>
    implements _$$AIActionImplCopyWith<$Res> {
  __$$AIActionImplCopyWithImpl(
      _$AIActionImpl _value, $Res Function(_$AIActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? conversationId = freezed,
    Object? toolName = null,
    Object? arguments = null,
    Object? status = null,
    Object? result = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$AIActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: freezed == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String?,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: null == arguments
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AIActionStatus,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIActionImpl implements _AIAction {
  const _$AIActionImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'conversation_id') this.conversationId,
      @JsonKey(name: 'tool_name') required this.toolName,
      final Map<String, dynamic> arguments = const {},
      this.status = AIActionStatus.pending_confirmation,
      final Map<String, dynamic>? result,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
      this.confirmedAt,
      @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
      this.completedAt})
      : _arguments = arguments,
        _result = result;

  factory _$AIActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIActionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'conversation_id')
  final String? conversationId;
  @override
  @JsonKey(name: 'tool_name')
  final String toolName;
  final Map<String, dynamic> _arguments;
  @override
  @JsonKey()
  Map<String, dynamic> get arguments {
    if (_arguments is EqualUnmodifiableMapView) return _arguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_arguments);
  }

  @override
  @JsonKey()
  final AIActionStatus status;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
  final DateTime? completedAt;

  @override
  String toString() {
    return 'AIAction(id: $id, userId: $userId, conversationId: $conversationId, toolName: $toolName, arguments: $arguments, status: $status, result: $result, createdAt: $createdAt, confirmedAt: $confirmedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      conversationId,
      toolName,
      const DeepCollectionEquality().hash(_arguments),
      status,
      const DeepCollectionEquality().hash(_result),
      createdAt,
      confirmedAt,
      completedAt);

  /// Create a copy of AIAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIActionImplCopyWith<_$AIActionImpl> get copyWith =>
      __$$AIActionImplCopyWithImpl<_$AIActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIActionImplToJson(
      this,
    );
  }
}

abstract class _AIAction implements AIAction {
  const factory _AIAction(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'conversation_id') final String? conversationId,
      @JsonKey(name: 'tool_name') required final String toolName,
      final Map<String, dynamic> arguments,
      final AIActionStatus status,
      final Map<String, dynamic>? result,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
      final DateTime? confirmedAt,
      @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
      final DateTime? completedAt}) = _$AIActionImpl;

  factory _AIAction.fromJson(Map<String, dynamic> json) =
      _$AIActionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'conversation_id')
  String? get conversationId;
  @override
  @JsonKey(name: 'tool_name')
  String get toolName;
  @override
  Map<String, dynamic> get arguments;
  @override
  AIActionStatus get status;
  @override
  Map<String, dynamic>? get result;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
  DateTime? get completedAt;

  /// Create a copy of AIAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIActionImplCopyWith<_$AIActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncQueueItem _$SyncQueueItemFromJson(Map<String, dynamic> json) {
  return _SyncQueueItem.fromJson(json);
}

/// @nodoc
mixin _$SyncQueueItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  SyncOperation get operation => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  SyncStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'retry_count')
  int get retryCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_error')
  String? get lastError => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SyncQueueItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncQueueItemCopyWith<SyncQueueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncQueueItemCopyWith<$Res> {
  factory $SyncQueueItemCopyWith(
          SyncQueueItem value, $Res Function(SyncQueueItem) then) =
      _$SyncQueueItemCopyWithImpl<$Res, SyncQueueItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      SyncOperation operation,
      Map<String, dynamic> payload,
      SyncStatus status,
      @JsonKey(name: 'retry_count') int retryCount,
      @JsonKey(name: 'last_error') String? lastError,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$SyncQueueItemCopyWithImpl<$Res, $Val extends SyncQueueItem>
    implements $SyncQueueItemCopyWith<$Res> {
  _$SyncQueueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? status = null,
    Object? retryCount = null,
    Object? lastError = freezed,
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
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as SyncOperation,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SyncQueueItemImplCopyWith<$Res>
    implements $SyncQueueItemCopyWith<$Res> {
  factory _$$SyncQueueItemImplCopyWith(
          _$SyncQueueItemImpl value, $Res Function(_$SyncQueueItemImpl) then) =
      __$$SyncQueueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      SyncOperation operation,
      Map<String, dynamic> payload,
      SyncStatus status,
      @JsonKey(name: 'retry_count') int retryCount,
      @JsonKey(name: 'last_error') String? lastError,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$SyncQueueItemImplCopyWithImpl<$Res>
    extends _$SyncQueueItemCopyWithImpl<$Res, _$SyncQueueItemImpl>
    implements _$$SyncQueueItemImplCopyWith<$Res> {
  __$$SyncQueueItemImplCopyWithImpl(
      _$SyncQueueItemImpl _value, $Res Function(_$SyncQueueItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? status = null,
    Object? retryCount = null,
    Object? lastError = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SyncQueueItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as SyncOperation,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
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
class _$SyncQueueItemImpl implements _SyncQueueItem {
  const _$SyncQueueItemImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      required this.operation,
      final Map<String, dynamic> payload = const {},
      this.status = SyncStatus.pending,
      @JsonKey(name: 'retry_count') this.retryCount = 0,
      @JsonKey(name: 'last_error') this.lastError,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt})
      : _payload = payload;

  factory _$SyncQueueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncQueueItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  final SyncOperation operation;
  final Map<String, dynamic> _payload;
  @override
  @JsonKey()
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  @JsonKey()
  final SyncStatus status;
  @override
  @JsonKey(name: 'retry_count')
  final int retryCount;
  @override
  @JsonKey(name: 'last_error')
  final String? lastError;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SyncQueueItem(id: $id, userId: $userId, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncQueueItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError) &&
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
      entityType,
      entityId,
      operation,
      const DeepCollectionEquality().hash(_payload),
      status,
      retryCount,
      lastError,
      createdAt,
      updatedAt);

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncQueueItemImplCopyWith<_$SyncQueueItemImpl> get copyWith =>
      __$$SyncQueueItemImplCopyWithImpl<_$SyncQueueItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncQueueItemImplToJson(
      this,
    );
  }
}

abstract class _SyncQueueItem implements SyncQueueItem {
  const factory _SyncQueueItem(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'entity_type') required final String entityType,
      @JsonKey(name: 'entity_id') required final String entityId,
      required final SyncOperation operation,
      final Map<String, dynamic> payload,
      final SyncStatus status,
      @JsonKey(name: 'retry_count') final int retryCount,
      @JsonKey(name: 'last_error') final String? lastError,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$SyncQueueItemImpl;

  factory _SyncQueueItem.fromJson(Map<String, dynamic> json) =
      _$SyncQueueItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  SyncOperation get operation;
  @override
  Map<String, dynamic> get payload;
  @override
  SyncStatus get status;
  @override
  @JsonKey(name: 'retry_count')
  int get retryCount;
  @override
  @JsonKey(name: 'last_error')
  String? get lastError;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncQueueItemImplCopyWith<_$SyncQueueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
