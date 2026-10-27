import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/detected_card_model.dart';

class DetectedCardRemoteDataSource {
  final SupabaseClient _client;
  DetectedCardRemoteDataSource(this._client);

  Future<DetectedCard> upsertCard(DetectedCard card) async {
    final row = await _client
        .from('detected_cards')
        .upsert({
          'id': card.id,
          'user_id': card.userId,
          'last4': card.last4,
          'bank_name': card.bankName,
          'transaction_count': card.transactionCount,
          'appearance': card.appearance.toJson(),
          'is_credit_card': card.isCreditCard,
          'credit_limit_minor': card.creditLimitMinor,
          'current_balance_minor': card.currentBalanceMinor,
          'cash_withdrawal_enabled': card.cashWithdrawalEnabled,
          'created_at': card.createdAt.toIso8601String(),
          'updated_at': card.updatedAt.toIso8601String(),
        }, onConflict: 'id')
        .select()
        .single();
    return DetectedCard.fromJson(Map<String, dynamic>.from(row));
  }
}
