import '../../domain/entities/card_resolution_result.dart';
export '../../domain/entities/card_resolution_result.dart';
import 'dart:async';

import '../local/datasources/money_local_datasource.dart'
    show BankScopedIdentityWriteResult;
import '../../domain/entities/detected_card_model.dart';
import '../../domain/entities/transaction_model.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/services/card_ownership.dart';

/// The two sibling populations a bank-scoped confirmation acts on.
///
/// `card_last4` and `card_id` are independent, so a row can be missing either,
/// both, or neither — and the write has to know which.
class _BankScopedSiblings {
  /// Same user + same canonical bank + `card_last4 IS NULL`. These receive the
  /// confirmed Last 4, and the card id if they have none.
  final List<String> last4MissingIds;

  /// Same user + same canonical bank + already carrying the confirmed Last 4 +
  /// `card_id IS NULL`. These receive only the card link; their number is
  /// already correct and is never rewritten.
  final List<String> cardLinkMissingIds;

  const _BankScopedSiblings(this.last4MissingIds, this.cardLinkMissingIds);
}

/// SMART, DETERMINISTIC card identity resolution.
///
/// Turns a user-confirmed Card Last 4 into card assignments â€” for the edited
/// transaction AND, when the stored data proves them identical, for the other
/// unresolved transactions that share that exact identity.
///
/// The safety principle in one line: **only propagate when the existing data
/// provides a deterministic relationship**. It is a strict identity matcher,
/// not a guesser:
///
///   SAFE match fields  : card last4 + normalised bank identity
///                        + canonical transaction type (propagation only).
///   NEVER match fields : amount, date, sender, description, the selected card,
///                        the current card, the first card.
///
/// Two identities are deliberately kept apart here:
///
///   * the PHYSICAL CARD identity is `user + bank + last4`, and is what a
///     `DetectedCard` row represents. Resolving a card never asks for the
///     transaction type — one card is one card whatever was bought on it.
///   * the TRANSACTION PROPAGATION identity is
///     `user + bank + last4 + type`. The type is required only to decide which
///     TRANSACTIONS a confirmation may reach, so confirming a `purchase` never
///     fills a sibling `atm_withdrawal` of the same card.
///
/// Consequences the tests lock down:
///   * an already-resolved transaction (`card_id != null`) is never touched;
///   * a row whose bank is unknown is never pulled in by a bank-qualified
///     decision â€” it stays red-dotted, exactly as required;
///   * if the identity cannot be proven, the ONLY row written is the one the
///     user explicitly edited.
class SmartCardResolutionService {
  final Future<List<String>> Function(
          String userId, String transactionId, List<String> candidates)?
      filterSmsSiblings;
  final Future<List<DetectedCard>> Function(String userId) _cards;
  final Future<List<Transaction>> Function(String userId) _transactions;
  final Future<Map<String, String>> Function(String userId) _bankNames;
  final Future<int> Function(List<String> transactionIds, String cardId)
      _assignAtomically;

  /// Every distinct bank name the user's positively-identified SMS detection
  /// records carry, so the canonical matcher can recover the concrete spellings
  /// SQL must compare.
  final Future<List<String>> Function(String userId) _distinctDetectedBankNames;

  /// The bank-scoped sibling query: same user, one of [bankNames] as recorded on
  /// the linked detection row, `card_last4 IS NULL`, and the same canonical
  /// transaction TYPE.
  final Future<List<String>> Function(
          String userId, List<String> bankNames, String type)
      _findNullLast4IdsForBankNames;

  /// The same bank, the same transaction type and an already-correct Last 4,
  /// but no card link yet.
  final Future<List<String>> Function({
    required String userId,
    required List<String> bankNames,
    required String last4,
    required String type,
  }) _findMissingCardIdIdsForIdentity;

  /// THE authoritative local write for a user-confirmed identity: the edited
  /// row, every same-user/same-bank sibling missing its Last 4, and the linked
  /// SMS detection records — all in one Drift transaction.
  ///
  /// `card_last4` and `card_id` are written independently so a sibling that
  /// already has an explicit card still receives the Last 4 it was missing,
  /// while its card ownership is never replaced.
  final Future<BankScopedIdentityWriteResult> Function({
    required String transactionId,
    required String cardId,
    required String last4,
    required List<String> siblingTransactionIds,
  }) _applyBankScopedIdentity;

  final Future<void> Function(String transactionId, String cardId)
      _assignRemote;

