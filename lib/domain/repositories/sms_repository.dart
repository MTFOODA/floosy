import '../entities/sms_ingestion_result.dart';

abstract interface class SmsRepository {
  Future<SmsIngestionResult> scanNow({bool fullScan = false});
  void start();
  void stop();
}

abstract interface class SmsMaintenanceRepository {
  Future<void> waitForIdle();
  void resetMemory();
}

abstract interface class BankMappingsRepository {
  Future<List<String>> getUnknownSenders(String userId);
  Future<void> setMapping(String userId, String sender, String bankName);
  Future<void> rejectSender(String userId, String sender);
  Future<List<String>> getRejectedSenders(String userId);
  Future<void> restoreSender(String userId, String sender);
}
