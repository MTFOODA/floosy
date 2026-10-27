import '../entities/sms_ingestion_result.dart';

abstract interface class SmsRepository {
  Future<SmsIngestionResult> scanNow();
  void start();
  void stop();
}

abstract interface class BankMappingsRepository {
  Future<List<String>> getUnknownSenders(String userId);
  Future<void> setMapping(String userId, String sender, String bankName);
}
