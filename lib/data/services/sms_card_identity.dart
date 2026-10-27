import '../../domain/services/card_ownership.dart';
import 'sms_parser_service.dart';
import '../../domain/entities/transaction_model.dart';

/// A bank account is not a card. User-confirmed links bridge the two.
String? smsCardIdentityKey(
    {required String? sender,
    required String body,
    required String? bankName,
    required TransactionType? type}) {
  final bank = normalizeBankIdentity(bankName);
  if (bank == null || type == null || (sender ?? '').trim().isEmpty) {
    return null;
  }
  final account = SMSParser.accountToken(body);
  // Account aliases can be shared by incoming/outgoing transfers. Without an
  // account token, constrain learning to this sender, type and channel.
  final channel = body.contains('الموبايل') ? 'mobile' : 'account';
  return '$bank|${sender!.trim().toLowerCase()}|'
      '${account == null ? '${type.name}|$channel' : 'account:$account'}';
}
