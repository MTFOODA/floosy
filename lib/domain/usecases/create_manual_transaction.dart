import '../entities/transaction_model.dart';
import '../repositories/detected_card_repository.dart';
import '../repositories/money_repository.dart';
import '../repositories/transaction_repository.dart';

class CreateManualTransaction {
  final TransactionRepository _repository;
  final DetectedCardRepository cards;
  final MoneyRepository money;
  final String Function() createId;
  final DateTime Function() now;
  CreateManualTransaction(
    this._repository, {
    required this.cards,
    required this.money,
    required this.createId,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;
  Future<Transaction> call({
    required String userId,
    required TransactionType type,
    required int amountMinor,
    required String currency,
    String? note,
    String? cardId,
  }) async {
    if (amountMinor <= 0) throw ArgumentError('Amount must be positive');
    final card = cardId == null
        ? null
        : await cards.getCardById(userId, cardId);
    if (cardId != null && card?.userId != userId) {
      throw StateError('The selected card is no longer available');
    }
    final id = createId();
    final transaction = Transaction(
      id: id,
      userId: userId,
      type: type,
      source: TransactionSource.manual,
      amountMinor: amountMinor,
      currency: currency,
      transactionDate: now(),
      cardId: card?.id,
      cardLast4: card?.last4,
      notes: note == null || note.trim().isEmpty ? null : note.trim(),
      fingerprint: 'manual_$id',
      status: TransactionStatus.confirmed,
    );
    if (card == null) {
      return _repository.createTransaction(transaction: transaction);
    }
    await money.recordSmsTransaction(userId: userId, transaction: transaction);
    return transaction;
  }
}
