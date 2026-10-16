import 'dart:async';

import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../models/detected_card_model.dart';
import '../repositories/detected_card_repository.dart';
import '../repositories/money_repository.dart';
import '../local/datasources/processed_sms_local_datasource.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../remote/datasources/sms_remote_datasource.dart';
import 'bank_sender_mapping_store.dart';
import 'sms_parser_service.dart';
import '../../core/utils/app_logger.dart';

/// Orchestrates the SMS pipeline:
///
///   SMS text + sender
///     â†’ SMSParser (bank detection, type/direction, amount, currency, card)
///     â†’ remote sms_messages detection record (all stage results)
///     â†’ SMS-level dedupe (sms_messages unique hash)   [idempotency layer 1]
///     â†’ resolve real bank id + matching user bank account
///     â†’ money-ledger write (fingerprint dedupe + money
///       rules)                                        [idempotency layer 2]
///     â†’ DetectedCardRepository upsert (last4 + bank â†’ linked card)
///
/// The original SMS body is persisted in the detection record so review and
/// relationship auditing are possible. Logging still uses only sanitized data.

class SMSTransactionProcessor {
  /// Remote sms_messages calls (dedupe check, metadata insert, link) are
  /// bounded so an offline/hung network can never stall a scan. Injectable
  /// for tests.
  final Duration smsRecordTimeout;
  final Duration cardLinkTimeout;

  final MoneyRepository moneyRepository;
  final DetectedCardRepository? detectedCardRepository;
  final SmsRemoteDataSource? smsRemoteDataSource;
  final BankSenderMappingStore? bankSenderMappingStore;
  final ProcessedSmsLocalDataSource? processedSmsLocalDataSource;
  final SmsMessageLocalDataSource? smsMessageLocalDataSource;
  final _uuid = const Uuid();

  SMSTransactionProcessor({
    required this.moneyRepository,
    this.detectedCardRepository,
    this.smsRemoteDataSource,
    this.bankSenderMappingStore,
    this.processedSmsLocalDataSource,
    this.smsMessageLocalDataSource,
    this.smsRecordTimeout = const Duration(seconds: 8),
    this.cardLinkTimeout = const Duration(seconds: 8),
  });

