// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_id')
  String? get bankId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_id')
  String? get merchantId => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  TransactionSource get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_name')
  String? get merchantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_last4')
  String? get cardLast4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_id')
  String? get cardId => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw_reference')
  String? get rawReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_reference')
  String? get externalReference => throw _privateConstructorUsedError;
  String get fingerprint => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'bank_id') String? bankId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'merchant_id') String? merchantId,
      TransactionType type,
      TransactionSource source,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'transaction_date') DateTime transactionDate,
      @JsonKey(name: 'merchant_name') String? merchantName,
      @JsonKey(name: 'card_last4') String? cardLast4,
      @JsonKey(name: 'card_id') String? cardId,
      @JsonKey(name: 'raw_reference') String? rawReference,
      @JsonKey(name: 'external_reference') String? externalReference,
      String fingerprint,
      TransactionStatus status,
      String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bankId = freezed,
    Object? categoryId = freezed,
    Object? merchantId = freezed,
    Object? type = null,
    Object? source = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? transactionDate = null,
    Object? merchantName = freezed,
    Object? cardLast4 = freezed,
    Object? cardId = freezed,
    Object? rawReference = freezed,
    Object? externalReference = freezed,
    Object? fingerprint = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      merchantName: freezed == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      cardLast4: freezed == cardLast4
          ? _value.cardLast4
          : cardLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      cardId: freezed == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String?,
      rawReference: freezed == rawReference
          ? _value.rawReference
          : rawReference // ignore: cast_nullable_to_non_nullable
              as String?,
      externalReference: freezed == externalReference
          ? _value.externalReference
          : externalReference // ignore: cast_nullable_to_non_nullable
              as String?,
      fingerprint: null == fingerprint
          ? _value.fingerprint
          : fingerprint // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'bank_id') String? bankId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'merchant_id') String? merchantId,
      TransactionType type,
      TransactionSource source,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'transaction_date') DateTime transactionDate,
      @JsonKey(name: 'merchant_name') String? merchantName,
      @JsonKey(name: 'card_last4') String? cardLast4,
      @JsonKey(name: 'card_id') String? cardId,
      @JsonKey(name: 'raw_reference') String? rawReference,
      @JsonKey(name: 'external_reference') String? externalReference,
      String fingerprint,
      TransactionStatus status,
      String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bankId = freezed,
    Object? categoryId = freezed,
    Object? merchantId = freezed,
    Object? type = null,
    Object? source = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? transactionDate = null,
    Object? merchantName = freezed,
    Object? cardLast4 = freezed,
    Object? cardId = freezed,
    Object? rawReference = freezed,
    Object? externalReference = freezed,
    Object? fingerprint = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      merchantName: freezed == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      cardLast4: freezed == cardLast4
          ? _value.cardLast4
          : cardLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      cardId: freezed == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String?,
      rawReference: freezed == rawReference
          ? _value.rawReference
          : rawReference // ignore: cast_nullable_to_non_nullable
              as String?,
      externalReference: freezed == externalReference
          ? _value.externalReference
          : externalReference // ignore: cast_nullable_to_non_nullable
              as String?,
      fingerprint: null == fingerprint
          ? _value.fingerprint
          : fingerprint // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'bank_id') this.bankId,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'merchant_id') this.merchantId,
      required this.type,
      required this.source,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.currency = 'EGP',
      @JsonKey(name: 'transaction_date') required this.transactionDate,
      @JsonKey(name: 'merchant_name') this.merchantName,
      @JsonKey(name: 'card_last4') this.cardLast4,
      @JsonKey(name: 'card_id') this.cardId,
      @JsonKey(name: 'raw_reference') this.rawReference,
      @JsonKey(name: 'external_reference') this.externalReference,
      required this.fingerprint,
      this.status = TransactionStatus.confirmed,
      this.notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'bank_id')
  final String? bankId;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'merchant_id')
  final String? merchantId;
  @override
  final TransactionType type;
  @override
  final TransactionSource source;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  @override
  @JsonKey(name: 'merchant_name')
  final String? merchantName;
  @override
  @JsonKey(name: 'card_last4')
  final String? cardLast4;
  @override
  @JsonKey(name: 'card_id')
  final String? cardId;
  @override
  @JsonKey(name: 'raw_reference')
  final String? rawReference;
  @override
  @JsonKey(name: 'external_reference')
  final String? externalReference;
  @override
  final String fingerprint;
  @override
  @JsonKey()
  final TransactionStatus status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, bankId: $bankId, categoryId: $categoryId, merchantId: $merchantId, type: $type, source: $source, amountMinor: $amountMinor, currency: $currency, transactionDate: $transactionDate, merchantName: $merchantName, cardLast4: $cardLast4, cardId: $cardId, rawReference: $rawReference, externalReference: $externalReference, fingerprint: $fingerprint, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.cardLast4, cardLast4) ||
                other.cardLast4 == cardLast4) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.rawReference, rawReference) ||
                other.rawReference == rawReference) &&
            (identical(other.externalReference, externalReference) ||
                other.externalReference == externalReference) &&
            (identical(other.fingerprint, fingerprint) ||
                other.fingerprint == fingerprint) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        bankId,
        categoryId,
        merchantId,
        type,
        source,
        amountMinor,
        currency,
        transactionDate,
        merchantName,
        cardLast4,
        cardId,
        rawReference,
        externalReference,
        fingerprint,
        status,
        notes,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'bank_id') final String? bankId,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'merchant_id') final String? merchantId,
      required final TransactionType type,
      required final TransactionSource source,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String currency,
      @JsonKey(name: 'transaction_date')
      required final DateTime transactionDate,
      @JsonKey(name: 'merchant_name') final String? merchantName,
      @JsonKey(name: 'card_last4') final String? cardLast4,
      @JsonKey(name: 'card_id') final String? cardId,
      @JsonKey(name: 'raw_reference') final String? rawReference,
      @JsonKey(name: 'external_reference') final String? externalReference,
      required final String fingerprint,
      final TransactionStatus status,
      final String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'bank_id')
  String? get bankId;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'merchant_id')
  String? get merchantId;
  @override
  TransactionType get type;
  @override
  TransactionSource get source;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate;
  @override
  @JsonKey(name: 'merchant_name')
  String? get merchantName;
  @override
  @JsonKey(name: 'card_last4')
  String? get cardLast4;
  @override
  @JsonKey(name: 'card_id')
  String? get cardId;
  @override
  @JsonKey(name: 'raw_reference')
  String? get rawReference;
  @override
  @JsonKey(name: 'external_reference')
  String? get externalReference;
  @override
  String get fingerprint;
  @override
  TransactionStatus get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SMSMessage _$SMSMessageFromJson(Map<String, dynamic> json) {
  return _SMSMessage.fromJson(json);
}

