import '../../domain/repositories/money_repository.dart' as domain;
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/item_model.dart' as items;
import '../../domain/entities/item_model.dart' show CashWallet, CashMovement;
import '../../domain/entities/detected_card_model.dart';
import 'detected_card_repository.dart';
import '../../domain/entities/money_model.dart';
import '../../domain/entities/transaction_model.dart';
import '../local/datasources/money_local_datasource.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../remote/datasources/money_remote_datasource.dart';
import '../../domain/services/card_balance_calculator.dart';
import '../../domain/services/card_ownership.dart';
import '../services/sms_card_identity.dart';
import '../services/smart_card_resolution_service.dart';
import '../../core/utils/app_logger.dart';
import 'transaction_repository.dart';
import 'cash_wallet_repository.dart';
import 'expense_repository.dart';

/// Balances carry forward; only spending totals are month-scoped.
class MoneyRepository implements domain.MoneyRepository {
  final MoneyRemoteDataSource remote;
  final MoneyLocalDataSource local;
  final TransactionRepository transactionRepository;
  final CashWalletRepository cashWalletRepository;
  final ExpenseRepository expenseRepository;
  final DetectedCardRepository? detectedCardRepository;
  final SmsMessageLocalDataSource? smsMessageLocalDataSource;
  final Future<void> Function(String transactionId, String cardId)?
      remoteCardIdWriter;
  final _uuid = const Uuid();
  MoneyRepository(
      {required this.remote,
      required this.local,
      required this.transactionRepository,
      required this.cashWalletRepository,
      required this.expenseRepository,
      this.detectedCardRepository,
      this.smsMessageLocalDataSource,
      this.remoteCardIdWriter});

  @override
  Future<List<MonthlyIncome>> getMonthlyIncomes(String userId,
          {int? year, int? month}) =>
      local.getMonthlyIncomes(userId, year: year, month: month);

  @override
  Future<void> addMonthlyIncome(
      {required String userId,
      required int year,
      required int month,
      String? label,
      required int amountMinor}) async {
    if (amountMinor <= 0) throw ArgumentError('Amount must be positive');
    await local.insertMonthlyIncome(MonthlyIncome(
        id: _uuid.v4(),
        userId: userId,
        year: year,
        month: month,
        label: label,
        amountMinor: amountMinor));
  }

