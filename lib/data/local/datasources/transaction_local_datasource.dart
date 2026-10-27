import 'package:drift/drift.dart';
import '../database/app_database.dart' as db;
import '../../../domain/entities/transaction_model.dart';

class TransactionLocalDataSource {
  final db.AppDatabase _db;

  TransactionLocalDataSource(this._db);

  Future<void> insertTransaction(Transaction transaction) async {
    await _db.into(_db.transactions).insert(
          db.TransactionsCompanion(
            id: Value(transaction.id),
            userId: Value(transaction.userId),
            bankId: Value(transaction.bankId),
            categoryId: Value(transaction.categoryId),
            merchantId: Value(transaction.merchantId),
            type: Value(transaction.type.toString()),
            source: Value(transaction.source.toString()),
            amountMinor: Value(transaction.amountMinor),
            currency: Value(transaction.currency),
            transactionDate: Value(transaction.transactionDate),
            merchantName: Value(transaction.merchantName),
            cardLast4: Value(transaction.cardLast4),
            cardId: Value(transaction.cardId),
            rawReference: Value(transaction.rawReference),
            externalReference: Value(transaction.externalReference),
            fingerprint: Value(transaction.fingerprint),
            status: Value(transaction.status.toString()),
            notes: Value(transaction.notes),
            createdAt: Value(transaction.createdAt ?? DateTime.now()),
            updatedAt: Value(transaction.updatedAt ?? DateTime.now()),
          ),
        );
  }

  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.transactionDate, mode: OrderingMode.desc)
          ]))
        .get();

    return rows.map((row) => _mapRowToTransaction(row)).toList();
  }

  Future<Transaction?> getTransactionByFingerprint(
    String userId,
    String fingerprint,
  ) async {
    final row = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) & t.fingerprint.equals(fingerprint)))
        .getSingleOrNull();

    return row != null ? _mapRowToTransaction(row) : null;
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transaction.id)))
        .write(
      db.TransactionsCompanion(
        bankId: Value(transaction.bankId),
        categoryId: Value(transaction.categoryId),
        merchantId: Value(transaction.merchantId),
        type: Value(transaction.type.toString()),
        source: Value(transaction.source.toString()),
        amountMinor: Value(transaction.amountMinor),
        currency: Value(transaction.currency),
        transactionDate: Value(transaction.transactionDate),
        merchantName: Value(transaction.merchantName),
        cardLast4: Value(transaction.cardLast4),
        cardId: Value(transaction.cardId),
        rawReference: Value(transaction.rawReference),
        externalReference: Value(transaction.externalReference),
        fingerprint: Value(transaction.fingerprint),
        status: Value(transaction.status.toString()),
        notes: Value(transaction.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Updates only the card_id field for a transaction.
  Future<void> updateTransactionCardId(
      String transactionId, String cardId) async {
    await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transactionId)))
        .write(db.TransactionsCompanion(cardId: Value(cardId)));
  }

  /// Writes BOTH halves of a card identity onto one row: `card_last4` and
  /// `card_id`.
  ///
  /// Deliberately narrow — only the two card columns are touched, so repairing a
  /// row can never resurrect other stale fields from a pre-edit in-memory object.
  /// Used to re-assert the user's explicit confirmation when the post-commit
  /// read-back finds the row was written from the stale object.
  ///
  /// A null [cardLast4] or [cardId] is written as NULL: the caller passes the
  /// authoritative committed value, including "there is none".
  Future<void> updateTransactionCardIdentity(
    String transactionId, {
    required String? cardId,
    required String? cardLast4,
  }) async {
    await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transactionId)))
        .write(db.TransactionsCompanion(
      cardId: Value(cardId),
      cardLast4: Value(cardLast4),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteTransaction(String id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Get transactions filtered by card_id
  Future<List<Transaction>> getTransactionsByCardId(
    String userId,
    String cardId,
  ) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) => t.userId.equals(userId) & t.cardId.equals(cardId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.transactionDate, mode: OrderingMode.desc)
          ]))
        .get();

    return rows.map((row) => _mapRowToTransaction(row)).toList();
  }

  /// Get deducted money (purchases + cash expenses + transfers sent) for a specific card in current month
  Future<int> getDeductedForCard(
    String userId,
    String cardId,
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.cardId.equals(cardId) &
              t.transactionDate.isBiggerOrEqualValue(startDate) &
              t.transactionDate.isSmallerThanValue(endDate) &
              t.type.isIn([
                TransactionType.purchase.toString(),
                TransactionType.cash_expense.toString(),
                TransactionType.transfer_out.toString(),
              ])))
        .get();

    return rows.fold<int>(0, (sum, row) => sum + row.amountMinor);
  }

  /// Get ATM withdrawals for a specific card in current month (for Pocket Cash calculation)
  Future<int> getAtmWithdrawalsForCard(
    String userId,
    String cardId,
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.cardId.equals(cardId) &
              t.transactionDate.isBiggerOrEqualValue(startDate) &
              t.transactionDate.isSmallerThanValue(endDate) &
              t.type.equals(TransactionType.atm_withdrawal.toString())))
        .get();

    return rows.fold<int>(0, (sum, row) => sum + row.amountMinor);
  }

  Future<List<Transaction>> getTransactionsByMonth(
    String userId,
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.transactionDate.isBiggerOrEqualValue(startDate) &
              t.transactionDate.isSmallerThanValue(endDate))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.transactionDate, mode: OrderingMode.desc)
          ]))
        .get();

    return rows.map((row) => _mapRowToTransaction(row)).toList();
  }

  /// Get transactions within the given date range (inclusive bounds).
  ///
  /// Null bounds mean unbounded in that direction. Used by the SMS Detection
  /// Range feature to filter what the Transactions page displays. Pure SQLite
  /// filter — no SMS re-detection, no Inbox read.
  Future<List<Transaction>> getTransactionsByRange(
    String userId, {
    required DateTime? startDateTime,
    required DateTime? endDateTime,
  }) async {
    Expression<bool> expr = _db.transactions.userId.equals(userId);
    if (startDateTime != null) {
      expr = expr &
          _db.transactions.transactionDate.isBiggerOrEqualValue(startDateTime);
    }
    if (endDateTime != null) {
      expr = expr &
          _db.transactions.transactionDate.isSmallerOrEqualValue(endDateTime);
    }
    final rows = await (_db.select(_db.transactions)
          ..where((t) => expr)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.transactionDate, mode: OrderingMode.desc)
          ]))
        .get();

    return rows.map((row) => _mapRowToTransaction(row)).toList();
  }

  Transaction _mapRowToTransaction(db.Transaction row) {
    return Transaction(
      id: row.id,
      userId: row.userId,
      bankId: row.bankId,
      categoryId: row.categoryId,
      merchantId: row.merchantId,
      type: _parseTransactionType(row.type),
      source: _parseTransactionSource(row.source),
      amountMinor: row.amountMinor,
      currency: row.currency,
      transactionDate: row.transactionDate,
      merchantName: row.merchantName,
      cardLast4: row.cardLast4,
      cardId: row.cardId,
      rawReference: row.rawReference,
      externalReference: row.externalReference,
      fingerprint: row.fingerprint,
      status: _parseTransactionStatus(row.status),
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TransactionType _parseTransactionType(String value) {
    // Stored value is the full enum toString(): "TransactionType.purchase".
    return TransactionType.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TransactionType.purchase,
    );
  }

  TransactionSource _parseTransactionSource(String value) {
    return TransactionSource.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TransactionSource.manual,
    );
  }

  TransactionStatus _parseTransactionStatus(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TransactionStatus.confirmed,
    );
  }
}
