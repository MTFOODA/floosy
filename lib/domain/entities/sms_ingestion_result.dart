/// Aggregate result of one inbox scan.
///
/// The [scanned] / [transactionsCreated] / [duplicatesOrSkipped] / [errors]
/// counters keep their historical meaning; the additional optional counters
/// report the *stages* of a historical scan (requirement L) without breaking
/// existing callers or tests.
class SmsIngestionResult {
  final int scanned;
  final int transactionsCreated;
  final int duplicatesOrSkipped;
  final int errors;

  /// Messages that passed the supported-date gate AND the bank/wallet
  /// sender/domain gate (i.e. entered the financial-detection scope).
  final int eligible;

  /// Eligible messages already recorded in the processed ledger (skipped
  /// without re-parsing; requirement F).
  final int alreadyProcessed;

  /// Eligible-but-unprocessed messages that produced a stored transaction.
  final int newlyProcessed;

  /// Messages rejected by the non-financial-sender gate (requirement E).
  final int skippedNonBank;

  /// Eligible messages whose parse produced no storable transaction.
  final int parseFailures;

  /// Number of inbox pages/batches consumed by this scan (requirement D).
  final int pagesConsumed;

  /// True when the inbox signaled more messages remain but the scan hit its
  /// safety cap (requirement D). The caller must surface this.
  final bool truncated;

  /// Oldest message timestamp observed on the LAST page consumed by this
  /// result (pagination cursor). Null when the page was empty or this result
  /// is an aggregate. Internal to the ingestion paginator.
  final DateTime? oldestSeenOnPage;

  /// Newest message timestamp observed on the page (the top of the scanned
  /// region). Used by the polling cursor to advance `lastProcessedAt` without
  /// assuming that a timestamp identifies a message.
  final DateTime? newestSeenOnPage;

  const SmsIngestionResult({
    required this.scanned,
    required this.transactionsCreated,
    required this.duplicatesOrSkipped,
    required this.errors,
    this.eligible = 0,
    this.alreadyProcessed = 0,
    this.newlyProcessed = 0,
    this.skippedNonBank = 0,
    this.parseFailures = 0,
    this.pagesConsumed = 0,
    this.truncated = false,
    this.oldestSeenOnPage,
    this.newestSeenOnPage,
  });

  /// Adds the page/run counters of [other] (same-scan aggregation).
  /// The cursors of the LAST page win (newest = latest instant seen anywhere).
  SmsIngestionResult operator +(SmsIngestionResult other) {
    return SmsIngestionResult(
      scanned: scanned + other.scanned,
      transactionsCreated: transactionsCreated + other.transactionsCreated,
      duplicatesOrSkipped: duplicatesOrSkipped + other.duplicatesOrSkipped,
      errors: errors + other.errors,
      eligible: eligible + other.eligible,
      alreadyProcessed: alreadyProcessed + other.alreadyProcessed,
      newlyProcessed: newlyProcessed + other.newlyProcessed,
      skippedNonBank: skippedNonBank + other.skippedNonBank,
      parseFailures: parseFailures + other.parseFailures,
      pagesConsumed: pagesConsumed + other.pagesConsumed,
      truncated: truncated || other.truncated,
      oldestSeenOnPage: other.oldestSeenOnPage ?? oldestSeenOnPage,
      newestSeenOnPage: _laterOf(newestSeenOnPage, other.newestSeenOnPage),
    );
  }

  static DateTime? _laterOf(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  @override
  String toString() => 'SmsIngestionResult(scanned=$scanned, '
      'created=$transactionsCreated, skipped=$duplicatesOrSkipped, '
      'errors=$errors, eligible=$eligible, already=$alreadyProcessed, '
      'new=$newlyProcessed, nonBank=$skippedNonBank, '
      'parseFail=$parseFailures, pages=$pagesConsumed, '
      'truncated=$truncated)';
}
