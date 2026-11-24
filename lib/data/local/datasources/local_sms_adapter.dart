import 'package:drift/drift.dart';
import '../../../domain/entities/transaction_model.dart';
import '../../remote/datasources/sms_remote_datasource.dart';
import 'private_record_store.dart';
import 'sms_message_local_datasource.dart';
import '../database/app_database.dart' show SmsMessagesCompanion;

class LocalSmsAdapter extends SmsRemoteDataSource {
  final PrivateRecordStore store;
  final SmsMessageLocalDataSource local;
  LocalSmsAdapter(super.client, this.store)
    : local = SmsMessageLocalDataSource(store.database);
  @override
  Future<SMSMessage> upsertSmsMessage(SMSMessage message) async {
    if (message.userId != store.owner) throw StateError('Account changed');
    await local.upsert(message);
    return message;
  }

  @override
  Future<void> updateSmsMessage(SMSMessage message) async {
    await upsertSmsMessage(message);
  }

  @override
  Future<bool> isKnownMessage(String userId, String messageHash) async =>
      (await knownMessageHashes(userId, [messageHash])).isNotEmpty;
  @override
  Future<Set<String>> knownMessageHashes(
    String userId,
    List<String> messageHashes,
  ) async {
    if (userId != store.owner) throw StateError('Account changed');
    final rows =
        await (store.database.select(store.database.smsMessages)..where(
              (r) =>
                  r.userId.equals(userId) &
                  r.messageHash.isIn(messageHashes) &
                  r.processingStatus.equals('processed'),
            ))
            .get();
    return rows.map((r) => r.messageHash).toSet();
  }

  @override
  Future<void> linkTransaction({
    required String smsMessageId,
    required String transactionId,
  }) async {
    await (store.database.update(store.database.smsMessages)..where(
          (r) => r.id.equals(smsMessageId) & r.userId.equals(store.owner),
        ))
        .write(
          SmsMessagesCompanion(
            transactionId: Value(transactionId),
            processingStatus: const Value('processed'),
          ),
        );
  }

  @override
  Future<void> deleteTransactionReferences(String transactionId) async {
    await (store.database.update(store.database.smsMessages)..where(
          (r) =>
              r.transactionId.equals(transactionId) &
              r.userId.equals(store.owner),
        ))
        .write(
          const SmsMessagesCompanion(
            transactionId: Value(null),
            processingStatus: Value('processed'),
          ),
        );
  }

  @override
  Future<List<SMSMessage>> getSmsMessages({
    required String userId,
    int limit = 100,
  }) async {
    if (userId != store.owner) throw StateError('Account changed');
    final rows =
        await (store.database.select(store.database.smsMessages)
              ..where((r) => r.userId.equals(userId))
              ..orderBy([(r) => OrderingTerm.desc(r.receivedAt)])
              ..limit(limit))
            .get();
    return Future.wait(
      rows.map(
        (r) async => SMSMessage(
          id: r.id,
          userId: r.userId,
          messageHash: r.messageHash,
          receivedAt: r.receivedAt,
          sender: r.sender,
          messageBody: await local.bodyFor(userId, r.messageHash),
          transactionId: r.transactionId,
          detectedBankName: r.detectedBankName,
          processingStatus: r.processingStatus,
          processedAt: r.processedAt,
          createdAt: r.createdAt,
          bankIdentified: r.bankIdentified,
          typeIdentified: r.typeIdentified,
          amountIdentified: r.amountIdentified,
          currencyIdentified: r.currencyIdentified,
          cardLast4Identified: r.cardLast4Identified,
          detectedBankId: r.detectedBankId,
          detectedType: r.detectedType,
          detectedAmountMinor: r.detectedAmountMinor,
          detectedCurrency: r.detectedCurrency,
          detectedCardLast4: r.detectedCardLast4,
          parserVersion: r.parserVersion,
          confidence: r.confidence,
        ),
      ),
    );
  }
}