/// @nodoc
mixin _$SMSMessage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_hash')
  String get messageHash => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
  DateTime get receivedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
  DateTime? get processedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_status')
  String get processingStatus => throw _privateConstructorUsedError;

  /// Original SMS body. Stored so the detection record remains auditable;
  /// callers/loggers must still avoid printing it.
  @JsonKey(name: 'message_body')
  String? get messageBody => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_identified')
  bool get bankIdentified => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_identified')
  bool get typeIdentified => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_identified')
  bool get amountIdentified => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_identified')
  bool get currencyIdentified => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_last4_identified')
  bool get cardLast4Identified => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_bank_id')
  String? get detectedBankId => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_bank_name')
  String? get detectedBankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_type')
  String? get detectedType => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_amount_minor')
  int? get detectedAmountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_currency')
  String? get detectedCurrency => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_card_last4')
  String? get detectedCardLast4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parser_version')
  String? get parserVersion => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SMSMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SMSMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SMSMessageCopyWith<SMSMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SMSMessageCopyWith<$Res> {
  factory $SMSMessageCopyWith(
          SMSMessage value, $Res Function(SMSMessage) then) =
      _$SMSMessageCopyWithImpl<$Res, SMSMessage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String? sender,
      @JsonKey(name: 'message_hash') String messageHash,
      @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
      DateTime receivedAt,
      @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
      DateTime? processedAt,
      @JsonKey(name: 'processing_status') String processingStatus,
      @JsonKey(name: 'message_body') String? messageBody,
      @JsonKey(name: 'bank_identified') bool bankIdentified,
      @JsonKey(name: 'type_identified') bool typeIdentified,
      @JsonKey(name: 'amount_identified') bool amountIdentified,
      @JsonKey(name: 'currency_identified') bool currencyIdentified,
      @JsonKey(name: 'card_last4_identified') bool cardLast4Identified,
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
      DateTime? createdAt});
}

