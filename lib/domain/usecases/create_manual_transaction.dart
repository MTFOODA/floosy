import '../entities/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class CreateManualTransaction {
  final TransactionRepository _repository;
  final String Function() createId;
  final DateTime Function() now;
  CreateManualTransaction(this._repository,
      {required this.createId, DateTime Function()? now})
      : now = now ?? DateTime.now;
  Future<Transaction> call(
      {required String userId,
      required TransactionType type,
      required int amountMinor,
      required String currency,
      String? note}) {
    if (amountMinor <= 0) throw ArgumentError('Amount must be positive');
    final id = createId();
    return _repository.createTransaction(
        transaction: Transaction(
            id: id,
            userId: userId,
            type: type,
            source: TransactionSource.manual,
            amountMinor: amountMinor,
            currency: currency,
            transactionDate: now(),
            merchantName:
                note == null || note.trim().isEmpty ? null : note.trim(),
            fingerprint: 'manual_$id',
            status: TransactionStatus.confirmed));
  }
}
