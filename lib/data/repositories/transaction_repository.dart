import '../../domain/repositories/transaction_repository.dart' as domain;
import 'package:drift/drift.dart' show Variable;
import '../../domain/entities/transaction_model.dart';
import '../../domain/entities/transaction_edit_policy.dart';
import '../remote/datasources/transaction_remote_datasource.dart';
import '../local/datasources/transaction_local_datasource.dart';
import '../remote/datasources/money_remote_datasource.dart';
import '../remote/datasources/sms_remote_datasource.dart';

/// The encrypted device ledger is authoritative. Legacy constructor arguments
/// remain compatible with callers; they never authorize financial networking.
class TransactionRepository
    implements
        domain.TransactionRepository,
        domain.TransactionEvidenceRepository,
        domain.TransactionBankIdentityRepository {
  @override
  Future<T> editAtomically<T>(Future<T> Function() action) =>
      _local.database.transaction(action);

  @override
  Future<TransactionEditEvidence?> editEvidence(
    String userId,
    String transactionId,
  ) async {
    _user(userId);
    final row = await _local.database
        .customSelect(
          'SELECT detected_bank_name,type_identified,amount_identified,currency_identified FROM sms_messages WHERE user_id=? AND transaction_id=? ORDER BY received_at DESC LIMIT 1',
          variables: [Variable(userId), Variable(transactionId)],
        )
        .getSingleOrNull();
    return row == null
        ? null
        : TransactionEditEvidence(
            bankName: row.readNullable<String>('detected_bank_name'),
            typeIdentified: row.read<int>('type_identified') == 1,
            amountIdentified: row.read<int>('amount_identified') == 1,
            currencyIdentified: row.read<int>('currency_identified') == 1,
          );
  }

  @override
  Future<void> completeEvidence(
    String userId,
    String transactionId, {
    String? bankName,
    String? cardLast4,
    TransactionType? type,
    int? amountMinor,
    String? currency,
  }) async {
    _user(userId);
    final fields = <String, Object?>{
      if (bankName != null) ...{
        'detected_bank_name': bankName,
        'bank_identified': 1,
      },
      if (type != null) ...{'detected_type': type.name, 'type_identified': 1},
      if (amountMinor != null) ...{
        'detected_amount_minor': amountMinor,
        'amount_identified': 1,
      },
      if (currency != null) ...{
        'detected_currency': currency,
        'currency_identified': 1,
      },
    };
    if (fields.isNotEmpty) {
      await _local.database.customStatement(
        'UPDATE sms_messages SET ${fields.keys.map((k) => '"$k"=?').join(',')} WHERE user_id=? AND transaction_id=?',
        [...fields.values, userId, transactionId],
      );
    }
    if (cardLast4 != null) {
      await _local.database.customStatement(
        'UPDATE sms_messages SET detected_card_last4=?, card_last4_identified=1 WHERE user_id=? AND transaction_id=? AND detected_card_last4 IS NULL',
        [cardLast4, userId, transactionId],
      );
    }
  }

  @override
  Future<Map<String, String>> bankNamesForTransactions(String userId) async {
    _user(userId);
    final rows = await _local.database
        .customSelect(
          'SELECT transaction_id,detected_bank_name FROM sms_messages WHERE user_id=? AND transaction_id IS NOT NULL AND detected_bank_name IS NOT NULL',
          variables: [Variable(userId)],
        )
        .get();
    return {
      for (final row in rows)
        row.read<String>('transaction_id'): row.read<String>(
          'detected_bank_name',
        ),
    };
  }

  final TransactionLocalDataSource _local;
  final String? Function()? _activeUser;
  final Future<void> Function(String)? _deleteMovements;
  final Future<void> Function(String)? _detachSms;
  final Future<void> Function(Transaction, Transaction)? _reconcile;
  TransactionRepository(
    TransactionRemoteDataSource unused,
    this._local, {
    Future<void> Function(String)? deleteTransactionMovements,
    Future<void> Function(String)? detachSmsTransaction,
    Future<void> Function(Transaction, Transaction)?
    reconcileTransactionMovements,
    MoneyRemoteDataSource? moneyRemoteDataSource,
    SmsRemoteDataSource? smsRemoteDataSource,
    String? Function()? activeUser,
  }) : _activeUser = activeUser,
       _deleteMovements = deleteTransactionMovements,
       _detachSms = detachSmsTransaction,
       _reconcile = reconcileTransactionMovements;

  @override
  Future<void> insertLocally(Transaction transaction) async {
    _user(transaction.userId);
    await _local.insertTransaction(transaction);
  }

  void _user(String user) {
    if (_activeUser != null && _activeUser() != user) {
      throw StateError('Account changed');
    }
  }

  @override
  Future<bool> mirrorCreatedTransaction(Transaction transaction) async => true;
  @override
  void mirrorTransactionInBackground(Transaction transaction) {}
  @override
  Future<Transaction> createTransaction({
    required Transaction transaction,
  }) async {
    await insertLocally(transaction);
    return transaction;
  }

  @override
  Future<List<Transaction>> getTransactions({
    required String userId,
    bool syncWithRemote = true,
    int limit = 100,
  }) async {
    _user(userId);
    return _local.getTransactionsByUserId(userId);
  }

  @override
  Future<List<Transaction>> getTransactionsByRange({
    required String userId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    bool syncWithRemote = true,
    int limit = 100,
  }) async {
    _user(userId);
    return _local.getTransactionsByRange(
      userId,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
    );
  }

  @override
  Future<List<Transaction>> getMonthlyTransactions({
    required String userId,
    required int year,
    required int month,
  }) async {
    _user(userId);
    return _local.getTransactionsByMonth(userId, year, month);
  }

  @override
  Future<bool> isDuplicateTransaction({
    required String userId,
    required String fingerprint,
  }) async {
    _user(userId);
    return await _local.getTransactionByFingerprint(userId, fingerprint) !=
        null;
  }

  @override
  Future<void> updateTransaction({
    required Transaction transaction,
    bool syncRemote = true,
  }) async {
    _user(transaction.userId);
    await _local.database.transaction(() async {
      final rows = await _local.getTransactionsByUserId(transaction.userId);
      final previous = rows.where((r) => r.id == transaction.id).firstOrNull;
      if (previous == null) throw StateError('Transaction not found');
      _user(transaction.userId);
      await _local.updateTransaction(transaction);
      await _updateLinkedExpense(transaction);
      if (previous.amountMinor != transaction.amountMinor ||
          previous.type != transaction.type ||
          previous.status != transaction.status ||
          previous.currency != transaction.currency ||
          previous.bankId != transaction.bankId ||
          !previous.transactionDate.isAtSameMomentAs(
            transaction.transactionDate,
          )) {
        await _reconcile?.call(previous, transaction);
      }
    });
  }

  @override
  Future<void> restoreCardIdentity({
    required Transaction transaction,
    required String? cardId,
    required String? last4,
  }) async {
    _user(transaction.userId);
    await _local.updateTransactionCardIdentity(
      transaction.id,
      cardId: cardId,
      cardLast4: last4,
    );
  }

  @override
  Future<void> deleteTransaction({
    required String transactionId,
  }) => _local.database.transaction(() async {
    if (_activeUser != null) {
      final row = await _local.database
          .customSelect(
            'SELECT user_id FROM transactions WHERE id=?',
            variables: [Variable(transactionId)],
          )
          .getSingleOrNull();
      if (row == null) return;
      _user(row.read<String>('user_id'));
    }
    await _deleteMovements?.call(transactionId);
    await _detachSms?.call(transactionId);
    final database = _local.database;
    await database.customStatement(
      'DELETE FROM item_usages WHERE expense_id IN (SELECT id FROM expenses WHERE transaction_id=?)',
      [transactionId],
    );
    await database.customStatement(
      'DELETE FROM expense_items WHERE expense_id IN (SELECT id FROM expenses WHERE transaction_id=?)',
      [transactionId],
    );
    await database.customStatement(
      'DELETE FROM expenses WHERE transaction_id=?',
      [transactionId],
    );
    await _local.deleteTransaction(transactionId);
  });

  Future<void> _updateLinkedExpense(Transaction transaction) async {
    final database = _local.database;
    final expenses = await database
        .customSelect(
          'SELECT id FROM expenses WHERE transaction_id=? AND user_id=?',
          variables: [Variable(transaction.id), Variable(transaction.userId)],
        )
        .get();
    // A split receipt cannot be reallocated safely from the transaction total.
    // Home Item purchases have exactly one expense and one usage row.
    if (expenses.length != 1) return;
    final id = expenses.single.read<String>('id');
    final date = transaction.transactionDate.millisecondsSinceEpoch ~/ 1000;
    await database.customStatement(
      'UPDATE expenses SET amount_minor=?,currency=?,expense_date=?,category_id=?,payment_method=? WHERE id=?',
      [
        transaction.amountMinor,
        transaction.currency,
        date,
        transaction.categoryId,
        transaction.type == TransactionType.cash_expense ? 'cash' : 'card',
        id,
      ],
    );
    final usages = await database
        .customSelect(
          'SELECT id FROM item_usages WHERE expense_id=?',
          variables: [Variable(id)],
        )
        .get();
    if (usages.length == 1) {
      await database.customStatement(
        'UPDATE item_usages SET total_amount_minor=?,usage_date=? WHERE id=?',
        [transaction.amountMinor, date, usages.single.read<String>('id')],
      );
    }
    final lines = await database
        .customSelect(
          'SELECT id,quantity FROM expense_items WHERE expense_id=?',
          variables: [Variable(id)],
        )
        .get();
    if (lines.length == 1 && lines.single.read<int>('quantity') == 1) {
      await database.customStatement(
        'UPDATE expense_items SET unit_price_minor=?,total_price_minor=? WHERE id=?',
        [
          transaction.amountMinor,
          transaction.amountMinor,
          lines.single.read<String>('id'),
        ],
      );
    }
  }
}
