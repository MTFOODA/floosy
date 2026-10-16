import '../models/ai_model.dart';
import '../remote/datasources/ai_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepository({required this.remoteDataSource});

  /// Get all conversations for a user
  Future<List<AIConversation>> getConversations(String userId) async {
    try {
      return await remoteDataSource.getConversations(userId);
    } catch (e) {
      logError('Error getting conversations: $e');
      return [];
    }
  }

  /// Get conversation by ID
  Future<AIConversation?> getConversation(String conversationId) async {
    try {
      return await remoteDataSource.getConversation(conversationId);
    } catch (e) {
      logError('Error getting conversation: $e');
      return null;
    }
  }

  /// Create a new conversation
  Future<AIConversation> createConversation({
    required String userId,
    required String title,
  }) async {
    final conversation = AIConversation(
      id: '',
      userId: userId,
      title: title,
    );

    try {
      return await remoteDataSource.createConversation(conversation);
    } catch (e) {
      logError('Error creating conversation: $e');
      rethrow;
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
    } catch (e) {
      logError('Error deleting conversation: $e');
      rethrow;
    }
  }

  /// Get messages in a conversation
  Future<List<AIMessage>> getMessages(String conversationId) async {
    try {
      return await remoteDataSource.getMessages(conversationId);
    } catch (e) {
      logError('Error getting messages: $e');
      return [];
    }
  }

  /// Add a user message to conversation
  Future<AIMessage> addUserMessage({
    required String conversationId,
    required String userId,
    required String content,
  }) async {
    final message = AIMessage(
      id: '',
      conversationId: conversationId,
      userId: userId,
      role: AIMessageRole.user,
      content: content,
      toolName: null,
      toolArguments: null,
      toolResult: null,
    );

    try {
      return await remoteDataSource.addMessage(message);
    } catch (e) {
      logError('Error adding user message: $e');
      rethrow;
    }
  }

  /// Add an assistant message to conversation
  Future<AIMessage> addAssistantMessage({
    required String conversationId,
    required String userId,
    required String content,
  }) async {
    final message = AIMessage(
      id: '',
      conversationId: conversationId,
      userId: userId,
      role: AIMessageRole.assistant,
      content: content,
      toolName: null,
      toolArguments: null,
      toolResult: null,
    );

    try {
      return await remoteDataSource.addMessage(message);
    } catch (e) {
      logError('Error adding assistant message: $e');
      rethrow;
    }
  }

  /// Add a tool call message
  Future<AIMessage> addToolMessage({
    required String conversationId,
    required String userId,
    required String toolName,
    required Map<String, dynamic> toolArguments,
    required Map<String, dynamic>? toolResult,
  }) async {
    final message = AIMessage(
      id: '',
      conversationId: conversationId,
      userId: userId,
      role: AIMessageRole.tool,
      content: 'Tool call: $toolName',
      toolName: toolName,
      toolArguments: toolArguments,
      toolResult: toolResult,
    );

    try {
      return await remoteDataSource.addMessage(message);
    } catch (e) {
      logError('Error adding tool message: $e');
      rethrow;
    }
  }

  /// Get pending AI actions for a user
  Future<List<AIAction>> getPendingActions(String userId) async {
    try {
      return await remoteDataSource.getPendingActions(userId);
    } catch (e) {
      logError('Error getting pending actions: $e');
      return [];
    }
  }

  /// Get AI action by ID
  Future<AIAction?> getAction(String actionId) async {
    try {
      return await remoteDataSource.getAction(actionId);
    } catch (e) {
      logError('Error getting action: $e');
      return null;
    }
  }

  /// Create a new AI action (pending confirmation)
  Future<AIAction> createAction({
    required String userId,
    required String toolName,
    required Map<String, dynamic> arguments,
    String? conversationId,
  }) async {
    final action = AIAction(
      id: '',
      userId: userId,
      conversationId: conversationId,
      toolName: toolName,
      arguments: arguments,
      status: AIActionStatus.pending_confirmation,
      result: null,
    );

    try {
      return await remoteDataSource.createAction(action);
    } catch (e) {
      logError('Error creating action: $e');
      rethrow;
    }
  }

  /// Confirm an AI action
  Future<AIAction> confirmAction(String actionId) async {
    try {
      return await remoteDataSource.updateActionStatus(
        actionId,
        AIActionStatus.confirmed,
      );
    } catch (e) {
      logError('Error confirming action: $e');
      rethrow;
    }
  }

  /// Reject an AI action
  Future<AIAction> rejectAction(String actionId) async {
    try {
      return await remoteDataSource.updateActionStatus(
        actionId,
        AIActionStatus.rejected,
      );
    } catch (e) {
      logError('Error rejecting action: $e');
      rethrow;
    }
  }

  /// Complete an AI action with result
  Future<AIAction> completeAction({
    required String actionId,
    required Map<String, dynamic> result,
  }) async {
    try {
      return await remoteDataSource.completeAction(actionId, result);
    } catch (e) {
      logError('Error completing action: $e');
      rethrow;
    }
  }

  /// Fail an AI action
  Future<AIAction> failAction({
    required String actionId,
    required String errorMessage,
  }) async {
    try {
      return await remoteDataSource.failAction(actionId, errorMessage);
    } catch (e) {
      logError('Error failing action: $e');
      rethrow;
    }
  }

  /// Get financial summary for AI context
  Future<Map<String, dynamic>> getFinancialSummary(String userId) async {
    try {
      return await remoteDataSource.getFinancialSummary(userId);
    } catch (e) {
      logError('Error getting financial summary: $e');
      return {};
    }
  }

  /// Get spending insights
  Future<String> getSpendingInsights(String userId) async {
    try {
      return await remoteDataSource.getSpendingInsights(userId);
    } catch (e) {
      logError('Error getting spending insights: $e');
      return '';
    }
  }

  /// Get recommendations
  Future<List<String>> getRecommendations(String userId) async {
    try {
      return await remoteDataSource.getRecommendations(userId);
    } catch (e) {
      logError('Error getting recommendations: $e');
      return [];
    }
  }
}
