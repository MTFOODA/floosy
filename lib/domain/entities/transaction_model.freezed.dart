// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'bank_id') String? get bankId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'merchant_id') String? get merchantId; TransactionType get type; TransactionSource get source;@JsonKey(name: 'amount_minor') int get amountMinor; String get currency;@JsonKey(name: 'transaction_date') DateTime get transactionDate;@JsonKey(name: 'merchant_name') String? get merchantName;@JsonKey(name: 'card_last4') String? get cardLast4;@JsonKey(name: 'card_id') String? get cardId;@JsonKey(name: 'raw_reference') String? get rawReference;@JsonKey(name: 'external_reference') String? get externalReference; String get fingerprint; TransactionStatus get status; String? get notes;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Transaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.bankId, _this.bankId) || other.bankId == _this.bankId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.merchantId, _this.merchantId) || other.merchantId == _this.merchantId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.transactionDate, _this.transactionDate) || other.transactionDate == _this.transactionDate)&&(identical(other.merchantName, _this.merchantName) || other.merchantName == _this.merchantName)&&(identical(other.cardLast4, _this.cardLast4) || other.cardLast4 == _this.cardLast4)&&(identical(other.cardId, _this.cardId) || other.cardId == _this.cardId)&&(identical(other.rawReference, _this.rawReference) || other.rawReference == _this.rawReference)&&(identical(other.externalReference, _this.externalReference) || other.externalReference == _this.externalReference)&&(identical(other.fingerprint, _this.fingerprint) || other.fingerprint == _this.fingerprint)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Transaction;
  return Object.hashAll([runtimeType,_this.id,_this.userId,_this.bankId,_this.categoryId,_this.merchantId,_this.type,_this.source,_this.amountMinor,_this.currency,_this.transactionDate,_this.merchantName,_this.cardLast4,_this.cardId,_this.rawReference,_this.externalReference,_this.fingerprint,_this.status,_this.notes,_this.createdAt,_this.updatedAt]);
}

@override
String toString() {
  final _this = this as Transaction;
  return 'Transaction(id: ${_this.id}, userId: ${_this.userId}, bankId: ${_this.bankId}, categoryId: ${_this.categoryId}, merchantId: ${_this.merchantId}, type: ${_this.type}, source: ${_this.source}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, transactionDate: ${_this.transactionDate}, merchantName: ${_this.merchantName}, cardLast4: ${_this.cardLast4}, cardId: ${_this.cardId}, rawReference: ${_this.rawReference}, externalReference: ${_this.externalReference}, fingerprint: ${_this.fingerprint}, status: ${_this.status}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'bank_id') String? bankId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'merchant_id') String? merchantId, TransactionType type, TransactionSource source,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'transaction_date') DateTime transactionDate,@JsonKey(name: 'merchant_name') String? merchantName,@JsonKey(name: 'card_last4') String? cardLast4,@JsonKey(name: 'card_id') String? cardId,@JsonKey(name: 'raw_reference') String? rawReference,@JsonKey(name: 'external_reference') String? externalReference, String fingerprint, TransactionStatus status, String? notes,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? bankId = freezed,Object? categoryId = freezed,Object? merchantId = freezed,Object? type = null,Object? source = null,Object? amountMinor = null,Object? currency = null,Object? transactionDate = null,Object? merchantName = freezed,Object? cardLast4 = freezed,Object? cardId = freezed,Object? rawReference = freezed,Object? externalReference = freezed,Object? fingerprint = null,Object? status = null,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bankId: freezed == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantId: freezed == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,rawReference: freezed == rawReference ? _self.rawReference : rawReference // ignore: cast_nullable_to_non_nullable
as String?,externalReference: freezed == externalReference ? _self.externalReference : externalReference // ignore: cast_nullable_to_non_nullable
as String?,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'merchant_id')  String? merchantId,  TransactionType type,  TransactionSource source, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'transaction_date')  DateTime transactionDate, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'card_last4')  String? cardLast4, @JsonKey(name: 'card_id')  String? cardId, @JsonKey(name: 'raw_reference')  String? rawReference, @JsonKey(name: 'external_reference')  String? externalReference,  String fingerprint,  TransactionStatus status,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.userId,_that.bankId,_that.categoryId,_that.merchantId,_that.type,_that.source,_that.amountMinor,_that.currency,_that.transactionDate,_that.merchantName,_that.cardLast4,_that.cardId,_that.rawReference,_that.externalReference,_that.fingerprint,_that.status,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'merchant_id')  String? merchantId,  TransactionType type,  TransactionSource source, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'transaction_date')  DateTime transactionDate, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'card_last4')  String? cardLast4, @JsonKey(name: 'card_id')  String? cardId, @JsonKey(name: 'raw_reference')  String? rawReference, @JsonKey(name: 'external_reference')  String? externalReference,  String fingerprint,  TransactionStatus status,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.userId,_that.bankId,_that.categoryId,_that.merchantId,_that.type,_that.source,_that.amountMinor,_that.currency,_that.transactionDate,_that.merchantName,_that.cardLast4,_that.cardId,_that.rawReference,_that.externalReference,_that.fingerprint,_that.status,_that.notes,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'bank_id')  String? bankId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'merchant_id')  String? merchantId,  TransactionType type,  TransactionSource source, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'transaction_date')  DateTime transactionDate, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'card_last4')  String? cardLast4, @JsonKey(name: 'card_id')  String? cardId, @JsonKey(name: 'raw_reference')  String? rawReference, @JsonKey(name: 'external_reference')  String? externalReference,  String fingerprint,  TransactionStatus status,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.userId,_that.bankId,_that.categoryId,_that.merchantId,_that.type,_that.source,_that.amountMinor,_that.currency,_that.transactionDate,_that.merchantName,_that.cardLast4,_that.cardId,_that.rawReference,_that.externalReference,_that.fingerprint,_that.status,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transaction implements Transaction {
  const _Transaction({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'bank_id') this.bankId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'merchant_id') this.merchantId, required this.type, required this.source, @JsonKey(name: 'amount_minor') required this.amountMinor, this.currency = 'EGP', @JsonKey(name: 'transaction_date') required this.transactionDate, @JsonKey(name: 'merchant_name') this.merchantName, @JsonKey(name: 'card_last4') this.cardLast4, @JsonKey(name: 'card_id') this.cardId, @JsonKey(name: 'raw_reference') this.rawReference, @JsonKey(name: 'external_reference') this.externalReference, required this.fingerprint, this.status = TransactionStatus.confirmed, this.notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'bank_id') final  String? bankId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'merchant_id') final  String? merchantId;