  /// Creates or returns the persistent card identity for
  /// `user + bank + last4`. Injected so this service stays free of storage
  /// concerns and the SAME `DetectedCardRepository` that backs the card UI is
  /// the single place a card identity is ever created.
  final Future<DetectedCard> Function(
    String userId,
    String last4,
    String bankName,
  ) _learnCardIdentity;

  SmartCardResolutionService({
    this.filterSmsSiblings,
    required Future<List<DetectedCard>> Function(String userId) cards,
    required Future<List<Transaction>> Function(String userId) transactions,
    required Future<Map<String, String>> Function(String userId) bankNames,
    required Future<int> Function(List<String> transactionIds, String cardId)
        assignAtomically,
    required Future<List<String>> Function(String userId)
        distinctDetectedBankNames,
    required Future<List<String>> Function(
      String userId,
      List<String> bankNames,
      String type,
    ) findNullLast4IdsForBankNames,
    required Future<List<String>> Function({
      required String userId,
      required List<String> bankNames,
      required String last4,
      required String type,
    }) findMissingCardIdIdsForIdentity,
    required Future<BankScopedIdentityWriteResult> Function({
      required String transactionId,
      required String cardId,
      required String last4,
      required List<String> siblingTransactionIds,
    }) applyBankScopedIdentity,
    required Future<DetectedCard> Function(
      String userId,
      String last4,
      String bankName,
    ) learnCardIdentity,
    Future<void> Function(String transactionId, String cardId)? assignRemote,
  })  : _cards = cards,
        _transactions = transactions,
        _bankNames = bankNames,
        _assignAtomically = assignAtomically,
        _distinctDetectedBankNames = distinctDetectedBankNames,
        _findNullLast4IdsForBankNames = findNullLast4IdsForBankNames,
        _findMissingCardIdIdsForIdentity = findMissingCardIdIdsForIdentity,
        _applyBankScopedIdentity = applyBankScopedIdentity,
        _learnCardIdentity = learnCardIdentity,
        _assignRemote = assignRemote ?? ((_, __) async {});

  /// Mirrors the committed identity to Supabase WITHOUT blocking the caller.
  ///
  /// The local Drift commit is the source of truth and the UI must not wait on
  /// network latency, so this deliberately does not `await` each row. Failures
  /// are logged and the local state stands; a later sync picks the row up.
  void _mirrorRemoteInBackground(List<String> transactionIds, String cardId) {
    for (final id in transactionIds) {
      unawaited(() async {
        try {
          await _assignRemote(id, cardId);
        } catch (e) {
          logError('CARD_LEARN_REMOTE_SYNC_FAILED id=$id', e);
        }
      }());
    }
  }

  /// Finds or creates the persistent card identity for user + bank + last4.
  Future<DetectedCard> _findOrCreateIdentity({
    required String userId,
    required String last4,
    required String bank,
  }) async {
    logInfo('[SMART CARD] looking for existing card identity '
        'user=$userId bank=$bank last4=$last4');
    final card = await _learnCardIdentity(userId, last4, bank);
    logInfo('[SMART CARD] cardId=${card.id} '
        'bankName=${card.bankName} last4=${card.last4}');
    return card;
  }

  /// The canonical bank identity of a transaction, from its SMS detection
  /// record. This is the value the user does NOT have to re-enter: the
  /// transaction already knows which bank it came from.
  Future<String?> bankOfTransaction(String userId, String transactionId) async {
    final names = await _bankNames(userId);
    return names[transactionId];
  }

