import '../../../../data/models/detected_card_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/detected_card_repository.dart';
import '../../../../data/repositories/transaction_repository.dart';
import '../../../../data/services/card_ownership.dart';
import '../../../../data/services/smart_card_resolution_service.dart';
import '../../../../core/utils/app_logger.dart';

/// The values the Edit dialog collects.
class TransactionEditDraft {
  final Transaction transaction;
  final TransactionType type;
  final int amountMinor;
  final String currency;
  final String bankText;
  final String last4Text;
  final String? categoryId;
  final String? merchantName;
  final DateTime transactionDate;

  const TransactionEditDraft({
    required this.transaction,
    required this.type,
    required this.amountMinor,
    required this.currency,
    required this.bankText,
    required this.last4Text,
    required this.categoryId,
    required this.merchantName,
    required this.transactionDate,
  });
}

/// The REAL "Edit -> Save" behaviour of the Transactions screen, extracted out
/// of the widget so it can be tested directly.
///
/// This exists because the save path previously lived inside a private
/// `_showTransactionEditor` method: the card-identity learning and propagation
/// it triggered could not be exercised by any test, which is exactly how a real
/// regression (the learned "bank" being a merchant name instead of the detected
/// bank) shipped unnoticed. The widget delegates here, so the widget and the
/// tests execute the same code.
class TransactionEditController {
  TransactionEditController({
    required this.userId,
    required this.transactionRepository,
    required this.moneyRepository,
    required this.cardRepository,
    required this.bankCatalogLoader,
    this.onChanged,
  });

  final String userId;
  final TransactionRepository transactionRepository;
  final dynamic moneyRepository; // MoneyRepository
  final DetectedCardRepository cardRepository;
  final Future<List<Bank>> Function() bankCatalogLoader;

  /// Invoked after a successful save so the screen can refresh its providers.
  final void Function()? onChanged;

  /// Persists the edit, then LEARNS the `bank + last4 -> card` identity and
  /// propagates it to every other unresolved transaction with the same identity.
  ///
  /// The ORDER here is the contract, not an implementation detail:
  ///
  ///     normalise Last 4
  ///       -> ONE local Drift transaction (edited row + propagation)
  ///       -> COMMIT
  ///       -> re-read to verify
  ///       -> notify the UI
  ///       -> Supabase mirror, best-effort, in the BACKGROUND
  ///
  /// The UI must never be blocked on Supabase. The previous version awaited the
  /// row upsert, the card upsert and one remote `card_id` write per row *before*
  /// calling [onChanged], which is why pressing Save appeared to hang.
  ///
  /// Returns the learning result (null when no Last 4 was supplied), so callers
  /// and tests can inspect exactly what was assigned.
  Future<SmartResolutionResult?> save(TransactionEditDraft draft) async {
    final transaction = draft.transaction;
    final bankText = draft.bankText.trim();

    // Resolve the bank UUID the transactions table stores. This is display
    // information only and is NOT the card identity.
    String? bankId = transaction.bankId;
    if (bankText.isNotEmpty) {
      final known = await bankCatalogLoader();
      final match = known
          .where((b) =>
              b.id == bankText || b.name == bankText || b.code == bankText)
          .toList();
      bankId = match.isEmpty ? null : match.first.id;
    }

    // The bank used for CARD IDENTITY comes from the transaction's detection
    // record, not from this field.
    //
    // The field is pre-filled with `transaction.merchantName`, which the SMS
    // pipeline sets to `parsed.merchant ?? bankName` - so for a purchase SMS it
    // usually holds a MERCHANT ("Koshary Abu Tarek"), not a bank. Passing that
    // through as the bank identity would learn a bogus identity like
    // "Koshary Abu Tarek + 1234" whose propagation would then match nothing.
    //
    // So the field is only treated as an explicit bank choice when the user
    // actually CHANGED it; otherwise the detected bank is used.
    final prefilledBank = (transaction.merchantName ?? '').trim();
    final explicitBank =
        (bankText.isNotEmpty && bankText != prefilledBank) ? bankText : null;

    final cardLast4 = normalizeCardLast4(draft.last4Text.trim());
    // The edited row is written WITHOUT relying on the card id the stale
    // in-memory object carries. The authoritative assignment happens inside the
    // learning step below, in the SAME commit as the confirmed Last 4. Writing
    // `updated` (which still has the pre-edit `cardId`) after the identity was
    // applied is exactly what previously let the old object win.
    final updated = transaction.copyWith(
      type: draft.type,
      amountMinor: draft.amountMinor,
      currency: draft.currency,
      transactionDate: draft.transactionDate,
      bankId: bankId,
      // The Last 4 the user typed is persisted on the row even when the bank is
      // unknown: learning then refuses to guess, but the number is kept so the
      // identity can be resolved as soon as a bank is known.
      cardLast4: cardLast4 ?? transaction.cardLast4,
      categoryId: draft.categoryId,
      merchantName: draft.merchantName,
      updatedAt: DateTime.now(),
    );

    // LOCAL FIRST, and local only. The remote mirror of this row is scheduled in
    // the background so Save returns as soon as Drift commits.
    await transactionRepository.updateTransaction(
      transaction: updated,
      syncRemote: false,
    );

    SmartResolutionResult? learned;
    if (cardLast4 != null) {
      logInfo('[SMART CARD] Save started userId=$userId '
          'txn=${transaction.id} last4Raw=${draft.last4Text.trim()} '
          'last4Normalized=$cardLast4 '
          'bankRaw=${explicitBank ?? '<from detection>'}');
      // Resolves the identity, then commits `card_last4` + `card_id` for the
      // edited row AND every provable match, in ONE Drift transaction.
      learned = await moneyRepository.learnCardIdentity(
        userId: userId,
        transactionId: transaction.id,
        last4: cardLast4,
        bankIdentityOverride: explicitBank,
      );
      final result = learned;
      if (result != null) {
        logInfo('[SMART CARD] propagation committed '
            'cardId=${result.resolution.cardId} '
            'propagated=${result.propagatedTransactionIds.length} '
            'totalAssigned=${result.totalAssigned}');
      }
    }

    // The save is COMPLETE only once the committed row has been re-read from
    // the database. This is the authoritative post-commit state that the screen
    // is about to reload, and it proves no later write clobbered the freshly
    // learned card_id/card_last4 with the stale in-memory object.
    await _verifyCommittedRow(
      transaction.id,
      expectedLast4: cardLast4,
      expectedCardId: learned?.resolution.cardId,
    );

    // The card badge is cosmetic. It must never be able to abort the save and
    // skip the provider refresh, otherwise the database is correct while the
    // Transactions screen keeps rendering the pre-edit row.
    try {
      await _recomputeCardCounts();
    } catch (e) {
      logError('[SMART CARD] card count recompute skipped', e);
    }

    // Everything local is committed: let the UI show the result NOW.
    onChanged?.call();

    // The remote mirror of the edited row runs strictly AFTER the UI has been
    // told, and is never awaited. A failure here cannot affect what the user
    // just saved locally.
    transactionRepository.mirrorTransactionInBackground(updated);

    return learned;
  }

