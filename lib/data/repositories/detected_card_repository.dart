import 'package:uuid/uuid.dart';
import '../../core/utils/app_logger.dart';
import '../models/detected_card_model.dart';
import '../services/card_ownership.dart';
import '../local/datasources/detected_card_local_datasource.dart';
import '../remote/datasources/detected_card_remote_datasource.dart';

/// Repository for detected bank cards. Persists across restarts and keeps
/// a transaction count per card. Uniqueness is guaranteed by last4 + bank.
class DetectedCardRepository {
  final DetectedCardLocalDataSource local;
  final DetectedCardRemoteDataSource? remote;
  final _uuid = const Uuid();

  DetectedCardRepository({required this.local, this.remote});

  /// Returns all detected cards for [userId], sorted by last4.
  Future<List<DetectedCard>> getCards(String userId) async {
    final cards = await local.getCards(userId);
    cards.sort((a, b) => a.last4.compareTo(b.last4));
    return cards;
  }

  /// Create-or-update the card identity for `userId + last4 + bankName`.
  ///
  /// This is THE persistence point for a card identity, and it is keyed on the
  /// triple (user, bank, last4) — never on the last4 alone, so two banks may
  /// legitimately hold cards that end in the same four digits.
  ///
  /// Bank comparison goes through [normalizeBankIdentity], so "CIB", "cib" and
  /// "CIB Bank" all resolve to the SAME card identity rather than silently
  /// creating duplicates. The first-stored display name is preserved so the UI
  /// keeps showing what the user recognised.
  Future<DetectedCard> upsertCard({
    required String userId,
    required String last4,
    String? bankName,
    int? transactionCountDelta,
    CardAppearance? appearance,
  }) async {
    final cards = await local.getCards(userId);
    final bank = normalizeBankIdentity(bankName);
    final existingIdx = cards.indexWhere(
      (c) =>
          c.last4 == last4 && normalizeBankIdentity(c.bankName) == bank,
    );

    if (existingIdx >= 0) {
      final existing = cards[existingIdx];
      final updated = existing.copyWith(
        bankName: bankName ?? existing.bankName,
        transactionCount:
            (existing.transactionCount + (transactionCountDelta ?? 0))
                .clamp(0, 1 << 30),
        appearance: appearance ?? existing.appearance,
      );
      cards[existingIdx] = updated;
      await local.saveCards(userId, cards);
      if (remote != null) {
        try {
          await remote!.upsertCard(updated);
        } catch (_) {
          // Local card persistence remains authoritative when offline.
        }
      }
      return updated;
    }

    final created = DetectedCard(
      id: _uuid.v4(),
      userId: userId,
      last4: last4,
      bankName: bankName,
      transactionCount: (transactionCountDelta ?? 0),
      appearance: appearance ??
          CardAppearance(
              presetIndex: cards.length % CardPresets.presets.length),
    );
    cards.add(created);
    await local.saveCards(userId, cards);
    if (remote != null) {
      try {
        await remote!.upsertCard(created);
      } catch (_) {
        // Local card persistence remains authoritative when offline.
      }
    }
    return created;
  }

  /// The single card identity for `userId + last4 + bankName`, or null.
  ///
  /// The lookup counterpart of [upsertCard] and the read path every consumer
  /// uses to ask "does this user already know this Bank + Last 4 card?". It
  /// never creates anything.
  Future<DetectedCard?> findCardIdentity({
    required String userId,
    required String last4,
    String? bankName,
  }) async {
    final bank = normalizeBankIdentity(bankName);
    for (final card in await local.getCards(userId)) {
      if (card.last4 == last4 && normalizeBankIdentity(card.bankName) == bank) {
        return card;
      }
    }
    return null;
  }

  /// Persist an independently-customized appearance for one card.
  Future<void> updateAppearance(
      String userId, String cardId, CardAppearance appearance) async {
    final cards = await local.getCards(userId);
    final idx = cards.indexWhere((c) => c.id == cardId);
    if (idx < 0) return;
    cards[idx] = cards[idx].copyWith(appearance: appearance);
    await local.saveCards(userId, cards);
  }

  Future<void> updateDetectedCard(DetectedCard card) async {
    await remote?.upsertCard(card);
  }

