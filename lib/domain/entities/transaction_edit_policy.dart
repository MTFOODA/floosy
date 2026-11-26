import 'transaction_model.dart';
import 'bank_directory.dart';
import 'detected_card_model.dart';

class TransactionEditEvidence {
  final String? bankName;
  final bool typeIdentified;
  final bool amountIdentified;
  final bool currencyIdentified;
  const TransactionEditEvidence({
    this.bankName,
    required this.typeIdentified,
    required this.amountIdentified,
    required this.currencyIdentified,
  });
}

/// Existing facts are immutable. Unknown values may be completed once.
class TransactionEditPolicy {
  final Transaction transaction;
  final TransactionEditEvidence? evidence;
  final List<DetectedCard> cardOptions;
  const TransactionEditPolicy(
    this.transaction,
    this.evidence, {
    this.cardOptions = const [],
  });
  String? get bankName =>
      evidence?.bankName ??
      (transaction.source == TransactionSource.manual
          ? null
          : BankCatalog.byIdentity(transaction.merchantName)?.name);
  bool get amount =>
      transaction.amountMinor <= 0 && evidence?.amountIdentified != true;
  bool get type => evidence?.typeIdentified == false;
  bool get currency =>
      transaction.currency.trim().isEmpty ||
      evidence?.currencyIdentified == false;
  bool get bank =>
      (transaction.bankId?.trim().isEmpty ?? true) &&
      (bankName?.trim().isEmpty ?? true);
  bool get last4 => !RegExp(r'^\d{4}$').hasMatch(transaction.cardLast4 ?? '');
  bool get merchant =>
      (transaction.merchantName?.trim().isEmpty ?? true) ||
      BankCatalog.byIdentity(transaction.merchantName) != null;
  bool get category => transaction.categoryId?.trim().isEmpty ?? true;
}

class TransactionEditFailure implements Exception {
  final String code;
  const TransactionEditFailure(this.code);
}
