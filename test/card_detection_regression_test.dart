import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/expense_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/remote/datasources/cash_wallet_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/expense_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

class _LinkingMoneyLocalDataSource extends MoneyLocalDataSource {
  _LinkingMoneyLocalDataSource() : super(db.AppDatabase());

  String? linkedCardId;

  @override
  Future<void> updateTransactionCardId(
      String transactionId, String cardId) async {
    linkedCardId = cardId;
  }
}

class _LinkingMoneyRepository extends MoneyRepository {
  _LinkingMoneyRepository(_LinkingMoneyLocalDataSource local)
      : super(
          remote: MoneyRemoteDataSource(_dummyClient()),
          local: local,
          transactionRepository: TransactionRepository(
            TransactionRemoteDataSource(_dummyClient()),
            TransactionLocalDataSource(db.AppDatabase()),
          ),
          cashWalletRepository: CashWalletRepository(
            remoteDataSource: CashWalletRemoteDataSource(_dummyClient()),
          ),
          expenseRepository: ExpenseRepository(
            remoteDataSource: ExpenseRemoteDataSource(_dummyClient()),
            localDataSource: ExpenseLocalDataSource(db.AppDatabase()),
          ),
        );

  Transaction? recorded;

  @override
  Future<bool> recordSmsTransaction({
    required String userId,
    required Transaction transaction,
    String? accountId,
  }) async {
    recorded = transaction;
    return true;
  }
}

class _NoWriteMoneyRepository extends MoneyRepository {
  _NoWriteMoneyRepository()
      : super(
          remote: MoneyRemoteDataSource(_dummyClient()),
          local: MoneyLocalDataSource(db.AppDatabase()),
          transactionRepository: TransactionRepository(
            TransactionRemoteDataSource(_dummyClient()),
            TransactionLocalDataSource(db.AppDatabase()),
          ),
          cashWalletRepository: CashWalletRepository(
            remoteDataSource: CashWalletRemoteDataSource(_dummyClient()),
          ),
          expenseRepository: ExpenseRepository(
            remoteDataSource: ExpenseRemoteDataSource(_dummyClient()),
            localDataSource: ExpenseLocalDataSource(db.AppDatabase()),
          ),
        );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Detected bank card — contextual last4 regression', () {
    const cases = <String, String>{
      'masked without space ****1234': '1234',
      'masked with space **** 1234': '1234',
      'X-mask without space XXXX1234': '1234',
      'X-mask with space XXXX 1234': '1234',
      'existing Egyptian card pattern بطاقة 1234': '1234',
      'alternate Arabic spelling بطاقه 1234': '1234',
      'card ending 1234': '1234',
      'card ending in 1234': '1234',
      'card reference 1234': '1234',
      'Arabic ending بطاقة تنتهي بـ ١٢٣٤': '1234',
    };

    for (final entry in cases.entries) {
      test('extracts ${entry.key}', () async {
        final result = await SMSParser.parse(
          smsContent: 'FAISAL BANK: ${entry.key}',
          sender: 'FAISAL BANK',
        );
        expect(result.cardLast4, entry.value);
      });
    }

