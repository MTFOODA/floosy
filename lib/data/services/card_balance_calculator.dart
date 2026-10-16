import '../models/detected_card_model.dart';
import '../models/transaction_model.dart';
import 'card_ownership.dart';

/// The three per-card money figures of the Floosy product model, plus the
/// inputs needed to enforce the credit-card Fixed Amount ceiling.
///
/// Everything here is a PURE function of (card, that card's own transactions).
/// There is no global pool that is later split visually: card A's numbers are
/// computed from card A's rows only, so switching the selected card can never
/// change another card's figures, and a card with no rows reads as zero.
class CardBalance {
  final int myBalanceMinor;
  final int deductedMinor;
  final int pocketCashMinor;

  /// Configured Fixed Amount (credit limit) in minor units, or 0 for a debit
  /// card / a credit card that has not been given one yet.
  final int fixedAmountMinor;

  /// True only for a credit card that actually has a Fixed Amount. Drives the
  /// "+" button: a credit card without one must not offer repayment.
  final bool hasFixedAmount;

  const CardBalance({
    required this.myBalanceMinor,
    required this.deductedMinor,
    required this.pocketCashMinor,
    this.fixedAmountMinor = 0,
    this.hasFixedAmount = false,
  });

  static const CardBalance zero = CardBalance(
    myBalanceMinor: 0,
    deductedMinor: 0,
    pocketCashMinor: 0,
  );

  /// Headroom the "+" button may still hand out, or null when the card has no
  /// Fixed Amount concept at all (debit card → unlimited).
  int? get maxAddableMinor {
    if (!hasFixedAmount) return null;
    final headroom = fixedAmountMinor - myBalanceMinor;
    return headroom < 0 ? 0 : headroom;
  }

  /// Sign of a transaction's effect on "My Balance".
  ///
  ///   incoming (income / transfer_in / refund)  → +
  ///   outgoing (purchase / transfer_out / ATM)  → −
  ///   cash_expense                               → 0 (spends Pocket Cash, which
  ///   already left the account at the ATM — counting it twice would bill the
  ///   card for cash it never paid out)
  static int balanceDelta(Transaction t) {
    if (t.status != TransactionStatus.confirmed) return 0;
    if (t.type.isIncoming) return t.amountMinor;
    if (t.type.isOutgoing && t.type != TransactionType.cash_expense) {
      return -t.amountMinor;
    }
    return 0;
  }

  /// Computes the figures for a last4 that has NO stored card record.
  ///
  /// The user can have money on a card Floosy has not (yet) registered as a
  /// detected card. Ownership is then decided purely by that last4, which is
  /// only safe while it identifies at most one card — the same ambiguity rule
  /// as everywhere else. If the last4 is genuinely ambiguous this returns
  /// [CardBalance.zero] rather than splitting the money between the candidates.
  static CardBalance computeForUnregisteredLast4({
    required String cardLast4,
    required List<Transaction> allTransactions,
    required List<DetectedCard> allCards,
    String? Function(Transaction t)? bankOf,
  }) {
    if (!CardOwnership.last4IsUnambiguous(cardLast4, allCards)) {
      return CardBalance.zero;
    }
    final owned = allTransactions
        .where((t) {
          if (t.cardLast4 != cardLast4) return false;
          // A known bank that no known card carries means this row is not
          // provably ours, so it stays out of the figures.
          final bank = normalizeBankIdentity(bankOf?.call(t));
          if (bank == null) return true;
          for (final card in allCards) {
            if (card.last4 == cardLast4 &&
                normalizeBankIdentity(card.bankName) == bank) {
              return true;
            }
          }
          return false;
        })
        .where((t) => t.status == TransactionStatus.confirmed)
        .toList(growable: false);

    return CardBalance(
      myBalanceMinor: owned.fold<int>(0, (sum, t) => sum + balanceDelta(t)),
      deductedMinor: owned
          .where((t) => t.type.countsTowardsDeducted)
          .fold<int>(0, (sum, t) => sum + t.amountMinor),
      pocketCashMinor: owned.fold<int>(
        0,
        (sum, t) => sum +
            (t.type == TransactionType.atm_withdrawal
                ? t.amountMinor
                : t.type == TransactionType.cash_expense
                    ? -t.amountMinor
                    : 0),
      ),
    );
  }

  /// Computes every figure for [card] from [allTransactions] (the user's full
  /// list) by first isolating the rows that belong to [card].
  ///
  /// CREDIT CARD:
  ///  * no Fixed Amount yet → My Balance is 0. No stale limit, no previous
  ///    value, no debit-style ledger sum is used for a credit card.
  ///  * Fixed Amount = 20,000, no purchases → 20,000. Purchases consume it
  ///    (3,000 → 17,000), payments restore it, and the result is clamped so
  ///    My Balance can never exceed the Fixed Amount.
  ///
  /// DEBIT CARD: My Balance is the card's own ledger sum.
  static CardBalance compute({
    required DetectedCard card,
    required List<Transaction> allTransactions,
    required List<DetectedCard> allCards,

    /// Optional lookup of a transaction's detected bank name, so ownership can
    /// be judged on the full `bank + last4` identity. When supplied, a row whose
    /// bank disagrees with this card's bank is NOT counted here, which is what
    /// keeps `NBE + 1234` out of `CIB/1234` once the user has learned both.
    String? Function(Transaction t)? bankOf,
  }) {
    final owned =
        CardOwnership.forCard(allTransactions, card, allCards, bankOf)
            .where((t) => t.status == TransactionStatus.confirmed);

    final deducted = owned
        .where((t) => t.type.countsTowardsDeducted)
        .fold<int>(0, (sum, t) => sum + t.amountMinor);

    final pocketCash = owned.fold<int>(
      0,
      (sum, t) => sum +
          (t.type == TransactionType.atm_withdrawal
              ? t.amountMinor
              : t.type == TransactionType.cash_expense
                  ? -t.amountMinor
                  : 0),
    );

    final ledger = owned.fold<int>(0, (sum, t) => sum + balanceDelta(t));

    if (!card.isCreditCard) {
      return CardBalance(
        myBalanceMinor: ledger,
        deductedMinor: deducted,
        pocketCashMinor: pocketCash,
      );
    }

    // Credit card: the Fixed Amount IS the available baseline. Without one the
    // balance is 0 by definition, not a stale value from a previous limit.
    if (card.creditLimitMinor <= 0) {
      return CardBalance(
        myBalanceMinor: 0,
        deductedMinor: deducted,
        pocketCashMinor: pocketCash,
        hasFixedAmount: false,
      );
    }

    var balance = card.creditLimitMinor + ledger;
    // The Fixed Amount is a ceiling, never a suggestion.
    if (balance > card.creditLimitMinor) balance = card.creditLimitMinor;

    return CardBalance(
      myBalanceMinor: balance,
      deductedMinor: deducted,
      pocketCashMinor: pocketCash,
      fixedAmountMinor: card.creditLimitMinor,
      hasFixedAmount: true,
    );
  }
}
