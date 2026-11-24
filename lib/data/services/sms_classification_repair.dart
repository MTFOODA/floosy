import '../local/datasources/private_record_store.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../repositories/transaction_repository.dart';
import '../../domain/entities/transaction_model.dart';
import '../../domain/entities/detected_card_model.dart';
import '../../domain/services/card_ownership.dart';
import 'sms_parser_service.dart';

/// Repair only proven promotional SMS imports. Retain the source and dedupe
/// identity, and reverse derived movements through the normal delete path.
class SmsClassificationRepair {
  static const version = 'sms-promotion-repair-v1';
  final PrivateRecordStore store;
  final SmsMessageLocalDataSource messages;
  final TransactionRepository transactions;
  SmsClassificationRepair(this.store, this.messages, this.transactions);

  Future<int> run(String user) async {
    if (store.owner != user) throw StateError('Account changed');
    if (await store.get('preferences', version) != null) return 0;
    return store.database.transaction(() async {
      final rows = {
        for (final t in await transactions.getTransactions(userId: user))
          t.id: t,
      };
      var removed = 0;
      final linked = await messages.linkedMessages(user);
      for (final message in linked) {
        final transaction = rows[message.transactionId];
        if (transaction == null ||
            transaction.source != TransactionSource.sms ||
            !SMSParser.isPromotional(message.messageBody ?? '')) {
          continue;
        }
        if (store.owner != user) throw StateError('Account changed');
        await transactions.deleteTransaction(transactionId: transaction.id);
        rows.remove(transaction.id);
        await store.database.customStatement(
          'UPDATE sms_messages SET processing_status=?,detected_type=NULL,type_identified=0,parser_version=? WHERE user_id=? AND message_hash=?',
          ['ignored_promotion', '4', user, message.messageHash],
        );
        await store.database.customStatement(
          'UPDATE processed_sms_messages SET transaction_id=NULL WHERE user_id=? AND message_hash=?',
          [user, message.messageHash],
        );
        removed++;
      }
      if (removed > 0) {
        final cards = (await store.list(
          'detected_cards',
        )).map(DetectedCard.fromJson).toList();
        final banks = {
          for (final message in linked)
            message.transactionId: message.detectedBankName,
        };
        for (final card in cards) {
          final count = rows.values
              .where(
                (t) => CardOwnership.belongsToCard(
                  t,
                  card,
                  cards,
                  (t) =>
                      banks[t.id] ??
                      BankCatalog.byIdentity(t.merchantName)?.name,
                ),
              )
              .length;
          await store.put(
            'detected_cards',
            card.copyWith(transactionCount: count).toJson(),
          );
        }
      }
      if (store.owner != user) throw StateError('Account changed');
      await store.put('preferences', {'id': version, 'removed_count': removed});
      return removed;
    });
  }
}