/// @nodoc
class _$SMSMessageCopyWithImpl<$Res, $Val extends SMSMessage>
    implements $SMSMessageCopyWith<$Res> {
  _$SMSMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SMSMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sender = freezed,
    Object? messageHash = null,
    Object? receivedAt = null,
    Object? processedAt = freezed,
    Object? processingStatus = null,
    Object? messageBody = freezed,
    Object? bankIdentified = null,
    Object? typeIdentified = null,
    Object? amountIdentified = null,
    Object? currencyIdentified = null,
    Object? cardLast4Identified = null,
    Object? detectedBankId = freezed,
    Object? detectedBankName = freezed,
    Object? detectedType = freezed,
    Object? detectedAmountMinor = freezed,
    Object? detectedCurrency = freezed,
    Object? detectedCardLast4 = freezed,
    Object? transactionId = freezed,
    Object? parserVersion = freezed,
    Object? confidence = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      messageHash: null == messageHash
          ? _value.messageHash
          : messageHash // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      messageBody: freezed == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIdentified: null == bankIdentified
          ? _value.bankIdentified
          : bankIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      typeIdentified: null == typeIdentified
          ? _value.typeIdentified
          : typeIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      amountIdentified: null == amountIdentified
          ? _value.amountIdentified
          : amountIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyIdentified: null == currencyIdentified
          ? _value.currencyIdentified
          : currencyIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      cardLast4Identified: null == cardLast4Identified
          ? _value.cardLast4Identified
          : cardLast4Identified // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedBankId: freezed == detectedBankId
          ? _value.detectedBankId
          : detectedBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedBankName: freezed == detectedBankName
          ? _value.detectedBankName
          : detectedBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedType: freezed == detectedType
          ? _value.detectedType
          : detectedType // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedAmountMinor: freezed == detectedAmountMinor
          ? _value.detectedAmountMinor
          : detectedAmountMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      detectedCurrency: freezed == detectedCurrency
          ? _value.detectedCurrency
          : detectedCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedCardLast4: freezed == detectedCardLast4
          ? _value.detectedCardLast4
          : detectedCardLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      parserVersion: freezed == parserVersion
          ? _value.parserVersion
          : parserVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SMSMessageImplCopyWith<$Res>
    implements $SMSMessageCopyWith<$Res> {
  factory _$$SMSMessageImplCopyWith(
          _$SMSMessageImpl value, $Res Function(_$SMSMessageImpl) then) =
      __$$SMSMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String? sender,
      @JsonKey(name: 'message_hash') String messageHash,
      @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
      DateTime receivedAt,
      @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
      DateTime? processedAt,
      @JsonKey(name: 'processing_status') String processingStatus,
      @JsonKey(name: 'message_body') String? messageBody,
      @JsonKey(name: 'bank_identified') bool bankIdentified,
      @JsonKey(name: 'type_identified') bool typeIdentified,
      @JsonKey(name: 'amount_identified') bool amountIdentified,
      @JsonKey(name: 'currency_identified') bool currencyIdentified,
      @JsonKey(name: 'card_last4_identified') bool cardLast4Identified,
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
      DateTime? createdAt});
}