  /// Re-reads the committed edited row straight from the database and REPAIRS it
  /// if the confirmed identity did not stick.
  ///
  /// This is the `Re-read the transaction after commit to verify` step. It runs
  /// after every authoritative write (row update, learning, propagation) so the
  /// trace shows the real final state rather than the in-memory draft.
  ///
  /// The repair matters: if any later write restored the stale `card_id` or the
  /// un-persisted `card_last4`, the database would disagree with what the user
  /// just confirmed — and since the screen reloads from this same database, the
  /// UI would render the pre-edit row.
  Future<void> _verifyCommittedRow(
    String transactionId, {
    String? expectedLast4,
    String? expectedCardId,
  }) async {
    try {
      Future<Transaction?> read() async => (await transactionRepository
              .getTransactions(userId: userId, syncWithRemote: false))
          .where((r) => r.id == transactionId)
          .firstOrNull;

      final committed = await read();
      logInfo('[VERIFY DB] transactionId=$transactionId '
          'cardLast4=${committed?.cardLast4} cardId=${committed?.cardId}');

      if (committed == null) return;
      final last4Ok = expectedLast4 == null ||
          normalizeCardLast4(committed.cardLast4) == expectedLast4;
      final cardIdOk = expectedCardId == null ||
          committed.cardId == expectedCardId;
      if (last4Ok && cardIdOk) return;

      // Something overwrote the confirmed identity. Re-assert it so the
      // committed state is the one the user explicitly confirmed.
      logInfo('[VERIFY DB] repairing committed row txn=$transactionId '
          'expectedLast4=$expectedLast4 expectedCardId=$expectedCardId '
          'foundLast4=${committed.cardLast4} foundCardId=${committed.cardId}');
      await transactionRepository.restoreCardIdentity(
        transaction: committed,
        cardId: expectedCardId,
        last4: expectedLast4,
      );
      final repaired = await read();
      logInfo('[VERIFY DB] repaired txn=$transactionId '
          'cardLast4=${repaired?.cardLast4} cardId=${repaired?.cardId}');
    } catch (e) {
      logError('[VERIFY DB] read-back failed txn=$transactionId', e);
    }
  }

  /// Recomputes the per-card transaction badge through the SAME ownership rule
  /// the balances use, so the badge can never disagree with the figures.
  Future<void> _recomputeCardCounts() async {
    final transactions = await transactionRepository
        .getTransactions(userId: userId, syncWithRemote: false);
    final cards = await cardRepository.getCards(userId);
    await cardRepository.recomputeTransactionCountsForCards(
      userId,
      (DetectedCard card) =>
          CardOwnership.forCard(transactions, card, cards).length,
    );
  }
}
