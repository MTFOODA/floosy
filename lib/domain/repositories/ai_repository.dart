import '../entities/ai_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class AIRepository {
  Future<List<AIConversation>> getConversations(String userId);

  Future<AIConversation?> getConversation(String conversationId);

  Future<AIConversation> createConversation({
    required String userId,
    required String title,
  });

  Future<void> deleteConversation(String conversationId);

  Future<List<AIMessage>> getMessages(String conversationId);

  Future<AIMessage> addUserMessage({
    required String conversationId,
    required String userId,
    required String content,
  });

  Future<AIMessage> addAssistantMessage({
    required String conversationId,
    required String userId,
    required String content,
  });

  Future<AIMessage> addToolMessage({
    required String conversationId,
    required String userId,
    required String toolName,
    required Map<String, dynamic> toolArguments,
    required Map<String, dynamic>? toolResult,
  });

  Future<List<AIAction>> getPendingActions(String userId);

  Future<AIAction?> getAction(String actionId);

  Future<AIAction> createAction({
    required String userId,
    required String toolName,
    required Map<String, dynamic> arguments,
    String? conversationId,
  });

  Future<AIAction> confirmAction(String actionId);

  Future<AIAction> rejectAction(String actionId);

  Future<AIAction> completeAction({
    required String actionId,
    required Map<String, dynamic> result,
  });

  Future<AIAction> failAction({
    required String actionId,
    required String errorMessage,
  });

  Future<Map<String, dynamic>> getFinancialSummary(String userId);

  Future<String> getSpendingInsights(String userId);

  Future<List<String>> getRecommendations(String userId);
}
