import '../entities/imported_bank_message.dart';
import 'sms_repository.dart';

abstract interface class BankMessageImportRepository implements SmsRepository {
  Future<void> bindUser(String? userId);
  Future<BankMessageInbox> getInbox();
  Future<void> setEnabled(bool enabled);
  Future<void> addMessage(String sender, String body, DateTime receivedAt);
  Future<void> retryMessage(String id);
  Future<void> discardMessage(String id);
}
