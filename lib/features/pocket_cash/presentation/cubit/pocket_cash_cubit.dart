import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/item_model.dart';
import '../../../../domain/repositories/cash_wallet_repository.dart';

class PocketCashCubit extends AsyncCubit<(int, List<CashMovement>)> {
  final CashWalletRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  PocketCashCubit(this._repository, this._userId, this._onChanged);
  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear((0, const []));
      return Future.value();
    }
    return load(() async => (
          await _repository.getCashBalance(userId),
          await _repository.getMovements(userId)
        ));
  }

  Future<int> getCashBalance(String userId) =>
      _repository.getCashBalance(userId);

  Future<CashWallet> getOrCreateWallet(String userId, String currency) =>
      _repository.getOrCreateWallet(userId, currency);

  Future<List<CashMovement>> getMovements(String userId) =>
      _repository.getMovements(userId);

  Future<CashMovement> addCash({
    required String userId,
    required String walletId,
    required int amountMinor,
    required String description,
  }) async {
    final result = await _repository.addCash(
        userId: userId,
        walletId: walletId,
        amountMinor: amountMinor,
        description: description);
    _onChanged();
    return result;
  }
}
