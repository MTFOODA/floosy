import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/item_model.dart';

/// Pocket-cash remote data source. The balance is always derived from the
/// cash_movements ledger (PostgreSQL function `get_cash_balance`).
class CashWalletRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  CashWalletRemoteDataSource(this._supabaseClient);

  Future<int> getCashBalance(String userId) async {
    final response = await _supabaseClient
        .rpc('get_cash_balance', params: {'user_id_param': userId});
    if (response is int) return response;
    if (response is num) return response.toInt();
    if (response is String) return int.tryParse(response) ?? 0;
    return 0;
  }

  Future<CashWallet> getOrCreateWallet(String userId, String currency) async {
    final existing = await _supabaseClient
        .from('cash_wallets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (existing != null) return CashWallet.fromJson(existing);

    final response = await _supabaseClient
        .from('cash_wallets')
        .insert({'id': _uuid.v4(), 'user_id': userId, 'currency': currency})
        .select()
        .single();
    return CashWallet.fromJson(response);
  }

  Future<CashMovement> recordMovement({
    required String userId,
    required String walletId,
    required String type,
    required int amountMinor,
    required String description,
    String? referenceType,
    String? referenceId,
  }) async {
    final response = await _supabaseClient
        .from('cash_movements')
        .insert({
          'id': _uuid.v4(),
          'user_id': userId,
          'wallet_id': walletId,
          'type': type,
          'amount_minor': amountMinor,
          'description': description,
          if (referenceType != null) 'reference_type': referenceType,
          if (referenceId != null) 'reference_id': referenceId,
          'movement_date': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();
    return CashMovement.fromJson(response);
  }

  Future<List<CashMovement>> getMovements(String userId) async {
    final response = await _supabaseClient
        .from('cash_movements')
        .select()
        .eq('user_id', userId)
        .order('movement_date', ascending: false)
        .limit(500);
    return (response as List)
        .map((json) => CashMovement.fromJson(json))
        .toList();
  }
}