/// @nodoc
class __$$SMSMessageImplCopyWithImpl<$Res>
    extends _$SMSMessageCopyWithImpl<$Res, _$SMSMessageImpl>
    implements _$$SMSMessageImplCopyWith<$Res> {
  __$$SMSMessageImplCopyWithImpl(
      _$SMSMessageImpl _value, $Res Function(_$SMSMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SMSMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sender = freezed,
    Object? messageHash = null,
    Object? receivedAt = null,
    Object? processedAt = freezed,
    Object? processingStatus = null,
    Object? messageBody = freezed,
    Object? bankIdentified = null,
    Object? typeIdentified = null,
    Object? amountIdentified = null,
    Object? currencyIdentified = null,
    Object? cardLast4Identified = null,
    Object? detectedBankId = freezed,
    Object? detectedBankName = freezed,
    Object? detectedType = freezed,
    Object? detectedAmountMinor = freezed,
    Object? detectedCurrency = freezed,
    Object? detectedCardLast4 = freezed,
    Object? transactionId = freezed,
    Object? parserVersion = freezed,
    Object? confidence = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SMSMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      messageHash: null == messageHash
          ? _value.messageHash
          : messageHash // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      messageBody: freezed == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIdentified: null == bankIdentified
          ? _value.bankIdentified
          : bankIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      typeIdentified: null == typeIdentified
          ? _value.typeIdentified
          : typeIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      amountIdentified: null == amountIdentified
          ? _value.amountIdentified
          : amountIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyIdentified: null == currencyIdentified
          ? _value.currencyIdentified
          : currencyIdentified // ignore: cast_nullable_to_non_nullable
              as bool,
      cardLast4Identified: null == cardLast4Identified
          ? _value.cardLast4Identified
          : cardLast4Identified // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedBankId: freezed == detectedBankId
          ? _value.detectedBankId
          : detectedBankId // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedBankName: freezed == detectedBankName
          ? _value.detectedBankName
          : detectedBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedType: freezed == detectedType
          ? _value.detectedType
          : detectedType // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedAmountMinor: freezed == detectedAmountMinor
          ? _value.detectedAmountMinor
          : detectedAmountMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      detectedCurrency: freezed == detectedCurrency
          ? _value.detectedCurrency
          : detectedCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedCardLast4: freezed == detectedCardLast4
          ? _value.detectedCardLast4
          : detectedCardLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      parserVersion: freezed == parserVersion
          ? _value.parserVersion
          : parserVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SMSMessageImpl implements _SMSMessage {
  const _$SMSMessageImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      this.sender,
      @JsonKey(name: 'message_hash') required this.messageHash,
      @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
      required this.receivedAt,
      @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
      this.processedAt,
      @JsonKey(name: 'processing_status') this.processingStatus = 'pending',
      @JsonKey(name: 'message_body') this.messageBody,
      @JsonKey(name: 'bank_identified') this.bankIdentified = false,
      @JsonKey(name: 'type_identified') this.typeIdentified = false,
      @JsonKey(name: 'amount_identified') this.amountIdentified = false,
      @JsonKey(name: 'currency_identified') this.currencyIdentified = false,
      @JsonKey(name: 'card_last4_identified') this.cardLast4Identified = false,
      @JsonKey(name: 'detected_bank_id') this.detectedBankId,
      @JsonKey(name: 'detected_bank_name') this.detectedBankName,
      @JsonKey(name: 'detected_type') this.detectedType,
      @JsonKey(name: 'detected_amount_minor') this.detectedAmountMinor,
      @JsonKey(name: 'detected_currency') this.detectedCurrency,
      @JsonKey(name: 'detected_card_last4') this.detectedCardLast4,
      @JsonKey(name: 'transaction_id') this.transactionId,
      @JsonKey(name: 'parser_version') this.parserVersion,
      this.confidence,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$SMSMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SMSMessageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String? sender;
  @override
  @JsonKey(name: 'message_hash')
  final String messageHash;
  @override
  @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
  final DateTime receivedAt;
  @override
  @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
  final DateTime? processedAt;
  @override
  @JsonKey(name: 'processing_status')
  final String processingStatus;

  /// Original SMS body. Stored so the detection record remains auditable;
  /// callers/loggers must still avoid printing it.
  @override
  @JsonKey(name: 'message_body')
  final String? messageBody;
  @override
  @JsonKey(name: 'bank_identified')
  final bool bankIdentified;
  @override
  @JsonKey(name: 'type_identified')
  final bool typeIdentified;
  @override
  @JsonKey(name: 'amount_identified')
  final bool amountIdentified;
  @override
  @JsonKey(name: 'currency_identified')
  final bool currencyIdentified;
  @override
  @JsonKey(name: 'card_last4_identified')
  final bool cardLast4Identified;
  @override
  @JsonKey(name: 'detected_bank_id')
  final String? detectedBankId;
  @override
  @JsonKey(name: 'detected_bank_name')
  final String? detectedBankName;
  @override
  @JsonKey(name: 'detected_type')
  final String? detectedType;
  @override
  @JsonKey(name: 'detected_amount_minor')
  final int? detectedAmountMinor;
  @override
  @JsonKey(name: 'detected_currency')
  final String? detectedCurrency;
  @override
  @JsonKey(name: 'detected_card_last4')
  final String? detectedCardLast4;
  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @override
  @JsonKey(name: 'parser_version')
  final String? parserVersion;
  @override
  final double? confidence;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SMSMessage(id: $id, userId: $userId, sender: $sender, messageHash: $messageHash, receivedAt: $receivedAt, processedAt: $processedAt, processingStatus: $processingStatus, messageBody: $messageBody, bankIdentified: $bankIdentified, typeIdentified: $typeIdentified, amountIdentified: $amountIdentified, currencyIdentified: $currencyIdentified, cardLast4Identified: $cardLast4Identified, detectedBankId: $detectedBankId, detectedBankName: $detectedBankName, detectedType: $detectedType, detectedAmountMinor: $detectedAmountMinor, detectedCurrency: $detectedCurrency, detectedCardLast4: $detectedCardLast4, transactionId: $transactionId, parserVersion: $parserVersion, confidence: $confidence, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SMSMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.messageHash, messageHash) ||
                other.messageHash == messageHash) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.processingStatus, processingStatus) ||
                other.processingStatus == processingStatus) &&
            (identical(other.messageBody, messageBody) ||
                other.messageBody == messageBody) &&
            (identical(other.bankIdentified, bankIdentified) ||
                other.bankIdentified == bankIdentified) &&
            (identical(other.typeIdentified, typeIdentified) ||
                other.typeIdentified == typeIdentified) &&
            (identical(other.amountIdentified, amountIdentified) ||
                other.amountIdentified == amountIdentified) &&
            (identical(other.currencyIdentified, currencyIdentified) ||
                other.currencyIdentified == currencyIdentified) &&
            (identical(other.cardLast4Identified, cardLast4Identified) ||
                other.cardLast4Identified == cardLast4Identified) &&
            (identical(other.detectedBankId, detectedBankId) ||
                other.detectedBankId == detectedBankId) &&
            (identical(other.detectedBankName, detectedBankName) ||
                other.detectedBankName == detectedBankName) &&
            (identical(other.detectedType, detectedType) ||
                other.detectedType == detectedType) &&
            (identical(other.detectedAmountMinor, detectedAmountMinor) ||
                other.detectedAmountMinor == detectedAmountMinor) &&
            (identical(other.detectedCurrency, detectedCurrency) ||
                other.detectedCurrency == detectedCurrency) &&
            (identical(other.detectedCardLast4, detectedCardLast4) ||
                other.detectedCardLast4 == detectedCardLast4) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.parserVersion, parserVersion) ||
                other.parserVersion == parserVersion) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        sender,
        messageHash,
        receivedAt,
        processedAt,
        processingStatus,
        messageBody,
        bankIdentified,
        typeIdentified,
        amountIdentified,
        currencyIdentified,
        cardLast4Identified,
        detectedBankId,
        detectedBankName,
        detectedType,
        detectedAmountMinor,
        detectedCurrency,
        detectedCardLast4,
        transactionId,
        parserVersion,
        confidence,
        createdAt
      ]);

  /// Create a copy of SMSMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SMSMessageImplCopyWith<_$SMSMessageImpl> get copyWith =>
      __$$SMSMessageImplCopyWithImpl<_$SMSMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SMSMessageImplToJson(
      this,
    );
  }
}