@override final  TransactionType type;
@override final  TransactionSource source;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'transaction_date') final  DateTime transactionDate;
@override@JsonKey(name: 'merchant_name') final  String? merchantName;
@override@JsonKey(name: 'card_last4') final  String? cardLast4;
@override@JsonKey(name: 'card_id') final  String? cardId;
@override@JsonKey(name: 'raw_reference') final  String? rawReference;
@override@JsonKey(name: 'external_reference') final  String? externalReference;
@override final  String fingerprint;
@override@JsonKey() final  TransactionStatus status;
@override final  String? notes;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.bankId, bankId) || other.bankId == bankId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.rawReference, rawReference) || other.rawReference == rawReference)&&(identical(other.externalReference, externalReference) || other.externalReference == externalReference)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,userId,bankId,categoryId,merchantId,type,source,amountMinor,currency,transactionDate,merchantName,cardLast4,cardId,rawReference,externalReference,fingerprint,status,notes,createdAt,updatedAt]);
}

@override
String toString() {
    return 'Transaction(id: $id, userId: $userId, bankId: $bankId, categoryId: $categoryId, merchantId: $merchantId, type: $type, source: $source, amountMinor: $amountMinor, currency: $currency, transactionDate: $transactionDate, merchantName: $merchantName, cardLast4: $cardLast4, cardId: $cardId, rawReference: $rawReference, externalReference: $externalReference, fingerprint: $fingerprint, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'bank_id') String? bankId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'merchant_id') String? merchantId, TransactionType type, TransactionSource source,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'transaction_date') DateTime transactionDate,@JsonKey(name: 'merchant_name') String? merchantName,@JsonKey(name: 'card_last4') String? cardLast4,@JsonKey(name: 'card_id') String? cardId,@JsonKey(name: 'raw_reference') String? rawReference,@JsonKey(name: 'external_reference') String? externalReference, String fingerprint, TransactionStatus status, String? notes,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? bankId = freezed,Object? categoryId = freezed,Object? merchantId = freezed,Object? type = null,Object? source = null,Object? amountMinor = null,Object? currency = null,Object? transactionDate = null,Object? merchantName = freezed,Object? cardLast4 = freezed,Object? cardId = freezed,Object? rawReference = freezed,Object? externalReference = freezed,Object? fingerprint = null,Object? status = null,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bankId: freezed == bankId ? _self.bankId : bankId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,merchantId: freezed == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,rawReference: freezed == rawReference ? _self.rawReference : rawReference // ignore: cast_nullable_to_non_nullable
as String?,externalReference: freezed == externalReference ? _self.externalReference : externalReference // ignore: cast_nullable_to_non_nullable
as String?,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SMSMessage {

 String get id;@JsonKey(name: 'user_id') String get userId; String? get sender;@JsonKey(name: 'message_hash') String get messageHash;@JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired) DateTime get receivedAt;@JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson) DateTime? get processedAt;@JsonKey(name: 'processing_status') String get processingStatus;/// Original SMS body. Stored so the detection record remains auditable;
/// callers/loggers must still avoid printing it.
@JsonKey(name: 'message_body') String? get messageBody;@JsonKey(name: 'bank_identified') bool get bankIdentified;@JsonKey(name: 'type_identified') bool get typeIdentified;@JsonKey(name: 'amount_identified') bool get amountIdentified;@JsonKey(name: 'currency_identified') bool get currencyIdentified;@JsonKey(name: 'card_last4_identified') bool get cardLast4Identified;@JsonKey(name: 'detected_bank_id') String? get detectedBankId;@JsonKey(name: 'detected_bank_name') String? get detectedBankName;@JsonKey(name: 'detected_type') String? get detectedType;@JsonKey(name: 'detected_amount_minor') int? get detectedAmountMinor;@JsonKey(name: 'detected_currency') String? get detectedCurrency;@JsonKey(name: 'detected_card_last4') String? get detectedCardLast4;@JsonKey(name: 'transaction_id') String? get transactionId;@JsonKey(name: 'parser_version') String? get parserVersion; double? get confidence;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of SMSMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SMSMessageCopyWith<SMSMessage> get copyWith => _$SMSMessageCopyWithImpl<SMSMessage>(this as SMSMessage, _$identity);

  /// Serializes this SMSMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SMSMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SMSMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.sender, _this.sender) || other.sender == _this.sender)&&(identical(other.messageHash, _this.messageHash) || other.messageHash == _this.messageHash)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt)&&(identical(other.processedAt, _this.processedAt) || other.processedAt == _this.processedAt)&&(identical(other.processingStatus, _this.processingStatus) || other.processingStatus == _this.processingStatus)&&(identical(other.messageBody, _this.messageBody) || other.messageBody == _this.messageBody)&&(identical(other.bankIdentified, _this.bankIdentified) || other.bankIdentified == _this.bankIdentified)&&(identical(other.typeIdentified, _this.typeIdentified) || other.typeIdentified == _this.typeIdentified)&&(identical(other.amountIdentified, _this.amountIdentified) || other.amountIdentified == _this.amountIdentified)&&(identical(other.currencyIdentified, _this.currencyIdentified) || other.currencyIdentified == _this.currencyIdentified)&&(identical(other.cardLast4Identified, _this.cardLast4Identified) || other.cardLast4Identified == _this.cardLast4Identified)&&(identical(other.detectedBankId, _this.detectedBankId) || other.detectedBankId == _this.detectedBankId)&&(identical(other.detectedBankName, _this.detectedBankName) || other.detectedBankName == _this.detectedBankName)&&(identical(other.detectedType, _this.detectedType) || other.detectedType == _this.detectedType)&&(identical(other.detectedAmountMinor, _this.detectedAmountMinor) || other.detectedAmountMinor == _this.detectedAmountMinor)&&(identical(other.detectedCurrency, _this.detectedCurrency) || other.detectedCurrency == _this.detectedCurrency)&&(identical(other.detectedCardLast4, _this.detectedCardLast4) || other.detectedCardLast4 == _this.detectedCardLast4)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.parserVersion, _this.parserVersion) || other.parserVersion == _this.parserVersion)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SMSMessage;
  return Object.hashAll([runtimeType,_this.id,_this.userId,_this.sender,_this.messageHash,_this.receivedAt,_this.processedAt,_this.processingStatus,_this.messageBody,_this.bankIdentified,_this.typeIdentified,_this.amountIdentified,_this.currencyIdentified,_this.cardLast4Identified,_this.detectedBankId,_this.detectedBankName,_this.detectedType,_this.detectedAmountMinor,_this.detectedCurrency,_this.detectedCardLast4,_this.transactionId,_this.parserVersion,_this.confidence,_this.createdAt]);
}