  /// Process one SMS. Returns true when a transaction was recorded,
  /// false when it was a duplicate or deliberately skipped.
  Future<bool> process({
    required String userId,
    required String smsContent,
    String? sender,
    List<Bank> knownBanks = const [],
    String? overrideTypeName,
    String? overrideAccountId,
    DateTime? receivedAt,
  }) async {
    final parsed = await SMSParser.parse(
      smsContent: smsContent,
      sender: sender,
      knownBanks: knownBanks,
    );

    // -- SENDER/BANK VALIDATION FIRST (requirement #4) -----------------------
    // The sender identity is resolved BEFORE any financial keyword or amount
    // is trusted. Order:
    //   1. automatic bank detection (already ran inside the parser â€” sender
    //      + body matched against the remote/static bank catalog);
    //   2. previously saved manual senderâ†’bank mapping (requirement #5);
    //   3. only then may the message proceed to transaction handling.
    // A message from an UNRECOGNIZED sender NEVER becomes a transaction,
    // even when its body contains "purchase"/"EGP"/amounts â€” the sender is
    // recorded as unknown and the user assigns the bank once in Settings â†’
    // Bank Mappings. From then on every message from that sender is
    // processed automatically (nothing is discarded â€” requirement #5).
    var bankName = parsed.bankName;
    var hasIdentifiedBank =
        (parsed.bankId != null && parsed.bankId!.isNotEmpty) ||
            (bankName != null && bankName.trim().isNotEmpty);
    if (!hasIdentifiedBank &&
        bankSenderMappingStore != null &&
        (sender ?? '').trim().isNotEmpty) {
      final mapped =
          await bankSenderMappingStore!.getBankForSender(userId, sender!);
      if (mapped != null) {
        bankName = mapped;
        hasIdentifiedBank = true;
        logInfo('SMS_BANK_IDENTIFIED via manual mapping: $mapped');
      } else if (!SMSParser.isRecognizedBankOrWalletSender(
        sender: sender,
        knownBanks: knownBanks,
      )) {
        // Not mapped AND not a recognized bank/wallet identifier: record it
        // for the manual Bank Mappings fallback (requirement #5) and skip.
        // A RECOGNIZED wallet/bank identifier (IPN, Vodafone Cash, ...) falls
        // through to the wallet handling below instead of being dropped --
        // those are legitimate financial messages and must never be discarded
        // just because no manual mapping exists yet.
        await bankSenderMappingStore!.markUnknown(userId, sender);
        logInfo('SMS_BANK_UNKNOWN sender=$sender â€” not a validated bank '
            'sender; skipped (pending manual assignment)');
        return false;
      }
    } else if (hasIdentifiedBank) {
      logInfo('SMS_BANK_IDENTIFIED: $bankName');
    }

    // Requirement #2/#13: the sender may ALREADY have been validated as a
    // bank/wallet financial identifier by the ingestion gate (e.g. IPN â†’
    // InstaPay, Vodafone Cash, CIB, NBE) without matching the static bank
    // catalog. Those wallet SMS are valid financial messages â€” they MUST be
    // preserved as transactions with a display bank name derived from the
    // validated sender, never silently discarded. No bank account is linked
    // (bankId stays null) until the user links one â€” the transaction is
    // still created and visible.
    if (!hasIdentifiedBank &&
        SMSParser.isRecognizedBankOrWalletSender(
          sender: sender,
          knownBanks: knownBanks,
        )) {
      bankName = _walletDisplayName(sender);
      hasIdentifiedBank = true;
      logInfo('SMS_BANK_IDENTIFIED via recognized wallet/sender identifier: '
          '$sender â†’ $bankName');
    }

    if (!hasIdentifiedBank) {
      logInfo('SMS_BANK_UNKNOWN sender=$sender â€” empty sender ignored');
      return false;
    }

    // Deterministic sender+body identity used by the local ledger and
    // remote sms_messages unique index.
    final messageHash = SMSParser.fingerprintOf('${sender ?? ''}|$smsContent');
    String? bankId = parsed.bankId == null || parsed.bankId!.isEmpty
        ? _resolveRemoteBankId(bankName, knownBanks)
        : parsed.bankId;

    // Persist the complete detection result before any transaction decision.
    // Failed stages are intentionally not added to the successful-message
    // ledger, so they remain reviewable and retryable.
    final localDetection = SMSMessage(
      id: _uuid.v4(),
      userId: userId,
      sender: sender,
      messageHash: messageHash,
      messageBody: smsContent,
      receivedAt: receivedAt ?? DateTime.now(),
      bankIdentified: hasIdentifiedBank,
      typeIdentified: parsed.type != null || overrideTypeName != null,
      amountIdentified: parsed.amountMinor != null,
      currencyIdentified: parsed.currency.isNotEmpty,
      cardLast4Identified: parsed.cardLast4 != null,
      detectedBankId: bankId,
      detectedBankName: bankName,
      detectedType: parsed.type?.name ?? overrideTypeName,
      detectedAmountMinor: parsed.amountMinor,
      detectedCurrency: parsed.currency,
      detectedCardLast4: parsed.cardLast4,
      processingStatus: 'detected',
      parserVersion: '3',
      confidence: parsed.confidence,
    );
    try {
      await smsMessageLocalDataSource?.upsert(localDetection);
    } catch (e) {
      logError('SMS_LOCAL_DETECTION_PERSIST_FAILED hash=$messageHash', e);
    }
    SMSMessage? remoteDetectionRecord;
    if (smsRemoteDataSource != null) {
      try {
        // The local mirror keeps the stable local row id. The remote row may
        // have a different generated id, so completion is best-effort and does
        // not replace [localDetection].
        remoteDetectionRecord = await smsRemoteDataSource!
            .upsertSmsMessage(
              SMSMessage(
                id: _uuid.v4(),
                userId: userId,
                sender: sender,
                messageHash: messageHash,
                messageBody: smsContent,
                receivedAt: receivedAt ?? DateTime.now(),
                bankIdentified: hasIdentifiedBank,
                typeIdentified: parsed.type != null || overrideTypeName != null,
                amountIdentified: parsed.amountMinor != null,
                currencyIdentified: parsed.currency.isNotEmpty,
                cardLast4Identified: parsed.cardLast4 != null,
                detectedBankId: bankId,
                detectedBankName: bankName,
                detectedType: parsed.type?.name ?? overrideTypeName,
                detectedAmountMinor: parsed.amountMinor,
                detectedCurrency: parsed.currency,
                detectedCardLast4: parsed.cardLast4,
                processingStatus: 'detected',
                parserVersion: '3',
                confidence: parsed.confidence,
              ),
            )
            .timeout(smsRecordTimeout);
        logInfo('SMS_MESSAGE_PERSISTED hash=$messageHash');
      } on TimeoutException {
        logError('SMS_RECORD_TIMEOUT proceeding with transaction', 'timeout');
      } catch (e) {
        logError('SMS_MESSAGE_PERSIST_FAILED hash=$messageHash', e);
      }
    }

    // Resolve the destination card BEFORE the transaction is created so the
    // row is written with its final `card_id`.
    //
    // ORDER MATTERS: the LEARNED identity (`user + bank + last4`) is consulted
    // FIRST, so a future SMS for a card the user has already confirmed is
    // routed at creation time instead of sitting unassigned until someone
    // notices the red dot. Only when nothing was learned do we fall back to
    // discovering a brand-new card from this message.
    //
    // When the SMS carries no card number there is NO card to resolve, and we
    // deliberately do not substitute the currently selected card, the last
    // selected card, the first card or any other fallback. The transaction is
    // stored unassigned and keeps its red-dot indicator until the user supplies
    // a card number.
    DetectedCard? detectedCard;
    if (parsed.cardLast4 != null && parsed.cardLast4!.isNotEmpty) {
      final learned = await moneyRepository.findLearnedCardIdentity(
        userId: userId,
        last4: parsed.cardLast4!,
        bankName: bankName,
      );
      if (learned != null) {
        detectedCard = learned;
        logInfo('SMS_CARD_LEARNED_HIT last4=${parsed.cardLast4} '
            'bank=$bankName -> card=${learned.id}');
      } else {
        detectedCard = await _upsertDetectedCard(
          userId: userId,
          last4: parsed.cardLast4!,
          bankName: bankName,
        );
        if (detectedCard == null) {
          logInfo('SMS_CARD_UNRESOLVED last4=${parsed.cardLast4} '
              'bank=$bankName -> transaction stays unassigned');
        }
      }
    }

    if (parsed.amountMinor == null) {
      logWarning('TRANSACTION_SKIPPED hash=$messageHash reason=amount');
      await _updateDetectionStatus(localDetection, remoteDetectionRecord, 'needs_review');
      return false;
    }

    var type = parsed.type;
    if (overrideTypeName != null) {
      for (final t in TransactionType.values) {
        if (t.name == overrideTypeName) {
          type = t;
          break;
        }
      }
    }
    if (type == null) {
      logWarning('TRANSACTION_SKIPPED hash=$messageHash reason=type');
      await _updateDetectionStatus(localDetection, remoteDetectionRecord, 'needs_review');
      return false;
    }

    logInfo('SMS_TYPE_IDENTIFIED: ${type.name}');
    logInfo('SMS_AMOUNT_IDENTIFIED: ${parsed.amountMinor}');
    logInfo('SMS_CURRENCY_IDENTIFIED: ${parsed.currency}');
      logInfo('SMS_CARD_LAST4_IDENTIFIED present=${parsed.cardLast4 != null}');

    // Resolve the user's bank account (multi-bank). A missing account is
    // allowed: the transaction still remains visible and can be linked later.
    String? accountId = overrideAccountId;
    try {
      accountId ??=
          await _resolveAccountId(userId, bankId).timeout(smsRecordTimeout);
    } on TimeoutException catch (e) {
      logError('SMS_ACCOUNT_LOOKUP_TIMEOUT proceeding without account', e);
    }

    final transaction = Transaction(
      id: _uuid.v4(),
      userId: userId,
      bankId: bankId,
      type: type,
      source: TransactionSource.sms,
      amountMinor: parsed.amountMinor!,
      currency: parsed.currency,
      transactionDate: receivedAt ?? DateTime.now(),
      merchantName: parsed.merchant ?? bankName,
      cardLast4: parsed.cardLast4,
      // Stamped at creation time. Null when the SMS carried no card number or
      // the card could not be resolved -> the row stays unassigned (red dot).
      cardId: detectedCard?.id,
      rawReference: messageHash,
      fingerprint: parsed.fingerprint,
      status: TransactionStatus.confirmed,
    );

    final recorded = await moneyRepository.recordSmsTransaction(
      userId: userId,
      transaction: transaction,
      accountId: accountId,
    );

    // The remote detection row is already persisted. Set its final state and
    // relationship only after the authoritative money-ledger write succeeds.
    if (recorded) {
      await _completeDetection(localDetection, remoteDetectionRecord, transaction.id);
      logInfo('TRANSACTION_CREATED id=${transaction.id} source=sms');
    } else {
      logInfo('TRANSACTION_SKIPPED id=${transaction.id} reason=duplicate');
    }

    // Mark this SMS as processed in the LOCAL ledger (authoritative
    // per-message processed identity â€” survives app restarts, works offline).
    // This closes requirement #12/#13: range changes NEVER reset processed
    // history, and future scans skip already-processed messages.
    if (recorded) {
      try {
        await processedSmsLocalDataSource?.markProcessed(
          ProcessedSmsRecord(
            id: 'ps-${transaction.id}',
            userId: userId,
            sender: sender,
            messageHash: messageHash,
            receivedAt: transaction.transactionDate,
            transactionId: transaction.id,
            processedAt: DateTime.now(),
          ),
        );
      } catch (e) {
        logError(
            'SMS_MARK_PROCESSED_FAILED hash=$messageHash â€” transaction '
            'persisted but ledger update failed (safe: will be re-checked on '
            'next scan)',
            e);
      }
    }

    // Relationship is maintained by sms_messages.transaction_id and
    // transaction.raw_reference. Do not delete or mutate the source message
    // when a transaction is edited/deleted.
    if (recorded) {
      // _completeDetection above already performed the bounded remote link.
      logInfo('SMS_MESSAGE_PERSISTED hash=$messageHash');
    }

    // Count the card only when a new transaction was actually persisted
    // (dedupe-safe). The Card -> Transaction link is already part of the
    // transaction row itself (stamped at creation above), so there is no
    // detached re-link to run here â€” only the denormalised counter is bumped,
    // off the critical path so a slow write never stalls the SMS scan.
    if (recorded && detectedCard != null) {
      final countedCard = detectedCard;
      unawaited(() async {
        await _upsertDetectedCard(
          userId: userId,
          last4: countedCard.last4,
          bankName: countedCard.bankName,
          transactionCountDelta: 1,
        );
      }());
    }

    return recorded;
  }

