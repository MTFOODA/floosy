import '../entities/transaction_model.dart';
import '../entities/user_model.dart';

abstract interface class FinancialQueriesRepository {
  Future<List<Bank>> getBanks();
  Future<Map<String, int>> getConfirmedItemUsageCounts(
      String userId, int year, int month);
  Future<bool> isHighFrequency(
      {required String userId, required String itemId});
  Future<String?> resolveImage(String reference);
  Future<String?> uploadImage(
      {required String userId,
      required String itemId,
      required String filePath});
  Future<void> deleteImage({required String userId, required String itemId});
  Future<List<Transaction>> getLocalTransactions(
      {required String userId, DateTime? start, DateTime? end});
}
