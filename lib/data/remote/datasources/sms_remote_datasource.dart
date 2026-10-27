import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/transaction_model.dart';

/// Remote data source for the `sms_messages` table. Stores the original
/// message plus the complete detection result for every eligible bank/wallet
/// SMS, including messages that need review and do not produce a transaction.
class SmsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SmsRemoteDataSource(this._supabaseClient);

  /// Insert or refresh one metadata row. The (user_id, message_hash) unique
  /// index makes this idempotent, including for eligible messages that were
  /// previously reviewed without producing a transaction.
  Future<SMSMessage> upsertSmsMessage(SMSMessage message) async {
    final response = await _supabaseClient
        .from('sms_messages')
        .upsert({
          'id': message.id,
          'user_id': message.userId,
          'sender': message.sender,
          'message_hash': message.messageHash,
          'message_body': message.messageBody,
          'received_at': message.receivedAt.toIso8601String(),
          'bank_identified': message.bankIdentified,
          'type_identified': message.typeIdentified,
          'amount_identified': message.amountIdentified,
          'currency_identified': message.currencyIdentified,
          'card_last4_identified': message.cardLast4Identified,
          'detected_bank_id': message.detectedBankId,
          'detected_bank_name': message.detectedBankName,
          'detected_type': message.detectedType,
          'detected_amount_minor': message.detectedAmountMinor,
          'detected_currency': message.detectedCurrency,
          'detected_card_last4': message.detectedCardLast4,
          'processed_at': message.processedAt?.toIso8601String(),
          'processing_status': message.processingStatus,
          'transaction_id': message.transactionId,
          'parser_version': message.parserVersion,
          'confidence': message.confidence,
        }, onConflict: 'user_id,message_hash')
        .select()
        .single();
    return SMSMessage.fromJson(response);
  }

  /// Update the detection record after a later pipeline stage changes.
  Future<void> updateSmsMessage(SMSMessage message) async {
    await _supabaseClient.from('sms_messages').update({
      'message_body': message.messageBody,
      'bank_identified': message.bankIdentified,
      'type_identified': message.typeIdentified,
      'amount_identified': message.amountIdentified,
      'currency_identified': message.currencyIdentified,
      'card_last4_identified': message.cardLast4Identified,
      'detected_bank_id': message.detectedBankId,
      'detected_bank_name': message.detectedBankName,
      'detected_type': message.detectedType,
      'detected_amount_minor': message.detectedAmountMinor,
      'detected_currency': message.detectedCurrency,
      'detected_card_last4': message.detectedCardLast4,
      'processed_at': message.processedAt?.toIso8601String(),
      'processing_status': message.processingStatus,
      'transaction_id': message.transactionId,
      'parser_version': message.parserVersion,
      'confidence': message.confidence,
    }).eq('id', message.id);
  }

  /// True when an SMS with this hash was already stored for the user.
  Future<bool> isKnownMessage(String userId, String messageHash) async {
    final response = await _supabaseClient
        .from('sms_messages')
        .select('id')
        .eq('user_id', userId)
        .eq('message_hash', messageHash)
        .eq('processing_status', 'processed')
        .maybeSingle();
    return response != null;
  }

  /// Batched version of [isKnownMessage]: ONE query resolves which of
  /// [messageHashes] are already stored for [userId].
  ///
  /// PULL-REFRESH ANR FIX: a full-scan pull-to-refresh used to issue one
  /// sequential network round-trip per recognized SMS via [isKnownMessage]
  /// (hundreds of requests on a real device, tens of seconds each pull).
  /// [SmsIngestionService] now resolves the whole batch here in a single
  /// (chunked) query. Dedupe semantics are identical — the same unique
  /// (user_id, message_hash) rows are consulted.
  Future<Set<String>> knownMessageHashes(
    String userId,
    List<String> messageHashes,
  ) async {
    final known = <String>{};
    // Chunk the `in` filter — PostgREST URL length limits make very large
    // batches unreliable.
    const chunkSize = 100;
    for (var i = 0; i < messageHashes.length; i += chunkSize) {
      final end = (i + chunkSize) > messageHashes.length
          ? messageHashes.length
          : i + chunkSize;
      final chunk = messageHashes.sublist(i, end);
      final response = await _supabaseClient
          .from('sms_messages')
          .select('message_hash')
          .eq('user_id', userId)
          .eq('processing_status', 'processed')
          .inFilter('message_hash', chunk);
      for (final row in response as List) {
        final hash = row['message_hash'];
        if (hash is String) known.add(hash);
      }
    }
    return known;
  }

  /// Link an existing SMS record to the transaction created from it.
  Future<void> linkTransaction({
    required String smsMessageId,
    required String transactionId,
  }) async {
    await _supabaseClient.from('sms_messages').update({
      'transaction_id': transactionId,
      'processed_at': DateTime.now().toUtc().toIso8601String(),
      'processing_status': 'processed',
    }).eq('id', smsMessageId);
  }

  // A deleted SMS-derived transaction is detached from its source row, while
  // the row remains processed and therefore cannot recreate the transaction.
  Future<void> deleteTransactionReferences(String transactionId) async {
    await _supabaseClient
        .from('sms_messages')
        .update({'transaction_id': null, 'processing_status': 'processed'}).eq(
            'transaction_id', transactionId);
  }

  Future<List<SMSMessage>> getSmsMessages({
    required String userId,
    int limit = 100,
  }) async {
    final response = await _supabaseClient
        .from('sms_messages')
        .select()
        .eq('user_id', userId)
        .order('received_at', ascending: false)
        .limit(limit);
    return (response as List).map((json) => SMSMessage.fromJson(json)).toList();
  }
}