  Future<void> recomputeTransactionCountsForCards(
    String userId,
    int Function(DetectedCard card) countFor,
  ) async {
    final cards = await local.getCards(userId);
    for (var i = 0; i < cards.length; i++) {
      cards[i] = cards[i].copyWith(transactionCount: countFor(cards[i]));
    }
    // LOCAL FIRST. The badge must be committed locally before any network I/O,
    // and the remote mirror is strictly best-effort: a failed upsert must never
    // abort the caller (that used to make the Transactions screen skip its
    // provider refresh, leaving a correct database with a stale UI).
    await local.saveCards(userId, cards);
    final mirror = remote;
    if (mirror == null) return;
    for (final card in cards) {
      try {
        await mirror.upsertCard(card);
      } catch (e) {
        logInfo('[CARD] count mirror skipped card=${card.id}: $e');
      }
    }
  }

  /// Recompute transaction counts for all cards from stored transactions.
  Future<void> recomputeTransactionCounts(
    String userId, int Function(String cardLast4) countFor) async {
    await recomputeTransactionCountsForCards(
      userId,
      (card) => countFor(card.last4),
    );
  }

  Future<void> deleteCard(String userId, String cardId) async {
    final cards = await local.getCards(userId);
    cards.removeWhere((c) => c.id == cardId);
    await local.saveCards(userId, cards);
  }

  /// Returns the card's eye (balance visibility) state.
  Future<bool> getCardEyeVisible(String userId, String cardId) async {
    final cards = await local.getCards(userId);
    final card = cards.firstWhere((c) => c.id == cardId);
    return card.appearance.eyeVisible;
  }

  /// Toggles the card's eye visibility and returns the new state.
  Future<bool> toggleCardEye(String userId, String cardId) async {
    final cards = await local.getCards(userId);
    final idx = cards.indexWhere((c) => c.id == cardId);
    if (idx < 0) return false;

    final current = cards[idx].appearance.eyeVisible;
    final newVisible = !current;
    cards[idx] = cards[idx].copyWith(
      appearance: cards[idx].appearance.copyWith(eyeVisible: newVisible),
    );
    await local.saveCards(userId, cards);
    return newVisible;
  }

  /// Sets the card's eye visibility directly.
  Future<void> setCardEyeVisible(
      String userId, String cardId, bool visible) async {
    final cards = await local.getCards(userId);
    final idx = cards.indexWhere((c) => c.id == cardId);
    if (idx < 0) return;

    cards[idx] = cards[idx].copyWith(
      appearance: cards[idx].appearance.copyWith(eyeVisible: visible),
    );
    await local.saveCards(userId, cards);
  }

  Future<DetectedCard?> getCardById(String userId, String cardId) async {
    final cards = await local.getCards(userId);
    for (final card in cards) {
      if (card.id == cardId) return card;
    }
    return null;
  }

  Future<void> setCardEye(String userId, String cardId, bool visible) =>
      setCardEyeVisible(userId, cardId, visible);

  /// Targeted update for the "Use Card for Cash Withdrawal" setting.
  ///
  /// Changes ONLY [enabled] (+ updatedAt). The Fixed Amount, the opening
  /// balance, appearance, eye state and every other financial field are
  /// untouched — the cash-withdrawal flag is an ELIGIBILITY switch, never a
  /// financial operation (requirement #12: an unrelated card-setting update
  /// must never overwrite the card's current financial state).
  Future<void> setCashWithdrawalEnabled(
      String userId, String cardId, bool enabled) async {
    final cards = await local.getCards(userId);
    final idx = cards.indexWhere((c) => c.id == cardId);
    if (idx < 0) return;
    cards[idx] = cards[idx].copyWith(
      cashWithdrawalEnabled: enabled,
      updatedAt: DateTime.now(),
    );
    await local.saveCards(userId, cards);
  }

