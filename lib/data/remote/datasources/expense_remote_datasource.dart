import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/transaction_model.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  ExpenseRemoteDataSource(this._supabaseClient);

  Future<List<Expense>> getExpenses(String userId) async {
    final response = await _supabaseClient
        .from('expenses')
        .select()
        .eq('user_id', userId)
        .order('expense_date', ascending: false)
        .limit(1000);
    return (response as List).map((json) => Expense.fromJson(json)).toList();
  }

  Future<Expense?> getExpense(String expenseId) async {
    final response = await _supabaseClient
        .from('expenses')
        .select()
        .eq('id', expenseId)
        .maybeSingle();
    return response == null ? null : Expense.fromJson(response);
  }

  Future<Expense> createExpense(Expense expense) async {
    final withId =
        expense.id.isEmpty ? expense.copyWith(id: _uuid.v4()) : expense;
    final response = await _supabaseClient
        .from('expenses')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return Expense.fromJson(response);
  }

  Future<Expense> updateExpense(Expense expense) async {
    final response = await _supabaseClient
        .from('expenses')
        .update(expense.toJson()..remove('created_at'))
        .eq('id', expense.id)
        .select()
        .single();
    return Expense.fromJson(response);
  }

  Future<void> deleteExpense(String expenseId) async {
    await _supabaseClient.from('expenses').delete().eq('id', expenseId);
  }

  Future<void> createExpenseItem(ExpenseItem item) async {
    final withId = item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    await _supabaseClient
        .from('expense_items')
        .insert(withId.toJson()..remove('created_at'));
  }

  /// Persist an item-usage row (best-effort sync for analytics).
  Future<void> createItemUsage(ItemUsage usage) async {
    final withId = usage.id.isEmpty ? usage.copyWith(id: _uuid.v4()) : usage;
    await _supabaseClient
        .from('item_usage')
        .insert(withId.toJson()..remove('created_at'));
  }

  Future<List<ExpenseItem>> getExpenseItems(String expenseId) async {
    final response = await _supabaseClient
        .from('expense_items')
        .select()
        .eq('expense_id', expenseId);
    return (response as List)
        .map((json) => ExpenseItem.fromJson(json))
        .toList();
  }
}