abstract class _SMSMessage implements SMSMessage {
  const factory _SMSMessage(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      final String? sender,
      @JsonKey(name: 'message_hash') required final String messageHash,
      @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
      required final DateTime receivedAt,
      @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
      final DateTime? processedAt,
      @JsonKey(name: 'processing_status') final String processingStatus,
      @JsonKey(name: 'message_body') final String? messageBody,
      @JsonKey(name: 'bank_identified') final bool bankIdentified,
      @JsonKey(name: 'type_identified') final bool typeIdentified,
      @JsonKey(name: 'amount_identified') final bool amountIdentified,
      @JsonKey(name: 'currency_identified') final bool currencyIdentified,
      @JsonKey(name: 'card_last4_identified') final bool cardLast4Identified,
      @JsonKey(name: 'detected_bank_id') final String? detectedBankId,
      @JsonKey(name: 'detected_bank_name') final String? detectedBankName,
      @JsonKey(name: 'detected_type') final String? detectedType,
      @JsonKey(name: 'detected_amount_minor') final int? detectedAmountMinor,
      @JsonKey(name: 'detected_currency') final String? detectedCurrency,
      @JsonKey(name: 'detected_card_last4') final String? detectedCardLast4,
      @JsonKey(name: 'transaction_id') final String? transactionId,
      @JsonKey(name: 'parser_version') final String? parserVersion,
      final double? confidence,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$SMSMessageImpl;

  factory _SMSMessage.fromJson(Map<String, dynamic> json) =
      _$SMSMessageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String? get sender;
  @override
  @JsonKey(name: 'message_hash')
  String get messageHash;
  @override
  @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)
  DateTime get receivedAt;
  @override
  @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)
  DateTime? get processedAt;
  @override
  @JsonKey(name: 'processing_status')
  String get processingStatus;

  /// Original SMS body. Stored so the detection record remains auditable;
  /// callers/loggers must still avoid printing it.
  @override
  @JsonKey(name: 'message_body')
  String? get messageBody;
  @override
  @JsonKey(name: 'bank_identified')
  bool get bankIdentified;
  @override
  @JsonKey(name: 'type_identified')
  bool get typeIdentified;
  @override
  @JsonKey(name: 'amount_identified')
  bool get amountIdentified;
  @override
  @JsonKey(name: 'currency_identified')
  bool get currencyIdentified;
  @override
  @JsonKey(name: 'card_last4_identified')
  bool get cardLast4Identified;
  @override
  @JsonKey(name: 'detected_bank_id')
  String? get detectedBankId;
  @override
  @JsonKey(name: 'detected_bank_name')
  String? get detectedBankName;
  @override
  @JsonKey(name: 'detected_type')
  String? get detectedType;
  @override
  @JsonKey(name: 'detected_amount_minor')
  int? get detectedAmountMinor;
  @override
  @JsonKey(name: 'detected_currency')
  String? get detectedCurrency;
  @override
  @JsonKey(name: 'detected_card_last4')
  String? get detectedCardLast4;
  @override
  @JsonKey(name: 'transaction_id')
  String? get transactionId;
  @override
  @JsonKey(name: 'parser_version')
  String? get parserVersion;
  @override
  double? get confidence;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of SMSMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SMSMessageImplCopyWith<_$SMSMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

