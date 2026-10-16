import 'package:freezed_annotation/freezed_annotation.dart';

// Enum values mirror the PostgreSQL enum values 1:1 (snake_case).
// ignore_for_file: constant_identifier_names
part 'ai_model.freezed.dart';
part 'ai_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

enum AIMessageRole { user, assistant, tool, system }

@freezed
class AIConversation with _$AIConversation {
  const factory AIConversation({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    String? title,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _AIConversation;

  factory AIConversation.fromJson(Map<String, dynamic> json) =>
      _$AIConversationFromJson(json);
}

@freezed
class AIMessage with _$AIMessage {
  const factory AIMessage({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'user_id') required String userId,
    required AIMessageRole role,
    String? content,
    @JsonKey(name: 'tool_name') String? toolName,
    @JsonKey(name: 'tool_arguments') Map<String, dynamic>? toolArguments,
    @JsonKey(name: 'tool_result') Map<String, dynamic>? toolResult,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _AIMessage;

  factory AIMessage.fromJson(Map<String, dynamic> json) =>
      _$AIMessageFromJson(json);
}

enum AIActionStatus {
  pending_confirmation,
  confirmed,
  rejected,
  completed,
  failed
}

@freezed
class AIAction with _$AIAction {
  const factory AIAction({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'conversation_id') String? conversationId,
    @JsonKey(name: 'tool_name') required String toolName,
    @Default({}) Map<String, dynamic> arguments,
    @Default(AIActionStatus.pending_confirmation) AIActionStatus status,
    Map<String, dynamic>? result,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'confirmed_at', fromJson: _dateTimeFromJson)
    DateTime? confirmedAt,
    @JsonKey(name: 'completed_at', fromJson: _dateTimeFromJson)
    DateTime? completedAt,
  }) = _AIAction;

  factory AIAction.fromJson(Map<String, dynamic> json) =>
      _$AIActionFromJson(json);
}

enum SyncOperation { insert, update, delete }

enum SyncStatus { pending, processing, completed, failed }

@freezed
class SyncQueueItem with _$SyncQueueItem {
  const factory SyncQueueItem({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') required String entityId,
    required SyncOperation operation,
    @Default({}) Map<String, dynamic> payload,
    @Default(SyncStatus.pending) SyncStatus status,
    @JsonKey(name: 'retry_count') @Default(0) int retryCount,
    @JsonKey(name: 'last_error') String? lastError,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _SyncQueueItem;

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) =>
      _$SyncQueueItemFromJson(json);
}
