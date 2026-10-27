/// A half-open inspection window used by *paginated historical SMS scans*.
///
/// IMPORTANT — this type describes an **SMS INGESTION** window only. It is
/// never the Transactions page display filter. Ingestion (which SMS have
/// already been processed and stored permanently) and display (which already
/// stored transactions are visible) are two independent concepts:
///
///   * ingestion   → [DetectionWindow] / the processed-SMS ledger / the
///                   persistent scan cursor;
///   * display     → `TransactionDisplayFilter` (Transactions page only).
///
/// `null` bounds mean unbounded in that direction (i.e. the whole available
/// inbox history).
class DetectionWindow {
  /// Inclusive lower bound, or null for "oldest available".
  final DateTime? start;

  /// Inclusive upper bound, or null for "newest available".
  final DateTime? end;

  const DetectionWindow(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      other is DetectionWindow && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DetectionWindow(start=$start, end=$end)';

  /// True when [instant] falls inside this window. If both bounds are null,
  /// everything is contained.
  bool containsDateTime(DateTime instant) {
    if (start != null && instant.isBefore(start!)) return false;
    if (end != null && instant.isAfter(end!)) return false;
    return true;
  }

  /// Approximate number of days spanned by this window.
  /// Unbounded (null) sides count as 30 days per side for estimation.
  int get durationInDays {
    final s = start ?? DateTime.now().subtract(const Duration(days: 30));
    final e = end ?? DateTime.now().add(const Duration(days: 30));
    return e.difference(s).inDays.clamp(1, 3650);
  }
}
