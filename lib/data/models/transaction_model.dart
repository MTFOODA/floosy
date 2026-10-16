import 'package:freezed_annotation/freezed_annotation.dart';

// Enum values mirror the PostgreSQL enum values 1:1 (snake_case).
// ignore_for_file: constant_identifier_names
part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType {
  purchase,
  atm_withdrawal,
  cash_expense,
  income,
  transfer_in,
  transfer_out,
  adjustment,
  refund,
  reversal
}

extension TransactionTypeX on TransactionType {
  bool get isIncoming =>
      this == TransactionType.income ||
      this == TransactionType.transfer_in ||
      this == TransactionType.refund;

  bool get isOutgoing =>
      this == TransactionType.purchase ||
      this == TransactionType.atm_withdrawal ||
      this == TransactionType.cash_expense ||
      this == TransactionType.transfer_out;

  /// Money that reduces "My Balance" but increases "Deducted Money".
  bool get countsTowardsDeducted =>
      this == TransactionType.purchase ||
      this == TransactionType.cash_expense ||
      this == TransactionType.transfer_out;
}

enum TransactionSource { sms, manual, receipt, system, ai_assisted }

enum TransactionStatus { pending, confirmed, cancelled, reversed }

enum PaymentMethod { cash, card }

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

DateTime _dateTimeFromJsonRequired(dynamic value) =>
    DateTime.parse(value.toString()).toUtc();

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'bank_id') String? bankId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'merchant_id') String? merchantId,
    required TransactionType type,
    required TransactionSource source,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'transaction_date') required DateTime transactionDate,
    @JsonKey(name: 'merchant_name') String? merchantName,
    @JsonKey(name: 'card_last4') String? cardLast4,
    @JsonKey(name: 'card_id') String? cardId,
    @JsonKey(name: 'raw_reference') String? rawReference,
    @JsonKey(name: 'external_reference') String? externalReference,
    required String fingerprint,
    @Default(TransactionStatus.confirmed) TransactionStatus status,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
class SMSMessage with _$SMSMessage {
  const factory SMSMessage({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    String? sender,
    @JsonKey(name: 'message_hash') required String messageHash,
    @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
    required DateTime receivedAt,
    @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
    DateTime? processedAt,
    @JsonKey(name: 'processing_status') @Default('pending') String processingStatus,
    /// Original SMS body. Stored so the detection record remains auditable;
    /// callers/loggers must still avoid printing it.
    @JsonKey(name: 'message_body') String? messageBody,
    @JsonKey(name: 'bank_identified') @Default(false) bool bankIdentified,
    @JsonKey(name: 'type_identified') @Default(false) bool typeIdentified,
    @JsonKey(name: 'amount_identified') @Default(false) bool amountIdentified,
    @JsonKey(name: 'currency_identified') @Default(false) bool currencyIdentified,
    @JsonKey(name: 'card_last4_identified') @Default(false) bool cardLast4Identified,
    @JsonKey(name: 'detected_bank_id') String? detectedBankId,
    @JsonKey(name: 'detected_bank_name') String? detectedBankName,
    @JsonKey(name: 'detected_type') String? detectedType,
    @JsonKey(name: 'detected_amount_minor') int? detectedAmountMinor,
    @JsonKey(name: 'detected_currency') String? detectedCurrency,
    @JsonKey(name: 'detected_card_last4') String? detectedCardLast4,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'parser_version') String? parserVersion,
    double? confidence,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _SMSMessage;

  factory SMSMessage.fromJson(Map<String, dynamic> json) =>
      _$SMSMessageFromJson(json);
}

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime expenseDate,
    @JsonKey(name: 'payment_method') required PaymentMethod paymentMethod,
    @JsonKey(name: 'merchant_id') String? merchantId,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

@freezed
class ExpenseItem with _$ExpenseItem {
  const factory ExpenseItem({
    required String id,
    @JsonKey(name: 'expense_id') required String expenseId,
    @JsonKey(name: 'item_id') required String itemId,
    required int quantity,
    @JsonKey(name: 'unit_price_minor') required int unitPriceMinor,
    @JsonKey(name: 'total_price_minor') required int totalPriceMinor,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _ExpenseItem;

  factory ExpenseItem.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemFromJson(json);
}

@freezed
class ItemUsage with _$ItemUsage {
  const factory ItemUsage({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'expense_id') required String expenseId,
    required int quantity,
    @JsonKey(name: 'total_amount_minor') required int totalAmountMinor,
    @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime usageDate,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _ItemUsage;

  factory ItemUsage.fromJson(Map<String, dynamic> json) =>
      _$ItemUsageFromJson(json);
}
