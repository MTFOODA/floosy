import '../entities/detected_card_model.dart';
import '../repositories/detected_card_repository.dart';
import '../repositories/money_repository.dart';

class ConfigureCard {
  final DetectedCardRepository _cards;
  final MoneyRepository _money;
  const ConfigureCard(this._cards, this._money);
  Future<void> call(
      {required String userId,
      required DetectedCard original,
      required CreditCardConfigResult result}) async {
    if (original.userId != userId) throw ArgumentError('Card account mismatch');
    if (result.isCreditCard) {
      // A cash-withdrawal toggle must never rewrite a limit or opening balance.
      if (original.isCreditCard &&
          result.creditLimitMinor == original.creditLimitMinor) {
        await _cards.setCashWithdrawalEnabled(
            userId, original.id, result.cashWithdrawalEnabled);
      } else {
        await _money.setFixedAmountForCard(
            userId: userId,
            cardLast4: original.last4,
            bankName: original.bankName,
            fixedAmountMinor: result.creditLimitMinor,
            cashWithdrawalEnabled: result.cashWithdrawalEnabled);
      }
    } else {
      await _cards.setCreditCardConfig(
          userId: userId,
          cardId: original.id,
          isCreditCard: false,
          creditLimitMinor: 0,
          currentBalanceMinor: 0,
          cashWithdrawalEnabled: false,
          updatedAt: DateTime.now());
    }
  }
}