/// @nodoc
mixin _$Expense {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_minor')
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get expenseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_id')
  String? get merchantId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
      DateTime expenseDate,
      @JsonKey(name: 'payment_method') PaymentMethod paymentMethod,
      @JsonKey(name: 'merchant_id') String? merchantId,
      String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? transactionId = freezed,
    Object? categoryId = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? expenseDate = null,
    Object? paymentMethod = null,
    Object? merchantId = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
          _$ExpenseImpl value, $Res Function(_$ExpenseImpl) then) =
      __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'amount_minor') int amountMinor,
      String currency,
      @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
      DateTime expenseDate,
      @JsonKey(name: 'payment_method') PaymentMethod paymentMethod,
      @JsonKey(name: 'merchant_id') String? merchantId,
      String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
      _$ExpenseImpl _value, $Res Function(_$ExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? transactionId = freezed,
    Object? categoryId = freezed,
    Object? amountMinor = null,
    Object? currency = null,
    Object? expenseDate = null,
    Object? paymentMethod = null,
    Object? merchantId = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseImpl implements _Expense {
  const _$ExpenseImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'transaction_id') this.transactionId,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'amount_minor') required this.amountMinor,
      this.currency = 'EGP',
      @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
      required this.expenseDate,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      @JsonKey(name: 'merchant_id') this.merchantId,
      this.notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      this.updatedAt});

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'amount_minor')
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime expenseDate;
  @override
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;
  @override
  @JsonKey(name: 'merchant_id')
  final String? merchantId;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Expense(id: $id, userId: $userId, transactionId: $transactionId, categoryId: $categoryId, amountMinor: $amountMinor, currency: $currency, expenseDate: $expenseDate, paymentMethod: $paymentMethod, merchantId: $merchantId, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      transactionId,
      categoryId,
      amountMinor,
      currency,
      expenseDate,
      paymentMethod,
      merchantId,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseImplToJson(
      this,
    );
  }
}

abstract class _Expense implements Expense {
  const factory _Expense(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'transaction_id') final String? transactionId,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'amount_minor') required final int amountMinor,
      final String currency,
      @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime expenseDate,
      @JsonKey(name: 'payment_method')
      required final PaymentMethod paymentMethod,
      @JsonKey(name: 'merchant_id') final String? merchantId,
      final String? notes,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt}) = _$ExpenseImpl;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'transaction_id')
  String? get transactionId;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'amount_minor')
  int get amountMinor;
  @override
  String get currency;
  @override
  @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get expenseDate;
  @override
  @JsonKey(name: 'payment_method')
  PaymentMethod get paymentMethod;
  @override
  @JsonKey(name: 'merchant_id')
  String? get merchantId;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpenseItem _$ExpenseItemFromJson(Map<String, dynamic> json) {
  return _ExpenseItem.fromJson(json);
}

