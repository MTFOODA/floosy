import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/processed_sms_local_datasource.dart';
import 'package:floosy/data/services/sms_classification_repair.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/domain/entities/transaction_model.dart';

const promotion =
    'خصم 15% على أمازون بحد أقصى 1000 جم عند الدفع ببطاقات بنك الإسكندرية الائتمانية خلال شهر نوفمبر وكمان ممكن تقسط بدون فوائد حتى 36 شهر. استخدم بروموكود Alex15. تطبق الشروط والأحكام.';
const realVodafone =
    'تمت عملية بمبلغ10.00 EGPببطاقة1234** في13/11/26-04:29 عند Vodafone Top Up APP Smart Village EG للاستفسار 19851';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDependencies deps;
  late SupabaseClient client;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    client = SupabaseClient(
      'https://floosy.supabase.co',
      'key',
      httpClient: MockClient(
        (_) async => throw StateError('Financial data must stay local'),
      ),
    );
    deps = AppDependencies(
      client: client,
      database: db.AppDatabase(NativeDatabase.memory()),
    );
    deps.currentUserId = () => 'u';
    await deps.prepareUser('u');
  });
  tearDown(() async {
    await deps.close();
    await client.dispose();
  });

  test(
    'Arabic/English discount offers and telecom gifts never become money movements',
    () async {
      for (final body in [
        promotion,
        'خصم ١٥٪ على مشترياتك بحد أقصى ١٠٠٠ جنيه عند الدفع ببطاقتك',
        'Get 15% cashback up to EGP 1000. Use promo code SAVE15. Terms and conditions apply.',
        'ليك 1000 وحدة هدية لما تشحن فكة 15. اشحن عن طريق محفظة فودافون كاش',
        'تم إضافة 1000 وحدة هدية عند شحن 15 جنيه من محفظة فودافون كاش',
      ]) {
        final parsed = await SMSParser.parse(
          sender: 'ALEXBANK',
          smsContent: body,
        );
        expect(SMSParser.isPromotional(body), isTrue, reason: body);
        expect(parsed.type, isNull);
        expect(parsed.amountMinor, isNull);
        expect(
          await deps.smsTransactionProcessor.process(
            userId: 'u',
            sender: 'ALEXBANK',
            smsContent: body,
            receivedAt: DateTime(2026, 11, 1),
          ),
          isFalse,
        );
      }
      expect(
        await deps.transactionRepository.getTransactions(userId: 'u'),
        isEmpty,
      );
      expect(await deps.detectedCardRepository.getCards('u'), isEmpty);
    },
  );

  test(
    'actual card purchases at Vodafone remain purchases from their issuing bank',
    () async {
      final parsed = await SMSParser.parse(
        sender: 'FAISAL BANK',
        smsContent: realVodafone,
      );
      expect(parsed.type, TransactionType.purchase);
      expect(parsed.amountMinor, 1000);
      expect(BankCatalog.byIdentity(parsed.bankName)?.code, 'FAISAL');
      expect(parsed.merchant, contains('Vodafone'));
      expect(
        SMSParser.isSupportedSender(
          'Vodafone',
          body: 'Enjoy Vodafone Cash offers',
        ),
        isFalse,
      );
      expect(
        SMSParser.classify(
          'تم خصم مبلغ 577 جم / الموبايل والانترنت البنكي من حسابك',
        ).type,
        TransactionType.purchase,
      );
      expect(
        SMSParser.classify(
          'Purchase of EGP 20 at DISCOUNT STORE. Use promo code NEXT for your next order.',
        ).type,
        TransactionType.purchase,
      );
      expect(
        SMSParser.classify(
          'Cashback of EGP 20 was credited to your account.',
        ).type?.isIncoming,
        isTrue,
      );
    },
  );

  test(
    'one-time repair reverses the old promotional debit, keeps real Vodafone purchases and dedupe',
    () async {
      final card = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '1234',
        bankName: 'ALEXBANK',
      );
      await deps.moneyRepository.recordSmsTransaction(
        userId: 'u',
        transaction: Transaction(
          id: 'old-ad',
          userId: 'u',
          type: TransactionType.purchase,
          source: TransactionSource.sms,
          amountMinor: 100000,
          transactionDate: DateTime(2026, 11, 1),
          fingerprint: 'legacy-ad',
          cardId: card.id,
          cardLast4: '1234',
        ),
      );
      final hash = SMSParser.fingerprintOf('ALEXBANK|$promotion');
      await deps.smsMessageLocalDataSource.upsert(
        SMSMessage(
          id: 'sms-ad',
          userId: 'u',
          messageHash: hash,
          receivedAt: DateTime(2026, 11, 1),
          sender: 'ALEXBANK',
          messageBody: promotion,
          transactionId: 'old-ad',
          processingStatus: 'processed',
        ),
      );
      await deps.processedSmsLocalDataSource.markProcessed(
        ProcessedSmsRecord(
          id: 'ps-ad',
          userId: 'u',
          messageHash: hash,
          receivedAt: DateTime(2026, 11, 1),
          transactionId: 'old-ad',
          processedAt: DateTime.now(),
        ),
      );
      expect(
        (await deps.moneyRepository.getCardBalance(
          'u',
          '1234',
          bankName: 'ALEXBANK',
        )).deductedMinor,
        100000,
      );
      expect(
        await deps.smsTransactionProcessor.process(
          userId: 'u',
          sender: 'FAISAL BANK',
          smsContent: realVodafone,
          receivedAt: DateTime(2026, 11, 13),
        ),
        isTrue,
      );
      await deps.privateRecords.delete(
        'preferences',
        SmsClassificationRepair.version,
      );
      final repair = SmsClassificationRepair(
        deps.privateRecords,
        deps.smsMessageLocalDataSource,
        deps.transactionRepository,
      );
      expect(await repair.run('u'), 1);
      final remaining = await deps.transactionRepository.getTransactions(
        userId: 'u',
      );
      expect(remaining, hasLength(1));
      expect(remaining.single.merchantName, contains('Vodafone'));
      expect(
        BankCatalog.byIdentity(
          (await deps.transactionRepository.bankNamesForTransactions(
            'u',
          ))[remaining.single.id],
        )?.code,
        'FAISAL',
      );
      expect(
        (await deps.moneyRepository.getCardBalance(
          'u',
          '1234',
          bankName: 'ALEXBANK',
        )).deductedMinor,
        0,
      );
      expect(
        await deps.processedSmsLocalDataSource.isProcessed('u', hash),
        isTrue,
      );
      expect(
        await deps.smsMessageLocalDataSource.bodyFor('u', hash),
        promotion,
      );
      expect(await repair.run('u'), 0);
      expect(
        await deps.smsTransactionProcessor.process(
          userId: 'u',
          sender: 'ALEXBANK',
          smsContent: promotion,
          receivedAt: DateTime(2026, 11, 1),
        ),
        isFalse,
      );
    },
  );

  test(
    'official display identities localize aliases without translating merchant names',
    () {
      expect(BankCatalog.displayName('Bank of Alexandria'), 'ALEXBANK');
      expect(
        BankCatalog.displayName('Bank of Alexandria', arabic: true),
        'بنك الإسكندرية',
      );
      expect(
        BankCatalog.displayName('FAISAL BANK', arabic: true),
        'بنك فيصل الإسلامي المصري',
      );
      expect(
        BankCatalog.displayName('Vodafone Top Up APP', arabic: true),
        'Vodafone Top Up APP',
      );
    },
  );
}