@override
String toString() {
  final _this = this as SMSMessage;
  return 'SMSMessage(id: ${_this.id}, userId: ${_this.userId}, sender: ${_this.sender}, messageHash: ${_this.messageHash}, receivedAt: ${_this.receivedAt}, processedAt: ${_this.processedAt}, processingStatus: ${_this.processingStatus}, messageBody: ${_this.messageBody}, bankIdentified: ${_this.bankIdentified}, typeIdentified: ${_this.typeIdentified}, amountIdentified: ${_this.amountIdentified}, currencyIdentified: ${_this.currencyIdentified}, cardLast4Identified: ${_this.cardLast4Identified}, detectedBankId: ${_this.detectedBankId}, detectedBankName: ${_this.detectedBankName}, detectedType: ${_this.detectedType}, detectedAmountMinor: ${_this.detectedAmountMinor}, detectedCurrency: ${_this.detectedCurrency}, detectedCardLast4: ${_this.detectedCardLast4}, transactionId: ${_this.transactionId}, parserVersion: ${_this.parserVersion}, confidence: ${_this.confidence}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SMSMessageCopyWith<$Res>  {
  factory $SMSMessageCopyWith(SMSMessage value, $Res Function(SMSMessage) _then) = _$SMSMessageCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? sender,@JsonKey(name: 'message_hash') String messageHash,@JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired) DateTime receivedAt,@JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson) DateTime? processedAt,@JsonKey(name: 'processing_status') String processingStatus,@JsonKey(name: 'message_body') String? messageBody,@JsonKey(name: 'bank_identified') bool bankIdentified,@JsonKey(name: 'type_identified') bool typeIdentified,@JsonKey(name: 'amount_identified') bool amountIdentified,@JsonKey(name: 'currency_identified') bool currencyIdentified,@JsonKey(name: 'card_last4_identified') bool cardLast4Identified,@JsonKey(name: 'detected_bank_id') String? detectedBankId,@JsonKey(name: 'detected_bank_name') String? detectedBankName,@JsonKey(name: 'detected_type') String? detectedType,@JsonKey(name: 'detected_amount_minor') int? detectedAmountMinor,@JsonKey(name: 'detected_currency') String? detectedCurrency,@JsonKey(name: 'detected_card_last4') String? detectedCardLast4,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'parser_version') String? parserVersion, double? confidence,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$SMSMessageCopyWithImpl<$Res>
    implements $SMSMessageCopyWith<$Res> {
  _$SMSMessageCopyWithImpl(this._self, this._then);

  final SMSMessage _self;
  final $Res Function(SMSMessage) _then;

/// Create a copy of SMSMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? sender = freezed,Object? messageHash = null,Object? receivedAt = null,Object? processedAt = freezed,Object? processingStatus = null,Object? messageBody = freezed,Object? bankIdentified = null,Object? typeIdentified = null,Object? amountIdentified = null,Object? currencyIdentified = null,Object? cardLast4Identified = null,Object? detectedBankId = freezed,Object? detectedBankName = freezed,Object? detectedType = freezed,Object? detectedAmountMinor = freezed,Object? detectedCurrency = freezed,Object? detectedCardLast4 = freezed,Object? transactionId = freezed,Object? parserVersion = freezed,Object? confidence = freezed,Object? createdAt = freezed,}) {
  return _then(SMSMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,messageHash: null == messageHash ? _self.messageHash : messageHash // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,messageBody: freezed == messageBody ? _self.messageBody : messageBody // ignore: cast_nullable_to_non_nullable
as String?,bankIdentified: null == bankIdentified ? _self.bankIdentified : bankIdentified // ignore: cast_nullable_to_non_nullable
as bool,typeIdentified: null == typeIdentified ? _self.typeIdentified : typeIdentified // ignore: cast_nullable_to_non_nullable
as bool,amountIdentified: null == amountIdentified ? _self.amountIdentified : amountIdentified // ignore: cast_nullable_to_non_nullable
as bool,currencyIdentified: null == currencyIdentified ? _self.currencyIdentified : currencyIdentified // ignore: cast_nullable_to_non_nullable
as bool,cardLast4Identified: null == cardLast4Identified ? _self.cardLast4Identified : cardLast4Identified // ignore: cast_nullable_to_non_nullable
as bool,detectedBankId: freezed == detectedBankId ? _self.detectedBankId : detectedBankId // ignore: cast_nullable_to_non_nullable
as String?,detectedBankName: freezed == detectedBankName ? _self.detectedBankName : detectedBankName // ignore: cast_nullable_to_non_nullable
as String?,detectedType: freezed == detectedType ? _self.detectedType : detectedType // ignore: cast_nullable_to_non_nullable
as String?,detectedAmountMinor: freezed == detectedAmountMinor ? _self.detectedAmountMinor : detectedAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,detectedCurrency: freezed == detectedCurrency ? _self.detectedCurrency : detectedCurrency // ignore: cast_nullable_to_non_nullable
as String?,detectedCardLast4: freezed == detectedCardLast4 ? _self.detectedCardLast4 : detectedCardLast4 // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,parserVersion: freezed == parserVersion ? _self.parserVersion : parserVersion // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SMSMessage].
extension SMSMessagePatterns on SMSMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SMSMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SMSMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SMSMessage value)  $default,){
final _that = this;
switch (_that) {
case _SMSMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SMSMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SMSMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? sender, @JsonKey(name: 'message_hash')  String messageHash, @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)  DateTime receivedAt, @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)  DateTime? processedAt, @JsonKey(name: 'processing_status')  String processingStatus, @JsonKey(name: 'message_body')  String? messageBody, @JsonKey(name: 'bank_identified')  bool bankIdentified, @JsonKey(name: 'type_identified')  bool typeIdentified, @JsonKey(name: 'amount_identified')  bool amountIdentified, @JsonKey(name: 'currency_identified')  bool currencyIdentified, @JsonKey(name: 'card_last4_identified')  bool cardLast4Identified, @JsonKey(name: 'detected_bank_id')  String? detectedBankId, @JsonKey(name: 'detected_bank_name')  String? detectedBankName, @JsonKey(name: 'detected_type')  String? detectedType, @JsonKey(name: 'detected_amount_minor')  int? detectedAmountMinor, @JsonKey(name: 'detected_currency')  String? detectedCurrency, @JsonKey(name: 'detected_card_last4')  String? detectedCardLast4, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'parser_version')  String? parserVersion,  double? confidence, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SMSMessage() when $default != null:
return $default(_that.id,_that.userId,_that.sender,_that.messageHash,_that.receivedAt,_that.processedAt,_that.processingStatus,_that.messageBody,_that.bankIdentified,_that.typeIdentified,_that.amountIdentified,_that.currencyIdentified,_that.cardLast4Identified,_that.detectedBankId,_that.detectedBankName,_that.detectedType,_that.detectedAmountMinor,_that.detectedCurrency,_that.detectedCardLast4,_that.transactionId,_that.parserVersion,_that.confidence,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String? sender, @JsonKey(name: 'message_hash')  String messageHash, @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)  DateTime receivedAt, @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)  DateTime? processedAt, @JsonKey(name: 'processing_status')  String processingStatus, @JsonKey(name: 'message_body')  String? messageBody, @JsonKey(name: 'bank_identified')  bool bankIdentified, @JsonKey(name: 'type_identified')  bool typeIdentified, @JsonKey(name: 'amount_identified')  bool amountIdentified, @JsonKey(name: 'currency_identified')  bool currencyIdentified, @JsonKey(name: 'card_last4_identified')  bool cardLast4Identified, @JsonKey(name: 'detected_bank_id')  String? detectedBankId, @JsonKey(name: 'detected_bank_name')  String? detectedBankName, @JsonKey(name: 'detected_type')  String? detectedType, @JsonKey(name: 'detected_amount_minor')  int? detectedAmountMinor, @JsonKey(name: 'detected_currency')  String? detectedCurrency, @JsonKey(name: 'detected_card_last4')  String? detectedCardLast4, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'parser_version')  String? parserVersion,  double? confidence, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SMSMessage():
return $default(_that.id,_that.userId,_that.sender,_that.messageHash,_that.receivedAt,_that.processedAt,_that.processingStatus,_that.messageBody,_that.bankIdentified,_that.typeIdentified,_that.amountIdentified,_that.currencyIdentified,_that.cardLast4Identified,_that.detectedBankId,_that.detectedBankName,_that.detectedType,_that.detectedAmountMinor,_that.detectedCurrency,_that.detectedCardLast4,_that.transactionId,_that.parserVersion,_that.confidence,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String? sender, @JsonKey(name: 'message_hash')  String messageHash, @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired)  DateTime receivedAt, @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson)  DateTime? processedAt, @JsonKey(name: 'processing_status')  String processingStatus, @JsonKey(name: 'message_body')  String? messageBody, @JsonKey(name: 'bank_identified')  bool bankIdentified, @JsonKey(name: 'type_identified')  bool typeIdentified, @JsonKey(name: 'amount_identified')  bool amountIdentified, @JsonKey(name: 'currency_identified')  bool currencyIdentified, @JsonKey(name: 'card_last4_identified')  bool cardLast4Identified, @JsonKey(name: 'detected_bank_id')  String? detectedBankId, @JsonKey(name: 'detected_bank_name')  String? detectedBankName, @JsonKey(name: 'detected_type')  String? detectedType, @JsonKey(name: 'detected_amount_minor')  int? detectedAmountMinor, @JsonKey(name: 'detected_currency')  String? detectedCurrency, @JsonKey(name: 'detected_card_last4')  String? detectedCardLast4, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'parser_version')  String? parserVersion,  double? confidence, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SMSMessage() when $default != null:
return $default(_that.id,_that.userId,_that.sender,_that.messageHash,_that.receivedAt,_that.processedAt,_that.processingStatus,_that.messageBody,_that.bankIdentified,_that.typeIdentified,_that.amountIdentified,_that.currencyIdentified,_that.cardLast4Identified,_that.detectedBankId,_that.detectedBankName,_that.detectedType,_that.detectedAmountMinor,_that.detectedCurrency,_that.detectedCardLast4,_that.transactionId,_that.parserVersion,_that.confidence,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SMSMessage implements SMSMessage {
  const _SMSMessage({required this.id, @JsonKey(name: 'user_id') required this.userId, this.sender, @JsonKey(name: 'message_hash') required this.messageHash, @JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired) required this.receivedAt, @JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson) this.processedAt, @JsonKey(name: 'processing_status') this.processingStatus = 'pending', @JsonKey(name: 'message_body') this.messageBody, @JsonKey(name: 'bank_identified') this.bankIdentified = false, @JsonKey(name: 'type_identified') this.typeIdentified = false, @JsonKey(name: 'amount_identified') this.amountIdentified = false, @JsonKey(name: 'currency_identified') this.currencyIdentified = false, @JsonKey(name: 'card_last4_identified') this.cardLast4Identified = false, @JsonKey(name: 'detected_bank_id') this.detectedBankId, @JsonKey(name: 'detected_bank_name') this.detectedBankName, @JsonKey(name: 'detected_type') this.detectedType, @JsonKey(name: 'detected_amount_minor') this.detectedAmountMinor, @JsonKey(name: 'detected_currency') this.detectedCurrency, @JsonKey(name: 'detected_card_last4') this.detectedCardLast4, @JsonKey(name: 'transaction_id') this.transactionId, @JsonKey(name: 'parser_version') this.parserVersion, this.confidence, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _SMSMessage.fromJson(Map<String, dynamic> json) => _$SMSMessageFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String? sender;
@override@JsonKey(name: 'message_hash') final  String messageHash;
@override@JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired) final  DateTime receivedAt;
@override@JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson) final  DateTime? processedAt;
@override@JsonKey(name: 'processing_status') final  String processingStatus;
/// Original SMS body. Stored so the detection record remains auditable;
/// callers/loggers must still avoid printing it.
@override@JsonKey(name: 'message_body') final  String? messageBody;
@override@JsonKey(name: 'bank_identified') final  bool bankIdentified;
@override@JsonKey(name: 'type_identified') final  bool typeIdentified;
@override@JsonKey(name: 'amount_identified') final  bool amountIdentified;
@override@JsonKey(name: 'currency_identified') final  bool currencyIdentified;
@override@JsonKey(name: 'card_last4_identified') final  bool cardLast4Identified;
@override@JsonKey(name: 'detected_bank_id') final  String? detectedBankId;
@override@JsonKey(name: 'detected_bank_name') final  String? detectedBankName;
@override@JsonKey(name: 'detected_type') final  String? detectedType;
@override@JsonKey(name: 'detected_amount_minor') final  int? detectedAmountMinor;
@override@JsonKey(name: 'detected_currency') final  String? detectedCurrency;
@override@JsonKey(name: 'detected_card_last4') final  String? detectedCardLast4;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override@JsonKey(name: 'parser_version') final  String? parserVersion;
@override final  double? confidence;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of SMSMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SMSMessageCopyWith<_SMSMessage> get copyWith => __$SMSMessageCopyWithImpl<_SMSMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SMSMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SMSMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.messageHash, messageHash) || other.messageHash == messageHash)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.messageBody, messageBody) || other.messageBody == messageBody)&&(identical(other.bankIdentified, bankIdentified) || other.bankIdentified == bankIdentified)&&(identical(other.typeIdentified, typeIdentified) || other.typeIdentified == typeIdentified)&&(identical(other.amountIdentified, amountIdentified) || other.amountIdentified == amountIdentified)&&(identical(other.currencyIdentified, currencyIdentified) || other.currencyIdentified == currencyIdentified)&&(identical(other.cardLast4Identified, cardLast4Identified) || other.cardLast4Identified == cardLast4Identified)&&(identical(other.detectedBankId, detectedBankId) || other.detectedBankId == detectedBankId)&&(identical(other.detectedBankName, detectedBankName) || other.detectedBankName == detectedBankName)&&(identical(other.detectedType, detectedType) || other.detectedType == detectedType)&&(identical(other.detectedAmountMinor, detectedAmountMinor) || other.detectedAmountMinor == detectedAmountMinor)&&(identical(other.detectedCurrency, detectedCurrency) || other.detectedCurrency == detectedCurrency)&&(identical(other.detectedCardLast4, detectedCardLast4) || other.detectedCardLast4 == detectedCardLast4)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.parserVersion, parserVersion) || other.parserVersion == parserVersion)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,userId,sender,messageHash,receivedAt,processedAt,processingStatus,messageBody,bankIdentified,typeIdentified,amountIdentified,currencyIdentified,cardLast4Identified,detectedBankId,detectedBankName,detectedType,detectedAmountMinor,detectedCurrency,detectedCardLast4,transactionId,parserVersion,confidence,createdAt]);
}

