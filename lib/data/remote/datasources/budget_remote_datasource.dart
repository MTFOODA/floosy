import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/budget_model.dart';

class BudgetRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  BudgetRemoteDataSource(this._supabaseClient);

  Future<List<Budget>> getBudgets(String userId) async {
    final response = await _supabaseClient
        .from('budgets')
        .select()
        .eq('user_id', userId)
        .order('start_date', ascending: false);
    return (response as List).map((json) => Budget.fromJson(json)).toList();
  }

  Future<Budget?> getBudget(String budgetId) async {
    final response = await _supabaseClient
        .from('budgets')
        .select()
        .eq('id', budgetId)
        .maybeSingle();
    return response == null ? null : Budget.fromJson(response);
  }

  Future<Budget> createBudget(Budget budget) async {
    final withId = budget.id.isEmpty ? budget.copyWith(id: _uuid.v4()) : budget;
    final response = await _supabaseClient
        .from('budgets')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return Budget.fromJson(response);
  }

  Future<Budget> updateBudget(Budget budget) async {
    final response = await _supabaseClient
        .from('budgets')
        .update(budget.toJson()..remove('created_at'))
        .eq('id', budget.id)
        .select()
        .single();
    return Budget.fromJson(response);
  }

  Future<void> deleteBudget(String budgetId) async {
    await _supabaseClient.from('budgets').delete().eq('id', budgetId);
  }

  Future<BudgetCategory> setBudgetCategory(
      String budgetId, String categoryId, int limitMinor) async {
    final response = await _supabaseClient
        .from('budget_categories')
        .upsert({
          'id': _uuid.v4(),
          'budget_id': budgetId,
          'category_id': categoryId,
          'limit_minor': limitMinor,
        }, onConflict: 'budget_id,category_id')
        .select()
        .single();
    return BudgetCategory.fromJson(response);
  }

  Future<List<BudgetCategory>> getBudgetCategories(String budgetId) async {
    final response = await _supabaseClient
        .from('budget_categories')
        .select()
        .eq('budget_id', budgetId);
    return (response as List)
        .map((json) => BudgetCategory.fromJson(json))
        .toList();
  }

  Future<void> removeBudgetCategory(String budgetId, String categoryId) async {
    await _supabaseClient
        .from('budget_categories')
        .delete()
        .eq('budget_id', budgetId)
        .eq('category_id', categoryId);
  }

  /// Actual spending per category within the budget period, computed from
  /// real expense records. Keyed by category_id.
  Future<Map<String, int>> getCurrentSpending(String budgetId) async {
    final budget = await getBudget(budgetId);
    if (budget == null) return {};

    final expenses = await _supabaseClient
        .from('expenses')
        .select('category_id,amount_minor')
        .eq('user_id', budget.userId)
        .gte('expense_date', budget.startDate.toIso8601String())
        .lte('expense_date', budget.endDate.toIso8601String());

    final result = <String, int>{};
    for (final row in (expenses as List)) {
      final categoryId = row['category_id'] as String?;
      if (categoryId == null) continue;
      final amount = row['amount_minor'];
      final minor = amount is int ? amount : int.parse(amount.toString());
      result[categoryId] = (result[categoryId] ?? 0) + minor;
    }
    return result;
  }
}
