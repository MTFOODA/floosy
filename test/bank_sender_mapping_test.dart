import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floosy/data/services/bank_sender_mapping_store.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
import 'package:floosy/data/repositories/money_repository.dart';

class _UntouchedMoney extends Fake implements MoneyRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'rejected supported bank cannot enter the financial processor',
    () async {
      final store = BankSenderMappingStore();
      await store.rejectSender('alice', 'CIB');
      final processor = SMSTransactionProcessor(
        moneyRepository: _UntouchedMoney(),
        bankSenderMappingStore: BankSenderMappingStore(),
      );
      expect(
        await processor.process(
          userId: 'alice',
          sender: 'CIB',
          smsContent:
              'Purchase EGP 125.50 using card ending 1234 at TEST SHOP.',
        ),
        isFalse,
      );
    },
  );
  test(
    'rejection survives store recreation, normalization and another scan',
    () async {
      final store = BankSenderMappingStore();
      await store.markUnknown('alice', '  Unknown-Sender  ');
      await store.rejectSender('alice', 'unknown-sender');
      final restarted = BankSenderMappingStore();
      await restarted.markUnknown('alice', 'UNKNOWN-SENDER');
      expect(await restarted.getUnknownSenders('alice'), isEmpty);
      expect(await restarted.isRejected('alice', ' Unknown-Sender '), isTrue);
      expect(
        await restarted.getBankForSender('alice', 'unknown-sender'),
        isNull,
      );
    },
  );
  test(
    'rejected known or manually mapped sender cannot be reimported',
    () async {
      final store = BankSenderMappingStore();
      await store.setMapping('alice', 'CIB', 'Commercial International Bank');
      await store.rejectSender('alice', 'CIB');
      expect(await store.getBankForSender('alice', 'CIB'), isNull);
      await expectLater(
        store.setMapping('alice', 'CIB', 'Another Bank'),
        throwsStateError,
      );
      await store.restoreSender('alice', 'cib');
      expect(await store.isRejected('alice', 'CIB'), isFalse);
      expect(await store.getUnknownSenders('alice'), ['CIB']);
      await store.setMapping('alice', 'CIB', 'Commercial International Bank');
      expect(await store.getUnknownSenders('alice'), isEmpty);
    },
  );
  test('one account cannot reject or assign senders for another', () async {
    final store = BankSenderMappingStore();
    await store.rejectSender('alice', 'SENDER');
    await store.markUnknown('bob', 'SENDER');
    expect(await store.getUnknownSenders('bob'), ['SENDER']);
    await store.setMapping('bob', 'SENDER', 'Bank');
    expect(await store.getBankForSender('bob', 'SENDER'), 'Bank');
    expect(await store.isRejected('alice', 'SENDER'), isTrue);
  });
}
