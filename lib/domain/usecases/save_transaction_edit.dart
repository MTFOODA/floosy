import '../entities/detected_card_model.dart';
import '../entities/transaction_model.dart';
import '../entities/user_model.dart';
import '../repositories/detected_card_repository.dart';
import '../repositories/transaction_repository.dart';
import '../services/card_ownership.dart';
import '../entities/card_resolution_result.dart';
import '../repositories/money_repository.dart';
import '../entities/transaction_edit_policy.dart';
import '../entities/bank_directory.dart';

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
  final String? additionalNote;
  final String? selectedCardId;

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
    this.additionalNote,
    this.selectedCardId,
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
class SaveTransactionEdit {
  SaveTransactionEdit({
    required this.userId,
    required this.transactionRepository,
    required this.moneyRepository,
    required this.cardRepository,
    required this.bankCatalogLoader,
    this.onChanged,
    this.trace = _silentTrace,
    this.reportError = _silentError,
  });

  static void _silentTrace(String message) {}
  static void _silentError(String message, Object error, [StackTrace? stack]) {}
  final void Function(String) trace;
  final void Function(String, Object, [StackTrace?]) reportError;

  final String userId;
  final TransactionRepository transactionRepository;
  final MoneyRepository moneyRepository;
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
  Future<TransactionEditPolicy> policy(Transaction transaction) async {
    final repository = transactionRepository;
    var current = (await repository.getTransactions(
      userId: userId,
      syncWithRemote: false,
    )).where((t) => t.id == transaction.id).firstOrNull;
    if (current == null || current.userId != userId) {
      throw const TransactionEditFailure('notFound');
    }
    var evidence = repository is TransactionEvidenceRepository
        ? await (repository as TransactionEvidenceRepository).editEvidence(
            userId,
            current.id,
          )
        : null;
    final cards = await cardRepository.getCards(userId);
    final linkedId = current.cardId;
    final linked = cards.where((card) => card.id == linkedId).firstOrNull;
    if (linked != null) {
      current = current.copyWith(cardLast4: current.cardLast4 ?? linked.last4);
      evidence = TransactionEditEvidence(
        bankName: evidence?.bankName ?? linked.bankName,
        typeIdentified: evidence?.typeIdentified ?? true,
        amountIdentified: evidence?.amountIdentified ?? current.amountMinor > 0,
        currencyIdentified:
            evidence?.currencyIdentified ?? current.currency.isNotEmpty,
      );
    }
    final rules = TransactionEditPolicy(current, evidence);
    final knownLast4 = normalizeCardLast4(current.cardLast4);
    final knownBank = rules.bankName;
    final options = cards.where((card) {
      if (linked != null &&
          rules.transaction.source != TransactionSource.manual) {
        return false;
      }
      if (!rules.bank && knownBank == null) return false;
      return (knownLast4 == null || card.last4 == knownLast4) &&
          (knownBank == null || sameIssuingBank(card.bankName, knownBank));
    }).toList();
    return TransactionEditPolicy(
      current,
      evidence,
      cardOptions: linked != null && options.length <= 1 ? const [] : options,
    );
  }

  Future<SmartResolutionResult?> save(TransactionEditDraft draft) {
    final repository = transactionRepository;
    return repository is TransactionEvidenceRepository
        ? (repository as TransactionEvidenceRepository).editAtomically(
            () => _save(draft),
          )
        : _save(draft);
  }

  Future<SmartResolutionResult?> _save(TransactionEditDraft draft) async {
    final rules = await policy(draft.transaction);
    final transaction = rules.transaction;
    final selectedCard = rules.cardOptions
        .where((card) => card.id == draft.selectedCardId)
        .firstOrNull;
    if (draft.selectedCardId != null && selectedCard == null) {
      throw const TransactionEditFailure('locked');
    }
    if ((!rules.type && draft.type != transaction.type) ||
        (!rules.amount && draft.amountMinor != transaction.amountMinor) ||
        (!rules.currency && draft.currency != transaction.currency) ||
        !draft.transactionDate.isAtSameMomentAs(transaction.transactionDate) ||
        (selectedCard == null &&
            !rules.last4 &&
            normalizeCardLast4(draft.last4Text) != transaction.cardLast4) ||
        (!rules.category && draft.categoryId != transaction.categoryId) ||
        (!rules.merchant && draft.merchantName != transaction.merchantName)) {
      throw const TransactionEditFailure('locked');
    }
    if (rules.amount && draft.amountMinor <= 0) {
      throw const TransactionEditFailure('amount');
    }
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(draft.currency)) {
      throw const TransactionEditFailure('currency');
    }
    final bankText = (selectedCard?.bankName ?? draft.bankText).trim();
    if (!rules.bank && bankText.isNotEmpty) {
      if (bankText != transaction.bankId &&
          !sameIssuingBank(bankText, rules.bankName)) {
        throw const TransactionEditFailure('locked');
      }
    }