/// @nodoc
mixin _$ExpenseItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_id')
  String get expenseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_minor')
  int get unitPriceMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price_minor')
  int get totalPriceMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseItemCopyWith<ExpenseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseItemCopyWith<$Res> {
  factory $ExpenseItemCopyWith(
          ExpenseItem value, $Res Function(ExpenseItem) then) =
      _$ExpenseItemCopyWithImpl<$Res, ExpenseItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'expense_id') String expenseId,
      @JsonKey(name: 'item_id') String itemId,
      int quantity,
      @JsonKey(name: 'unit_price_minor') int unitPriceMinor,
      @JsonKey(name: 'total_price_minor') int totalPriceMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$ExpenseItemCopyWithImpl<$Res, $Val extends ExpenseItem>
    implements $ExpenseItemCopyWith<$Res> {
  _$ExpenseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? itemId = null,
    Object? quantity = null,
    Object? unitPriceMinor = null,
    Object? totalPriceMinor = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceMinor: null == unitPriceMinor
          ? _value.unitPriceMinor
          : unitPriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalPriceMinor: null == totalPriceMinor
          ? _value.totalPriceMinor
          : totalPriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseItemImplCopyWith<$Res>
    implements $ExpenseItemCopyWith<$Res> {
  factory _$$ExpenseItemImplCopyWith(
          _$ExpenseItemImpl value, $Res Function(_$ExpenseItemImpl) then) =
      __$$ExpenseItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'expense_id') String expenseId,
      @JsonKey(name: 'item_id') String itemId,
      int quantity,
      @JsonKey(name: 'unit_price_minor') int unitPriceMinor,
      @JsonKey(name: 'total_price_minor') int totalPriceMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$ExpenseItemImplCopyWithImpl<$Res>
    extends _$ExpenseItemCopyWithImpl<$Res, _$ExpenseItemImpl>
    implements _$$ExpenseItemImplCopyWith<$Res> {
  __$$ExpenseItemImplCopyWithImpl(
      _$ExpenseItemImpl _value, $Res Function(_$ExpenseItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? itemId = null,
    Object? quantity = null,
    Object? unitPriceMinor = null,
    Object? totalPriceMinor = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ExpenseItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceMinor: null == unitPriceMinor
          ? _value.unitPriceMinor
          : unitPriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalPriceMinor: null == totalPriceMinor
          ? _value.totalPriceMinor
          : totalPriceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseItemImpl implements _ExpenseItem {
  const _$ExpenseItemImpl(
      {required this.id,
      @JsonKey(name: 'expense_id') required this.expenseId,
      @JsonKey(name: 'item_id') required this.itemId,
      required this.quantity,
      @JsonKey(name: 'unit_price_minor') required this.unitPriceMinor,
      @JsonKey(name: 'total_price_minor') required this.totalPriceMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$ExpenseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'expense_id')
  final String expenseId;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price_minor')
  final int unitPriceMinor;
  @override
  @JsonKey(name: 'total_price_minor')
  final int totalPriceMinor;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ExpenseItem(id: $id, expenseId: $expenseId, itemId: $itemId, quantity: $quantity, unitPriceMinor: $unitPriceMinor, totalPriceMinor: $totalPriceMinor, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPriceMinor, unitPriceMinor) ||
                other.unitPriceMinor == unitPriceMinor) &&
            (identical(other.totalPriceMinor, totalPriceMinor) ||
                other.totalPriceMinor == totalPriceMinor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, expenseId, itemId, quantity,
      unitPriceMinor, totalPriceMinor, createdAt);

  /// Create a copy of ExpenseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseItemImplCopyWith<_$ExpenseItemImpl> get copyWith =>
      __$$ExpenseItemImplCopyWithImpl<_$ExpenseItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseItemImplToJson(
      this,
    );
  }
}

abstract class _ExpenseItem implements ExpenseItem {
  const factory _ExpenseItem(
      {required final String id,
      @JsonKey(name: 'expense_id') required final String expenseId,
      @JsonKey(name: 'item_id') required final String itemId,
      required final int quantity,
      @JsonKey(name: 'unit_price_minor') required final int unitPriceMinor,
      @JsonKey(name: 'total_price_minor') required final int totalPriceMinor,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$ExpenseItemImpl;

  factory _ExpenseItem.fromJson(Map<String, dynamic> json) =
      _$ExpenseItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'expense_id')
  String get expenseId;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price_minor')
  int get unitPriceMinor;
  @override
  @JsonKey(name: 'total_price_minor')
  int get totalPriceMinor;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of ExpenseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseItemImplCopyWith<_$ExpenseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItemUsage _$ItemUsageFromJson(Map<String, dynamic> json) {
  return _ItemUsage.fromJson(json);
}

/// @nodoc
mixin _$ItemUsage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_id')
  String get expenseId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount_minor')
  int get totalAmountMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get usageDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ItemUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemUsageCopyWith<ItemUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemUsageCopyWith<$Res> {
  factory $ItemUsageCopyWith(ItemUsage value, $Res Function(ItemUsage) then) =
      _$ItemUsageCopyWithImpl<$Res, ItemUsage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'expense_id') String expenseId,
      int quantity,
      @JsonKey(name: 'total_amount_minor') int totalAmountMinor,
      @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
      DateTime usageDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$ItemUsageCopyWithImpl<$Res, $Val extends ItemUsage>
    implements $ItemUsageCopyWith<$Res> {
  _$ItemUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? expenseId = null,
    Object? quantity = null,
    Object? totalAmountMinor = null,
    Object? usageDate = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmountMinor: null == totalAmountMinor
          ? _value.totalAmountMinor
          : totalAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      usageDate: null == usageDate
          ? _value.usageDate
          : usageDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemUsageImplCopyWith<$Res>
    implements $ItemUsageCopyWith<$Res> {
  factory _$$ItemUsageImplCopyWith(
          _$ItemUsageImpl value, $Res Function(_$ItemUsageImpl) then) =
      __$$ItemUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'expense_id') String expenseId,
      int quantity,
      @JsonKey(name: 'total_amount_minor') int totalAmountMinor,
      @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
      DateTime usageDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$ItemUsageImplCopyWithImpl<$Res>
    extends _$ItemUsageCopyWithImpl<$Res, _$ItemUsageImpl>
    implements _$$ItemUsageImplCopyWith<$Res> {
  __$$ItemUsageImplCopyWithImpl(
      _$ItemUsageImpl _value, $Res Function(_$ItemUsageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? expenseId = null,
    Object? quantity = null,
    Object? totalAmountMinor = null,
    Object? usageDate = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ItemUsageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmountMinor: null == totalAmountMinor
          ? _value.totalAmountMinor
          : totalAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      usageDate: null == usageDate
          ? _value.usageDate
          : usageDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemUsageImpl implements _ItemUsage {
  const _$ItemUsageImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'expense_id') required this.expenseId,
      required this.quantity,
      @JsonKey(name: 'total_amount_minor') required this.totalAmountMinor,
      @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
      required this.usageDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      this.createdAt});

  factory _$ItemUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemUsageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'expense_id')
  final String expenseId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'total_amount_minor')
  final int totalAmountMinor;
  @override
  @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
  final DateTime usageDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ItemUsage(id: $id, userId: $userId, itemId: $itemId, expenseId: $expenseId, quantity: $quantity, totalAmountMinor: $totalAmountMinor, usageDate: $usageDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemUsageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalAmountMinor, totalAmountMinor) ||
                other.totalAmountMinor == totalAmountMinor) &&
            (identical(other.usageDate, usageDate) ||
                other.usageDate == usageDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, itemId, expenseId,
      quantity, totalAmountMinor, usageDate, createdAt);

  /// Create a copy of ItemUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemUsageImplCopyWith<_$ItemUsageImpl> get copyWith =>
      __$$ItemUsageImplCopyWithImpl<_$ItemUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemUsageImplToJson(
      this,
    );
  }
}

abstract class _ItemUsage implements ItemUsage {
  const factory _ItemUsage(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'item_id') required final String itemId,
      @JsonKey(name: 'expense_id') required final String expenseId,
      required final int quantity,
      @JsonKey(name: 'total_amount_minor') required final int totalAmountMinor,
      @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
      required final DateTime usageDate,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt}) = _$ItemUsageImpl;

  factory _ItemUsage.fromJson(Map<String, dynamic> json) =
      _$ItemUsageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'expense_id')
  String get expenseId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'total_amount_minor')
  int get totalAmountMinor;
  @override
  @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)
  DateTime get usageDate;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;

  /// Create a copy of ItemUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemUsageImplCopyWith<_$ItemUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