  /// Sibling transactions that should receive a user-confirmed Last 4.
  ///
  /// Selection is the product rule and nothing more:
  ///
  ///     same user
  ///       AND same canonical bank identity
  ///       AND same canonical transaction type
  ///       AND card_last4 IS NULL
  ///
  /// The TYPE dimension is what keeps a `purchase` confirmation away from a
  /// sibling `atm_withdrawal` / `transfer_in` / `deposit` row of the very same
  /// card. It is compared as the canonical `TransactionType.toString()` value
  /// the app already stores, so no second type representation is introduced.
  ///
  /// The bank is compared through [normalizeBankIdentity], never as a raw
  /// string, so `CIB` / `cib` / `Cib Bank` collapse to one identity while
  /// `Faisal Bank`, `AlexBank`, `CIB` and `NBE` stay separate. Merchant name and
  /// SMS sender are never used as bank identity.
  ///
  /// The concrete bank-name spellings that SQL must match are recovered by
  /// folding the user's stored detection names through the same normaliser, so
  /// the database does the filtering in one indexed statement rather than
  /// loading every unresolved row into memory.
  ///
  /// The returned rows are grouped by what they still need, because
  /// `card_last4` and `card_id` are independent: [last4MissingIds] need the
  /// number, [cardLinkMissingIds] already have it and only need the link.
  Future<_BankScopedSiblings> _bankScopedNullLast4Candidates({
    required String userId,
    required String bank,
    required String last4,
    required String excludeId,
    required String type,
  }) async {
    final names = await _distinctDetectedBankNames(userId);
    final matching = <String>[];
    for (final name in names) {
      if (normalizeBankIdentity(name) == bank) matching.add(name);
    }
    if (matching.isEmpty) {
      return const _BankScopedSiblings([], []);
    }

    // Set 1: the row the user is actually supplying the missing number for.
    final last4Missing =
        (await _findNullLast4IdsForBankNames(userId, matching, type))
            .where((id) => id != excludeId)
            .toList();

    // Set 2: same user + same bank + same type + the number is ALREADY the
    // confirmed one, but the card link is still missing. Nothing is guessed
    // here — the stored value equals the value the user just typed.
    final already = await _findMissingCardIdIdsForIdentity(
      userId: userId,
      bankNames: matching,
      last4: last4,
      type: type,
    );
    final cardLinkMissing = already
        .where((id) => id != excludeId && !last4Missing.contains(id))
        .toList();

    return _BankScopedSiblings(last4Missing, cardLinkMissing);
  }