@override
String toString() {
    return 'SMSMessage(id: $id, userId: $userId, sender: $sender, messageHash: $messageHash, receivedAt: $receivedAt, processedAt: $processedAt, processingStatus: $processingStatus, messageBody: $messageBody, bankIdentified: $bankIdentified, typeIdentified: $typeIdentified, amountIdentified: $amountIdentified, currencyIdentified: $currencyIdentified, cardLast4Identified: $cardLast4Identified, detectedBankId: $detectedBankId, detectedBankName: $detectedBankName, detectedType: $detectedType, detectedAmountMinor: $detectedAmountMinor, detectedCurrency: $detectedCurrency, detectedCardLast4: $detectedCardLast4, transactionId: $transactionId, parserVersion: $parserVersion, confidence: $confidence, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SMSMessageCopyWith<$Res> implements $SMSMessageCopyWith<$Res> {
  factory _$SMSMessageCopyWith(_SMSMessage value, $Res Function(_SMSMessage) _then) = __$SMSMessageCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String? sender,@JsonKey(name: 'message_hash') String messageHash,@JsonKey(name: 'received_at', fromJson: _dateTimeFromJsonRequired) DateTime receivedAt,@JsonKey(name: 'processed_at', fromJson: _dateTimeFromJson) DateTime? processedAt,@JsonKey(name: 'processing_status') String processingStatus,@JsonKey(name: 'message_body') String? messageBody,@JsonKey(name: 'bank_identified') bool bankIdentified,@JsonKey(name: 'type_identified') bool typeIdentified,@JsonKey(name: 'amount_identified') bool amountIdentified,@JsonKey(name: 'currency_identified') bool currencyIdentified,@JsonKey(name: 'card_last4_identified') bool cardLast4Identified,@JsonKey(name: 'detected_bank_id') String? detectedBankId,@JsonKey(name: 'detected_bank_name') String? detectedBankName,@JsonKey(name: 'detected_type') String? detectedType,@JsonKey(name: 'detected_amount_minor') int? detectedAmountMinor,@JsonKey(name: 'detected_currency') String? detectedCurrency,@JsonKey(name: 'detected_card_last4') String? detectedCardLast4,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'parser_version') String? parserVersion, double? confidence,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$SMSMessageCopyWithImpl<$Res>
    implements _$SMSMessageCopyWith<$Res> {
  __$SMSMessageCopyWithImpl(this._self, this._then);

  final _SMSMessage _self;
  final $Res Function(_SMSMessage) _then;

/// Create a copy of SMSMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? sender = freezed,Object? messageHash = null,Object? receivedAt = null,Object? processedAt = freezed,Object? processingStatus = null,Object? messageBody = freezed,Object? bankIdentified = null,Object? typeIdentified = null,Object? amountIdentified = null,Object? currencyIdentified = null,Object? cardLast4Identified = null,Object? detectedBankId = freezed,Object? detectedBankName = freezed,Object? detectedType = freezed,Object? detectedAmountMinor = freezed,Object? detectedCurrency = freezed,Object? detectedCardLast4 = freezed,Object? transactionId = freezed,Object? parserVersion = freezed,Object? confidence = freezed,Object? createdAt = freezed,}) {
  return _then(_SMSMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,messageHash: null == messageHash ? _self.messageHash : messageHash // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,messageBody: freezed == messageBody ? _self.messageBody : messageBody // ignore: cast_nullable_to_non_nullable
as String?,bankIdentified: null == bankIdentified ? _self.bankIdentified : bankIdentified // ignore: cast_nullable_to_non_nullable
as bool,typeIdentified: null == typeIdentified ? _self.typeIdentified : typeIdentified // ignore: cast_nullable_to_non_nullable
as bool,amountIdentified: null == amountIdentified ? _self.amountIdentified : amountIdentified // ignore: cast_nullable_to_non_nullable
as bool,currencyIdentified: null == currencyIdentified ? _self.currencyIdentified : currencyIdentified // ignore: cast_nullable_to_non_nullable
as bool,cardLast4Identified: null == cardLast4Identified ? _self.cardLast4Identified : cardLast4Identified // ignore: cast_nullable_to_non_nullable
as bool,detectedBankId: freezed == detectedBankId ? _self.detectedBankId : detectedBankId // ignore: cast_nullable_to_non_nullable
as String?,detectedBankName: freezed == detectedBankName ? _self.detectedBankName : detectedBankName // ignore: cast_nullable_to_non_nullable
as String?,detectedType: freezed == detectedType ? _self.detectedType : detectedType // ignore: cast_nullable_to_non_nullable
as String?,detectedAmountMinor: freezed == detectedAmountMinor ? _self.detectedAmountMinor : detectedAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,detectedCurrency: freezed == detectedCurrency ? _self.detectedCurrency : detectedCurrency // ignore: cast_nullable_to_non_nullable
as String?,detectedCardLast4: freezed == detectedCardLast4 ? _self.detectedCardLast4 : detectedCardLast4 // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,parserVersion: freezed == parserVersion ? _self.parserVersion : parserVersion // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Expense {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'transaction_id') String? get transactionId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'amount_minor') int get amountMinor; String get currency;@JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired) DateTime get expenseDate;@JsonKey(name: 'payment_method') PaymentMethod get paymentMethod;@JsonKey(name: 'merchant_id') String? get merchantId; String? get notes;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Expense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.expenseDate, _this.expenseDate) || other.expenseDate == _this.expenseDate)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.merchantId, _this.merchantId) || other.merchantId == _this.merchantId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Expense;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.transactionId,_this.categoryId,_this.amountMinor,_this.currency,_this.expenseDate,_this.paymentMethod,_this.merchantId,_this.notes,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Expense;
  return 'Expense(id: ${_this.id}, userId: ${_this.userId}, transactionId: ${_this.transactionId}, categoryId: ${_this.categoryId}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, expenseDate: ${_this.expenseDate}, paymentMethod: ${_this.paymentMethod}, merchantId: ${_this.merchantId}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired) DateTime expenseDate,@JsonKey(name: 'payment_method') PaymentMethod paymentMethod,@JsonKey(name: 'merchant_id') String? merchantId, String? notes,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? transactionId = freezed,Object? categoryId = freezed,Object? amountMinor = null,Object? currency = null,Object? expenseDate = null,Object? paymentMethod = null,Object? merchantId = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,merchantId: freezed == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)  DateTime expenseDate, @JsonKey(name: 'payment_method')  PaymentMethod paymentMethod, @JsonKey(name: 'merchant_id')  String? merchantId,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.userId,_that.transactionId,_that.categoryId,_that.amountMinor,_that.currency,_that.expenseDate,_that.paymentMethod,_that.merchantId,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)  DateTime expenseDate, @JsonKey(name: 'payment_method')  PaymentMethod paymentMethod, @JsonKey(name: 'merchant_id')  String? merchantId,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.userId,_that.transactionId,_that.categoryId,_that.amountMinor,_that.currency,_that.expenseDate,_that.paymentMethod,_that.merchantId,_that.notes,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'transaction_id')  String? transactionId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'amount_minor')  int amountMinor,  String currency, @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired)  DateTime expenseDate, @JsonKey(name: 'payment_method')  PaymentMethod paymentMethod, @JsonKey(name: 'merchant_id')  String? merchantId,  String? notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.userId,_that.transactionId,_that.categoryId,_that.amountMinor,_that.currency,_that.expenseDate,_that.paymentMethod,_that.merchantId,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'transaction_id') this.transactionId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'amount_minor') required this.amountMinor, this.currency = 'EGP', @JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired) required this.expenseDate, @JsonKey(name: 'payment_method') required this.paymentMethod, @JsonKey(name: 'merchant_id') this.merchantId, this.notes, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'amount_minor') final  int amountMinor;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired) final  DateTime expenseDate;
@override@JsonKey(name: 'payment_method') final  PaymentMethod paymentMethod;
@override@JsonKey(name: 'merchant_id') final  String? merchantId;
@override final  String? notes;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,transactionId,categoryId,amountMinor,currency,expenseDate,paymentMethod,merchantId,notes,createdAt,updatedAt);
}

