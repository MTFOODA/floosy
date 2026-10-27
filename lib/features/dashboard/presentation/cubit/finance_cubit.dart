import '../../../../core/state/async_cubit.dart';
import '../../../../domain/usecases/load_finances.dart';
import '../../../../domain/entities/money_model.dart';
import '../../../../domain/entities/item_model.dart' as items;
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../domain/repositories/money_repository.dart';

class FinanceCubit extends AsyncCubit<FinanceSnapshot> {
  final MoneyRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  final LoadFinances _loadFinances;
  final Future<List<DetectedCard>> Function(String) _cards;
  final (String?, String?) Function() _selection;
  List<DetectedCard> _displayCards = const [];
  void updateCardDisplay(List<DetectedCard> cards) {
    _displayCards = cards;
    if (!isClosed && state.value != null) emit(state.map(_latestAppearance));
  }

  FinanceSnapshot _latestAppearance(FinanceSnapshot snapshot) {
    final card =
        _displayCards.where((card) => card.id == snapshot.card?.id).firstOrNull;
    return card == null ? snapshot : snapshot.withCard(card);
  }

  FinanceCubit(this._repository, this._userId, this._selection, this._cards,
      this._onChanged)
      : _loadFinances = LoadFinances(_repository);
  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(FinanceSnapshot.empty());
      return Future.value();
    }
    final selection = _selection();
    return load(() async => _latestAppearance(await _loadFinances(
        userId: userId,
        cards: await _cards(userId),
        last4: selection.$1,
        bankName: selection.$2)));
  }

  Future<List<MonthlyIncome>> getMonthlyIncomes(String userId,
          {int? year, int? month}) =>
      _repository.getMonthlyIncomes(userId, year: year, month: month);

  Future<void> addMonthlyIncome(
      {required String userId,
      required int year,
      required int month,
      String? label,
      required int amountMinor}) async {
    await _repository.addMonthlyIncome(
        userId: userId,
        year: year,
        month: month,
        label: label,
        amountMinor: amountMinor);
    _onChanged();
  }

  Future<bool> purchaseItemWithCash({
    required String userId,
    required items.Item item,
    required String cardLast4,
    String? bankName,
    String? purchaseId,
  }) async {
    final result = await _repository.purchaseItemWithCash(
        userId: userId,
        item: item,
        cardLast4: cardLast4,
        bankName: bankName,
        purchaseId: purchaseId);
    _onChanged();
    return result;
  }

  Future<void> addBalanceManually({
    required String userId,
    required String cardLast4,
    required int amountMinor,
    String? bankName,
    String currency = 'EGP',
    String? note,
  }) async {
    await _repository.addBalanceManually(
        userId: userId,
        cardLast4: cardLast4,
        amountMinor: amountMinor,
        bankName: bankName,
        currency: currency,
        note: note);
    _onChanged();
  }

  Future<int?> getMaxAddableForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) =>
      _repository.getMaxAddableForCard(userId, cardLast4, bankName: bankName);

  Future<void> setFixedAmountForCard({
    required String userId,
    required String cardLast4,
    required int fixedAmountMinor,
    String? bankName,
    bool? cashWithdrawalEnabled,
  }) async {
    await _repository.setFixedAmountForCard(
        userId: userId,
        cardLast4: cardLast4,
        fixedAmountMinor: fixedAmountMinor,
        bankName: bankName,
        cashWithdrawalEnabled: cashWithdrawalEnabled);
    _onChanged();
  }

  Future<MoneySummary> getMoneySummary(String userId) =>
      _repository.getMoneySummary(userId);
}
