import '../entities/detected_card_model.dart';
import '../repositories/detected_card_repository.dart';
import '../repositories/salary_plan_repository.dart';
import '../repositories/transaction_repository.dart';
import '../services/card_ownership.dart';

class RemoveEmptyDuplicateCard {
  const RemoveEmptyDuplicateCard(this._cards, this._transactions, this._salary);

  final DetectedCardRepository _cards;
  final TransactionRepository _transactions;
  final SalaryPlanRepository _salary;

  static bool isNewerDuplicate(DetectedCard card, List<DetectedCard> cards) =>
      normalizeBankIdentity(card.bankName) != null &&
      cards.any(
        (other) =>
            other.id != card.id &&
            other.userId == card.userId &&
            other.last4 == card.last4 &&
            other.createdAt.isBefore(card.createdAt) &&
            sameIssuingBank(other.bankName, card.bankName),
      );

  Future<bool> call(String userId, String cardId) {
    final transactions = _transactions;
    if (transactions is! TransactionEvidenceRepository) {
      throw StateError('The card and ledger must share a local transaction');
    }
    return (transactions as TransactionEvidenceRepository).editAtomically(
      () async {
        final cards = await _cards.getCards(userId);
        final card = cards.where((card) => card.id == cardId).firstOrNull;
        if (card == null ||
            !isNewerDuplicate(card, cards) ||
            card.isCreditCard ||
            card.creditLimitMinor != 0 ||
            card.currentBalanceMinor != 0 ||
            card.cashWithdrawalEnabled) {
          return false;
        }
        final rows = await transactions.getTransactions(
          userId: userId,
          syncWithRemote: false,
        );
        if (rows.any((row) => row.cardId == card.id)) return false;
        final plan = await _salary.getPlan(
          userId,
          cardId: card.id,
          migrateLegacy: false,
        );
        if (plan != null) return false;
        await _cards.deleteCard(userId, card.id);
        return true;
      },
    );
  }
}
