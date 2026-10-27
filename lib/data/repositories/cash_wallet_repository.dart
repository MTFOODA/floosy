import '../../domain/repositories/cash_wallet_repository.dart' as domain;
import '../../domain/entities/item_model.dart';
import '../../domain/entities/transaction_model.dart' show Transaction;
import '../remote/datasources/cash_wallet_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class CashWalletRepository implements domain.CashWalletRepository {
  final CashWalletRemoteDataSource remoteDataSource;

  CashWalletRepository({required this.remoteDataSource});

  @override
  Future<void> ensureExpenseMovement(Transaction transaction) =>
      remoteDataSource.ensureExpenseMovement(transaction);

  /// Get cash balance for a user
  @override
  Future<int> getCashBalance(String userId) async {
    try {
      return await remoteDataSource.getCashBalance(userId);
    } catch (e) {
      logError('Error getting cash balance: $e');
      return 0;
    }
  }

  /// Get or create cash wallet for a user
  @override
  Future<CashWallet> getOrCreateWallet(String userId, String currency) async {
    try {
      return await remoteDataSource.getOrCreateWallet(userId, currency);
    } catch (e) {
      logError('Error getting or creating wallet: $e');
      rethrow;
    }
  }

  /// Record a cash movement (in or out)
  @override
  Future<CashMovement> recordMovement({
    required String userId,
    required String walletId,
    required String type, // 'in' or 'out'
    required int amountMinor,
    required String description,
    String? referenceType,
    String? referenceId,
  }) async {
    try {
      return await remoteDataSource.recordMovement(
        userId: userId,
        walletId: walletId,
        type: type,
        amountMinor: amountMinor,
        description: description,
        referenceType: referenceType,
        referenceId: referenceId,
      );
    } catch (e) {
      logError('Error recording movement: $e');
      rethrow;
    }
  }

  /// Get all cash movements for a user
  @override
  Future<List<CashMovement>> getMovements(String userId) async {
    try {
      return await remoteDataSource.getMovements(userId);
    } catch (e) {
      logError('Error getting movements: $e');
      return [];
    }
  }

  /// Get cash movements for a specific month
  @override
  Future<List<CashMovement>> getMonthlyMovements({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final movements = await remoteDataSource.getMovements(userId);
      return movements
          .where((m) =>
              m.movementDate.year == year && m.movementDate.month == month)
          .toList();
    } catch (e) {
      logError('Error getting monthly movements: $e');
      return [];
    }
  }

  /// Get total cash inflow for a period
  @override
  Future<int> getTotalInflow({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final movements = await remoteDataSource.getMovements(userId);
      return movements
          .where((m) =>
              m.type == 'in' &&
              m.movementDate.isAfter(startDate) &&
              m.movementDate.isBefore(endDate))
          .fold<int>(0, (sum, m) => sum + m.amountMinor);
    } catch (e) {
      logError('Error getting total inflow: $e');
      return 0;
    }
  }

  /// Get total cash outflow for a period
  @override
  Future<int> getTotalOutflow({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final movements = await remoteDataSource.getMovements(userId);
      return movements
          .where((m) =>
              m.type == 'out' &&
              m.movementDate.isAfter(startDate) &&
              m.movementDate.isBefore(endDate))
          .fold<int>(0, (sum, m) => sum + m.amountMinor);
    } catch (e) {
      logError('Error getting total outflow: $e');
      return 0;
    }
  }

  /// Add cash to wallet
  @override
  Future<CashMovement> addCash({
    required String userId,
    required String walletId,
    required int amountMinor,
    required String description,
  }) async {
    return recordMovement(
      userId: userId,
      walletId: walletId,
      type: 'in',
      amountMinor: amountMinor,
      description: description,
    );
  }

  /// Withdraw cash from wallet
  @override
  Future<CashMovement> withdrawCash({
    required String userId,
    required String walletId,
    required int amountMinor,
    required String description,
  }) async {
    return recordMovement(
      userId: userId,
      walletId: walletId,
      type: 'out',
      amountMinor: amountMinor,
      description: description,
    );
  }

  /// Adjust cash balance (for corrections)
  @override
  Future<CashMovement> adjustBalance({
    required String userId,
    required String walletId,
    required int adjustmentMinor,
    required String reason,
  }) async {
    final type = adjustmentMinor >= 0 ? 'in' : 'out';
    return recordMovement(
      userId: userId,
      walletId: walletId,
      type: type,
      amountMinor: adjustmentMinor.abs(),
      description: 'Balance adjustment: $reason',
      referenceType: 'adjustment',
    );
  }
}
