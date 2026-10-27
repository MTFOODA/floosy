import '../../../../domain/usecases/configure_card.dart';
import '../../../../domain/repositories/money_repository.dart';
import '../../../../core/state/async_cubit.dart';
import '../../../../core/state/load_state.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../domain/repositories/detected_card_repository.dart';

class CardsCubit extends AsyncCubit<List<DetectedCard>> {
  final DetectedCardRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  final MoneyRepository _money;
  CardsCubit(this._repository, this._money, this._userId, this._onChanged);
  Future<void> configure(
      {required String userId,
      required DetectedCard original,
      required CreditCardConfigResult result}) async {
    await ConfigureCard(_repository, _money)(
        userId: userId, original: original, result: result);
    _onChanged();
  }

  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(const []);
      return Future.value();
    }
    return load(
        () async => List.unmodifiable(await _repository.getCards(userId)));
  }

  LoadState<bool> eyeVisible(String cardId) => state.map((cards) =>
      cards
          .where((card) => card.id == cardId)
          .firstOrNull
          ?.appearance
          .eyeVisible ??
      true);

  Future<List<DetectedCard>> getCards(String userId) =>
      _repository.getCards(userId);

  Future<void> updateAppearance(
      String userId, String cardId, CardAppearance appearance) async {
    await _repository.updateAppearance(userId, cardId, appearance);
    await reload();
  }

  Future<void> recomputeTransactionCountsForCards(
    String userId,
    int Function(DetectedCard card) countFor,
  ) async {
    await _repository.recomputeTransactionCountsForCards(userId, countFor);
    _onChanged();
  }

  Future<void> deleteCard(String userId, String cardId) async {
    await _repository.deleteCard(userId, cardId);
    _onChanged();
  }

  Future<bool> getCardEyeVisible(String userId, String cardId) =>
      _repository.getCardEyeVisible(userId, cardId);

  Future<bool> toggleCardEye(String userId, String cardId) async {
    final result = await _repository.toggleCardEye(userId, cardId);
    await reload();
    return result;
  }

  Future<void> setCardEyeVisible(
      String userId, String cardId, bool visible) async {
    await _repository.setCardEyeVisible(userId, cardId, visible);
    await reload();
  }

  Future<DetectedCard?> getCardById(String userId, String cardId) =>
      _repository.getCardById(userId, cardId);

  Future<void> setCashWithdrawalEnabled(
      String userId, String cardId, bool enabled) async {
    await _repository.setCashWithdrawalEnabled(userId, cardId, enabled);
    _onChanged();
  }

  Future<void> setCreditCardConfig({
    required String userId,
    required String cardId,
    required bool isCreditCard,
    int creditLimitMinor = 0,
    int currentBalanceMinor = 0,
    bool cashWithdrawalEnabled = false,
    DateTime? updatedAt,
  }) async {
    await _repository.setCreditCardConfig(
        userId: userId,
        cardId: cardId,
        isCreditCard: isCreditCard,
        creditLimitMinor: creditLimitMinor,
        currentBalanceMinor: currentBalanceMinor,
        cashWithdrawalEnabled: cashWithdrawalEnabled,
        updatedAt: updatedAt);
    _onChanged();
  }
}
