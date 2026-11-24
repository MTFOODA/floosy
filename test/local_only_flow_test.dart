import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/remote/financial_network_boundary.dart';
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/data/services/private_sender_mapping_store.dart';
import 'package:floosy/data/services/private_sms_sync_state_store.dart';
import 'package:floosy/data/services/sms_sync_state_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'boundary denies all financial tables, RPC, functions and images before HTTP',
    () async {
      var sent = 0;
      final client = FinancialNetworkBoundary(
        MockClient((r) async {
          sent++;
          return http.Response('{}', 200);
        }),
        'floosy.supabase.co',
      );
      for (final path in [
        '/rest/v1/transactions',
        '/rest/v1/sms_messages',
        '/rest/v1/detected_cards',
        '/rest/v1/rpc/get_total_bank_balance',
        '/functions/v1/ai-chat',
        '/storage/v1/object/item-images/u/item',
        '/storage/v1/object/receipt-images/u/r',
      ]) {
        for (final method in ['GET', 'POST', 'PATCH', 'DELETE']) {
          await expectLater(
            client.send(
              http.Request(
                method,
                Uri.parse('https://floosy.supabase.co$path'),
              ),
            ),
            throwsA(isA<FinancialNetworkBlocked>()),
          );
        }
      }
      expect(sent, 0);
      await client.get(Uri.parse('https://floosy.supabase.co/rest/v1/banks'));
      expect(sent, 1);
      expect(
        client.permits(
          'POST',
          Uri.parse('https://elsewhere.com/auth/v1/token'),
        ),
        isFalse,
      );
      expect(
        client.permits(
          'POST',
          Uri.parse(
            'https://floosy.supabase.co/storage/v1/object/item-images/avatars/item',
          ),
        ),
        isFalse,
      );
      client.close();
    },
  );

  test(
    'real composition supports income, ATM, item cash purchase, edits and deletion with zero HTTP',
    () async {
      var sent = 0;
      final client = SupabaseClient(
        'https://floosy.supabase.co',
        'test-key',
        httpClient: MockClient((r) async {
          sent++;
          throw StateError('Unexpected network');
        }),
      );
      final dependencies = AppDependencies(
        client: client,
        database: db.AppDatabase(NativeDatabase.memory()),
      );
      dependencies.currentUserId = () => 'u';
      addTearDown(() async {
        await dependencies.close();
        await client.dispose();
      });
      final card = await dependencies.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '1234',
        bankName: 'CIB',
      );
      Future<void> record(String id, TransactionType type, int amount) async {
        await dependencies.moneyRepository.recordSmsTransaction(
          userId: 'u',
          transaction: Transaction(
            id: id,
            userId: 'u',
            type: type,
            source: TransactionSource.sms,
            amountMinor: amount,
            transactionDate: DateTime.utc(2026, 11, 20),
            fingerprint: id,
            cardId: card.id,
            cardLast4: card.last4,
          ),
        );
      }

      await record('income', TransactionType.income, 100000);
      await record('atm', TransactionType.atm_withdrawal, 20000);
      await record('purchase', TransactionType.purchase, 5000);
      await record('refund', TransactionType.refund, 1000);
      await record('in', TransactionType.transfer_in, 2000);
      await record('out', TransactionType.transfer_out, 3000);
      final duplicates = await Future.wait([
        for (var i = 0; i < 2; i++)
          dependencies.moneyRepository.recordSmsTransaction(
            userId: 'u',
            transaction: Transaction(
              id: 'parallel-$i',
              userId: 'u',
              type: TransactionType.purchase,
              source: TransactionSource.sms,
              amountMinor: 200,
              transactionDate: DateTime.utc(2026, 11, 20),
              fingerprint: 'same-message',
            ),
          ),
      ]);
      expect(duplicates.where((r) => r).length, 1);
      final unique = (await dependencies.transactionRepository.getTransactions(
        userId: 'u',
      )).singleWhere((r) => r.fingerprint == 'same-message');
      await dependencies.transactionRepository.deleteTransaction(
        transactionId: unique.id,
      );
      await expectLater(
        dependencies.moneyRepository.recordSmsTransaction(
          userId: 'u',
          accountId: 'missing',
          transaction: Transaction(
            id: 'invalid',
            userId: 'u',
            type: TransactionType.income,
            source: TransactionSource.sms,
            amountMinor: 100,
            transactionDate: DateTime.utc(2026, 11, 20),
            fingerprint: 'invalid',
          ),
        ),
        throwsArgumentError,
      );
      expect(
        (await dependencies.transactionRepository.getTransactions(
          userId: 'u',
        )).any((r) => r.id == 'invalid'),
        isFalse,
      );
      final item = await dependencies.itemRepository.createItem(
        userId: 'u',
        name: 'Coffee',
        nameAr: 'قهوة',
        priceMinor: 3000,
        currency: 'EGP',
      );
      expect(
        await dependencies.moneyRepository.purchaseItemWithCash(
          userId: 'u',
          item: item,
          cardLast4: '1234',
          bankName: 'CIB',
          purchaseId: 'cash',
        ),
        isTrue,
      );
      expect(
        await dependencies.moneyRepository.purchaseItemWithCash(
          userId: 'u',
          item: item,
          cardLast4: '1234',
          bankName: 'CIB',
          purchaseId: 'cash',
        ),
        isFalse,
      );
      var balance = await dependencies.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(balance.myBalanceMinor, 75000);
      expect(balance.pocketCashMinor, 17000);
      expect(balance.deductedMinor, 11000);
      final row = (await dependencies.transactionRepository.getTransactions(
        userId: 'u',
      )).firstWhere((r) => r.id == 'cash');
      await dependencies.transactionRepository.updateTransaction(
        transaction: row.copyWith(amountMinor: 2000),
      );
      balance = await dependencies.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(balance.myBalanceMinor, 75000);
      expect(balance.pocketCashMinor, 18000);
      expect(
        (await dependencies.expenseLocalDataSource.getExpenses(
          'u',
        )).single.amountMinor,
        2000,
      );
      expect(
        (await dependencies.moneyLocalDataSource.getItemUsages(
          'u',
        )).single.totalAmountMinor,
        2000,
      );
      expect(
        await dependencies.moneyLocalDataSource.getCashBalance('u'),
        18000,
      );
      await dependencies.transactionRepository.deleteTransaction(
        transactionId: 'cash',
      );
      expect(
        await dependencies.expenseLocalDataSource.getExpenses('u'),
        isEmpty,
      );
      expect(
        await dependencies.moneyLocalDataSource.getItemUsages('u'),
        isEmpty,
      );
      expect(
        await dependencies.moneyLocalDataSource.getCashBalance('u'),
        20000,
      );
      // The salary-cycle setup writes the selected debit card's real balance
      // baseline. New movements continue from that value; it is not a second
      // or disconnected budgeting pool.
      await dependencies.moneyRepository.setCurrentBalanceForCard(
        userId: 'u',
        cardLast4: '1234',
        bankName: 'CIB',
        targetBalanceMinor: 2805639,
      );
      balance = await dependencies.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(balance.myBalanceMinor, 2805639);
      await record('after-balance-set', TransactionType.purchase, 12500);
      balance = await dependencies.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(balance.myBalanceMinor, 2793139);
      await dependencies.itemRepository.updatePrice(
        itemId: item.id,
        newPriceMinor: 3500,
      );
      expect(
        (await dependencies.itemRepository.getItem(item.id))?.priceMinor,
        3500,
      );
      expect(
        await dependencies.itemRepository.getPriceHistory(item.id),
        isNotEmpty,
      );
      expect(sent, 0);
      dependencies.currentUserId = () => 'other';
      await expectLater(
        dependencies.transactionRepository.getTransactions(userId: 'u'),
        throwsStateError,
      );
      await expectLater(
        dependencies.transactionRepository.deleteTransaction(
          transactionId: 'income',
        ),
        throwsStateError,
      );
    },
  );

  test(
    'legacy sender rejection and SMS cursor migrate into encrypted records and stay account scoped',
    () async {
      SharedPreferences.setMockInitialValues({
        'floosy_bank_sender_map_u': '{"CIB":"CIB"}',
        'floosy_unknown_senders_u': '["SHOP"]',
        'floosy_rejected_senders_u': ['NOPE'],
        'floosy_sms_sync_state_u': '{"historyComplete":true,"pagesScanned":3}',
      });
      final client = SupabaseClient('https://floosy.supabase.co', 'test-key');
      final dependencies = AppDependencies(
        client: client,
        database: db.AppDatabase(NativeDatabase.memory()),
      );
      String owner = 'u';
      dependencies.currentUserId = () => owner;
      addTearDown(() async {
        await dependencies.close();
        await client.dispose();
      });
      final mapping = PrivateSenderMappingStore(dependencies.privateRecords);
      expect(await mapping.getBankForSender('u', 'cib'), 'CIB');
      await mapping.rejectSender('u', 'shop');
      await mapping.markUnknown('u', 'SHOP');
      expect(await mapping.getUnknownSenders('u'), isEmpty);
      expect(await mapping.isRejected('u', 'nope'), isTrue);
      final cursor = PrivateSmsSyncStateStore(dependencies.privateRecords);
      expect((await cursor.read('u')).historyComplete, isTrue);
      expect(
        (await SharedPreferences.getInstance()).getKeys().where(
          (k) => k.contains('sender') || k.contains('sms_sync'),
        ),
        isEmpty,
      );
      await cursor.write('u', const SmsSyncState(pagesScanned: 5));
      owner = 'other';
      expect((await cursor.read('other')).pagesScanned, 0);
      await expectLater(mapping.getUnknownSenders('u'), throwsStateError);
      owner = 'u';
      expect((await cursor.read('u')).pagesScanned, 5);
    },
  );

  test(
    'salary plans and cycle activity stay scoped to one debit card',
    () async {
      final client = SupabaseClient('https://floosy.supabase.co', 'test-key');
      final dependencies = AppDependencies(
        client: client,
        database: db.AppDatabase(NativeDatabase.memory()),
      );
      dependencies.currentUserId = () => 'u';
      addTearDown(() async {
        await dependencies.close();
        await client.dispose();
      });
      final salaryCard = await dependencies.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2307',
        bankName: 'Faisal Islamic Bank',
      );
      final otherCard = await dependencies.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2325',
        bankName: 'ALEXBANK',
      );
      await dependencies.salaryRepository.configure(
        'u',
        cardId: salaryCard.id,
        cardLast4: salaryCard.last4,
        bankName: salaryCard.bankName,
        monthlySalaryMinor: 1000000,
        startingBalanceMinor: 1000000,
        cycleStartDay: 1,
        effectiveFrom: DateTime(2026, 11, 1),
      );
      Future<void> record(
        String id,
        String cardId,
        String last4,
        TransactionType type,
        int amount,
      ) => dependencies.moneyRepository.recordSmsTransaction(
        userId: 'u',
        transaction: Transaction(
          id: id,
          userId: 'u',
          type: type,
          source: TransactionSource.sms,
          amountMinor: amount,
          transactionDate: DateTime.utc(2026, 11, 20),
          fingerprint: id,
          cardId: cardId,
          cardLast4: last4,
        ),
      );
      await record(
        'faisal-purchase',
        salaryCard.id,
        salaryCard.last4,
        TransactionType.purchase,
        12500,
      );
      await record(
        'alex-purchase',
        otherCard.id,
        otherCard.last4,
        TransactionType.purchase,
        50000,
      );

      final salarySummary = await dependencies.salaryRepository.summaryFor(
        'u',
        cardId: salaryCard.id,
        reference: DateTime(2026, 11, 24),
      );
      final otherSummary = await dependencies.salaryRepository.summaryFor(
        'u',
        cardId: otherCard.id,
        reference: DateTime(2026, 11, 24),
      );
      expect(salarySummary.plan?.cardId, salaryCard.id);
      expect(salarySummary.purchaseCount, 1);
      expect(salarySummary.purchaseMinor, 12500);
      expect(otherSummary.plan, isNull);
      expect(otherSummary.purchaseCount, 1);
      expect(otherSummary.purchaseMinor, 50000);
    },
  );
}