@override
String toString() {
    return 'Expense(id: $id, userId: $userId, transactionId: $transactionId, categoryId: $categoryId, amountMinor: $amountMinor, currency: $currency, expenseDate: $expenseDate, paymentMethod: $paymentMethod, merchantId: $merchantId, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'transaction_id') String? transactionId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'amount_minor') int amountMinor, String currency,@JsonKey(name: 'expense_date', fromJson: _dateTimeFromJsonRequired) DateTime expenseDate,@JsonKey(name: 'payment_method') PaymentMethod paymentMethod,@JsonKey(name: 'merchant_id') String? merchantId, String? notes,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? transactionId = freezed,Object? categoryId = freezed,Object? amountMinor = null,Object? currency = null,Object? expenseDate = null,Object? paymentMethod = null,Object? merchantId = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,merchantId: freezed == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ExpenseItem {

 String get id;@JsonKey(name: 'expense_id') String get expenseId;@JsonKey(name: 'item_id') String get itemId; int get quantity;@JsonKey(name: 'unit_price_minor') int get unitPriceMinor;@JsonKey(name: 'total_price_minor') int get totalPriceMinor;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of ExpenseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseItemCopyWith<ExpenseItem> get copyWith => _$ExpenseItemCopyWithImpl<ExpenseItem>(this as ExpenseItem, _$identity);

  /// Serializes this ExpenseItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpenseItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.expenseId, _this.expenseId) || other.expenseId == _this.expenseId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&(identical(other.totalPriceMinor, _this.totalPriceMinor) || other.totalPriceMinor == _this.totalPriceMinor)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpenseItem;
  return Object.hash(runtimeType,_this.id,_this.expenseId,_this.itemId,_this.quantity,_this.unitPriceMinor,_this.totalPriceMinor,_this.createdAt);
}