  /// LEARNS a persistent `Bank + Last 4 -> Card` identity from an explicit user
  /// confirmation, then resolves everything that provably follows from it.
  ///
  /// This is the entry point for the real product flow:
  ///
  ///     long press -> Edit -> type the Card Last 4 -> Save
  ///
  /// The user confirming a Last 4 on a transaction IS the source of truth — it
  /// is not a lookup against cards that happen to exist already. The bank comes
  /// from the TRANSACTION (already detected), so the user never re-selects it.
  ///
  /// Steps:
  ///   1. Validate the entered Last 4 (exactly four digits).
  ///   2. Take the bank from the transaction; without one, refuse to learn.
  ///   3. Create or find the persistent card identity for
  ///      `user + bank + last4` (never a duplicate).
  ///   4. Write the edited row, then fill every SAME-USER / SAME-BANK sibling
  ///      that is still missing a `card_last4`, and the SMS detection records
  ///      linked to them — in one local transaction.
  ///   5. Commit locally, refresh the UI, and mirror to Supabase afterwards.
  ///
  /// The propagation is scoped to the user's own rows and to one canonical
  /// bank, so `CIB` never reaches `NBE`, and a row that already carries a
  /// `card_last4` or an explicit `card_id` is never rewritten.
  Future<SmartResolutionResult> learnCardIdentityFromUserConfirmation({
    required String userId,
    required String transactionId,
    required String? last4,
    String? bankIdentityOverride,
  }) async {
    // 1. Validate. A malformed number is never "repaired" into an identity.
    final normalized = normalizeCardLast4(last4);
    if (normalized == null) {
      final result = SmartResolutionResult(
        resolution: Unresolved(
          (last4 == null || last4.trim().isEmpty)
              ? 'no_last4'
              : 'invalid_last4',
        ),
      );
      logInfo(
          'CARD_LEARN_REJECTED txn=$transactionId ${result.resolution.reason}');
      return result;
    }

    // 2. The bank comes from the transaction, not from the selected card and
    //    not from anything the user has to pick again.
    final bank = normalizeBankIdentity(
      bankIdentityOverride ?? await bankOfTransaction(userId, transactionId),
    );
    if (bank == null) {
      // No reliable bank identity: we must NOT create a bare "1234 -> card"
      // mapping, because that would let one bank's card claim another bank's
      // transactions. The Last 4 is still saved on the row by the caller; the
      // row simply stays unresolved until a bank is known.
      logInfo('CARD_LEARN_REJECTED txn=$transactionId '
          'unresolved: transaction has no bank identity');
      return const SmartResolutionResult(
        resolution: Unresolved('no_bank_identity'),
      );
    }

    // 3. Create or find the persistent identity for this user + bank + last4.
    // 3. Create or find the persistent identity for this user + bank + last4.
    final card = await _findOrCreateIdentity(
      userId: userId,
      last4: normalized,
      bank: bank,
    );

    // 4. Select the siblings: SAME USER + SAME canonical bank + SAME canonical
    //    transaction type, and MISSING a card_last4.
    //
    //    This is the product rule, and it is deliberately not the old
    //    `card_last4 = confirmed` match. On the real device that query returned
    //    nothing, because the sibling rows were WAITING for the value rather
    //    than already holding it — so only the edited row ever changed.
    //
    //    The TYPE is read from the row the user just confirmed, so the
    //    propagation group is the one the user actually acted on. A `purchase`
    //    confirmation therefore never reaches an `atm_withdrawal` sibling of
    //    the same card, while an `atm_withdrawal` confirmation still propagates
    //    across other ATM rows of that card.
    final edited = (await _transactions(userId))
        .where((t) => t.id == transactionId)
        .firstOrNull;
    if (edited == null) {
      logInfo('CARD_LEARN_SKIPPED txn=$transactionId reason=no_row');
      return const SmartResolutionResult(
        resolution: Unresolved('no_row'),
      );
    }
    final type = edited.type.toString();

    var siblings = await _bankScopedNullLast4Candidates(
      userId: userId,
      bank: bank,
      last4: normalized,
      excludeId: transactionId,
      type: type,
    );
    if (filterSmsSiblings != null) {
      final allowed = await filterSmsSiblings!(userId, transactionId,
          [...siblings.last4MissingIds, ...siblings.cardLinkMissingIds]);
      siblings = _BankScopedSiblings(
          siblings.last4MissingIds.where(allowed.contains).toList(),
          siblings.cardLinkMissingIds.where(allowed.contains).toList());
    }
    logInfo('BANK_SCOPED_CANDIDATES bank=$bank type=$type '
        'last4Missing=${siblings.last4MissingIds.length} '
        'cardLinkMissing=${siblings.cardLinkMissingIds.length}');

    // 5. ONE local Drift transaction. The edited row is written
    //    unconditionally (the user confirmed this exact transaction); siblings
    //    receive the confirmed Last 4 regardless of their `card_id`, and
    //    receive the card id only where it is still NULL; the linked SMS
    //    detection records are filled in the same commit.
    final write = await _applyBankScopedIdentity(
      transactionId: transactionId,
      cardId: card.id,
      last4: normalized,
      siblingTransactionIds: <String>[
        ...siblings.last4MissingIds,
        ...siblings.cardLinkMissingIds,
      ],
    );
    logInfo('BANK_SCOPED_COMMIT cardId=${card.id} cardLast4=$normalized '
        'edited=${write.editedRows} siblingLast4=${write.siblingLast4Rows} '
        'siblingCard=${write.siblingCardRows} sms=${write.smsRows}');

    // 6. The local commit is DONE. Supabase is mirrored in the BACKGROUND so the
    //    UI refreshes immediately instead of waiting on network latency.
    _mirrorRemoteInBackground(
      <String>[
        transactionId,
        ...siblings.last4MissingIds,
        ...siblings.cardLinkMissingIds,
      ],
      card.id,
    );

    logInfo('CARD_LEARN_APPLIED user=$userId bank=$bank last4=$normalized '
        'card=${card.id} edited=$transactionId '
        'propagated=${write.siblingLast4Rows}');

    return SmartResolutionResult(
      resolution: Resolved(card),
      transactionAssigned: true,
      propagatedTransactionIds: <String>[
        ...siblings.last4MissingIds,
        ...siblings.cardLinkMissingIds,
      ],
      // True when this call created or changed the identity rather than
      // leaving every already-applied row untouched.
      identityWasCreated: write.wroteAnything,
    );
  }

  /// Resolves a card identity for a user-supplied Last 4 WITHOUT writing, so a UI
  /// can preview "this will resolve" vs "this will stay unresolved".
  Future<CardOwnershipResolution> preview({
    required String userId,
    String? last4,
    String? bankIdentity,
  }) async {
    final cards = await _cards(userId);
    return CardIdentityResolver.resolve(
      cards: cards,
      last4: last4,
      bankIdentity: bankIdentity,
    );
  }