    test('Faisal bank plus contextual card last4 is preserved', () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN بمبلغ10.00 جم بطاقة 4321 رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.bankName, 'Faisal Bank');
      expect(result.cardLast4, '4321');
    });

    test('Bank of Alexandria body spelling is recognized', () async {
      const sms = 'Bank of Alexandria: purchase card ending 5678';
      final result = await SMSParser.parse(smsContent: sms, sender: '12345');
      expect(result.bankName, 'AlexBank');
      expect(result.cardLast4, '5678');
      expect(
        SMSParser.isRecognizedBankOrWalletSender(sender: '12345', body: sms),
        isTrue,
      );
    });

    test('AlexBank sender and Arabic bank body are recognized', () async {
      const sms = 'بنك الإسكندرية: تم شراء 50.00 جنيه بطاقة 8642';
      final result = await SMSParser.parse(smsContent: sms, sender: 'ALEXBANK');
      expect(result.bankName, 'AlexBank');
      expect(result.cardLast4, '8642');
    });

    test('amount at end is not mistaken for card last4', () async {
      const sms = 'FAISAL BANK: card ending 4321 purchase amount EGP 1250.00';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.cardLast4, '4321');
    });

    test('reference number is not mistaken for card last4', () async {
      const sms = 'FAISAL BANK: purchase amount EGP 1250.00 reference 987654';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.cardLast4, isNull);
    });

    test('Arabic account/reference text is not a card', () async {
      const sms = 'FAISAL BANK: بطاقة رقم مرجعي 987654';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.cardLast4, isNull);
    });
  });

  group('Transaction linking uses bank + last4', () {
    test('links a Faisal transaction to Faisal + 1234, not AlexBank + 1234',
        () async {
      SharedPreferences.setMockInitialValues({});
      final cards = DetectedCardRepository(
        local: DetectedCardLocalDataSource(),
      );
      final faisal = await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'Faisal Bank');
      final alex = await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'AlexBank');
      final local = _LinkingMoneyLocalDataSource();
      final money = _LinkingMoneyRepository(local);
      final processor = SMSTransactionProcessor(
        moneyRepository: money,
        detectedCardRepository: cards,
      );

      await processor.process(
        userId: 'u1',
        sender: 'FAISAL BANK',
        smsContent: 'FAISAL BANK: purchase EGP 25.00 card ****1234',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // The transaction must be written with the CORRECT card already linked.
      //
  // It used to be created with a NULL card_id and patched afterwards by a
  // detached background task, which meant a transaction could sit unassigned
  // (and therefore be counted against the wrong card) for an unbounded time.
  // The card is now resolved before the row is created, so the association is
  // correct at rest. Asserting on the created row proves this.
      expect(money.recorded, isNotNull);
      expect(money.recorded!.cardId, faisal.id);
      expect(money.recorded!.cardId, isNot(alex.id));
      // No follow-up patch is needed any more.
      expect(local.linkedCardId, isNull);
    });
  });

  group('Card detection is independent from transaction parsing', () {
    test('card is registered when parsing returns no transaction', () async {
      SharedPreferences.setMockInitialValues({});
      final cards = DetectedCardRepository(
        local: DetectedCardLocalDataSource(),
      );
      final processor = SMSTransactionProcessor(
        moneyRepository: _NoWriteMoneyRepository(),
        detectedCardRepository: cards,
      );

      final recorded = await processor.process(
        userId: 'u1',
        sender: 'FAISAL BANK',
        smsContent: 'FAISAL BANK: بطاقة 7654',
      );

      expect(recorded, isFalse);
      final stored = await cards.getCards('u1');
      expect(stored, hasLength(1));
      expect(stored.single.last4, '7654');
      expect(stored.single.bankName, 'Faisal Bank');
      expect(stored.single.transactionCount, 0);
    });
  });

  group('Detected bank card — bank + last4 identity', () {
    late DetectedCardRepository cards;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cards = DetectedCardRepository(local: DetectedCardLocalDataSource());
    });

    test('same bank + same last4 creates one card', () async {
      await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'Faisal Bank');
      await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'Faisal Bank');
      expect(await cards.getCards('u1'), hasLength(1));
    });

    test('same bank + different last4 creates two cards', () async {
      await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'Faisal Bank');
      await cards.upsertCard(
          userId: 'u1', last4: '5678', bankName: 'Faisal Bank');
      expect(await cards.getCards('u1'), hasLength(2));
    });

    test('different bank + same last4 creates two cards', () async {
      await cards.upsertCard(
          userId: 'u1', last4: '1234', bankName: 'Faisal Bank');
      await cards.upsertCard(userId: 'u1', last4: '1234', bankName: 'AlexBank');
      final stored = await cards.getCards('u1');
      expect(stored, hasLength(2));
      expect(
          stored.map((c) => c.bankName).toSet(), {'Faisal Bank', 'AlexBank'});
    });
  });
}
