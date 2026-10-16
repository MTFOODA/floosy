import 'package:uuid/uuid.dart';
import '../models/item_model.dart' as items;
import '../models/item_model.dart' show CashWallet, CashMovement;
import '../models/detected_card_model.dart';
import 'detected_card_repository.dart';
import '../models/money_model.dart';
import '../models/transaction_model.dart';
import '../local/datasources/money_local_datasource.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../remote/datasources/money_remote_datasource.dart';
import '../services/card_balance_calculator.dart';
import '../services/card_ownership.dart';
import '../services/smart_card_resolution_service.dart';
import '../../core/utils/app_logger.dart';
import 'transaction_repository.dart';
import 'cash_wallet_repository.dart';
import 'expense_repository.dart';

/// Balances carry forward; only spending totals are month-scoped.
class MoneyRepository {
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

  Future<List<MonthlyIncome>> getMonthlyIncomes(String userId,
          {int? year, int? month}) =>
      local.getMonthlyIncomes(userId, year: year, month: month);

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
    final card =
        await _findCardByLast4(userId, cardLast4, bankName: bankName);
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
            (wantBank == null ||
                normalizeBankIdentity(c.bankName) == wantBank))
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
  SmartCardResolutionService get smartCardResolver => SmartCardResolutionService(
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

  /// LEARNS a persistent `Bank + Last 4 -> Card` identity from the user's
  /// explicit confirmation on a transaction, then resolves the edited row and
  /// every transaction that provably shares that exact identity.
  ///
  /// The bank is read from the transaction itself; the caller only supplies the
  /// Last 4 the user typed. See
  /// [SmartCardResolutionService.learnCardIdentityFromUserConfirmation].
  Future<SmartResolutionResult> learnCardIdentity({
    required String userId,
    required String transactionId,
    required String? last4,
    String? bankIdentityOverride,
  }) =>
      smartCardResolver.learnCardIdentityFromUserConfirmation(
        userId: userId,
        transactionId: transactionId,
        last4: last4,
        bankIdentityOverride: bankIdentityOverride,
      );

  /// The learned card identity for `user + bank + last4`, or null.
  ///
  /// The read path used by SMS ingestion so a future message is routed at
  /// creation time instead of waiting for the user to fix it manually.
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

  /// Resolves the card identity for a user-supplied Last 4 WITHOUT writing.
  Future<CardOwnershipResolution> previewCardIdentity({
    required String userId,
    String? last4,
    String? bankIdentity,
  }) =>
      smartCardResolver
          .preview(userId: userId, last4: last4, bankIdentity: bankIdentity);

  /// Applies a user-confirmed Card Last 4 to [transactionId], propagating to
  /// other unresolved transactions ONLY when their identity is provably the
  /// same. See [SmartCardResolutionService] for the full safety contract.
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
  Future<int> backfillCardIdentities(String userId) =>
      smartCardResolver.backfill(userId: userId);

  /// Returns the fixed amount (credit limit) for a card.
  /// For credit cards this is creditLimitMinor. For debit cards this is 0
  /// (no fixed limit â€” balance is derived from transactions).
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
  Future<bool> isPocketCashVisibleForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  }) async {
    final card = await _findCardByLast4(userId, cardLast4, bankName: bankName);
    if (card == null || !card.isCreditCard) return true;
    return card.cashWithdrawalEnabled;
  }

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

  Future<List<UserBankAccount>> getBankAccounts(String userId) =>
      local.getBankAccounts(userId);
  Future<int> getMonthlyIncomeSum(String userId, int year, int month) =>
      local.getMonthlyIncomeSum(userId, year, month);

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
