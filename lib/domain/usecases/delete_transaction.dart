import '../repositories/transaction_repository.dart';
import '../repositories/detected_card_repository.dart';
import '../services/card_ownership.dart';

class DeleteTransaction {
  final TransactionRepository _transactions;
  final DetectedCardRepository _cards;
  const DeleteTransaction(this._transactions, this._cards);
  Future<void> call(
      {required String userId, required String transactionId}) async {
    final existing = await _transactions.getTransactions(
        userId: userId, syncWithRemote: false);
    if (!existing
        .any((row) => row.id == transactionId && row.userId == userId)) {
      throw StateError('Transaction does not belong to this account');
    }
    await _transactions.deleteTransaction(transactionId: transactionId);
    final rows = await _transactions.getTransactions(
        userId: userId, syncWithRemote: false);
    final cards = await _cards.getCards(userId);
    await _cards.recomputeTransactionCountsForCards(
        userId, (card) => CardOwnership.forCard(rows, card, cards).length);
  }
}
