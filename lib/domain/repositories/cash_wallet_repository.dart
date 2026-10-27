import '../entities/item_model.dart';
import '../entities/transaction_model.dart' show Transaction;

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class CashWalletRepository {
  Future<void> ensureExpenseMovement(Transaction transaction);

  Future<int> getCashBalance(String userId);

  Future<CashWallet> getOrCreateWallet(String userId, String currency);

  Future<CashMovement> recordMovement({
    required String userId,
    required String walletId,
    required String type, // 'in' or 'out'
    required int amountMinor,
    required String description,
    String? referenceType,
    String? referenceId,
  });

  Future<List<CashMovement>> getMovements(String userId);

  Future<List<CashMovement>> getMonthlyMovements({
    required String userId,
    required int year,
    required int month,
  });

  Future<int> getTotalInflow({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<int> getTotalOutflow({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<CashMovement> addCash({
    required String userId,
    required String walletId,
    required int amountMinor,
    required String description,
  });

  Future<CashMovement> withdrawCash({
    required String userId,
    required String walletId,
    required int amountMinor,
    required String description,
  });

  Future<CashMovement> adjustBalance({
    required String userId,
    required String walletId,
    required int adjustmentMinor,
    required String reason,
  });
}
