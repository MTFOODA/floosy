import '../entities/transaction_model.dart';
import '../entities/transaction_edit_policy.dart';

abstract interface class TransactionEvidenceRepository {
  Future<TransactionEditEvidence?> editEvidence(
    String userId,
    String transactionId,
  );
  Future<void> completeEvidence(
    String userId,
    String transactionId, {
    String? bankName,
    String? cardLast4,
    TransactionType? type,
    int? amountMinor,
    String? currency,
  });
  Future<T> editAtomically<T>(Future<T> Function() action);
}

abstract interface class TransactionBankIdentityRepository {
  Future<Map<String, String>> bankNamesForTransactions(String userId);
}

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class TransactionRepository {
  Future<void> insertLocally(Transaction transaction);

  Future<bool> mirrorCreatedTransaction(Transaction transaction);

  Future<Transaction> createTransaction({required Transaction transaction});

  Future<List<Transaction>> getTransactions({
    required String userId,
    bool syncWithRemote = true,
    int limit = 100,
  });

  Future<bool> isDuplicateTransaction({
    required String userId,
    required String fingerprint,
  });

  Future<void> updateTransaction({
    required Transaction transaction,
    bool syncRemote = true,
  });

  void mirrorTransactionInBackground(Transaction transaction);

  Future<void> restoreCardIdentity({
    required Transaction transaction,
    required String? cardId,
    required String? last4,
  });

  Future<void> deleteTransaction({required String transactionId});

  Future<List<Transaction>> getMonthlyTransactions({
    required String userId,
    required int year,
    required int month,
  });

  Future<List<Transaction>> getTransactionsByRange({
    required String userId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    bool syncWithRemote = true,
    int limit = 100,
  });
}
