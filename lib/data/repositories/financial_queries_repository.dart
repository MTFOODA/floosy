import '../../domain/entities/transaction_model.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/repositories/financial_queries_repository.dart';
import '../local/datasources/money_local_datasource.dart';
import '../repositories/transaction_repository.dart';
import '../remote/datasources/bank_remote_datasource.dart';
import '../services/high_frequency_service.dart';
import '../services/item_image_service.dart';

class FinancialQueries implements FinancialQueriesRepository {
  final BankRemoteDataSource banks;
  final MoneyLocalDataSource money;
  final TransactionRepository transactions;
  final HighFrequencyService frequency;
  final ItemImageService images;
  FinancialQueries(
      {required this.banks,
      required this.money,
      required this.transactions,
      required this.frequency,
      required this.images});
  @override
  Future<List<Bank>> getBanks() async {
    try {
      return await banks.getActiveBanks();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<Map<String, int>> getConfirmedItemUsageCounts(
          String userId, int year, int month) =>
      money.getConfirmedItemUsageCounts(userId, year, month);
  @override
  Future<bool> isHighFrequency(
          {required String userId, required String itemId}) =>
      frequency.isHighFrequency(userId: userId, itemId: itemId);
  @override
  Future<String?> resolveImage(String reference) =>
      images.resolveImage(reference);
  @override
  Future<String?> uploadImage(
          {required String userId,
          required String itemId,
          required String filePath}) =>
      images.uploadImage(userId: userId, itemId: itemId, filePath: filePath);
  @override
  Future<void> deleteImage({required String userId, required String itemId}) =>
      images.deleteImage(userId: userId, itemId: itemId);
  @override
  Future<List<Transaction>> getLocalTransactions(
          {required String userId, DateTime? start, DateTime? end}) =>
      transactions.getTransactionsByRange(
          userId: userId,
          startDateTime: start,
          endDateTime: end,
          syncWithRemote: false);
}