  /// The main entry point: the user confirmed [last4] (and optionally a bank)
  /// for [transactionId].
  ///
  /// 1. Validate + normalise the last4.
  /// 2. Resolve the identity through the central resolver.
  /// 3. Write the explicitly edited transaction and â€” only when the identity
  ///    is proven â€” every OTHER unresolved transaction that provably shares it.
  /// 4. Commit atomically, then mirror to remote.
  ///
  /// Ownership is PERSISTED before any balance is read, so a transaction can
  /// never be counted against the wrong card and then re-counted after the fix.
  /// When step 2 does not resolve, nothing beyond the user's own row is
  /// touched and that row keeps its red dot.
  Future<SmartResolutionResult> resolveForUserInput({
    required String userId,
    required String transactionId,
    String? last4,
    String? bankIdentity,
  }) async {
    final cards = await _cards(userId);

    final resolution = CardIdentityResolver.resolve(
      cards: cards,
      last4: last4,
      bankIdentity: bankIdentity,
    );

    if (resolution is! Resolved) {
      logInfo('CARD_RESOLUTION_NOT_PROVEN txn=$transactionId '
          '${resolution.reason}');
      return SmartResolutionResult(resolution: resolution);
    }

    final card = resolution.card;
    final rows = await _transactions(userId);
    final bankNames = await _bankNames(userId);

    // Candidates: unresolved rows only (never touch an explicit assignment)
    // whose identity provably equals the resolved card's.
    final candidates = <String>[];
    for (final row in rows) {
      if (row.id == transactionId) continue;
      if (row.cardId != null && row.cardId!.isNotEmpty) continue; // resolved
      final rowLast4 = normalizeCardLast4(row.cardLast4);
      if (rowLast4 == null) continue;
      final matches = CardIdentityResolver.identitiesMatch(
        leftLast4: card.last4,
        leftBank: card.bankName,
        rightLast4: rowLast4,
        rightBank: bankNames[row.id],
      );
      if (matches) candidates.add(row.id);
    }

    // ONE local Drift transaction, shared with the manual-confirmation path so
    // there is a single implementation. Both `card_last4` and `card_id` are
    // persisted — propagating the card id alone would leave the value the user
    // confirmed uncommitted, so the rest of the app would still read the old
    // one.
    final write = await _applyBankScopedIdentity(
      transactionId: transactionId,
      cardId: card.id,
      last4: card.last4,
      siblingTransactionIds: candidates,
    );
    if (!write.wroteAnything) {
      // Already applied: a proven resolution, just nothing left to write.
      return SmartResolutionResult(resolution: resolution);
    }

    // The local commit is DONE. Supabase is mirrored in the BACKGROUND so the
    // caller (and therefore the UI) never waits on network latency.
    _mirrorRemoteInBackground(<String>[transactionId, ...candidates], card.id);

    logInfo('CARD_RESOLUTION_APPLIED card=${card.id} last4=${card.last4} '
        'bank=${card.bankName} edited=$transactionId '
        'propagated=${candidates.length}');

    return SmartResolutionResult(
      resolution: resolution,
      transactionAssigned: true,
      propagatedTransactionIds: candidates,
    );
  }

  /// Re-scans every unresolved transaction and assigns the ones whose identity
  /// is now provable (e.g. after a new detected card or a bank mapping appears).
  ///
  /// Idempotent by construction: it only ever writes rows with card_id IS NULL,
  /// and the atomic write re-checks that guard, so a second run is a no-op.
  /// Rows it cannot prove are left untouched and keep their red dot.
  Future<int> backfill({
    required String userId,
    Future<void> Function(String transactionId, String cardId)? onResolved,
  }) async {
    final cards = await _cards(userId);
    final rows = await _transactions(userId);
    final bankNames = await _bankNames(userId);
    var repaired = 0;
    for (final row in rows) {
      // Never revisit an explicitly assigned transaction.
      if (row.cardId != null && row.cardId!.isNotEmpty) continue;
      final resolution = CardIdentityResolver.resolve(
        cards: cards,
        last4: row.cardLast4,
        bankIdentity: bankNames[row.id],
      );
      if (resolution is! Resolved) continue;
      final card = resolution.card;
      final written = await _assignAtomically(<String>[row.id], card.id);
      if (written == 0) continue; // already assigned: idempotent no-op
      repaired += written;
      try {
        await _assignRemote(row.id, card.id);
      } catch (e) {
        logError('CARD_BACKFILL_REMOTE_SYNC_FAILED id=${row.id}', e);
      }
      if (onResolved != null) await onResolved(row.id, card.id);
    }
    if (repaired > 0) logInfo('CARD_BACKFILL_REPAIRED count=$repaired');
    return repaired;
  }
}
