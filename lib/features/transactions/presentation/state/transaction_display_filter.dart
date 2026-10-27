import 'package:flutter_bloc/flutter_bloc.dart';

/// DISPLAY-ONLY date/time filter for the Transactions screen.
///
/// TWO COMPLETELY DIFFERENT CONCEPTS — never mix them:
///
///   A) SMS INGESTION / PROCESSING decides which SMS have already been
///      processed and permanently stored (owned by `SmsPollingService`, the
///      processed-SMS ledger and `SmsSyncStateStore`).
///   B) THIS FILTER decides which ALREADY STORED transactions are visible in
///      the Transactions screen.
///
/// Guarantees:
///   * `none` (the default) shows ALL stored transactions.
///   * A selected range is INCLUSIVE on both bounds
///     (`start 00:00 → end 23:59` keeps transactions at both boundaries).
///   * Changing/clearing this filter NEVER triggers an SMS scan, NEVER deletes
///     or recreates transactions and NEVER touches the ingestion pipeline.
///     It only changes the local-database query of the Transactions screen.
class TransactionDisplayFilter {
  /// Inclusive lower bound, or null for "no lower bound".
  final DateTime? startDateTime;

  /// Inclusive upper bound, or null for "no upper bound".
  final DateTime? endDateTime;

  const TransactionDisplayFilter({this.startDateTime, this.endDateTime});

  /// Default state: NO filter → show ALL stored transactions.
  const TransactionDisplayFilter.none()
      : startDateTime = null,
        endDateTime = null;

  bool get isActive => startDateTime != null || endDateTime != null;

  /// True when [instant] falls inside this filter (inclusive on both bounds).
  bool contains(DateTime instant) {
    if (startDateTime != null && instant.isBefore(startDateTime!)) {
      return false;
    }
    if (endDateTime != null && instant.isAfter(endDateTime!)) {
      return false;
    }
    return true;
  }

  /// True when this filter accepts everything (used to skip re-querying).
  bool get isUnbounded => startDateTime == null && endDateTime == null;

  @override
  bool operator ==(Object other) =>
      other is TransactionDisplayFilter &&
      other.startDateTime == startDateTime &&
      other.endDateTime == endDateTime;

  @override
  int get hashCode => Object.hash(startDateTime, endDateTime);

  @override
  String toString() =>
      'TransactionDisplayFilter($startDateTime → $endDateTime)';
}

/// Holds the Transactions screen display filter.
///
/// Deliberately in-memory only (not persisted): the app always OPENS with
/// "no filter → show all stored transactions", per the product contract.
class TransactionFilterCubit extends Cubit<TransactionDisplayFilter> {
  TransactionFilterCubit() : super(const TransactionDisplayFilter.none());

  /// Applies a start/end range (both inclusive). Throws [ArgumentError] when
  /// start > end so an invalid selection can never hide data silently.
  void setRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      throw ArgumentError('Filter start must not be after end');
    }
    emit(TransactionDisplayFilter(startDateTime: start, endDateTime: end));
  }

  /// Removes the filter → the screen shows ALL stored transactions again.
  void clear() => emit(const TransactionDisplayFilter.none());
}