    // Resolve the bank UUID the transactions table stores. This is display
    // information only and is NOT the card identity.
    String? bankId = transaction.bankId;
    if (selectedCard == null && rules.bank && bankText.isNotEmpty) {
      List<Bank> known;
      try {
        known = await bankCatalogLoader().timeout(const Duration(seconds: 3));
      } catch (_) {
        known = const [];
      }
      final canonical = BankCatalog.byIdentity(bankText);
      final match = known
          .where(
            (b) =>
                b.id == bankText ||
                b.name == bankText ||
                b.code == bankText ||
                (canonical != null &&
                    (BankCatalog.byIdentity(b.code) ??
                                BankCatalog.byIdentity(b.name))
                            ?.code ==
                        canonical.code),
          )
          .toList();
      bankId = match.isEmpty ? null : match.first.id;
    }

    // A bank choice only completes an unknown bank. Merchant text is never
    // treated as an issuing-bank identity or allowed to replace a known bank.
    final explicitBank = rules.bank && bankText.isNotEmpty
        ? (BankCatalog.byIdentity(bankText)?.name ?? bankText)
        : null;

    final cardLast4 =
        selectedCard?.last4 ?? normalizeCardLast4(draft.last4Text);
    if (draft.last4Text.trim().isNotEmpty && cardLast4 == null) {
      throw const TransactionEditFailure('last4');
    }
    // Manual entries with a typed bank and last four should reuse the existing
    // identity. A pre-existing duplicate requires the user's explicit choice.
    final typedMatches =
        selectedCard == null &&
            cardLast4 != null &&
            transaction.source == TransactionSource.manual &&
            transaction.cardId?.isNotEmpty != true &&
            (explicitBank ?? rules.bankName) != null
        ? (await cardRepository.getCards(userId))
              .where(
                (card) =>
                    card.last4 == cardLast4 &&
                    sameIssuingBank(
                      card.bankName,
                      explicitBank ?? rules.bankName,
                    ),
              )
              .toList()
        : const <DetectedCard>[];
    if (typedMatches.length > 1) {
      throw const TransactionEditFailure('chooseCard');
    }
    final targetCard = selectedCard ?? typedMatches.firstOrNull;
    final updated = transaction.copyWith(
      type: draft.type,
      amountMinor: draft.amountMinor,
      currency: draft.currency,
      status: transaction.status,
      transactionDate: draft.transactionDate,
      bankId: bankId,
      cardId: targetCard?.id ?? transaction.cardId,
      // The Last 4 the user typed is persisted on the row even when the bank is
      // unknown: learning then refuses to guess, but the number is kept so the
      // identity can be resolved as soon as a bank is known.
      cardLast4: cardLast4 ?? transaction.cardLast4,
      categoryId: draft.categoryId,
      merchantName: draft.merchantName,
      notes: draft.additionalNote?.trim().isNotEmpty == true
          ? [
              if (transaction.notes?.isNotEmpty == true) transaction.notes!,
              draft.additionalNote!.trim(),
            ].join('\n')
          : transaction.notes,
      updatedAt: DateTime.now(),
    );

