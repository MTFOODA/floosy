import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/budget_model.dart';

class RecurringExpenseRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  RecurringExpenseRemoteDataSource(this._supabaseClient);

  Future<List<RecurringExpense>> getRecurringExpenses(String userId) async {
    final response = await _supabaseClient
        .from('recurring_expenses')
        .select()
        .eq('user_id', userId)
        .order('next_due_date');
    return (response as List)
        .map((json) => RecurringExpense.fromJson(json))
        .toList();
  }

  Future<RecurringExpense?> getRecurringExpense(String expenseId) async {
    final response = await _supabaseClient
        .from('recurring_expenses')
        .select()
        .eq('id', expenseId)
        .maybeSingle();
    return response == null ? null : RecurringExpense.fromJson(response);
  }

  Future<RecurringExpense> createRecurringExpense(
      RecurringExpense expense) async {
    final withId =
        expense.id.isEmpty ? expense.copyWith(id: _uuid.v4()) : expense;
    final response = await _supabaseClient
        .from('recurring_expenses')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return RecurringExpense.fromJson(response);
  }

  Future<RecurringExpense> updateRecurringExpense(
      RecurringExpense expense) async {
    final response = await _supabaseClient
        .from('recurring_expenses')
        .update(expense.toJson()..remove('created_at'))
        .eq('id', expense.id)
        .select()
        .single();
    return RecurringExpense.fromJson(response);
  }

  Future<void> deleteRecurringExpense(String expenseId) async {
    await _supabaseClient
        .from('recurring_expenses')
        .delete()
        .eq('id', expenseId);
  }

  Future<List<RecurringExpenseOccurrence>> getOccurrences(
      String recurringExpenseId) async {
    final response = await _supabaseClient
        .from('recurring_expense_occurrences')
        .select()
        .eq('recurring_expense_id', recurringExpenseId)
        .order('scheduled_date');
    return (response as List)
        .map((json) => RecurringExpenseOccurrence.fromJson(json))
        .toList();
  }

  Future<void> markOccurrenceAsPaid(
      String occurrenceId, String? transactionId) async {
    await _supabaseClient.from('recurring_expense_occurrences').update({
      'status': 'paid',
      if (transactionId != null) 'transaction_id': transactionId,
    }).eq('id', occurrenceId);
  }
}
