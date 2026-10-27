import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/ai_model.dart';

class AIRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  AIRemoteDataSource(this._supabaseClient);

  Future<List<AIConversation>> getConversations(String userId) async {
    final response = await _supabaseClient
        .from('ai_conversations')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false);
    return (response as List)
        .map((json) => AIConversation.fromJson(json))
        .toList();
  }

  Future<AIConversation?> getConversation(String conversationId) async {
    final response = await _supabaseClient
        .from('ai_conversations')
        .select()
        .eq('id', conversationId)
        .maybeSingle();
    return response == null ? null : AIConversation.fromJson(response);
  }

  Future<AIConversation> createConversation(AIConversation conversation) async {
    final withId = conversation.id.isEmpty
        ? conversation.copyWith(id: _uuid.v4())
        : conversation;
    final response = await _supabaseClient
        .from('ai_conversations')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return AIConversation.fromJson(response);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _supabaseClient
        .from('ai_conversations')
        .delete()
        .eq('id', conversationId);
  }

  Future<List<AIMessage>> getMessages(String conversationId) async {
    final response = await _supabaseClient
        .from('ai_messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at');
    return (response as List).map((json) => AIMessage.fromJson(json)).toList();
  }

  Future<AIMessage> addMessage(AIMessage message) async {
    final withId =
        message.id.isEmpty ? message.copyWith(id: _uuid.v4()) : message;
    final response = await _supabaseClient
        .from('ai_messages')
        .insert(withId.toJson()..remove('created_at'))
        .select()
        .single();
    return AIMessage.fromJson(response);
  }

  Future<List<AIAction>> getPendingActions(String userId) async {
    final response = await _supabaseClient
        .from('ai_actions')
        .select()
        .eq('user_id', userId)
        .eq('status', 'pending_confirmation')
        .order('created_at', ascending: false);
    return (response as List).map((json) => AIAction.fromJson(json)).toList();
  }

  Future<AIAction?> getAction(String actionId) async {
    final response = await _supabaseClient
        .from('ai_actions')
        .select()
        .eq('id', actionId)
        .maybeSingle();
    return response == null ? null : AIAction.fromJson(response);
  }

  Future<AIAction> createAction(AIAction action) async {
    final withId = action.id.isEmpty ? action.copyWith(id: _uuid.v4()) : action;
    final response = await _supabaseClient
        .from('ai_actions')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('confirmed_at')
          ..remove('completed_at'))
        .select()
        .single();
    return AIAction.fromJson(response);
  }

  Future<AIAction> updateActionStatus(
      String actionId, AIActionStatus status) async {
    final response = await _supabaseClient
        .from('ai_actions')
        .update({
          'status': status.name,
          if (status == AIActionStatus.confirmed)
            'confirmed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', actionId)
        .select()
        .single();
    return AIAction.fromJson(response);
  }

  Future<AIAction> completeAction(
      String actionId, Map<String, dynamic> result) async {
    final response = await _supabaseClient
        .from('ai_actions')
        .update({
          'status': 'completed',
          'result': result,
          'completed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', actionId)
        .select()
        .single();
    return AIAction.fromJson(response);
  }

  Future<AIAction> failAction(String actionId, String errorMessage) async {
    final response = await _supabaseClient
        .from('ai_actions')
        .update({
          'status': 'failed',
          'result': {'error': errorMessage},
          'completed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', actionId)
        .select()
        .single();
    return AIAction.fromJson(response);
  }

  Future<Map<String, dynamic>> getFinancialSummary(String userId) async {
    final now = DateTime.now().toUtc();
    final monthStart = DateTime(now.year, now.month).toUtc();
    final expenses = await _supabaseClient
        .from('expenses')
        .select('amount_minor,payment_method')
        .eq('user_id', userId)
        .gte('expense_date', monthStart.toIso8601String());
    int total = 0, card = 0, cash = 0;
    for (final row in (expenses as List)) {
      final amount = row['amount_minor'];
      final minor = amount is int ? amount : int.parse(amount.toString());
      total += minor;
      if (row['payment_method'] == 'card') {
        card += minor;
      } else {
        cash += minor;
      }
    }
    final balance = await _supabaseClient
        .rpc('get_cash_balance', params: {'user_id_param': userId});
    return {
      'month': now.month,
      'year': now.year,
      'total_expenses_minor': total,
      'card_expenses_minor': card,
      'cash_expenses_minor': cash,
      'cash_balance_minor': balance is num ? balance.toInt() : 0,
    };
  }

  Future<String> getSpendingInsights(String userId) async {
    final summary = await getFinancialSummary(userId);
    final total = summary['total_expenses_minor'] as int;
    final card = summary['card_expenses_minor'] as int;
    final cash = summary['cash_expenses_minor'] as int;
    if (total == 0) return 'No expenses recorded yet for this month.';
    final cardPct = (card / total * 100).toStringAsFixed(0);
    return 'This month you spent $total minor units: $cardPct% by card ($card) and the rest in cash ($cash).';
  }

  Future<List<String>> getRecommendations(String userId) async {
    final now = DateTime.now().toUtc();
    final stats = await _supabaseClient
        .from('monthly_item_statistics')
        .select('item_id,quantity,total_spending_minor')
        .eq('user_id', userId)
        .eq('year', now.year)
        .eq('month', now.month)
        .gt('total_spending_minor', 0)
        .order('total_spending_minor', ascending: false)
        .limit(3);
    final recommendations = <String>[];
    for (final row in (stats as List)) {
      final spending = row['total_spending_minor'];
      final minor = spending is int ? spending : int.parse(spending.toString());
      final potential = minor * 0.1;
      recommendations.add(
          'Reducing usage of item ${row['item_id']} by 10% could save $potential minor units this month.');
    }
    return recommendations;
  }
}
