// ignore_for_file: prefer_const_constructors

import 'package:drift/drift.dart';
import '../../models/transaction_model.dart';
import '../database/app_database.dart' as db;

class SmsMessageLocalDataSource {
  final db.AppDatabase _db;
  SmsMessageLocalDataSource(this._db);

  Future<void> detachTransaction(String transactionId) async {
    await (_db.update(_db.smsMessages)
          ..where((t) => t.transactionId.equals(transactionId)))
        .write(db.SmsMessagesCompanion(
          transactionId: Value(null),
          processingStatus: const Value('processed'),
        ));
  }

  /// Detected bank name per transaction id, for the user's rows.
  ///
  /// `transactions` stores a bank UUID (`bank_id`) while `detected_cards` stores
  /// a bank NAME, so the detection record is the existing bridge between the two
  /// identifier spaces. This lookup reuses that link rather than introducing a
  /// second bank-matching mechanism.
  ///
  /// Only rows that were positively identified contribute a value; a message
  /// with no detected bank is omitted so callers treat it as "unknown bank".
  Future<Map<String, String>> bankNamesByTransactionId(String userId) async {
    final rows = await (_db.select(_db.smsMessages)
          ..where((t) =>
              t.userId.equals(userId) &
              t.transactionId.isNotNull() &
              t.detectedBankName.isNotNull() &
              t.bankIdentified.equals(true)))
        .get();
    final result = <String, String>{};
    for (final row in rows) {
      final txnId = row.transactionId;
      final name = row.detectedBankName;
      if (txnId != null && name != null && name.trim().isNotEmpty) {
        result[txnId] = name;
      }
    }
    return result;
  }

  Future<void> upsert(SMSMessage message) async {
    await _db.into(_db.smsMessages).insert(
      db.SmsMessagesCompanion(
        id: Value(message.id),
        userId: Value(message.userId),
        sender: Value(message.sender),
        messageHash: Value(message.messageHash),
        messageBody: Value(message.messageBody),
        receivedAt: Value(message.receivedAt),
        processedAt: Value(message.processedAt),
        processingStatus: Value(message.processingStatus),
        bankIdentified: Value(message.bankIdentified),
        typeIdentified: Value(message.typeIdentified),
        amountIdentified: Value(message.amountIdentified),
        currencyIdentified: Value(message.currencyIdentified),
        cardLast4Identified: Value(message.cardLast4Identified),
        detectedBankId: Value(message.detectedBankId),
        detectedBankName: Value(message.detectedBankName),
        detectedType: Value(message.detectedType),
        detectedAmountMinor: Value(message.detectedAmountMinor),
        detectedCurrency: Value(message.detectedCurrency),
        detectedCardLast4: Value(message.detectedCardLast4),
        transactionId: Value(message.transactionId),
        parserVersion: Value(message.parserVersion),
        confidence: Value(message.confidence),
        createdAt: Value(message.createdAt ?? DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