@override
String toString() {
  final _this = this as ExpenseItem;
  return 'ExpenseItem(id: ${_this.id}, expenseId: ${_this.expenseId}, itemId: ${_this.itemId}, quantity: ${_this.quantity}, unitPriceMinor: ${_this.unitPriceMinor}, totalPriceMinor: ${_this.totalPriceMinor}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ExpenseItemCopyWith<$Res>  {
  factory $ExpenseItemCopyWith(ExpenseItem value, $Res Function(ExpenseItem) _then) = _$ExpenseItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'item_id') String itemId, int quantity,@JsonKey(name: 'unit_price_minor') int unitPriceMinor,@JsonKey(name: 'total_price_minor') int totalPriceMinor,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$ExpenseItemCopyWithImpl<$Res>
    implements $ExpenseItemCopyWith<$Res> {
  _$ExpenseItemCopyWithImpl(this._self, this._then);

  final ExpenseItem _self;
  final $Res Function(ExpenseItem) _then;

/// Create a copy of ExpenseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseId = null,Object? itemId = null,Object? quantity = null,Object? unitPriceMinor = null,Object? totalPriceMinor = null,Object? createdAt = freezed,}) {
  return _then(ExpenseItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,totalPriceMinor: null == totalPriceMinor ? _self.totalPriceMinor : totalPriceMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseItem].
extension ExpenseItemPatterns on ExpenseItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseItem value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseItem value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'item_id')  String itemId,  int quantity, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_price_minor')  int totalPriceMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseItem() when $default != null:
return $default(_that.id,_that.expenseId,_that.itemId,_that.quantity,_that.unitPriceMinor,_that.totalPriceMinor,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'item_id')  String itemId,  int quantity, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_price_minor')  int totalPriceMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseItem():
return $default(_that.id,_that.expenseId,_that.itemId,_that.quantity,_that.unitPriceMinor,_that.totalPriceMinor,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'item_id')  String itemId,  int quantity, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_price_minor')  int totalPriceMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseItem() when $default != null:
return $default(_that.id,_that.expenseId,_that.itemId,_that.quantity,_that.unitPriceMinor,_that.totalPriceMinor,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseItem implements ExpenseItem {
  const _ExpenseItem({required this.id, @JsonKey(name: 'expense_id') required this.expenseId, @JsonKey(name: 'item_id') required this.itemId, required this.quantity, @JsonKey(name: 'unit_price_minor') required this.unitPriceMinor, @JsonKey(name: 'total_price_minor') required this.totalPriceMinor, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _ExpenseItem.fromJson(Map<String, dynamic> json) => _$ExpenseItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'expense_id') final  String expenseId;
@override@JsonKey(name: 'item_id') final  String itemId;
@override final  int quantity;
@override@JsonKey(name: 'unit_price_minor') final  int unitPriceMinor;
@override@JsonKey(name: 'total_price_minor') final  int totalPriceMinor;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of ExpenseItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseItemCopyWith<_ExpenseItem> get copyWith => __$ExpenseItemCopyWithImpl<_ExpenseItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseItem&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.totalPriceMinor, totalPriceMinor) || other.totalPriceMinor == totalPriceMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,expenseId,itemId,quantity,unitPriceMinor,totalPriceMinor,createdAt);
}