  Future<void> _completeDetection(
    SMSMessage localRecord,
    SMSMessage? remoteRecord,
    String transactionId,
  ) async {
    final localLinked = localRecord.copyWith(
      transactionId: transactionId,
      processingStatus: 'processed',
      processedAt: DateTime.now().toUtc(),
    );
    try {
      await smsMessageLocalDataSource?.upsert(localLinked);
    } catch (e) {
      logError('SMS_LOCAL_DETECTION_LINK_FAILED transaction=$transactionId', e);
    }
    if (smsRemoteDataSource == null || remoteRecord == null) return;
    try {
      await smsRemoteDataSource!
          .updateSmsMessage(remoteRecord.copyWith(
            transactionId: transactionId,
            processingStatus: 'processed',
            processedAt: DateTime.now().toUtc(),
          ))
          .timeout(smsRecordTimeout);
      logInfo('SMS_MESSAGE_LINKED transaction=$transactionId');
    } catch (e) {
      logError('SMS_MESSAGE_LINK_FAILED transaction=$transactionId', e);
    }
  }

  Future<void> _updateDetectionStatus(
    SMSMessage localRecord,
    SMSMessage? remoteRecord,
    String status,
  ) async {
    try {
      await smsMessageLocalDataSource?.upsert(localRecord.copyWith(processingStatus: status));
    } catch (e) {
      logError('SMS_LOCAL_DETECTION_STATUS_UPDATE_FAILED status=$status', e);
    }
    if (smsRemoteDataSource == null || remoteRecord == null) return;
    try {
      await smsRemoteDataSource!
          .updateSmsMessage(remoteRecord.copyWith(processingStatus: status))
          .timeout(smsRecordTimeout);
    } catch (e) {
      logError('SMS_MESSAGE_STATUS_UPDATE_FAILED status=$status', e);
    }
  }