  /// Sets credit card configuration for a card.
  /// When [isCreditCard] is set to false, resets limit-related fields.
  ///
  /// [currentBalanceMinor] is the card's OPENING adjustment: My Balance is
  /// computed as `currentBalanceMinor + Σ transaction deltas`.
  ///   * Creating a credit card always passes 0, so a brand-new card's
  ///     My Balance is exactly 0 until the customer adds money with "+".
  ///   * Lowering the Fixed Amount below the current My Balance is absorbed
  ///     by writing a NEGATIVE adjustment (see
  ///     `MoneyRepository.setFixedAmountForCard`), which keeps the invariant
  ///     `My Balance <= Fixed Amount` true.
  ///
  /// The opening adjustment is never allowed to exceed the Fixed Amount.
  Future<void> setCreditCardConfig({
    required String userId,
    required String cardId,
    required bool isCreditCard,
    int creditLimitMinor = 0,
    int currentBalanceMinor = 0,
    bool cashWithdrawalEnabled = false,
    DateTime? updatedAt,
  }) async {
    final cards = await local.getCards(userId);
    final idx = cards.indexWhere((c) => c.id == cardId);
    if (idx < 0) return;

    if (!isCreditCard) {
      cards[idx] = cards[idx].copyWith(
        isCreditCard: false,
        creditLimitMinor: 0,
        currentBalanceMinor: 0,
        cashWithdrawalEnabled: false,
        updatedAt: updatedAt ?? DateTime.now(),
      );
    } else {
      // Upper bound only: a negative opening adjustment is legitimate.
      final opening = currentBalanceMinor > creditLimitMinor
          ? creditLimitMinor
          : currentBalanceMinor;
      cards[idx] = cards[idx].copyWith(
        isCreditCard: true,
        creditLimitMinor: creditLimitMinor,
        currentBalanceMinor: opening,
        cashWithdrawalEnabled: cashWithdrawalEnabled,
        updatedAt: updatedAt ?? DateTime.now(),
      );
    }
    await local.saveCards(userId, cards);
  }

  /// Returns the credit card configuration for a card, or null if not a
  /// credit card (requirement #13).
  Future<CreditCardConfig?> getCreditCardConfig(
      String userId, String cardId) async {
    final card = await getCardById(userId, cardId);
    if (card == null || !card.isCreditCard) return null;
    return CreditCardConfig(
      cardId: cardId,
      isCreditCard: card.isCreditCard,
      creditLimitMinor: card.creditLimitMinor,
      currentBalanceMinor: card.currentBalanceMinor,
      cashWithdrawalEnabled: card.cashWithdrawalEnabled,
      updatedAt: card.updatedAt,
    );
  }

  /// Attempts to add (repay) balance to a credit card.
  /// Returns the new balance, or throws if it would exceed the limit
  /// (requirement #18, #21).
  Future<int> addCreditBalance({
    required String userId,
    required String cardId,
    required int amountMinor,
  }) async {
    final config = await getCreditCardConfig(userId, cardId);
    if (config == null) {
      throw const CardOperationException(
        'Card is not configured as a credit card',
      );
    }
    final newBalance = config.currentBalanceMinor + amountMinor;
    if (newBalance > config.creditLimitMinor) {
      throw CreditLimitExceededException(
        'Adding ${amountMinor ~/ 100} EGP would exceed credit limit of '
        '${config.creditLimitMinor ~/ 100} EGP',
      );
    }
    await setCreditCardConfig(
      userId: userId,
      cardId: cardId,
      isCreditCard: true,
      creditLimitMinor: config.creditLimitMinor,
      currentBalanceMinor: newBalance,
      cashWithdrawalEnabled: config.cashWithdrawalEnabled,
      updatedAt: DateTime.now(),
    );
    return newBalance;
  }

  /// Attempts to deduct balance from a credit card (e.g. for a purchase).
  /// Returns the new balance, or throws if insufficient funds.
  Future<int> deductCreditBalance({
    required String userId,
    required String cardId,
    required int amountMinor,
  }) async {
    final config = await getCreditCardConfig(userId, cardId);
    if (config == null) {
      throw const CardOperationException(
        'Card is not configured as a credit card',
      );
    }
    final newBalance = config.currentBalanceMinor - amountMinor;
    if (newBalance < 0) {
      throw InsufficientCreditException(
        'Transaction amount ${amountMinor ~/ 100} EGP exceeds available '
        'credit balance of ${config.currentBalanceMinor ~/ 100} EGP',
      );
    }
    await setCreditCardConfig(
      userId: userId,
      cardId: cardId,
      isCreditCard: true,
      creditLimitMinor: config.creditLimitMinor,
      currentBalanceMinor: newBalance,
      cashWithdrawalEnabled: config.cashWithdrawalEnabled,
      updatedAt: DateTime.now(),
    );
    return newBalance;
  }
}
