import '../entities/detected_card_model.dart';
import '../entities/transaction_model.dart';

/// THE SINGLE SOURCE OF TRUTH for "which card does this transaction belong to?".
///
/// Before this class every balance query re-implemented its own card filter
/// with slightly different fallbacks, which is exactly how transactions ended
/// up on the wrong card: a row with no `card_id` was silently claimed by any
/// card whose `last4` happened to match, and the SQL `getDeductedForCard`
/// claimed it for *every* such card. Three rules, one bug each.
///
/// The rule is deliberately small and total. For a user whose cards are
/// [cards], a transaction [t] has exactly one of three outcomes:
///
///  1. **[t].cardId is set** → that card owns it, full stop. `card_id` is the
///     persisted, Supabase-enforced identity and always wins. A row pointing
///     at a card that no longer exists is unassigned, never re-homed.
///
///  2. **No `card_id`, but a `last4`** → the last4 is used *only* when it
///     identifies exactly one card ([last4IsUnambiguous]). This keeps
///     SMS-derived rows working before the async `card_id` backfill in
///     `SMSTransactionProcessor` has landed, without guessing.
///
///  3. **No `card_id` and no `last4`** (or an ambiguous last4) → UNASSIGNED.
///     It affects no card's My Balance / Deducted Money / Pocket Cash, and the
///     red-dot indicator stays until the user resolves the card number.
///
/// The selected card, the last selected card, the first card and any other
/// fallback are deliberately NOT inputs here. An ambiguous transaction is
/// unassigned; it is never inherited by whatever card happens to be open.
class CardOwnership {
  const CardOwnership._();

  /// True when at most one of the user's cards carries [last4], AND [last4] is a
  /// well-formed four-digit number.
  ///
  /// Zero matches is still "unambiguous": the last4 simply describes a card
  /// Floosy has no record of yet, and matching on it is safe. Two or more
  /// matches is genuine ambiguity, and the last4 can no longer identify a
  /// card — those transactions stay unassigned for manual resolution.
  ///
  /// A MALFORMED last4 (not exactly four digits) identifies nothing at all, so
  /// it is reported as non-unambiguous. That keeps a typo such as "123" or
  /// "abcd" out of every card's totals and — importantly — keeps the red dot
  /// visible so the user can correct it, instead of the amount silently
  /// vanishing.
  static bool last4IsUnambiguous(
    String? last4,
    List<DetectedCard> cards,
  ) {
    if (normalizeCardLast4(last4) == null) return false;
    var matches = 0;
    for (final card in cards) {
      if (card.last4 == last4) {
        matches++;
        if (matches > 1) return false;
      }
    }
    return true;
  }

  /// The id of the card that owns [t], or null when it is unassigned.
  static String? ownerCardId(Transaction t, List<DetectedCard> cards) {
    final cardId = t.cardId;
    if (cardId != null && cardId.isNotEmpty) {
      // An explicit assignment only counts while the card still exists.
      // A dangling card_id must not leak into another card's totals.
      for (final card in cards) {
        if (card.id == cardId) return cardId;
      }
      return null;
    }
    if (!last4IsUnambiguous(t.cardLast4, cards)) return null;
    for (final card in cards) {
      if (card.last4 == t.cardLast4) return card.id;
    }
    // No card record for this last4. Ownership is decided by the caller,
    // which still scopes strictly by that single unambiguous last4.
    return null;
  }

  /// True when [t] must be counted towards [card]'s figures.
  ///
  /// [bankOf] supplies the row's detected bank name (from the SMS detection
  /// record) so ownership can be judged on the FULL identity. This matters once
  /// the user has learned more than one card: with `CIB/1234` and `NBE/1234`
  /// both known, an `NBE + 1234` row must NOT be counted against `CIB/1234`
  /// just because the four digits agree. When [bankOf] is omitted the rule
  /// degrades to the original last4-only behaviour.
  static bool belongsToCard(
      Transaction t, DetectedCard card, List<DetectedCard> allCards,
      [String? Function(Transaction t)? bankOf]) {
    final cardId = t.cardId;
    if (cardId != null && cardId.isNotEmpty) return cardId == card.id;
    if (t.cardLast4 == null || t.cardLast4 != card.last4) return false;
    // Fallback for rows awaiting the async card_id backfill. Only safe while
    // this last4 still points at exactly one card.
    if (!last4IsUnambiguous(card.last4, allCards)) return false;
    // A known bank must agree with the card's bank; a known mismatch is a
    // different card, not an unresolved one.
    final bank = bankOf?.call(t);
    if (bank != null && normalizeBankIdentity(bank) != null) {
      return normalizeBankIdentity(bank) ==
          normalizeBankIdentity(card.bankName);
    }
    return true;
  }

