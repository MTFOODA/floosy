// ignore_for_file: prefer_const_constructors

import 'package:drift/drift.dart';
import 'dart:convert';
import 'private_record_store.dart';
import '../../../domain/entities/transaction_model.dart';
import '../database/app_database.dart' as db;

class SmsMessageLocalDataSource {
  final db.AppDatabase _db;
  SmsMessageLocalDataSource(this._db);

  Future<String?> bodyFor(String userId, String hash) async {
    final row = await _db
        .customSelect(
          'SELECT payload FROM sms_payloads WHERE owner=? AND hash=?',
          variables: [Variable(userId), Variable(hash)],
        )
        .getSingleOrNull();
    return row == null
        ? null
        : utf8.decode(unpackPrivateData(row.read<Uint8List>('payload')));
  }

  Future<void> compactLegacyPayloads() async {
    while (true) {
      final rows =
          await (_db.select(_db.smsMessages)
                ..where((t) => t.messageBody.isNotNull())
                ..limit(100))
              .get();
      if (rows.isEmpty) break;
      await _db.transaction(() async {
        for (final r in rows) {
          await _db.customStatement(
            'INSERT OR IGNORE INTO sms_payloads(owner,hash,payload) VALUES(?,?,?)',
            [
              r.userId,
              r.messageHash,
              packPrivateData(utf8.encode(r.messageBody!)),
            ],
          );
          if (await bodyFor(r.userId, r.messageHash) != r.messageBody) {
            throw StateError('Message verification failed');
          }
          await (_db.update(_db.smsMessages)..where((t) => t.id.equals(r.id)))
              .write(const db.SmsMessagesCompanion(messageBody: Value(null)));
        }
      });
    }
  }

  Future<void> setDetectedBank(
    String userId,
    String transactionId,
    String bankName,
  ) =>
      (_db.update(_db.smsMessages)..where(
            (t) =>
                t.userId.equals(userId) & t.transactionId.equals(transactionId),
          ))
          .write(
            db.SmsMessagesCompanion(
              detectedBankName: Value(bankName),
              bankIdentified: const Value(true),
            ),
          )
          .then((_) {});

  Future<List<SMSMessage>> linkedMessages(String userId) async {
    final rows =
        await (_db.select(_db.smsMessages)..where(
              (t) => t.userId.equals(userId) & t.transactionId.isNotNull(),
            ))
            .get();
    return Future.wait(
      rows
          .map(
            (r) async => SMSMessage(
              id: r.id,
              userId: r.userId,
              messageHash: r.messageHash,
              receivedAt: r.receivedAt,
              sender: r.sender,
              messageBody:
                  r.messageBody ?? await bodyFor(r.userId, r.messageHash),
              transactionId: r.transactionId,
              detectedBankName: r.detectedBankName,
            ),
          )
          .toList(),
    );
  }

  Future<void> detachTransaction(String transactionId) async {
    await (_db.update(
      _db.smsMessages,
    )..where((t) => t.transactionId.equals(transactionId))).write(
      db.SmsMessagesCompanion(
        transactionId: Value(null),
        processingStatus: const Value('processed'),
      ),
    );
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
    final rows =
        await (_db.select(_db.smsMessages)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.transactionId.isNotNull() &
                  t.detectedBankName.isNotNull() &
                  t.bankIdentified.equals(true),
            ))
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
    await _db.transaction(() async {
      if (message.messageBody != null) {
        await _db.customStatement(
          '''INSERT INTO sms_payloads(owner,hash,payload) VALUES(?,?,?)
        ON CONFLICT(owner,hash) DO UPDATE SET payload=excluded.payload''',
          [
            message.userId,
            message.messageHash,
            packPrivateData(utf8.encode(message.messageBody!)),
          ],
        );
      }
      await _db
          .into(_db.smsMessages)
          .insert(
            db.SmsMessagesCompanion(
              id: Value(message.id),
              userId: Value(message.userId),
              sender: Value(message.sender),
              messageHash: Value(message.messageHash),
              messageBody: const Value(null),
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
    });
  }
}