@override
String toString() {
    return 'ExpenseItem(id: $id, expenseId: $expenseId, itemId: $itemId, quantity: $quantity, unitPriceMinor: $unitPriceMinor, totalPriceMinor: $totalPriceMinor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseItemCopyWith<$Res> implements $ExpenseItemCopyWith<$Res> {
  factory _$ExpenseItemCopyWith(_ExpenseItem value, $Res Function(_ExpenseItem) _then) = __$ExpenseItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'item_id') String itemId, int quantity,@JsonKey(name: 'unit_price_minor') int unitPriceMinor,@JsonKey(name: 'total_price_minor') int totalPriceMinor,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$ExpenseItemCopyWithImpl<$Res>
    implements _$ExpenseItemCopyWith<$Res> {
  __$ExpenseItemCopyWithImpl(this._self, this._then);

  final _ExpenseItem _self;
  final $Res Function(_ExpenseItem) _then;

/// Create a copy of ExpenseItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseId = null,Object? itemId = null,Object? quantity = null,Object? unitPriceMinor = null,Object? totalPriceMinor = null,Object? createdAt = freezed,}) {
  return _then(_ExpenseItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,totalPriceMinor: null == totalPriceMinor ? _self.totalPriceMinor : totalPriceMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ItemUsage {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'expense_id') String get expenseId; int get quantity;@JsonKey(name: 'total_amount_minor') int get totalAmountMinor;@JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired) DateTime get usageDate;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? get createdAt;
/// Create a copy of ItemUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemUsageCopyWith<ItemUsage> get copyWith => _$ItemUsageCopyWithImpl<ItemUsage>(this as ItemUsage, _$identity);

  /// Serializes this ItemUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemUsage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.expenseId, _this.expenseId) || other.expenseId == _this.expenseId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.totalAmountMinor, _this.totalAmountMinor) || other.totalAmountMinor == _this.totalAmountMinor)&&(identical(other.usageDate, _this.usageDate) || other.usageDate == _this.usageDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemUsage;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.itemId,_this.expenseId,_this.quantity,_this.totalAmountMinor,_this.usageDate,_this.createdAt);
}