  /// Creates-or-updates the detected card for a parsed last4 and returns it.
  ///
  /// Returns the card so the caller can stamp `card_id` on the transaction it
  /// is about to create, instead of writing the transaction first and patching
  /// `card_id` in a detached background task. Writing the link up-front is what
  /// makes "one transaction -> one correct card" true at rest, not just after a
  /// background job happens to succeed.
  ///
  /// Returns null when the card could not be created (offline/timeout); the
  /// transaction then stays UNASSIGNED and keeps its red dot rather than being
  /// pointed at an arbitrary card.
  Future<DetectedCard?> _upsertDetectedCard({
    required String userId,
    required String last4,
    required String? bankName,
    int transactionCountDelta = 0,
  }) async {
    try {
      return await detectedCardRepository
          ?.upsertCard(
            userId: userId,
            last4: last4,
            bankName: bankName,
            transactionCountDelta: transactionCountDelta,
          )
          .timeout(cardLinkTimeout);
    } on TimeoutException {
      logError('SMS_CARD_LINK_TIMEOUT last4=$last4', 'timeout');
      return null;
    } catch (e) {
      logInfo('[SMS] Failed to upsert detected card: $e');
      return null;
    }
  }

  /// Repairs legacy transactions that were stored WITHOUT a `card_id`.
  ///
  /// Now a thin delegate to the central smart resolver, so the backfill obeys
  /// EXACTLY the same deterministic rules as manual Last 4 entry and the red-dot
  /// indicator — there is no second, weaker implementation to drift.
  ///
  /// It resolves only what is provable (unique last4, or last4 + a bank that
  /// narrows several candidates to one) and is idempotent, so running it on
  /// every scan is safe and cheap. Rows it cannot prove keep their red dot.
  ///
  /// Returns the number of rows repaired.
  Future<int> backfillUnlinkedTransactionCards(String userId) async {
    try {
      return await moneyRepository.backfillCardIdentities(userId);
    } catch (e) {
      logError('SMS_CARD_BACKFILL_FAILED userId=$userId', e);
      return 0;
    }
  }


