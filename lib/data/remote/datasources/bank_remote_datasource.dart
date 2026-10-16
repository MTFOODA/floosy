import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

/// Remote data source for bank configurations and SMS patterns.
class BankRemoteDataSource {
  final SupabaseClient _supabaseClient;

  BankRemoteDataSource(this._supabaseClient);

  Future<List<Bank>> getBanks() async {
    final response = await _supabaseClient.from('banks').select().order('name');
    return (response as List).map((json) => Bank.fromJson(json)).toList();
  }

  Future<Bank?> getBank(String bankId) async {
    final response = await _supabaseClient
        .from('banks')
        .select()
        .eq('id', bankId)
        .maybeSingle();
    return response == null ? null : Bank.fromJson(response);
  }

  Future<List<BankSMSPattern>> getPatterns(String bankId) async {
    final response = await _supabaseClient
        .from('bank_sms_patterns')
        .select()
        .eq('bank_id', bankId)
        .eq('is_active', true);
    return (response as List)
        .map((json) => BankSMSPattern.fromJson(json))
        .toList();
  }

  /// Save the user's selected bank — stored on the profile row.
  Future<void> updateUserDefaultBank(String userId, String bankId) async {
    await _supabaseClient
        .from('profiles')
        .update({'default_bank_id': bankId}).eq('id', userId);
  }

  Future<List<Bank>> getActiveBanks() async {
    final response = await _supabaseClient
        .from('banks')
        .select()
        .eq('is_active', true)
        .order('name');
    return (response as List).map((json) => Bank.fromJson(json)).toList();
  }
}
