import '../models/item_model.dart';
import '../remote/datasources/cash_wallet_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class CashWalletRepository {
  final CashWalletRemoteDataSource remoteDataSource;

  CashWalletRepository({required this.remoteDataSource});

  /// Get cash balance for a user
  Future<int> getCashBalance(String userId) async {
    try {
      return await remoteDataSource.getCashBalance(userId);
    } catch (e) {
      logError('Error getting cash balance: $e');
      return 0;
    }
  }

  /// Get or create cash wallet for a user
  Future<CashWallet> getOrCreateWallet(String userId, String currency) async {
    try {
      return await remoteDataSource.getOrCreateWallet(userId, currency);
    } catch (e) {
      logError('Error getting or creating wallet: $e');
      rethrow;
    }
  }

  /// Record a cash movement (in or out)
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
  Future<List<CashMovement>> getMovements(String userId) async {
    try {
      return await remoteDataSource.getMovements(userId);
    } catch (e) {
      logError('Error getting movements: $e');
      return [];
    }
  }

  /// Get cash movements for a specific month
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
