// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIConversationImpl _$$AIConversationImplFromJson(Map<String, dynamic> json) =>
    _$AIConversationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$AIConversationImplToJson(
        _$AIConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AIMessageImpl _$$AIMessageImplFromJson(Map<String, dynamic> json) =>
    _$AIMessageImpl(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      role: $enumDecode(_$AIMessageRoleEnumMap, json['role']),
      content: json['content'] as String?,
      toolName: json['tool_name'] as String?,
      toolArguments: json['tool_arguments'] as Map<String, dynamic>?,
      toolResult: json['tool_result'] as Map<String, dynamic>?,
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$AIMessageImplToJson(_$AIMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'user_id': instance.userId,
      'role': _$AIMessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'tool_name': instance.toolName,
      'tool_arguments': instance.toolArguments,
      'tool_result': instance.toolResult,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$AIMessageRoleEnumMap = {
  AIMessageRole.user: 'user',
  AIMessageRole.assistant: 'assistant',
  AIMessageRole.tool: 'tool',
  AIMessageRole.system: 'system',
};

_$AIActionImpl _$$AIActionImplFromJson(Map<String, dynamic> json) =>
    _$AIActionImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      conversationId: json['conversation_id'] as String?,
      toolName: json['tool_name'] as String,
      arguments: json['arguments'] as Map<String, dynamic>? ?? const {},
      status: $enumDecodeNullable(_$AIActionStatusEnumMap, json['status']) ??
          AIActionStatus.pending_confirmation,
      result: json['result'] as Map<String, dynamic>?,
      createdAt: _dateTimeFromJson(json['created_at']),
      confirmedAt: _dateTimeFromJson(json['confirmed_at']),
      completedAt: _dateTimeFromJson(json['completed_at']),
    );

Map<String, dynamic> _$$AIActionImplToJson(_$AIActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'conversation_id': instance.conversationId,
      'tool_name': instance.toolName,
      'arguments': instance.arguments,
      'status': _$AIActionStatusEnumMap[instance.status]!,
      'result': instance.result,
      'created_at': instance.createdAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

const _$AIActionStatusEnumMap = {
  AIActionStatus.pending_confirmation: 'pending_confirmation',
  AIActionStatus.confirmed: 'confirmed',
  AIActionStatus.rejected: 'rejected',
  AIActionStatus.completed: 'completed',
  AIActionStatus.failed: 'failed',
};

_$SyncQueueItemImpl _$$SyncQueueItemImplFromJson(Map<String, dynamic> json) =>
    _$SyncQueueItemImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      operation: $enumDecode(_$SyncOperationEnumMap, json['operation']),
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      status: $enumDecodeNullable(_$SyncStatusEnumMap, json['status']) ??
          SyncStatus.pending,
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
      lastError: json['last_error'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$SyncQueueItemImplToJson(_$SyncQueueItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'operation': _$SyncOperationEnumMap[instance.operation]!,
      'payload': instance.payload,
      'status': _$SyncStatusEnumMap[instance.status]!,
      'retry_count': instance.retryCount,
      'last_error': instance.lastError,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$SyncOperationEnumMap = {
  SyncOperation.insert: 'insert',
  SyncOperation.update: 'update',
  SyncOperation.delete: 'delete',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.processing: 'processing',
  SyncStatus.completed: 'completed',
  SyncStatus.failed: 'failed',
};