  /// True when [t] cannot be attributed to any card and therefore shows the
  /// red-dot "needs a card number" indicator.
  static bool isUnassigned(
    Transaction t,
    List<DetectedCard> cards, [
    String? Function(Transaction t)? bankOf,
  ]) {
    final cardId = t.cardId;
    if (cardId != null && cardId.isNotEmpty) {
      for (final card in cards) {
        if (card.id == cardId) return false;
      }
      return true; // dangling card_id
    }
    if (!last4IsUnambiguous(t.cardLast4, cards)) return true;
    if (bankOf == null) return false;
    // A row with a KNOWN bank is only resolved when some card carries that same
    // bank identity. If the user has a learned identity for a different bank
    // with the same last4, this row still has nowhere proven to belong.
    final bank = normalizeBankIdentity(bankOf.call(t));
    if (bank == null) return false; // no bank known: keep last4-only behaviour
    for (final card in cards) {
      if (card.last4 == t.cardLast4 &&
          normalizeBankIdentity(card.bankName) == bank) {
        return false;
      }
    }
    return true;
  }

  /// [transactions] that belong to [card], in input order.
  static List<Transaction> forCard(
    List<Transaction> transactions,
    DetectedCard card,
    List<DetectedCard> allCards, [
    String? Function(Transaction t)? bankOf,
  ]) =>
      transactions
          .where((t) => belongsToCard(t, card, allCards, bankOf))
          .toList(growable: false);

  /// [transactions] that belong to no card at all.
  static List<Transaction> unassigned(
    List<Transaction> transactions,
    List<DetectedCard> cards, [
    String? Function(Transaction t)? bankOf,
  ]) =>
      transactions
          .where((t) => isUnassigned(t, cards, bankOf))
          .toList(growable: false);
}

/// Canonical normalisation of a card's last four digits.
///
/// The ONLY transformation applied is whitespace/separator removal plus upper
/// casing, so " 1234 ", "1234" and "12 34" all mean the same card. Anything
/// that is not exactly four ASCII digits is rejected outright and returns null —
/// the resolver never "repairs" a malformed number into a guess.
String? normalizeCardLast4(String? raw) {
  if (raw == null) return null;
  final compact = raw.replaceAll(RegExp(r'[\s\-•*_]'), '').toUpperCase();
  if (!RegExp(r'^[0-9]{4}$').hasMatch(compact)) return null;
  return compact;
}

/// Normalised bank identity used to qualify a last4.
///
/// "CIB", "cib", " CIB " and "CIB Bank" are all the SAME bank for matching
/// purposes, because the detected-card repository already keys cards on
/// `bankName` and would otherwise create duplicate cards for one bank. This is
/// the single normalisation point referenced by the resolver: no screen should
/// ever write its own bank-comparison logic, and no mapping is invented for a
/// bank the application does not already know.
String? normalizeBankIdentity(String? raw) {
  if (raw == null) return null;
  var value = raw.trim().toLowerCase();
  if (value.isEmpty) return null;
  // Strip a trailing generic word so "CIB Bank" == "CIB".
  const suffixes = [' bank', ' egypt'];
  for (final suffix in suffixes) {
    if (value.endsWith(suffix) && value.length > suffix.length) {
      value = value.substring(0, value.length - suffix.length).trim();
    }
  }
  return value.isEmpty ? null : value;
}

/// Why a card identity could or could not be proven.
///
/// The three cases are distinct on purpose. `Ambiguous` and `Unresolved` are
/// different situations for the user ("several cards match" vs "we know
/// nothing"). Both keep the red dot, but only `Ambiguous` can become
/// `Resolved` by supplying more information.
sealed class CardOwnershipResolution {
  const CardOwnershipResolution();

  /// The proven card id, or null when the identity is not proven.
  String? get cardId => switch (this) {
        Resolved(:final card) => card.id,
        Ambiguous() || Unresolved() => null,
      };

  /// True only when the identity is deterministic. The red dot and every
  /// balance calculation key off this.
  bool get isResolved => this is Resolved;

