import 'dart:convert';
import 'dart:typed_data';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/services/encrypted_backup_service.dart';
import 'package:floosy/data/services/sms_sync_state_store.dart';
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/domain/repositories/backup_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const password = 'test-only-long-passphrase';
  late AppDependencies deps;
  late SupabaseClient client;
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'supabase.auth.token': 'keep-auth',
    });
    client = SupabaseClient(
      'https://floosy.supabase.co',
      'key',
      httpClient: MockClient((_) async => throw StateError('No network')),
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
  Future<void> record(
    String id,
    int minor, {
    TransactionType type = TransactionType.purchase,
  }) async {
    await deps.moneyRepository.recordSmsTransaction(
      userId: 'u',
      transaction: Transaction(
        id: id,
        userId: 'u',
        type: type,
        source: TransactionSource.manual,
        amountMinor: minor,
        transactionDate: DateTime(2026, 11, 21),
        fingerprint: id,
      ),
    );
  }

  test(
    'portable encrypted snapshot restores every table, SMS bytes, media, balances and dedupe without Auth',
    () async {
      final card = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '1234',
        bankName: 'CIB',
      );
      for (final entry in [
        ('income', TransactionType.income, 100000),
        ('atm', TransactionType.atm_withdrawal, 20000),
        ('purchase', TransactionType.purchase, 5000),
      ]) {
        await deps.moneyRepository.recordSmsTransaction(
          userId: 'u',
          transaction: Transaction(
            id: entry.$1,
            userId: 'u',
            type: entry.$2,
            source: TransactionSource.sms,
            amountMinor: entry.$3,
            transactionDate: DateTime(2026, 11, 21),
            fingerprint: entry.$1,
            cardId: card.id,
            cardLast4: '1234',
          ),
        );
      }
      final item = await deps.itemRepository.createItem(
        userId: 'u',
        name: 'Private item',
        nameAr: 'خاص',
        priceMinor: 3000,
        currency: 'EGP',
      );
      await deps.moneyRepository.purchaseItemWithCash(
        userId: 'u',
        item: item,
        cardLast4: '1234',
        bankName: 'CIB',
        purchaseId: 'item-purchase',
      );
      await deps.smsMessageLocalDataSource.upsert(
        SMSMessage(
          id: 'sms1',
          userId: 'u',
          messageHash: 'hash1',
          messageBody: 'Private banking message',
          receivedAt: DateTime(2026, 11, 21),
          transactionId: 'purchase',
        ),
      );
      await deps.appDatabase.customStatement(
        'INSERT INTO private_media(owner,id,mime,payload) VALUES(?,?,?,?)',
        [
          'u',
          'picture',
          'image/png',
          Uint8List.fromList([1, 2, 3, 4, 5]),
        ],
      );
      await deps.bankSenderMappingStore.rejectSender('u', 'AD-SENDER');
      await deps.smsSyncStateStore.write(
        'u',
        SmsSyncState(
          historyComplete: true,
          firstAllowedAt: DateTime(2026, 11),
          lastProcessedAt: DateTime(2026, 11, 21),
          pagesScanned: 3,
        ),
      );
      final before = await deps.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      final bytes = await deps.backup.create('u', password);
      expect(latin1.decode(bytes), isNot(contains('Private banking message')));
      expect(latin1.decode(bytes), isNot(contains('keep-auth')));
      expect((await deps.backup.inspect('u', bytes, password)).transactions, 4);
      final target = AppDependencies(
        client: client,
        database: db.AppDatabase(NativeDatabase.memory()),
      );
      target.currentUserId = () => 'u';
      addTearDown(target.close);
      await target.prepareUser('u');
      target.currentUserId = () => 'other';
      await target.prepareUser('other');
      await target.moneyRepository.recordSmsTransaction(
        userId: 'other',
        transaction: Transaction(
          id: 'other-account-record',
          userId: 'other',
          type: TransactionType.income,
          source: TransactionSource.manual,
          amountMinor: 777,
          transactionDate: DateTime(2026, 11, 21),
          fingerprint: 'other-account-record',
        ),
      );
      target.currentUserId = () => 'u';
      await target.prepareUser('u');
      await target.backup.restore('u', bytes, password);
      expect(
        await target.transactionRepository.getTransactions(userId: 'u'),
        hasLength(4),
      );
      expect(
        await target.smsMessageLocalDataSource.bodyFor('u', 'hash1'),
        'Private banking message',
      );
      expect(
        await target.bankSenderMappingStore.isRejected('u', 'AD-SENDER'),
        isTrue,
      );
      expect((await target.smsSyncStateStore.read('u')).pagesScanned, 3);
      final after = await target.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(after.myBalanceMinor, before.myBalanceMinor);
      expect(after.pocketCashMinor, before.pocketCashMinor);
      expect(after.deductedMinor, before.deductedMinor);
      expect(
        (await target.appDatabase
                .customSelect(
                  'SELECT payload FROM private_media WHERE owner=\'u\'',
                )
                .getSingle())
            .data['payload'],
        [1, 2, 3, 4, 5],
      );
      await target.backup.restore('u', bytes, password);
      expect(
        await target.transactionRepository.getTransactions(userId: 'u'),
        hasLength(4),
      );
      expect(
        (await SharedPreferences.getInstance()).getString(
          'supabase.auth.token',
        ),
        'keep-auth',
      );
      target.currentUserId = () => 'other';
      expect(
        (await target.transactionRepository.getTransactions(
          userId: 'other',
        )).single.amountMinor,
        777,
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'wrong password, tampering and another account never change current records',
    () async {
      await record('keep', 12345);
      final bytes = await deps.backup.create('u', password);
      await expectLater(
        deps.backup.restore('u', bytes, 'wrong-password'),
        throwsA(isA<BackupFailure>()),
      );
      final damaged = Uint8List.fromList(bytes)..[bytes.length - 1] ^= 1;
      await expectLater(
        deps.backup.restore('u', damaged, password),
        throwsA(isA<BackupFailure>()),
      );
      deps.currentUserId = () => 'other';
      await expectLater(
        deps.backup.restore('other', bytes, password),
        throwsA(isA<BackupFailure>()),
      );
      deps.currentUserId = () => 'u';
      expect(
        (await deps.transactionRepository.getTransactions(
          userId: 'u',
        )).single.amountMinor,
        12345,
      );
      await expectLater(
        deps.backup.create('u', 'short'),
        throwsA(isA<BackupFailure>()),
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'restore rollback preserves current rows when post-import verification work fails',
    () async {
      await record('snapshot', 500);
      final bytes = await deps.backup.create('u', password);
      await record('newer', 900);
      final failing = EncryptedBackupService(
        deps.privateRecords,
        afterRestore: (_) async => throw StateError('Simulated failure'),
      );
      await expectLater(
        failing.restore('u', bytes, password),
        throwsStateError,
      );
      expect(
        await deps.transactionRepository.getTransactions(userId: 'u'),
        hasLength(2),
      );
      final randomized = await deps.backup.create('u', password);
      final another = await deps.backup.create('u', password);
      expect(randomized, isNot(orderedEquals(another)));
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