  /// Human-friendly display bank name for a validated wallet/sender
  /// identifier (requirement #2). Recognized wallet identifiers are not in
  /// the static bank catalog, so their messages get a readable name instead
  /// of being dropped.
  String _walletDisplayName(String? sender) {
    final normalized = (sender ?? '').trim();
    if (normalized.isEmpty) return 'Unknown';
    switch (normalized.toLowerCase()) {
      case 'ipn':
        return 'InstaPay';
      default:
        return normalized; // 'Vodafone Cash', 'CIB', 'NBE', â€¦ as-is.
    }
  }

  /// Resolve the real remote bank id from the runtime catalog by matching
  /// the detected bank name (English, Arabic or code). Generic for every
  /// bank â€” used when the parser fell back to the static offline catalog
  /// which carries no database ids.
  String? _resolveRemoteBankId(String? bankName, List<Bank> knownBanks) {
    if (bankName == null || bankName.trim().isEmpty) return null;
    final target = bankName.trim().toLowerCase();
    for (final bank in knownBanks) {
      final code = (bank.code ?? '').trim().toLowerCase();
      final name = bank.name.trim().toLowerCase();
      final nameAr = (bank.nameAr ?? '').trim().toLowerCase();
      if (name == target || (nameAr.isNotEmpty && nameAr == target)) {
        return bank.id;
      }
      // "Faisal Bank" detected from a catalog entry while the remote name
      // is slightly different (e.g. includes the code suffix).
      if (code.isNotEmpty && target.contains(code)) return bank.id;
      if (name.isNotEmpty && (name.contains(target) || target.contains(name))) {
        return bank.id;
      }
      if (nameAr.isNotEmpty && target.contains(nameAr)) return bank.id;
    }
    return null;
  }

  /// Find the user's first bank account that matches the detected bank.
  Future<String?> _resolveAccountId(String userId, String? bankId) async {
    if (bankId == null || bankId.isEmpty) return null;
    final accounts = await moneyRepository.getBankAccounts(userId);
    final active = accounts.where((a) => a.isActive && a.bankId == bankId);
    if (active.isNotEmpty) return active.first.id;
    // If the static catalog gave us an empty id, match by name.
    return null;
  }
}