    // LOCAL FIRST, and local only. The remote mirror of this row is scheduled in
    // the background so Save returns as soon as Drift commits.
    await transactionRepository.updateTransaction(
      transaction: updated,
      syncRemote: false,
    );
    final repository = transactionRepository;
    if (repository is TransactionEvidenceRepository) {
      await (repository as TransactionEvidenceRepository).completeEvidence(
        userId,
        transaction.id,
        bankName: explicitBank,
        cardLast4: selectedCard?.last4,
        type: rules.type ? draft.type : null,
        amountMinor: rules.amount ? draft.amountMinor : null,
        currency: rules.currency ? draft.currency : null,
      );
    }

    SmartResolutionResult? learned = targetCard == null
        ? null
        : SmartResolutionResult(
            resolution: Resolved(targetCard),
            transactionAssigned: true,
          );
    if (targetCard == null &&
        cardLast4 != null &&
        (transaction.cardId?.isEmpty != false ||
            rules.last4 ||
            explicitBank != null)) {
      trace(
        '[SMART CARD] Save started userId=$userId '
        'txn=${transaction.id} last4Raw=${draft.last4Text.trim()} '
        'last4Normalized=$cardLast4 '
        'bankRaw=${explicitBank ?? '<from detection>'}',
      );
      // Resolves the identity, then commits `card_last4` + `card_id` for the
      // edited row AND every provable match, in ONE Drift transaction.
      learned = await moneyRepository.learnCardIdentity(
        userId: userId,
        transactionId: transaction.id,
        last4: cardLast4,
        bankIdentityOverride: explicitBank ?? rules.bankName,
      );
      final result = learned;
      {
        trace(
          '[SMART CARD] propagation committed '
          'cardId=${result.resolution.cardId} '
          'propagated=${result.propagatedTransactionIds.length} '
          'totalAssigned=${result.totalAssigned}',
        );
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
      reportError('[SMART CARD] card count recompute skipped', e);
    }

    // Everything local is committed: let the UI show the result NOW.
    onChanged?.call();

    // The remote mirror of the edited row runs strictly AFTER the UI has been
    // told, and is never awaited. A failure here cannot affect what the user
    // just saved locally.
    final committedForMirror = (await transactionRepository.getTransactions(
      userId: userId,
      syncWithRemote: false,
    )).where((t) => t.id == transaction.id).firstOrNull;
    transactionRepository.mirrorTransactionInBackground(
      committedForMirror ?? updated,
    );

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
      Future<Transaction?> read() async =>
          (await transactionRepository.getTransactions(
            userId: userId,
            syncWithRemote: false,
          )).where((r) => r.id == transactionId).firstOrNull;

      final committed = await read();
      trace(
        '[VERIFY DB] transactionId=$transactionId '
        'cardLast4=${committed?.cardLast4} cardId=${committed?.cardId}',
      );

      if (committed == null) return;
      final last4Ok =
          expectedLast4 == null ||
          normalizeCardLast4(committed.cardLast4) == expectedLast4;
      final cardIdOk =
          expectedCardId == null || committed.cardId == expectedCardId;
      if (last4Ok && cardIdOk) return;

      // Something overwrote the confirmed identity. Re-assert it so the
      // committed state is the one the user explicitly confirmed.
      trace(
        '[VERIFY DB] repairing committed row txn=$transactionId '
        'expectedLast4=$expectedLast4 expectedCardId=$expectedCardId '
        'foundLast4=${committed.cardLast4} foundCardId=${committed.cardId}',
      );
      await transactionRepository.restoreCardIdentity(
        transaction: committed,
        cardId: expectedCardId,
        last4: expectedLast4,
      );
      final repaired = await read();
      trace(
        '[VERIFY DB] repaired txn=$transactionId '
        'cardLast4=${repaired?.cardLast4} cardId=${repaired?.cardId}',
      );
    } catch (e) {
      reportError('[VERIFY DB] read-back failed txn=$transactionId', e);
    }
  }

  /// Recomputes the per-card transaction badge through the SAME ownership rule
  /// the balances use, so the badge can never disagree with the figures.
  Future<void> _recomputeCardCounts() async {
    final transactions = await transactionRepository.getTransactions(
      userId: userId,
      syncWithRemote: false,
    );
    final cards = await cardRepository.getCards(userId);
    await cardRepository.recomputeTransactionCountsForCards(
      userId,
      (DetectedCard card) =>
          CardOwnership.forCard(transactions, card, cards).length,
    );
  }
}