  /// A home-screen item spends cash already withdrawn from this card.
  /// Its transaction, cash movement, expense and usage commit together.
  @override
  Future<bool> purchaseItemWithCash({
    required String userId,
    required items.Item item,
    required String cardLast4,
    String? bankName,
    String? purchaseId,
  }) async {
    if (item.userId != userId || !item.isActive || item.isArchived) {
      throw ArgumentError('Item is not available to this user');
    }
    if (item.priceMinor <= 0 || item.currency != 'EGP') {
      throw ArgumentError('A positive EGP price is required');
    }
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null) throw StateError('Select an unambiguous card');
    final expenseLocal = expenseRepository.localDataSource;
    if (expenseLocal == null) {
      throw StateError('Local expense storage is required');
    }
    final id = purchaseId ?? _uuid.v4();
    final date = DateTime.now().toUtc();
    final transaction = Transaction(
      id: id,
      userId: userId,
      type: TransactionType.cash_expense,
      source: TransactionSource.manual,
      amountMinor: item.priceMinor,
      currency: item.currency,
      categoryId: item.categoryId,
      cardId: card.id,
      cardLast4: card.last4,
      transactionDate: date,
      fingerprint: 'item-cash-$id',
      merchantName: item.nameAr ?? item.name,
      notes: item.name,
    );
    final expense = Expense(
        id: _uuid.v4(),
        userId: userId,
        transactionId: id,
        categoryId: item.categoryId,
        amountMinor: item.priceMinor,
        currency: item.currency,
        expenseDate: date,
        paymentMethod: PaymentMethod.cash,
        notes: item.name);
    final line = ExpenseItem(
        id: _uuid.v4(),
        expenseId: expense.id,
        itemId: item.id,
        quantity: 1,
        unitPriceMinor: item.priceMinor,
        totalPriceMinor: item.priceMinor);
    final usage = ItemUsage(
        id: _uuid.v4(),
        userId: userId,
        itemId: item.id,
        expenseId: expense.id,
        quantity: 1,
        totalAmountMinor: item.priceMinor,
        usageDate: date);
    var recorded = false;
    await local.runInTransaction(() async {
      if (await transactionRepository.isDuplicateTransaction(
          userId: userId, fingerprint: transaction.fingerprint)) {
        return;
      }
      final available =
          await getPocketCashForCard(userId, cardLast4, bankName: bankName);
      if (available < item.priceMinor) {
        throw InsufficientPocketCashException(
            requiredMinor: item.priceMinor, availableMinor: available);
      }
      var wallet = await local.getWallet(userId);
      if (wallet == null) {
        wallet =
            CashWallet(id: _uuid.v4(), userId: userId, currency: item.currency);
        await local.insertWallet(wallet);
      }
      await transactionRepository.insertLocally(transaction);
      await expenseLocal.insertExpense(expense);
      await expenseLocal.insertExpenseItem(line);
      await local.insertItemUsage(usage);
      await local.insertCashMovement(CashMovement(
          id: 'cash-$id',
          userId: userId,
          walletId: wallet.id,
          type: 'cash_expense',
          amountMinor: item.priceMinor,
          referenceType: 'transaction',
          referenceId: id,
          description: item.name,
          movementDate: date));
      await local.queueItemCashSync(userId, transaction.id);
      recorded = true;
    });
    if (recorded) {
      unawaited(_mirrorCashItemPurchase(transaction, expense, line, usage));
    }
    return recorded;
  }

  Future<void> _mirrorCashItemPurchase(Transaction transaction, Expense expense,
      ExpenseItem line, ItemUsage usage) async {
    if (!await transactionRepository.mirrorCreatedTransaction(transaction)) {
      return;
    }
    try {
      await expenseRepository.remoteDataSource
          .createExpense(expense)
          .timeout(const Duration(seconds: 15));
      await expenseRepository.remoteDataSource
          .createExpenseItem(line)
          .timeout(const Duration(seconds: 15));
      await expenseRepository
          .recordItemUsages([usage]).timeout(const Duration(seconds: 15));
      await cashWalletRepository
          .ensureExpenseMovement(transaction)
          .timeout(const Duration(seconds: 15));
      await local.markItemCashSynced(transaction.userId, transaction.id);
      logInfo('ITEM_CASH_REMOTE_SYNC_SUCCESS id=${transaction.id}');
    } catch (e) {
      logError('ITEM_CASH_REMOTE_SYNC_FAILED id=${transaction.id}', e);
    }
  }

  /// Repairs a missing remote cash movement without buying the item again.
  /// Only this cash-purchase flow is considered; legacy/manual rows stay owned
  /// by their original workflows. At most one bounded pending page per launch.
  @override
  Future<void> retryItemCashMovements(String userId) async {
    final rows = {for (final t in await _transactions(userId)) t.id: t};
    for (final t in rows.values.where((t) =>
        t.type == TransactionType.cash_expense &&
        t.fingerprint.startsWith('item-cash-'))) {
      await local.queueItemCashSync(userId, t.id);
    }
    for (final id in await local.pendingItemCashSync(userId)) {
      final t = rows[id];
      if (t == null ||
          t.type != TransactionType.cash_expense ||
          t.status != TransactionStatus.confirmed) {
        await local.markItemCashSynced(userId, id);
        continue;
      }
      try {
        await cashWalletRepository
            .ensureExpenseMovement(t)
            .timeout(const Duration(seconds: 15));
        await local.markItemCashSynced(userId, id);
        logInfo('ITEM_CASH_MOVEMENT_SYNC_SUCCESS id=$id');
      } catch (e) {
        logError('ITEM_CASH_MOVEMENT_SYNC_PENDING id=$id', e);
      }
    }
  }

  @override
  Future<void> purchaseItemWithCard(
      {required String userId,
      required items.Item item,
      required String cardLast4,
      String? bankName}) async {
    if (item.priceMinor <= 0) throw ArgumentError('Price must be positive');
    // Resolve the card up front so the purchase is stamped with a stable
    // `card_id` at creation time instead of relying on the SMS pipeline's
    // asynchronous backfill. A purchase made against a specific card must be
    // attributable to exactly that card.
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    final id = _uuid.v4();
    // The purchase is recorded as a transaction whose outgoing delta reduces
    // My Balance (getMyBalanceForCard = currentBalanceMinor + Î£ deltas), for
    // BOTH credit and debit cards.
    //
    // We deliberately do NOT also call `deductCreditBalance` here: that would
    // lower `currentBalanceMinor` AND produce a transaction delta, deducting
    // the amount twice. `currentBalanceMinor` is only ever an OPENING
    // adjustment â€” written once at creation (0) and by
    // `setFixedAmountForCard` when a Fixed Amount change has to clamp the
    // balance down.
    await recordSmsTransaction(
        userId: userId,
        transaction: Transaction(
            id: id,
            userId: userId,
            type: TransactionType.purchase,
            source: TransactionSource.manual,
            amountMinor: item.priceMinor,
            currency: item.currency,
            cardLast4: cardLast4,
            cardId: card?.id,
            transactionDate: DateTime.now(),
            fingerprint: 'item-$id',
            notes: item.name));
  }

  /// A manual top-up is an incoming ledger entry, never a purchase.
  ///
  /// For a CONFIGURED CREDIT CARD this is a repayment path (requirement #3):
  ///  - Repayment is only allowed when credit has actually been used
  ///    (available < credit limit). With full credit available the maximum
  ///    repayment is 0, so any positive amount throws.
  ///  - Maximum repayment = credit_limit - current available balance.
  ///  - Amounts above that throw [CreditLimitExceededException] â€” there is
  ///    NO silent clamping, and the available balance can never exceed the
  ///    credit limit.
  ///  - The repayment is recorded as an incoming ledger entry: it increases
  ///    My Balance and never increases Deducted Money (requirement #8).
  ///
  /// Debit/bank cards keep the existing unrestricted behaviour (requirement
  /// #9): the amount is added to the card's ledger with no credit-limit
  /// checks.
  @override
  Future<void> addBalanceManually({
    required String userId,
    required String cardLast4,
    required int amountMinor,
    String? bankName,
    String currency = 'EGP',
    String? note,
  }) async {
    if (amountMinor <= 0) throw ArgumentError('Amount must be positive');
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card != null && card.isCreditCard) {
      // A credit card with no Fixed Amount has no available balance at all,
      // so there is nothing to repay yet: the customer must configure the
      // Fixed Amount first. This is the server-side half of disabling "+".
      if (card.creditLimitMinor <= 0) {
        throw const CreditLimitExceededException(
          'Configure the Fixed Amount before adding a payment to this card',
        );
      }
      final available =
          await getMyBalanceForCard(userId, cardLast4, bankName: bankName);
      final maxRepayment = card.creditLimitMinor - available;
      if (amountMinor > maxRepayment) {
        throw CreditLimitExceededException(
          'Repayment of ${amountMinor ~/ 100} EGP exceeds the maximum '
          'repayment of ${maxRepayment ~/ 100} EGP '
          '(credit limit ${card.creditLimitMinor ~/ 100} EGP, '
          'available ${available ~/ 100} EGP)',
        );
      }
    }

    final id = _uuid.v4();
    await recordSmsTransaction(
      userId: userId,
      transaction: Transaction(
        id: id,
        userId: userId,
        type: TransactionType.income,
        source: TransactionSource.manual,
        amountMinor: amountMinor,
        currency: currency,
        cardLast4: cardLast4,
        cardId: card?.id,
        transactionDate: DateTime.now(),
        fingerprint: 'manual-$id',
        notes: note,
      ),
    );
  }

  Future<List<Transaction>> _transactions(String userId) =>
      transactionRepository.getTransactions(
          userId: userId, syncWithRemote: false);

  /// Resolves the stored card for a last4 (+ optional bank qualifier).
  ///
  /// Returns null when the card is unknown, or when the identity is AMBIGUOUS
  /// (two stored cards share the last4 and no bank disambiguates them). It
  /// never throws and never guesses a "closest" card: an ambiguous identity is
  /// reported as unresolved so the caller's red-dot flow can handle it instead
  /// of silently routing money to the wrong card.
  Future<DetectedCard?> _findCardByLast4(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final cards =
        await detectedCardRepository?.getCards(userId) ?? <DetectedCard>[];
    // Bank comparison MUST go through the shared normaliser. A raw `==` made
    // 'cib' != 'CIB' and silently returned null, which emptied the card's
    // transaction list, its figures and its eligibility - the user saw a card
    // that existed in the database but showed nothing after an edit.
    final wantBank = normalizeBankIdentity(bankName);
    final matches = cards
        .where((c) =>
            c.last4 == cardLast4 &&
            (wantBank == null || normalizeBankIdentity(c.bankName) == wantBank))
        .toList();
    if (matches.length != 1) return null;
    return matches.single;
  }

  /// Every stored card for a user. The ownership rules need the FULL set: a
  /// last4 is only safe to match when exactly one card carries it.
  Future<List<DetectedCard>> _allCards(String userId) async =>
      await detectedCardRepository?.getCards(userId) ?? <DetectedCard>[];

  /// The full per-card figure set for one card. This is the one place My
  /// Balance / Deducted Money / Pocket Cash are produced, so all three can
  /// never drift apart or be read from different filters.
  @override
  Future<CardBalance> getCardBalance(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    final rows = await _transactions(userId);
    final allCards = await _allCards(userId);
    // Bank-aware ownership: a row whose detected bank disagrees with this card's
    // bank is a different card, even when the four digits agree.
    final bankNames = await _bankNamesByTransaction(userId);
    String? bankOf(Transaction t) => bankNames[t.id];

    if (card == null) {
      // No stored card record for this identity. Money can still be tracked by
      // last4 alone, but only while that last4 is unambiguous. An ambiguous
      // identity yields zeros rather than guessing a card.
      return CardBalance.computeForUnregisteredLast4(
        cardLast4: cardLast4,
        allTransactions: rows,
        allCards: allCards,
        bankOf: bankOf,
      );
    }
    return CardBalance.compute(
      card: card,
      allTransactions: rows,
      allCards: allCards,
      bankOf: bankOf,
    );
  }

  /// Transactions that cannot be attributed to any card. These are the rows
  /// that keep the red-dot indicator until the user supplies a card number.
  ///
  /// Judged on the FULL `bank + last4` identity, using the same rule as the
  /// balances, so the dot can never disagree with the figures.
  @override
  Future<List<Transaction>> getUnassignedTransactions(String userId) async {
    final rows = await _transactions(userId);
    final cards = await _allCards(userId);
    final bankNames = await _bankNamesByTransaction(userId);
    return CardOwnership.unassigned(
      rows,
      cards,
      (t) => bankNames[t.id],
    );
  }

  /// Transactions belonging to exactly one card, used by the card screen.
  @override
  Future<List<Transaction>> getTransactionsForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null) return const [];
    final rows = await _transactions(userId);
    final allCards = await _allCards(userId);
    return CardOwnership.forCard(rows, card, allCards);
  }

  /// Detected bank name per transaction id, from the SMS detection record.
  ///
  /// `transactions` stores a bank UUID while `detected_cards` stores a bank NAME,
  /// so the existing detection record is the bridge. Returns an empty map when
  /// no local detection store is wired, which the resolver treats as "unknown
  /// bank" — the safe direction.
  Future<Map<String, String>> _bankNamesByTransaction(String userId) async {
    final store = smsMessageLocalDataSource;
    if (store == null) return const <String, String>{};
    try {
      return await store.bankNamesByTransactionId(userId);
    } catch (e) {
      logError('BANK_NAME_LOOKUP_FAILED', e);
      return const <String, String>{};
    }
  }

  /// The SMART card identity resolver, wired to this repository's stores.
  ///
  /// One instance per repository so every caller (manual Last 4 entry, the
  /// transactions screen, the legacy backfill) shares exactly the same rules.
  SmartCardResolutionService get smartCardResolver =>
      SmartCardResolutionService(
        filterSmsSiblings: _filterSmsSiblings,
        cards: _allCards,
        transactions: _transactions,
        bankNames: _bankNamesByTransaction,
        assignAtomically: local.updateTransactionCardIdsAtomically,
        // THE local write for a user-confirmed identity. It persists
        // `card_last4` AND `card_id` for the edited row, fills every
        // same-user/same-bank sibling that is MISSING its `card_last4`, and
        // fills the linked `sms_messages` detection records — all in one Drift
        // transaction so the rows and their source messages cannot disagree.
        applyBankScopedIdentity: ({
          required String transactionId,
          required String cardId,
          required String last4,
          required List<String> siblingTransactionIds,
        }) =>
            local.applyBankScopedConfirmedIdentity(
          transactionId: transactionId,
          cardId: cardId,
          last4: last4,
          siblingTransactionIds: siblingTransactionIds,
        ),
        // The bank-scoped sibling query. `bankNames` are the concrete spellings
        // the caller recovered through `normalizeBankIdentity`.
        distinctDetectedBankNames: (userId) =>
            local.distinctDetectedBankNames(userId),
        findNullLast4IdsForBankNames: (userId, bankNames, type) =>
            local.findNullLast4IdsForDetectedBankNames(
          userId: userId,
          bankNames: bankNames,
          type: type,
        ),
        // Rows in the same bank and the same transaction TYPE that already carry
        // the confirmed Last 4 and only lack the card link. Kept separate from
        // the NULL-Last 4 population because `card_last4` and `card_id` are
        // independent fields.
        findMissingCardIdIdsForIdentity: ({
          required String userId,
          required List<String> bankNames,
          required String last4,
          required String type,
        }) =>
            local.findMissingCardIdIdsForIdentity(
          userId: userId,
          bankNames: bankNames,
          last4: last4,
          type: type,
        ),
        // Learning delegates to the SAME detected-card repository the card UI
        // uses, so there is exactly one card-identity store and no duplicates.
        learnCardIdentity: (userId, last4, bankName) async {
          final repo = detectedCardRepository;
          if (repo == null) {
            throw StateError('Detected card repository is not configured');
          }
          return repo.upsertCard(
            userId: userId,
            last4: last4,
            bankName: bankName,
          );
        },
        assignRemote: remoteCardIdWriter,
      );

  Future<List<String>> _filterSmsSiblings(
      String userId, String transactionId, List<String> candidates) async {
    final store = smsMessageLocalDataSource;
    if (store == null) return candidates;
    final messages = {
      for (final s in await store.linkedMessages(userId)) s.transactionId: s
    };
    final source = messages[transactionId];
    // Legacy records without SMS bodies retain the existing bank/type rule.
    if (source?.messageBody == null) return candidates;
    final rows = {for (final t in await _transactions(userId)) t.id: t};
    String? key(SMSMessage? sms) => sms?.messageBody == null
        ? null
        : smsCardIdentityKey(
            sender: sms!.sender,
            body: sms.messageBody!,
            bankName: sms.detectedBankName,
            type: rows[sms.transactionId]?.type);
    final sourceKey = key(source);
    if (sourceKey == null) return [];
    return candidates
        .where((id) =>
            key(messages[id]) == sourceKey &&
            (rows[id]?.cardId == null ||
                rows[id]?.cardId == rows[transactionId]?.cardId))
        .toList();
  }

  /// LEARNS a persistent `Bank + Last 4 -> Card` identity from the user's
  /// explicit confirmation on a transaction, then resolves the edited row and
  /// every transaction that provably shares that exact identity.
  ///
  /// The bank is read from the transaction itself; the caller only supplies the
  /// Last 4 the user typed. See
  /// [SmartCardResolutionService.learnCardIdentityFromUserConfirmation].
  @override
  Future<SmartResolutionResult> learnCardIdentity({
    required String userId,
    required String transactionId,
    required String? last4,
    String? bankIdentityOverride,
  }) async {
    if (bankIdentityOverride != null &&
        bankIdentityOverride.trim().isNotEmpty) {
      await smsMessageLocalDataSource?.setDetectedBank(
          userId, transactionId, bankIdentityOverride.trim());
    }
    return smartCardResolver.learnCardIdentityFromUserConfirmation(
      userId: userId,
      transactionId: transactionId,
      last4: last4,
      bankIdentityOverride: bankIdentityOverride,
    );
  }

  /// The learned card identity for `user + bank + last4`, or null.
  ///
  /// The read path used by SMS ingestion so a future message is routed at
  /// creation time instead of waiting for the user to fix it manually.
  @override
  Future<DetectedCard?> findLearnedCardIdentity({
    required String userId,
    required String last4,
    String? bankName,
  }) async {
    final repo = detectedCardRepository;
    if (repo == null) return null;
    final normalized = normalizeCardLast4(last4);
    if (normalized == null) return null;
    return repo.findCardIdentity(
      userId: userId,
      last4: normalized,
      bankName: bankName,
    );
  }

  /// Reuses committed SMS-to-card links, surviving restarts. Conflicting
  /// confirmations are ambiguous and never choose an arbitrary card.
  @override
  Future<DetectedCard?> findLearnedSmsCard(
      {required String userId,
      required String? sender,
      required String body,
      required String? bankName,
      required TransactionType? type}) async {
    final store = smsMessageLocalDataSource;
    if (store == null || detectedCardRepository == null) return null;
    final key = smsCardIdentityKey(
        sender: sender, body: body, bankName: bankName, type: type);
    if (key == null) return null;
    final rows = {for (final t in await _transactions(userId)) t.id: t};
    final ids = <String>{};
    for (final sms in await store.linkedMessages(userId)) {
      final t = rows[sms.transactionId];
      if (t?.cardId == null || sms.messageBody == null) continue;
      if (smsCardIdentityKey(
              sender: sms.sender,
              body: sms.messageBody!,
              bankName: sms.detectedBankName,
              type: t!.type) ==
          key) {
        ids.add(t.cardId!);
      }
    }
    if (ids.length != 1) return null;
    final candidates = (await detectedCardRepository!.getCards(userId)).where(
        (c) =>
            ids.contains(c.id) &&
            normalizeBankIdentity(c.bankName) ==
                normalizeBankIdentity(bankName));
    return candidates.length == 1 ? candidates.single : null;
  }

  /// Resolves the card identity for a user-supplied Last 4 WITHOUT writing.
  @override
  Future<CardOwnershipResolution> previewCardIdentity({
    required String userId,
    String? last4,
    String? bankIdentity,
  }) =>
      smartCardResolver.preview(
          userId: userId, last4: last4, bankIdentity: bankIdentity);

  /// Applies a user-confirmed Card Last 4 to [transactionId], propagating to
  /// other unresolved transactions ONLY when their identity is provably the
  /// same. See [SmartCardResolutionService] for the full safety contract.
  @override
  Future<SmartResolutionResult> resolveCardIdentityForUserInput({
    required String userId,
    required String transactionId,
    String? last4,
    String? bankIdentity,
  }) =>
      smartCardResolver.resolveForUserInput(
        userId: userId,
        transactionId: transactionId,
        last4: last4,
        bankIdentity: bankIdentity,
      );

  /// Re-runs deterministic resolution across every unresolved transaction.
  /// Idempotent: a second call is a no-op.
  @override
  Future<int> backfillCardIdentities(String userId) =>
      smartCardResolver.backfill(userId: userId);

  /// Returns the fixed amount (credit limit) for a card.
  /// For credit cards this is creditLimitMinor. For debit cards this is 0
  /// (no fixed limit â€” balance is derived from transactions).
  @override
  Future<int> getFixedAmountForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null) return 0;
    return card.isCreditCard ? card.creditLimitMinor : 0;
  }

  /// Maximum amount the customer may still add through the "+" button.
  ///
  ///   credit card WITH a Fixed Amount    -> Fixed Amount - My Balance
  ///                                          (clamped at 0, never negative)
  ///   credit card WITHOUT a Fixed Amount -> 0 ("+" stays unavailable until the
  ///                                          customer configures one)
  ///   debit card                         -> null (unlimited, no Fixed Amount)
  ///
  /// This is the SINGLE source of truth for the "+" button. The UI reads it
  /// instead of recomputing the rule, and [addBalanceManually] enforces the
  /// very same ceiling, so the invariant `My Balance <= Fixed Amount` cannot be
  /// bypassed from any screen.
  @override
  Future<int?> getMaxAddableForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null || !card.isCreditCard) return null;
    if (card.creditLimitMinor <= 0) return 0;
    final balance =
        await getMyBalanceForCard(userId, cardLast4, bankName: bankName);
    final remaining = card.creditLimitMinor - balance;
    return remaining < 0 ? 0 : remaining;
  }

  /// True when this card may be topped up through "+". A credit card with no
  /// Fixed Amount reports false so the UI can disable the button outright.
  @override
  Future<bool> canAddBalanceForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null) return false;
    if (!card.isCreditCard) return true;
    if (card.creditLimitMinor <= 0) return false;
    final balance =
        await getMyBalanceForCard(userId, cardLast4, bankName: bankName);
    return balance < card.creditLimitMinor;
  }

  /// Changes a credit card's Fixed Amount.
  ///
  /// My Balance is NOT cached here and no opening-adjustment delta is written.
  /// The Fixed Amount is simply the new baseline that `CardBalance.compute`
  /// combines with this card's own purchases/payments, so the balance reflects
  /// the change on the very next read:
  ///
  ///   20,000 -> 25,000 : balance = 25,000 minus whatever is still spent
  ///   25,000 -> 18,000 : balance = 18,000 minus whatever is still spent
  ///                     (never the stale 25,000-derived figure)
  ///
  /// The previous implementation wrote `currentBalanceMinor` as a one-off delta
  /// to force the balance onto the new limit. That cached value then had to be
  /// carried forever and drifted out of sync with the ledger - which is exactly
  /// why changing the Fixed Amount did not update My Balance. Deriving instead
  /// of caching removes that whole class of stale-data bug.
  @override
  Future<void> setFixedAmountForCard({
    required String userId,
    required String cardLast4,
    required int fixedAmountMinor,
    String? bankName,
    bool? cashWithdrawalEnabled,
  }) async {
    if (fixedAmountMinor <= 0) {
      throw ArgumentError('Fixed amount must be positive');
    }
    final repo = detectedCardRepository;
    if (repo == null) {
      throw StateError('Detected card repository is not configured');
    }
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null) {
      throw StateError('Unknown card $bankName + $cardLast4');
    }

    await repo.setCreditCardConfig(
      userId: userId,
      cardId: card.id,
      isCreditCard: true,
      creditLimitMinor: fixedAmountMinor,
      // No opening adjustment: My Balance is derived from the Fixed Amount
      // plus this card's own ledger, so a limit change is reflected at once.
      currentBalanceMinor: 0,
      cashWithdrawalEnabled:
          cashWithdrawalEnabled ?? card.cashWithdrawalEnabled,
      updatedAt: DateTime.now(),
    );
  }

  int _balanceDelta(Transaction t) => CardBalance.balanceDelta(t);

  @override
  Future<int> getMyBalanceForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async =>
      (await getCardBalance(userId, cardLast4, bankName: bankName))
          .myBalanceMinor;

  /// Deducted Money for one card: purchases + outgoing transfers + cash
  /// expenses, computed from that card's OWN rows. ATM withdrawals are
  /// excluded â€” they are Pocket Cash, not Deducted Money.
  @override
  Future<int> getDeductedMoneyForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async =>
      (await getCardBalance(userId, cardLast4, bankName: bankName))
          .deductedMinor;

  /// Whether the Pocket Cash section may be shown for a card.
  ///
  /// This is the SINGLE source of truth for Pocket Cash eligibility and for
  /// hiding the whole Pocket Cash container in the Dashboard:
  ///   * debit card       â†’ always visible (existing behaviour unchanged);
  ///   * credit card      â†’ visible only when this card's own
  ///                         "Use Card for Cash Withdrawal" setting is ON;
  ///   * unknown card     â†’ visible (previous behaviour, never hides data).
  ///
  /// Keyed strictly by [cardLast4], never by the currently selected card.
  /// Historical transaction rows are preserved regardless of the setting.
  @override
  Future<bool> isPocketCashVisibleForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null || !card.isCreditCard) return true;
    return card.cashWithdrawalEnabled;
  }

  @override
  Future<int> getPocketCashForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    // Pocket-Cash eligibility is per card ("Use Card for Cash Withdrawal"):
    // a credit card participates only when its own cash-withdrawal setting is
    // enabled. Debit cards always participate, and unknown cards behave as
    // before. The historical transaction rows are never deleted or rewritten.
    if (!await isPocketCashVisibleForCard(userId, cardLast4,
        bankName: bankName)) {
      return 0;
    }
    return (await getCardBalance(userId, cardLast4, bankName: bankName))
        .pocketCashMinor;
  }

  @override
  Future<List<UserBankAccount>> getBankAccounts(String userId) =>
      local.getBankAccounts(userId);
  @override
  Future<int> getMonthlyIncomeSum(String userId, int year, int month) =>
      local.getMonthlyIncomeSum(userId, year, month);

  @override
  Future<MoneySummary> getMoneySummary(String userId) async {
    final now = DateTime.now();
    final rows = await _transactions(userId);
    final movements = await local.getBankMovements(userId);
    final represented = movements
        .where((m) => m.referenceType == 'transaction')
        .map((m) => m.referenceId)
        .toSet();
    var balance = 0;
    for (final account in await getBankAccounts(userId)) {
      if (account.isActive) {
        balance += await local.getBankAccountBalance(account.id);
      }
    }
    for (final t in rows) {
      if (!represented.contains(t.id)) balance += _balanceDelta(t);
    }
    return MoneySummary(
        myBalanceMinor: balance,
        deductedMinor:
            await local.getDeductedForMonth(userId, now.year, now.month),
        pocketCashMinor: await local.getCashBalance(userId),
        monthlyIncomeMinor:
            await getMonthlyIncomeSum(userId, now.year, now.month));
  }

  @override
  Future<bool> recordSmsTransaction(
      {required String userId,
      required Transaction transaction,
      String? accountId}) async {
    if (transaction.userId != userId) throw ArgumentError('User mismatch');
    if (await transactionRepository.isDuplicateTransaction(
        userId: userId, fingerprint: transaction.fingerprint)) {
      return false;
    }
    await transactionRepository.createTransaction(transaction: transaction);
    if (transaction.status != TransactionStatus.confirmed) return true;
    final delta = _balanceDelta(transaction);
    if (accountId != null && delta != 0) {
      await local.insertBankMovement(BankAccountMovement(
          id: 'bank-${transaction.id}',
          accountId: accountId,
          userId: userId,
          type: delta > 0 ? 'in' : 'out',
          amountMinor: delta.abs(),
          referenceType: 'transaction',
          referenceId: transaction.id,
          movementDate: transaction.transactionDate));
    }
    if (transaction.type == TransactionType.atm_withdrawal ||
        transaction.type == TransactionType.cash_expense) {
      var wallet = await local.getWallet(userId);
      if (wallet == null) {
        wallet = CashWallet(
            id: _uuid.v4(), userId: userId, currency: transaction.currency);
        await local.insertWallet(wallet);
      }
      await local.insertCashMovement(CashMovement(
          id: 'cash-${transaction.id}',
          userId: userId,
          walletId: wallet.id,
          type: transaction.type.name,
          amountMinor: transaction.amountMinor,
          referenceType: 'transaction',
          referenceId: transaction.id,
          movementDate: transaction.transactionDate));
    }
    return true;
  }
}
