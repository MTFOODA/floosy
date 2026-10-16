import 'package:drift/drift.dart';
import '../../models/money_model.dart';
import '../../models/item_model.dart';
import '../../models/transaction_model.dart' as models;
import '../database/app_database.dart' as db;

/// Local (Drift) storage for the money model: monthly income, bank accounts,
/// bank-ledger movements, pocket-cash movements and item usage.
///
/// Everything is offline-first; remote sync happens on top through the
/// repositories.
class MoneyLocalDataSource {
  final db.AppDatabase _db;

  MoneyLocalDataSource(this._db);

  /// Updates only the card_id field of one transaction (Card ↔ Transaction
  /// relationship, requirement #5). Used by the SMS pipeline right after a
  /// card is upserted so the transaction is linked by a stable id.
  Future<void> updateTransactionCardId(
      String transactionId, String cardId) async {
    await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transactionId)))
        .write(db.TransactionsCompanion(cardId: Value(cardId)));
  }

  /// Atomically writes `card_id` for the given transactions, and returns only
  /// after every row is committed (or the whole batch is rolled back).
  ///
  /// This is what makes automatic propagation safe: there is no window in which
  /// transaction A is updated and transaction B silently is not. The caller
  /// knows the operation either fully applied or not at all.
  ///
  /// The write is restricted to rows whose `card_id IS NULL`, so an explicitly
  /// assigned transaction can NEVER be overwritten by a propagation pass — even
  /// if it appears in [transactionIds]. Combined with the caller's filtering,
  /// that makes repeated runs idempotent.
  Future<int> updateTransactionCardIdsAtomically(
    List<String> transactionIds,
    String cardId,
  ) async {
    if (transactionIds.isEmpty) return 0;
    var updated = 0;
    await _db.transaction(() async {
      // Re-apply the "unresolved only" guard inside the transaction so a row
      // that gained an explicit assignment between planning and writing is
      // left alone instead of being clobbered.
      updated = await (_db.update(_db.transactions)
            ..where((t) =>
                t.id.isIn(transactionIds) & t.cardId.isNull()))
          .write(db.TransactionsCompanion(cardId: Value(cardId)));
    });
    return updated;
  }

  /// Applies a user-CONFIRMED card identity to the edited transaction AND to
  /// every transaction that provably shares it, inside ONE Drift transaction.
  ///
  /// This is THE authoritative local write for the "Edit -> type Last 4 -> Save"
  /// flow, and it persists BOTH halves of the identity:
  ///
  ///     card_last4 = confirmedLast4
  ///     card_id    = confirmedCardId
  ///
  /// Persisting only `card_id` is not enough. The Last 4 the user typed is
  /// *itself* the confirmed value, and the UI, the red-dot indicator and the
  /// per-card balances all read `card_last4`; a Last 4 that only ever reached
  /// Supabase — or only the widget's in-memory copy — is a value the user never
  /// really saved.
  ///
  /// The two write groups are deliberately different:
  ///
  ///  * the EDITED row is written unconditionally. The user explicitly confirmed
  ///    this exact transaction, so there is no ambiguity to preserve, and this is
  ///    what makes an edited `CIB + NULL` row immediately become `CIB + 1234`.
  ///    It is also what repairs a row that already carried a `card_id` without
  ///    the matching `card_last4`.
  ///  * the PROPAGATED rows are restricted to `card_id IS NULL`, so an existing
  ///    explicit assignment is never overwritten. Reinforcing their already
  ///    identical `card_last4` is a no-op, not a change of meaning.
  ///
  /// Returns the number of rows written, counted only after the transaction
  /// commits. One commit means the edited row and its propagation targets can
  /// never be half-applied.
  Future<int> applyConfirmedCardIdentity({
    required String transactionId,
    required String cardId,
    required String last4,
    List<String> propagatedTransactionIds = const [],
  }) async {
    var written = 0;
    await _db.transaction(() async {
      // 1. The transaction the user explicitly edited/confirmed.
      written += await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(db.TransactionsCompanion(
            cardLast4: Value(last4),
            cardId: Value(cardId),
            updatedAt: Value(DateTime.now()),
          ));

      // 2. The other rows proven to carry the same identity. `card_id IS NULL`
      //    is re-checked INSIDE the transaction so a row that gained an
      //    explicit assignment between planning and writing is left alone.
      final others = propagatedTransactionIds
          .where((id) => id != transactionId)
          .toList(growable: false);
      if (others.isNotEmpty) {
        written += await (_db.update(_db.transactions)
              ..where((t) => t.id.isIn(others) & t.cardId.isNull()))
            .write(db.TransactionsCompanion(
              cardLast4: Value(last4),
              cardId: Value(cardId),
              updatedAt: Value(DateTime.now()),
            ));
      }
    });
    return written;
  }

  /// The transaction ids of [userId] that have NO card last 4 recorded, whose
  /// originating SMS detection record positively names one of [bankNames], and
  /// whose canonical transaction type is [type].
  ///
  /// This is the DATABASE half of the product's bank-scoped Last 4 propagation.
  /// The join is on the PERSISTED relationship (`sms_messages.transaction_id`),
  /// never on merchant, amount, timestamp, sender or message-text similarity.
  ///
  /// `card_last4 IS NULL` is the whole selection rule: those rows are the ones
  /// the user is supplying the missing identity for. Rows that already carry a
  /// last 4 are never selected.
  ///
  /// The transaction TYPE is part of the propagation identity, so a
  /// `purchase` confirmation never reaches a sibling `atm_withdrawal` /
  /// `transfer_in` row of the same card. The stored value is the canonical
  /// `TransactionType` `toString()` — the same representation the app already
  /// writes and reads, so no second type system is introduced. A row whose
  /// stored type is unrecognised simply does not match, which keeps it out of
  /// every group rather than silently joining one.
  ///
  /// Only positively identified detections contribute a name
  /// (`bank_identified = true`), so a message with no detected bank cannot make
  /// its transaction a candidate for any bank.
  ///
  /// The caller folds the returned bank names through [normalizeBankIdentity]
  /// before issuing the query, which is what keeps `Faisal Bank`, `AlexBank`,
  /// `CIB` and `NBE` separate while collapsing `CIB` / `cib` onto one identity.
  Future<List<String>> findNullLast4IdsForDetectedBankNames({
    required String userId,
    required List<String> bankNames,
    required String type,
  }) async {
    if (bankNames.isEmpty) return const [];
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.id])
      ..join([
        innerJoin(
          _db.smsMessages,
          _db.smsMessages.transactionId.equalsExp(_db.transactions.id),
        ),
      ])
      ..where(
        _db.transactions.userId.equals(userId) &
            _db.transactions.cardLast4.isNull() &
            _db.transactions.type.equals(type) &
            _db.smsMessages.bankIdentified.equals(true) &
            _db.smsMessages.detectedBankName.isIn(bankNames),
      );
    final rows = await query.get();
    return rows.map((r) => r.read(_db.transactions.id)!).toList();
  }

  /// The transaction ids of [userId] in one of [bankNames] that ALREADY carry
  /// [last4] but still have no `card_id`.
  ///
  /// These are the second, separate population the product rule needs. The
  /// Last 4 propagation query only selects rows whose `card_last4 IS NULL`; this
  /// one selects the rows where the number is already right and only the card
  /// LINK is missing.
  ///
  /// Requiring the exact confirmed [last4], the same bank AND the same
  /// transaction [type] is what keeps this safe: the value is identical to the
  /// one the user just typed, so there is nothing to guess, the bank is still
  /// compared so `CIB + 1234` never reaches an `NBE + 1234` row, and the type
  /// is compared so a `purchase` confirmation never claims a sibling
  /// `atm_withdrawal` row that merely shares the card.
  Future<List<String>> findMissingCardIdIdsForIdentity({
    required String userId,
    required List<String> bankNames,
    required String last4,
    required String type,
  }) async {
    if (bankNames.isEmpty) return const [];
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.id])
      ..join([
        innerJoin(
          _db.smsMessages,
          _db.smsMessages.transactionId.equalsExp(_db.transactions.id),
        ),
      ])
      ..where(
        _db.transactions.userId.equals(userId) &
            _db.transactions.cardId.isNull() &
            _db.transactions.cardLast4.equals(last4) &
            _db.transactions.type.equals(type) &
            _db.smsMessages.bankIdentified.equals(true) &
            _db.smsMessages.detectedBankName.isIn(bankNames),
      );
    final rows = await query.get();
    return rows.map((r) => r.read(_db.transactions.id)!).toList();
  }

  /// Every distinct bank NAME the user's positively-identified detection records
  /// carry, returned raw.
  ///
  /// The caller normalises them and recovers the concrete spellings that SQL
  /// must match. Reading them once keeps propagation a fixed number of
  /// statements instead of one query per candidate row.
  Future<List<String>> distinctDetectedBankNames(String userId) async {
    final query = _db.selectOnly(_db.smsMessages)
      ..addColumns([_db.smsMessages.detectedBankName])
      ..where(
        _db.smsMessages.userId.equals(userId) &
            _db.smsMessages.bankIdentified.equals(true) &
            _db.smsMessages.detectedBankName.isNotNull(),
      );
    final rows = await query.get();
    // De-duplicated in Dart: the set of banks a user has is tiny, and this keeps
    // the statement portable across Drift versions.
    final seen = <String>{};
    for (final row in rows) {
      final name = row.read(_db.smsMessages.detectedBankName);
      if (name != null) seen.add(name);
    }
    return seen.toList(growable: false);
  }

  /// Applies a user-CONFIRMED card identity bank-wide, in ONE Drift transaction.
  ///
  /// This is the product rule: when the user manually confirms the real Last 4
  /// for one transaction, every transaction of the SAME USER and SAME canonical
  /// BANK whose `card_last4` is NULL receives that confirmed value. It is
  /// deliberately NOT keyed on `card_last4 = confirmed` — on real data that
  /// matched nothing, because the rows were WAITING for the value rather than
  /// already holding it.
  ///
  /// `card_last4` and `card_id` are handled INDEPENDENTLY:
  ///
  ///  * the EDITED row is written unconditionally — the user confirmed this
  ///    exact transaction, so both fields become authoritative;
  ///  * SIBLING rows get `card_last4` unconditionally, even when they already
  ///    carry an explicit `card_id`, because filling a missing last 4 must never
  ///    require a missing card id;
  ///  * SIBLING rows get `card_id` only where it is still NULL, so explicit
  ///    ownership always wins;
  ///  * rows that already have a `card_last4` are never passed in by the query,
  ///    and are additionally re-guarded here, so they cannot be rewritten.
  ///
  /// The linked SMS detection records are updated in the SAME transaction, via
  /// the persisted `sms_messages.transaction_id` relationship, so the stored
  /// message and the stored transaction can never disagree after a commit.
  /// Only NULL detections are filled, preserving any value genuinely parsed out
  /// of a message.
  ///
  /// A single commit means the edited row, its siblings and their SMS records
  /// are either all updated or none are.
  Future<BankScopedIdentityWriteResult> applyBankScopedConfirmedIdentity({
    required String transactionId,
    required String cardId,
    required String last4,
    required List<String> siblingTransactionIds,
    bool fillSmsDetections = true,
  }) async {
    final siblings = siblingTransactionIds
        .where((id) => id != transactionId)
        .toList(growable: false);
    var editedRows = 0;
    var siblingLast4Rows = 0;
    var siblingCardRows = 0;
    var smsRows = 0;

    await _db.transaction(() async {
      // 1. The transaction the user explicitly edited and confirmed.
      editedRows = await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(db.TransactionsCompanion(
            cardLast4: Value(last4),
            cardId: Value(cardId),
            updatedAt: Value(DateTime.now()),
          ));

      if (siblings.isNotEmpty) {
        // 2. Every same-user/same-bank sibling that was missing the Last 4.
        //    Independent of card_id, so a row with explicit ownership still
        //    gets the number it was missing.
        siblingLast4Rows = await (_db.update(_db.transactions)
              ..where((t) => t.id.isIn(siblings) & t.cardLast4.isNull()))
            .write(db.TransactionsCompanion(
              cardLast4: Value(last4),
              updatedAt: Value(DateTime.now()),
            ));

        // 3. Card ownership, only where it is still unassigned.
        siblingCardRows = await (_db.update(_db.transactions)
              ..where((t) => t.id.isIn(siblings) & t.cardId.isNull()))
            .write(db.TransactionsCompanion(
              cardId: Value(cardId),
              updatedAt: Value(DateTime.now()),
            ));
      }

      if (fillSmsDetections) {
        final affected = <String>[transactionId, ...siblings];
        // 4. The originating detection record of every affected transaction,
        //    joined on the persisted relationship, never on content matching.
        smsRows = await (_db.update(_db.smsMessages)
              ..where((s) =>
                  s.transactionId.isIn(affected) & s.detectedCardLast4.isNull()))
            .write(db.SmsMessagesCompanion(
              detectedCardLast4: Value(last4),
              cardLast4Identified: const Value(true),
            ));
      }
    });

    return BankScopedIdentityWriteResult(
      editedRows: editedRows,
      siblingLast4Rows: siblingLast4Rows,
      siblingCardRows: siblingCardRows,
      smsRows: smsRows,
    );
  }

  /// Ids of the user's transactions that are still awaiting a card assignment.
  /// Used to scope propagation to unresolved rows only.
  Future<List<String>> getUnlinkedTransactionIds(String userId) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) => t.userId.equals(userId) & t.cardId.isNull()))
        .get();
    return rows.map((r) => r.id).toList();
  }

  /// The unresolved transactions of [userId] that already carry [last4].
  ///
  /// This is the DATABASE half of propagation. The WHERE clause is explicit
  /// and is deliberately NOT "last4 only":
  ///
  ///     user_id = :userId
  ///     AND card_id IS NULL            (never touch an explicit assignment)
  ///     AND card_last4 = :last4        (exact four-digit match)
  ///
  /// The bank equality is applied by the caller on top of this result,
  /// because the transaction row does not carry a bank column (the detected
  /// bank lives on the sms_messages detection record and needs normalisation,
  /// which cannot be expressed as a plain SQL comparison). Narrowing in SQL
  /// first keeps the set small and makes the "same last4, unresolved, same
  /// user" part of the rule a real indexed query rather than a full scan.
  Future<List<String>> findUnresolvedIdsForLast4({
    required String userId,
    required String last4,
  }) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.cardId.isNull() &
              t.cardLast4.equals(last4)))
        .get();
    return rows.map((r) => r.id).toList();
  }

  // ── Monthly income ─────────────────────────────────────────────────────────

  Future<void> insertMonthlyIncome(MonthlyIncome income) async {
    await _db.into(_db.monthlyIncomes).insert(db.MonthlyIncomesCompanion(
          id: Value(income.id),
          userId: Value(income.userId),
          year: Value(income.year),
          month: Value(income.month),
          label: Value(income.label),
          amountMinor: Value(income.amountMinor),
          currency: Value(income.currency),
          bankAccountId: Value(income.bankAccountId),
          createdAt: Value(income.createdAt ?? DateTime.now()),
          updatedAt: Value(income.updatedAt ?? DateTime.now()),
        ));
  }

  Future<List<MonthlyIncome>> getMonthlyIncomes(
    String userId, {
    int? year,
    int? month,
  }) async {
    final query = _db.select(_db.monthlyIncomes)
      ..where((t) {
        var expr = t.userId.equals(userId);
        if (year != null) expr = expr & t.year.equals(year);
        if (month != null) expr = expr & t.month.equals(month);
        return expr;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.year, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.month, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_mapMonthlyIncome).toList();
  }

  Future<void> updateMonthlyIncome(MonthlyIncome income) async {
    await (_db.update(_db.monthlyIncomes)..where((t) => t.id.equals(income.id)))
        .write(db.MonthlyIncomesCompanion(
      label: Value(income.label),
      amountMinor: Value(income.amountMinor),
      currency: Value(income.currency),
      bankAccountId: Value(income.bankAccountId),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteMonthlyIncome(String id) async {
    await (_db.delete(_db.monthlyIncomes)..where((t) => t.id.equals(id))).go();
  }

  // ── Bank accounts ──────────────────────────────────────────────────────────

  Future<void> insertBankAccount(UserBankAccount account) async {
    await _db.into(_db.bankAccounts).insert(db.BankAccountsCompanion(
          id: Value(account.id),
          userId: Value(account.userId),
          name: Value(account.name),
          bankId: Value(account.bankId),
          accountLast4: Value(account.accountLast4),
          openingBalanceMinor: Value(account.openingBalanceMinor),
          currency: Value(account.currency),
          isActive: Value(account.isActive),
          createdAt: Value(account.createdAt ?? DateTime.now()),
          updatedAt: Value(account.updatedAt ?? DateTime.now()),
        ));
  }

  Future<List<UserBankAccount>> getBankAccounts(String userId) async {
    final rows = await (_db.select(_db.bankAccounts)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
    return rows.map(_mapBankAccount).toList();
  }

  Future<UserBankAccount?> getBankAccount(String accountId) async {
    final row = await (_db.select(_db.bankAccounts)
          ..where((t) => t.id.equals(accountId)))
        .getSingleOrNull();
    return row == null ? null : _mapBankAccount(row);
  }

  Future<void> updateBankAccount(UserBankAccount account) async {
    await (_db.update(_db.bankAccounts)..where((t) => t.id.equals(account.id)))
        .write(db.BankAccountsCompanion(
      name: Value(account.name),
      bankId: Value(account.bankId),
      accountLast4: Value(account.accountLast4),
      openingBalanceMinor: Value(account.openingBalanceMinor),
      currency: Value(account.currency),
      isActive: Value(account.isActive),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteBankAccount(String accountId) async {
    await (_db.delete(_db.bankAccounts)..where((t) => t.id.equals(accountId)))
        .go();
  }

  /// Derived balance for an account = opening + Σ(in) − Σ(out).
  Future<int> getBankAccountBalance(String accountId) async {
    final rows = await (_db.select(_db.bankMovements)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
    final account = await getBankAccount(accountId);
    var balance = account?.openingBalanceMinor ?? 0;
    for (final m in rows) {
      balance += m.type == 'in' ? m.amountMinor : -m.amountMinor;
    }
    return balance;
  }

  // ── Bank movements (ledger) ────────────────────────────────────────────────

  Future<void> insertBankMovement(BankAccountMovement movement) async {
    await _db.into(_db.bankMovements).insert(db.BankMovementsCompanion(
          id: Value(movement.id),
          accountId: Value(movement.accountId),
          userId: Value(movement.userId),
          type: Value(movement.type),
          amountMinor: Value(movement.amountMinor),
          description: Value(movement.description),
          referenceType: Value(movement.referenceType),
          referenceId: Value(movement.referenceId),
          movementDate: Value(movement.movementDate),
          createdAt: Value(movement.createdAt ?? DateTime.now()),
        ));
  }

  Future<List<BankAccountMovement>> getBankMovements(String userId) async {
    final rows = await (_db.select(_db.bankMovements)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc)
          ]))
        .get();
    return rows.map(_mapBankMovement).toList();
  }

  // ── Pocket cash ────────────────────────────────────────────────────────────

  Future<CashWallet?> getWallet(String userId) async {
    final row = await (_db.select(_db.cashWallets)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row == null
        ? null
        : CashWallet(
            id: row.id,
            userId: row.userId,
            currency: row.currency,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt);
  }

  Future<void> insertWallet(CashWallet wallet) async {
    await _db.into(_db.cashWallets).insert(db.CashWalletsCompanion(
          id: Value(wallet.id),
          userId: Value(wallet.userId),
          currency: Value(wallet.currency),
          createdAt: Value(wallet.createdAt ?? DateTime.now()),
          updatedAt: Value(wallet.updatedAt ?? DateTime.now()),
        ));
  }

  Future<void> insertCashMovement(CashMovement movement) async {
    await _db.into(_db.cashMovements).insert(db.CashMovementsCompanion(
          id: Value(movement.id),
          userId: Value(movement.userId),
          walletId: Value(movement.walletId),
          type: Value(movement.type),
          amountMinor: Value(movement.amountMinor),
          referenceType: Value(movement.referenceType),
          referenceId: Value(movement.referenceId),
          description: Value(movement.description),
          movementDate: Value(movement.movementDate),
          createdAt: Value(movement.createdAt ?? DateTime.now()),
        ));
  }

  Future<int> getCashBalance(String userId) async {
    final rows = await (_db.select(_db.cashMovements)
          ..where((t) => t.userId.equals(userId)))
        .get();
    var balance = 0;
    for (final m in rows) {
      balance += (m.type == 'atm_withdrawal' ||
              m.type == 'income' ||
              m.type == 'in' ||
              m.type == 'manual_in' ||
              m.type == 'adjustment_in')
          ? m.amountMinor
          : -m.amountMinor;
    }
    return balance;
  }

  // ── Item usage ─────────────────────────────────────────────────────────────

  Future<void> insertItemUsage(models.ItemUsage usage) async {
    await _db.into(_db.itemUsages).insert(db.ItemUsagesCompanion(
          id: Value(usage.id),
          userId: Value(usage.userId),
          itemId: Value(usage.itemId),
          expenseId: Value(usage.expenseId),
          quantity: Value(usage.quantity),
          totalAmountMinor: Value(usage.totalAmountMinor),
          usageDate: Value(usage.usageDate),
          createdAt: Value(usage.createdAt ?? DateTime.now()),
        ));
  }

  Future<List<models.ItemUsage>> getItemUsages(
    String userId, {
    int? year,
    int? month,
  }) async {
    final query = _db.select(_db.itemUsages)
      ..where((t) {
        var expr = t.userId.equals(userId);
        if (year != null && month != null) {
          final start = DateTime(year, month, 1);
          final end = DateTime(year, month + 1, 1);
          expr = expr &
              t.usageDate.isBiggerOrEqualValue(start) &
              t.usageDate.isSmallerThanValue(end);
        }
        return expr;
      })
      ..orderBy([(t) => OrderingTerm(expression: t.usageDate)]);
    final rows = await query.get();
    return rows
        .map((u) => models.ItemUsage(
              id: u.id,
              userId: u.userId,
              itemId: u.itemId,
              expenseId: u.expenseId,
              quantity: u.quantity,
              totalAmountMinor: u.totalAmountMinor,
              usageDate: u.usageDate,
              createdAt: u.createdAt,
            ))
        .toList();
  }

  // ── Money model tables (schema v2) ────────────────────────────────────────

  /// Sum of confirmed transactions that count as "deducted money" for a month.
  Future<int> getDeductedForMonth(String userId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end)))
        .get();
    var total = 0;
    for (final row in rows) {
      final type = _parseTransactionType(row.type);
      if (type?.countsTowardsDeducted ?? false) total += row.amountMinor;
    }
    return total;
  }

  /// Sum of confirmed incoming money transactions for a month
  /// (salary via type=income plus incoming transfers).
  Future<int> getIncomingForMonth(String userId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end)))
        .get();
    var total = 0;
    for (final row in rows) {
      final type = _parseTransactionType(row.type);
      if (type == models.TransactionType.income ||
          type == models.TransactionType.transfer_in) {
        total += row.amountMinor;
      }
    }
    return total;
  }

  /// Sum of deducted money for a specific card in a month.
  ///
  /// Ownership is decided by the CALLER and expressed with two explicit flags,
  /// because this predicate used to be the main source of cross-card leakage:
  /// it matched `card_id IS NULL AND card_last4 = ?`, so a row with no card id
  /// was counted for EVERY card sharing that last4.
  ///
  ///  * [cardId]      — restrict to rows whose `card_id` equals this, plus
  ///                    unlinked rows with [cardLast4] when
  ///                    [includeUnlinkedByLast4] is set (the normal, unique
  ///                    last4 case).
  ///  * [onlyUnlinkedByLast4] — match ONLY unlinked rows by last4 and no card
  ///                    at all. Used when no card could be resolved, so nothing
  ///                    bleeds across cards.
  Future<int> getDeductedForCard(
    String userId,
    String cardLast4,
    int year,
    int month, {
    String? cardId,
    bool includeUnlinkedByLast4 = true,
    bool onlyUnlinkedByLast4 = false,
  }) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) {
            final Expression<bool> byLast4 = t.cardLast4.equals(cardLast4);
            final Expression<bool> unlinked = t.cardId.isNull() & byLast4;
            final Expression<bool> ownership;
            if (onlyUnlinkedByLast4) {
              ownership = unlinked;
            } else if (cardId == null) {
              ownership =
                  includeUnlinkedByLast4 ? byLast4 : const Constant(false);
            } else {
              ownership = includeUnlinkedByLast4
                  ? (t.cardId.equals(cardId) | unlinked)
                  : t.cardId.equals(cardId);
            }
            return t.userId.equals(userId) &
                ownership &
                t.status.equals('TransactionStatus.confirmed') &
                t.transactionDate.isBiggerOrEqualValue(start) &
                t.transactionDate.isSmallerThanValue(end);
          }))
        .get();
    var total = 0;
    for (final row in rows) {
      final type = _parseTransactionType(row.type);
      if (type?.countsTowardsDeducted ?? false) total += row.amountMinor;
    }
    return total;
  }

  /// Sum of ATM withdrawals for a specific card in a month
  Future<int> getAtmWithdrawalsForCard(
    String userId,
    String cardLast4,
    int year,
    int month, {
    String? cardId,
  }) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              (cardId == null
                  ? t.cardLast4.equals(cardLast4)
                  : t.cardId.equals(cardId)) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end) &
              t.type.equals('TransactionType.atm_withdrawal')))
        .get();
    var total = 0;
    for (final row in rows) {
      total += row.amountMinor;
    }
    return total;
  }

  /// Sum of incoming money for a specific card in a month
  Future<int> getIncomingForCard(
    String userId,
    String cardLast4,
    int year,
    int month, {
    String? cardId,
  }) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              (cardId == null
                  ? t.cardLast4.equals(cardLast4)
                  : t.cardId.equals(cardId)) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end) &
              t.type.isIn([
                'TransactionType.income',
                'TransactionType.transfer_in',
                'TransactionType.refund',
              ])))
        .get();
    var total = 0;
    for (final row in rows) {
      total += row.amountMinor;
    }
    return total;
  }

  /// Sum of cash expenses (type=cash_expense) for a specific card in a month.
  Future<int> getCardCashSpending(
    String userId,
    String cardLast4,
    int year,
    int month, {
    String? cardId,
  }) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              (cardId == null
                  ? t.cardLast4.equals(cardLast4)
                  : t.cardId.equals(cardId)) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end) &
              t.type.equals(models.TransactionType.cash_expense.toString())))
        .get();
    var total = 0;
    for (final row in rows) {
      total += row.amountMinor;
    }
    return total;
  }

  /// Sum of confirmed incoming-money transactions (income / received
  /// transfers) that are NOT already reflected in a bank-account balance via
  /// a linked ledger movement.
  ///
  /// `recordSmsTransaction` only creates a `bank_movements` row when the SMS
  /// matched a linked bank account (or a monthly income was tied to an
  /// account). Everything else — SMS received with no linked account, manual
  /// "Add Transaction" entries — lives ONLY in `transactions`, so the
  /// Dashboard "My Balance" card (which is derived from bank balances) would
  /// silently hide it. This method adds exactly those rows back.
  Future<int> getUnrepresentedIncomingSum(String userId) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.status.equals('TransactionStatus.confirmed') &
              (t.type.equals('TransactionType.income') |
                  t.type.equals('TransactionType.transfer_in'))))
        .get();
    final movements = await getBankMovements(userId);
    final referenced = movements
        .where((m) => m.referenceId != null && m.referenceId!.isNotEmpty)
        .map((m) => m.referenceId!)
        .toSet();
    var total = 0;
    for (final row in rows) {
      // Already counted through an account ledger movement → skip to avoid
      // double counting (the bank balance already includes that money).
      if (referenced.contains(row.id)) continue;
      total += row.amountMinor;
    }
    return total;
  }

  /// Confirmed transactions in a month grouped by type name.
  Future<Map<String, int>> getMonthlyBreakdown(
      String userId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.status.equals('TransactionStatus.confirmed') &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end)))
        .get();
    final result = <String, int>{};
    for (final row in rows) {
      result[row.type] = (result[row.type] ?? 0) + row.amountMinor;
    }
    return result;
  }

  Future<int> getMonthlyIncomeSum(String userId, int year, int month) async {
    final incomes = await getMonthlyIncomes(userId, year: year, month: month);
    return incomes.fold<int>(0, (sum, i) => sum + i.amountMinor);
  }

  Future<void> runInTransaction(Future<void> Function() action) {
    return _db.transaction(() async => action());
  }

  // ── Mapping helpers ────────────────────────────────────────────────────────

  // ── Deletion helpers (used by TransactionDataResetService) ──────────────

  Future<void> deleteMovementsForTransaction(String transactionId) async {
    await (_db.delete(_db.bankMovements)
          ..where((t) =>
              t.referenceType.equals('transaction') &
              t.referenceId.equals(transactionId)))
        .go();
    await (_db.delete(_db.cashMovements)
          ..where((t) =>
              t.referenceType.equals('transaction') &
              t.referenceId.equals(transactionId)))
        .go();
  }

  Future<void> deleteBankMovement(String id) async {
    await (_db.delete(_db.bankMovements)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteCashMovement(String id) async {
    await (_db.delete(_db.cashMovements)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteWallet(String id) async {
    await (_db.delete(_db.cashWallets)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteItemUsage(String id) async {
    await (_db.delete(_db.itemUsages)..where((t) => t.id.equals(id))).go();
  }

  Future<List<BankAccountMovement>> getMovementsForAccount(
      String accountId) async {
    final rows = await (_db.select(_db.bankMovements)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
    return rows.map(_mapBankMovement).toList();
  }

  Future<List<CashMovement>> getCashMovements(String walletId) async {
    final rows = await (_db.select(_db.cashMovements)
          ..where((t) => t.walletId.equals(walletId)))
        .get();
    return rows.map(_mapCashMovement).toList();
  }

  MonthlyIncome _mapMonthlyIncome(db.MonthlyIncome row) {
    return MonthlyIncome(
      id: row.id,
      userId: row.userId,
      year: row.year,
      month: row.month,
      label: row.label,
      amountMinor: row.amountMinor,
      currency: row.currency,
      bankAccountId: row.bankAccountId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  UserBankAccount _mapBankAccount(db.BankAccount row) {
    return UserBankAccount(
      id: row.id,
      userId: row.userId,
      name: row.name,
      bankId: row.bankId,
      accountLast4: row.accountLast4,
      openingBalanceMinor: row.openingBalanceMinor,
      currency: row.currency,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  BankAccountMovement _mapBankMovement(db.BankMovement row) {
    return BankAccountMovement(
      id: row.id,
      accountId: row.accountId,
      userId: row.userId,
      type: row.type,
      amountMinor: row.amountMinor,
      description: row.description,
      referenceType: row.referenceType,
      referenceId: row.referenceId,
      movementDate: row.movementDate,
      createdAt: row.createdAt,
    );
  }

  CashMovement _mapCashMovement(db.CashMovement row) {
    return CashMovement(
      id: row.id,
      userId: row.userId,
      walletId: row.walletId,
      type: row.type,
      amountMinor: row.amountMinor,
      referenceType: row.referenceType,
      referenceId: row.referenceId,
      description: row.description,
      movementDate: row.movementDate,
      createdAt: row.createdAt,
    );
  }

  models.TransactionType? _parseTransactionType(String value) {
    // Stored value is the full enum toString(): "TransactionType.purchase".
    for (final e in models.TransactionType.values) {
      if (e.toString() == value) return e;
    }
    return null;
  }
}

/// Row counts from [MoneyLocalDataSource.applyBankScopedConfirmedIdentity].
///
/// Reported so callers, traces and tests can state exactly what a confirmation
/// changed, rather than inferring it.
class BankScopedIdentityWriteResult {
  /// Rows written for the transaction the user explicitly edited.
  final int editedRows;

  /// Sibling rows that received the confirmed Last 4.
  final int siblingLast4Rows;

  /// Sibling rows that additionally received the confirmed `card_id`
  /// (those whose card id was still NULL).
  final int siblingCardRows;

  /// Linked SMS detection records that received the confirmed value.
  final int smsRows;

  const BankScopedIdentityWriteResult({
    this.editedRows = 0,
    this.siblingLast4Rows = 0,
    this.siblingCardRows = 0,
    this.smsRows = 0,
  });

  /// Every transaction row the confirmation touched.
  int get totalTransactions => editedRows + siblingLast4Rows;

  bool get wroteAnything =>
      editedRows > 0 || siblingLast4Rows > 0 || smsRows > 0;
}