@override
String toString() {
  final _this = this as ItemUsage;
  return 'ItemUsage(id: ${_this.id}, userId: ${_this.userId}, itemId: ${_this.itemId}, expenseId: ${_this.expenseId}, quantity: ${_this.quantity}, totalAmountMinor: ${_this.totalAmountMinor}, usageDate: ${_this.usageDate}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ItemUsageCopyWith<$Res>  {
  factory $ItemUsageCopyWith(ItemUsage value, $Res Function(ItemUsage) _then) = _$ItemUsageCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'expense_id') String expenseId, int quantity,@JsonKey(name: 'total_amount_minor') int totalAmountMinor,@JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired) DateTime usageDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$ItemUsageCopyWithImpl<$Res>
    implements $ItemUsageCopyWith<$Res> {
  _$ItemUsageCopyWithImpl(this._self, this._then);

  final ItemUsage _self;
  final $Res Function(ItemUsage) _then;

/// Create a copy of ItemUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? expenseId = null,Object? quantity = null,Object? totalAmountMinor = null,Object? usageDate = null,Object? createdAt = freezed,}) {
  return _then(ItemUsage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalAmountMinor: null == totalAmountMinor ? _self.totalAmountMinor : totalAmountMinor // ignore: cast_nullable_to_non_nullable
as int,usageDate: null == usageDate ? _self.usageDate : usageDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemUsage].
extension ItemUsagePatterns on ItemUsage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemUsage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemUsage value)  $default,){
final _that = this;
switch (_that) {
case _ItemUsage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ItemUsage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'expense_id')  String expenseId,  int quantity, @JsonKey(name: 'total_amount_minor')  int totalAmountMinor, @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)  DateTime usageDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemUsage() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.expenseId,_that.quantity,_that.totalAmountMinor,_that.usageDate,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'expense_id')  String expenseId,  int quantity, @JsonKey(name: 'total_amount_minor')  int totalAmountMinor, @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)  DateTime usageDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ItemUsage():
return $default(_that.id,_that.userId,_that.itemId,_that.expenseId,_that.quantity,_that.totalAmountMinor,_that.usageDate,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'expense_id')  String expenseId,  int quantity, @JsonKey(name: 'total_amount_minor')  int totalAmountMinor, @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired)  DateTime usageDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemUsage() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.expenseId,_that.quantity,_that.totalAmountMinor,_that.usageDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemUsage implements ItemUsage {
  const _ItemUsage({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'expense_id') required this.expenseId, required this.quantity, @JsonKey(name: 'total_amount_minor') required this.totalAmountMinor, @JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired) required this.usageDate, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt});
  factory _ItemUsage.fromJson(Map<String, dynamic> json) => _$ItemUsageFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'expense_id') final  String expenseId;
@override final  int quantity;
@override@JsonKey(name: 'total_amount_minor') final  int totalAmountMinor;
@override@JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired) final  DateTime usageDate;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of ItemUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemUsageCopyWith<_ItemUsage> get copyWith => __$ItemUsageCopyWithImpl<_ItemUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemUsage&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalAmountMinor, totalAmountMinor) || other.totalAmountMinor == totalAmountMinor)&&(identical(other.usageDate, usageDate) || other.usageDate == usageDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,itemId,expenseId,quantity,totalAmountMinor,usageDate,createdAt);
}

@override
String toString() {
    return 'ItemUsage(id: $id, userId: $userId, itemId: $itemId, expenseId: $expenseId, quantity: $quantity, totalAmountMinor: $totalAmountMinor, usageDate: $usageDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ItemUsageCopyWith<$Res> implements $ItemUsageCopyWith<$Res> {
  factory _$ItemUsageCopyWith(_ItemUsage value, $Res Function(_ItemUsage) _then) = __$ItemUsageCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'expense_id') String expenseId, int quantity,@JsonKey(name: 'total_amount_minor') int totalAmountMinor,@JsonKey(name: 'usage_date', fromJson: _dateTimeFromJsonRequired) DateTime usageDate,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$ItemUsageCopyWithImpl<$Res>
    implements _$ItemUsageCopyWith<$Res> {
  __$ItemUsageCopyWithImpl(this._self, this._then);

  final _ItemUsage _self;
  final $Res Function(_ItemUsage) _then;

/// Create a copy of ItemUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? expenseId = null,Object? quantity = null,Object? totalAmountMinor = null,Object? usageDate = null,Object? createdAt = freezed,}) {
  return _then(_ItemUsage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalAmountMinor: null == totalAmountMinor ? _self.totalAmountMinor : totalAmountMinor // ignore: cast_nullable_to_non_nullable
as int,usageDate: null == usageDate ? _self.usageDate : usageDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
