import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/transaction_model.dart';

/// Card purchases, ATM withdrawals and income recorded from bank SMS or
/// manual entry. Note: cash transactions are handled by the local engine
/// together with cash_movements, not here.
class TransactionRemoteDataSource {
  final SupabaseClient _supabaseClient;

  TransactionRemoteDataSource(this._supabaseClient);

  // PostgreSQL interprets an ISO timestamp without an offset in the server's
  // timezone. Always send an explicit UTC instant, including for bank times
  // parsed in the phone's local timezone.
  Map<String, dynamic> _remoteJson(Transaction transaction) =>
      transaction.toJson()
        ..['transaction_date'] =
            transaction.transactionDate.toUtc().toIso8601String();

  Future<Transaction> createTransaction(Transaction transaction) async {
    final response = await _supabaseClient
        .from('transactions')
        .insert(_remoteJson(transaction)
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return Transaction.fromJson(response);
  }

  Future<List<Transaction>> getTransactions({
    required String userId,
    int limit = 100,
  }) async {
    final response = await _supabaseClient
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('transaction_date', ascending: false)
        .limit(limit);
    return (response as List)
        .map((json) => Transaction.fromJson(json))
        .toList();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _supabaseClient
        .from('transactions')
        .update(_remoteJson(transaction)..remove('created_at'))
        .eq('id', transaction.id);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _supabaseClient.from('transactions').delete().eq('id', transactionId);
  }

  /// Updates only the card_id field of one transaction (Card ↔ Transaction
  /// relationship, requirement #5). Best-effort from the SMS pipeline.
  Future<void> updateTransactionCardId(
      String transactionId, String cardId) async {
    await _supabaseClient
        .from('transactions')
        .update({'card_id': cardId}).eq('id', transactionId);
  }
}
