// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bankId: json['bank_id'] as String?,
      categoryId: json['category_id'] as String?,
      merchantId: json['merchant_id'] as String?,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      source: $enumDecode(_$TransactionSourceEnumMap, json['source']),
      amountMinor: (json['amount_minor'] as num).toInt(),
      currency: json['currency'] as String? ?? 'EGP',
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      merchantName: json['merchant_name'] as String?,
      cardLast4: json['card_last4'] as String?,
      cardId: json['card_id'] as String?,
      rawReference: json['raw_reference'] as String?,
      externalReference: json['external_reference'] as String?,
      fingerprint: json['fingerprint'] as String,
      status: $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.confirmed,
      notes: json['notes'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'bank_id': instance.bankId,
      'category_id': instance.categoryId,
      'merchant_id': instance.merchantId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'source': _$TransactionSourceEnumMap[instance.source]!,
      'amount_minor': instance.amountMinor,
      'currency': instance.currency,
      'transaction_date': instance.transactionDate.toIso8601String(),
      'merchant_name': instance.merchantName,
      'card_last4': instance.cardLast4,
      'card_id': instance.cardId,
      'raw_reference': instance.rawReference,
      'external_reference': instance.externalReference,
      'fingerprint': instance.fingerprint,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.purchase: 'purchase',
  TransactionType.atm_withdrawal: 'atm_withdrawal',
  TransactionType.cash_expense: 'cash_expense',
  TransactionType.income: 'income',
  TransactionType.transfer_in: 'transfer_in',
  TransactionType.transfer_out: 'transfer_out',
  TransactionType.adjustment: 'adjustment',
  TransactionType.refund: 'refund',
  TransactionType.reversal: 'reversal',
};

const _$TransactionSourceEnumMap = {
  TransactionSource.sms: 'sms',
  TransactionSource.manual: 'manual',
  TransactionSource.receipt: 'receipt',
  TransactionSource.system: 'system',
  TransactionSource.ai_assisted: 'ai_assisted',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.confirmed: 'confirmed',
  TransactionStatus.cancelled: 'cancelled',
  TransactionStatus.reversed: 'reversed',
};

_$SMSMessageImpl _$$SMSMessageImplFromJson(Map<String, dynamic> json) =>
    _$SMSMessageImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sender: json['sender'] as String?,
      messageHash: json['message_hash'] as String,
      receivedAt: _dateTimeFromJsonRequired(json['received_at']),
      processedAt: _dateTimeFromJson(json['processed_at']),
      processingStatus: json['processing_status'] as String? ?? 'pending',
      messageBody: json['message_body'] as String?,
      bankIdentified: json['bank_identified'] as bool? ?? false,
      typeIdentified: json['type_identified'] as bool? ?? false,
      amountIdentified: json['amount_identified'] as bool? ?? false,
      currencyIdentified: json['currency_identified'] as bool? ?? false,
      cardLast4Identified: json['card_last4_identified'] as bool? ?? false,
      detectedBankId: json['detected_bank_id'] as String?,
      detectedBankName: json['detected_bank_name'] as String?,
      detectedType: json['detected_type'] as String?,
      detectedAmountMinor: (json['detected_amount_minor'] as num?)?.toInt(),
      detectedCurrency: json['detected_currency'] as String?,
      detectedCardLast4: json['detected_card_last4'] as String?,
      transactionId: json['transaction_id'] as String?,
      parserVersion: json['parser_version'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$SMSMessageImplToJson(_$SMSMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'sender': instance.sender,
      'message_hash': instance.messageHash,
      'received_at': instance.receivedAt.toIso8601String(),
      'processed_at': instance.processedAt?.toIso8601String(),
      'processing_status': instance.processingStatus,
      'message_body': instance.messageBody,
      'bank_identified': instance.bankIdentified,
      'type_identified': instance.typeIdentified,
      'amount_identified': instance.amountIdentified,
      'currency_identified': instance.currencyIdentified,
      'card_last4_identified': instance.cardLast4Identified,
      'detected_bank_id': instance.detectedBankId,
      'detected_bank_name': instance.detectedBankName,
      'detected_type': instance.detectedType,
      'detected_amount_minor': instance.detectedAmountMinor,
      'detected_currency': instance.detectedCurrency,
      'detected_card_last4': instance.detectedCardLast4,
      'transaction_id': instance.transactionId,
      'parser_version': instance.parserVersion,
      'confidence': instance.confidence,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      transactionId: json['transaction_id'] as String?,
      categoryId: json['category_id'] as String?,
      amountMinor: (json['amount_minor'] as num).toInt(),
      currency: json['currency'] as String? ?? 'EGP',
      expenseDate: _dateTimeFromJsonRequired(json['expense_date']),
      paymentMethod:
          $enumDecode(_$PaymentMethodEnumMap, json['payment_method']),
      merchantId: json['merchant_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'transaction_id': instance.transactionId,
      'category_id': instance.categoryId,
      'amount_minor': instance.amountMinor,
      'currency': instance.currency,
      'expense_date': instance.expenseDate.toIso8601String(),
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'merchant_id': instance.merchantId,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
};

_$ExpenseItemImpl _$$ExpenseItemImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseItemImpl(
      id: json['id'] as String,
      expenseId: json['expense_id'] as String,
      itemId: json['item_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
      totalPriceMinor: (json['total_price_minor'] as num).toInt(),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$ExpenseItemImplToJson(_$ExpenseItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expense_id': instance.expenseId,
      'item_id': instance.itemId,
      'quantity': instance.quantity,
      'unit_price_minor': instance.unitPriceMinor,
      'total_price_minor': instance.totalPriceMinor,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$ItemUsageImpl _$$ItemUsageImplFromJson(Map<String, dynamic> json) =>
    _$ItemUsageImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      expenseId: json['expense_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalAmountMinor: (json['total_amount_minor'] as num).toInt(),
      usageDate: _dateTimeFromJsonRequired(json['usage_date']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$$ItemUsageImplToJson(_$ItemUsageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'expense_id': instance.expenseId,
      'quantity': instance.quantity,
      'total_amount_minor': instance.totalAmountMinor,
      'usage_date': instance.usageDate.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
