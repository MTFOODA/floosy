import '../services/card_ownership.dart';

/// Outcome of a smart-resolution attempt.
class SmartResolutionResult {
  /// The central resolver's verdict, used verbatim by the red-dot UI so the
  /// indicator can never disagree with what the resolver actually proved.
  final CardOwnershipResolution resolution;

  /// True when the explicitly edited transaction itself was assigned.
  final bool transactionAssigned;

  /// Ids of additional unresolved transactions that were safely propagated.
  final List<String> propagatedTransactionIds;

  /// True when this call wrote a card assignment (created identity or assigned
  /// rows). False when nothing needed to change — which is what makes repeated
  /// confirmations idempotent.
  final bool identityWasCreated;

  const SmartResolutionResult({
    required this.resolution,
    this.transactionAssigned = false,
    this.propagatedTransactionIds = const [],
    this.identityWasCreated = false,
  });

  bool get isResolved => resolution.isResolved;
  bool get isAmbiguous => resolution is Ambiguous;
  bool get isUnresolved => resolution is Unresolved;

  /// Total rows written, including the edited transaction.
  int get totalAssigned =>
      (transactionAssigned ? 1 : 0) + propagatedTransactionIds.length;
}