  /// A short reason suitable for logs and UI messaging.
  String get reason => switch (this) {
        Resolved(:final card) =>
          'resolved to ${card.bankName ?? 'card'} ****${card.last4}',
        Ambiguous(:final candidates) =>
          'ambiguous: ${candidates.length} cards share this last4 '
              '(${candidates.map((c) => c.bankName ?? '?').join(', ')})',
        Unresolved(:final detail) => 'unresolved: $detail',
      };
}

/// The identity is proven: exactly one card matches.
class Resolved extends CardOwnershipResolution {
  final DetectedCard card;
  const Resolved(this.card);
}

/// Several cards match the last4, so the identity is NOT proven.
class Ambiguous extends CardOwnershipResolution {
  final List<DetectedCard> candidates;
  const Ambiguous(this.candidates);
}

/// Not enough information exists to identify any card.
class Unresolved extends CardOwnershipResolution {
  /// Machine-readable reason: `no_last4`, `invalid_last4` or `no_matching_card`.
  final String detail;
  const Unresolved(this.detail);
}

/// The CENTRAL card identity resolver.
///
/// One implementation of "can this identity be proven?", used by SMS
/// ingestion, transaction editing, manual Last 4 entry, the legacy backfill and
/// the red-dot indicator. It EXTENDS [CardOwnership] rather than replacing it:
/// the base rule stays the only thing that decides balances, and this class
/// only decides whether an identity is provable enough to *write* a card_id.
///
/// The safety principle is explicit: propagate only when the stored data
/// provides a deterministic relationship. Amount, date, sender and transaction
/// type are never inputs.
class CardIdentityResolver {
  const CardIdentityResolver._();

  /// Resolves the card identity for a raw (un-normalised) last4 + bank.
  ///
  /// The bank is a QUALIFIER, never a match key on its own:
  ///   * a last4 that maps to exactly one card resolves on its own, exactly as
  ///     the pre-existing ownership rule already did (no behaviour change);
  ///   * a last4 shared by several cards resolves ONLY when the supplied bank
  ///     narrows those candidates down to exactly one;
  ///   * anything still ambiguous or empty stays unresolved.
  static CardOwnershipResolution resolve({
    required List<DetectedCard> cards,
    String? last4,
    String? bankIdentity,
  }) {
    final normalized = normalizeCardLast4(last4);
    if (normalized == null) {
      final detail = (last4 == null || last4.trim().isEmpty)
          ? 'no_last4'
          : 'invalid_last4';
      return Unresolved(detail);
    }

    final byLast4 =
        cards.where((c) => c.last4 == normalized).toList(growable: false);

    if (byLast4.isEmpty) return const Unresolved('no_matching_card');
    if (byLast4.length == 1) return Resolved(byLast4.single);

    // Several cards share this last4: only a bank identity can break the tie.
    final bank = normalizeBankIdentity(bankIdentity);
    if (bank == null) return Ambiguous(byLast4);

    final narrowed = byLast4
        .where((c) => normalizeBankIdentity(c.bankName) == bank)
        .toList(growable: false);
    if (narrowed.length == 1) return Resolved(narrowed.single);

    // A bank matching nothing, or matching several, proves nothing.
    return narrowed.isEmpty
        ? const Unresolved('no_matching_card')
        : Ambiguous(narrowed);
  }

  /// True when two identities are provably the same card.
  ///
  /// Used to decide whether propagation to another row is safe. It requires
  /// EQUAL last4 AND equal bank identity, where "unknown bank" only matches
  /// "unknown bank".
  ///
  /// That asymmetry is deliberate and is the whole point: resolving
  /// `1234 + CIB` proves the edited row, but it must NOT pull in a sibling row
  /// that merely says `1234` with no bank. That row could belong to any of the
  /// cards sharing this last4, so it stays unresolved until the user supplies
  /// its bank. Treating a missing bank as "no conflict" would be exactly the
  /// probabilistic guess this resolver exists to avoid.
  ///
  /// It deliberately does not look at amount, date, sender or type.
  static bool identitiesMatch({
    required String leftLast4,
    String? leftBank,
    required String rightLast4,
    String? rightBank,
  }) {
    if (leftLast4 != rightLast4) return false;
    final l = normalizeBankIdentity(leftBank);
    final r = normalizeBankIdentity(rightBank);
    // Both sides agree: either the same known bank, or both unknown.
    return l == r;
  }
}
