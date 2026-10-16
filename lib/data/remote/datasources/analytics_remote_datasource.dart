import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/analytics_model.dart';
import '../../models/budget_model.dart';

class AnalyticsRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  AnalyticsRemoteDataSource(this._supabaseClient);

  Future<MonthlyReport?> getMonthlyReport({
    required String userId,
    required int year,
    required int month,
  }) async {
    final response = await _supabaseClient
        .from('monthly_reports')
        .select()
        .eq('user_id', userId)
        .eq('year', year)
        .eq('month', month)
        .maybeSingle();
    return response == null ? null : MonthlyReport.fromJson(response);
  }

  Future<List<MonthlyReport>> getMonthlyReports(String userId) async {
    final response = await _supabaseClient
        .from('monthly_reports')
        .select()
        .eq('user_id', userId)
        .order('year', ascending: false)
        .order('month', ascending: false);
    return (response as List)
        .map((json) => MonthlyReport.fromJson(json))
        .toList();
  }

  Future<List<MonthlyItemStatistic>> getItemStatistics({
    required String userId,
    required int year,
    required int month,
  }) async {
    final response = await _supabaseClient
        .from('monthly_item_statistics')
        .select()
        .eq('user_id', userId)
        .eq('year', year)
        .eq('month', month)
        .order('total_spending_minor', ascending: false);
    return (response as List)
        .map((json) => MonthlyItemStatistic.fromJson(json))
        .toList();
  }

  Future<List<SavingRecommendation>> getSavingRecommendations(
      String userId) async {
    final response = await _supabaseClient
        .from('saving_recommendations')
        .select()
        .eq('user_id', userId)
        .eq('status', 'active')
        .order('estimated_saving_minor', ascending: false);
    return (response as List)
        .map((json) => SavingRecommendation.fromJson(json))
        .toList();
  }

  Future<List<SavingGoal>> getSavingGoals(String userId) async {
    final response = await _supabaseClient
        .from('saving_goals')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((json) => SavingGoal.fromJson(json)).toList();
  }

  Future<SavingGoal> createSavingGoal(SavingGoal goal) async {
    final withId = goal.id.isEmpty ? goal.copyWith(id: _uuid.v4()) : goal;
    final response = await _supabaseClient
        .from('saving_goals')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return SavingGoal.fromJson(response);
  }

  Future<List<Alert>> getAlerts(String userId) async {
    final response = await _supabaseClient
        .from('alerts')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(100);
    return (response as List).map((json) => Alert.fromJson(json)).toList();
  }

  Future<void> markAlertAsRead(String alertId) async {
    await _supabaseClient
        .from('alerts')
        .update({'is_read': true}).eq('id', alertId);
  }

  Future<Alert> createAlert(Alert alert) async {
    final withId = alert.id.isEmpty ? alert.copyWith(id: _uuid.v4()) : alert;
    final response = await _supabaseClient
        .from('alerts')
        .insert(withId.toJson()..remove('created_at'))
        .select()
        .single();
    return Alert.fromJson(response);
  }
}
