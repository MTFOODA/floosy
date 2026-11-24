import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/private_record_store.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/processed_sms_local_datasource.dart';
import 'package:floosy/data/services/legacy_financial_import.dart';
import 'package:floosy/data/services/legacy_financial_manifest.dart';
import 'package:floosy/domain/entities/transaction_model.dart';

class Source implements LegacyReadOnlySource {
  final Map<String, List<Map<String, dynamic>>> rows;
  String? failTable;
  void Function(String, int)? onPage;
  final calls = <String, int>{};
  Source(this.rows);
  @override
  Future<List<Map<String, dynamic>>> page(
    LegacyTable table,
    String user,
    String? after,
  ) async {
    final count = calls.update(table.name, (n) => n + 1, ifAbsent: () => 1);
    onPage?.call(table.name, count);
    if (failTable == table.name) throw StateError('Disconnected');
    final values = [...rows[table.name] ?? <Map<String, dynamic>>[]]
      ..sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
    return values
        .where((r) => after == null || (r['id'] as String).compareTo(after) > 0)
        .take(200)
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
  }
}

Map<String, dynamic> tx(
  String id, {
  int amount = 100,
  String type = 'purchase',
  String? fingerprint,
}) => {
  'id': id,
  'user_id': 'u',
  'type': type,
  'source': 'sms',
  'amount_minor': amount,
  'currency': 'EGP',
  'transaction_date': '2026-11-20T12:00:00Z',
  'status': 'confirmed',
  'fingerprint': fingerprint ?? id,
};

void main() {
  late db.AppDatabase database;
  late PrivateRecordStore store;
  String? owner;
  setUp(() {
    owner = 'u';
    database = db.AppDatabase(NativeDatabase.memory());
    store = PrivateRecordStore(database, () => owner);
  });
  tearDown(() async => database.close());
  test(
    'fractional server timestamps survive the seconds-based legacy ledger',
    () async {
      const original = '2026-11-20T12:00:00.123456Z';
      final source = Source({
        'transactions': [
          {...tx('fractional'), 'transaction_date': original},
        ],
      });
      await LegacyFinancialImport(store, source).run('u');
      expect(
        (await store.get(
          'legacy_extras:transactions',
          'fractional',
        ))?['source_timestamps'],
        {'transaction_date': original},
      );
      expect((await localRows(database)).single.amountMinor, 100);
    },
  );

  test(
    'projection failure rolls back the entire ledger and retains the staged source',
    () async {
      final source = Source({
        'transactions': [tx('one')],
        'expenses': [
          {'id': 'incomplete', 'user_id': 'u'},
        ],
      });
      final importer = LegacyFinancialImport(store, source);
      await expectLater(importer.run('u'), throwsA(anything));
      expect(await localRows(database), isEmpty);
      expect(await importer.completed('u'), isFalse);
      expect((await store.list('stage:transactions')).single['id'], 'one');
    },
  );
  test(
    'interrupted paginated import resumes atomically and never repeats rows',
    () async {
      final source = Source({
        'transactions': [
          for (var i = 0; i < 205; i++)
            tx(i.toString().padLeft(4, '0'), amount: i + 1),
        ],
      });
      source.onPage = (table, n) {
        if (table == 'transactions' && n == 2) source.failTable = table;
      };
      final importer = LegacyFinancialImport(store, source);
      await expectLater(importer.run('u'), throwsStateError);
      expect(
        await TransactionLocalDataSource(database).getTransactionsByUserId('u'),
        isEmpty,
      );
      expect(await importer.completed('u'), isFalse);
      source.failTable = null;
      source.onPage = null;
      await importer.run('u');
      final rows = await TransactionLocalDataSource(
        database,
      ).getTransactionsByUserId('u');
      expect(rows.length, 205);
      expect(rows.fold<int>(0, (s, t) => s + t.amountMinor), 21115);
      expect(await importer.completed('u'), isTrue);
      final before = jsonEncode(source.calls);
      await importer.run('u');
      expect(jsonEncode(source.calls), before);
      expect(await store.list('stage:transactions'), isEmpty);
    },
  );

  test(
    'changed remote snapshot and account switches never commit a partial ledger',
    () async {
      final source = Source({
        'transactions': [tx('one')],
      });
      source.onPage = (table, n) {
        if (table == 'transactions' && n == 2) {
          source.rows['transactions']![0]['amount_minor'] = 999;
        }
      };
      final importer = LegacyFinancialImport(store, source);
      await expectLater(importer.run('u'), throwsStateError);
      expect(
        await TransactionLocalDataSource(database).getTransactionsByUserId('u'),
        isEmpty,
      );
      source.onPage = null;
      await importer.run('u');
      expect(
        (await TransactionLocalDataSource(
          database,
        ).getTransactionsByUserId('u')).single.amountMinor,
        999,
      );
      owner = 'other';
      await expectLater(importer.run('u'), throwsStateError);
      expect(await store.list('detected_cards'), isEmpty);
    },
  );

  test(
    'fingerprint and wallet aliases retain local edits without doubling balances or SMS',
    () async {
      final local = TransactionLocalDataSource(database);
      await local.insertTransaction(
        Transaction.fromJson(
          tx('local', amount: 500, type: 'atm_withdrawal', fingerprint: 'same'),
        ),
      );
      await database.customStatement(
        "INSERT INTO cash_wallets(id,user_id,currency) VALUES('local-wallet','u','EGP')",
      );
      final source = Source({
        'cash_wallets': [
          {'id': 'old-wallet', 'user_id': 'u', 'currency': 'EGP'},
        ],
        'transactions': [
          tx('old', amount: 900, type: 'atm_withdrawal', fingerprint: 'same'),
        ],
        'cash_movements': [
          {
            'id': 'movement',
            'user_id': 'u',
            'wallet_id': 'old-wallet',
            'type': 'atm_withdrawal',
            'amount_minor': 900,
            'reference_type': 'transaction',
            'reference_id': 'old',
            'movement_date': '2026-11-20T12:00:00Z',
          },
        ],
        'sms_messages': [
          {
            'id': 'sms',
            'user_id': 'u',
            'message_hash': 'hash',
            'message_body': 'Bank message ' * 100,
            'received_at': '2026-11-20T12:00:00Z',
            'processing_status': 'processed',
            'transaction_id': 'old',
          },
        ],
      });
      await LegacyFinancialImport(store, source).run('u');
      expect(
        (await local.getTransactionsByUserId('u')).single.amountMinor,
        500,
      );
      expect(
        (await store.list(
          'legacy_conflicts:transactions',
        )).single['amount_minor'],
        900,
      );
      final money = MoneyLocalDataSource(database);
      expect(await money.getCashBalance('u'), 500);
      expect(
        (await money.getCashMovements('local-wallet')).single.referenceId,
        'local',
      );
      expect(
        await SmsMessageLocalDataSource(database).bodyFor('u', 'hash'),
        'Bank message ' * 100,
      );
      expect(
        await ProcessedSmsLocalDataSource(database).isProcessed('u', 'hash'),
        isTrue,
      );
      expect(
        (await database.select(database.smsMessages).get()).single.messageBody,
        isNull,
      );
    },
  );

  test(
    'unknown schema or foreign records abort without changing the ledger',
    () async {
      final source = Source({
        'transactions': [
          {...tx('one'), 'unexpected': 'value'},
        ],
      });
      await expectLater(
        LegacyFinancialImport(store, source).run('u'),
        throwsStateError,
      );
      expect(await localRows(database), isEmpty);
      source.rows['transactions'] = [
        {...tx('one'), 'user_id': 'another'},
      ];
      await expectLater(
        LegacyFinancialImport(store, source).run('u'),
        throwsStateError,
      );
      expect(await localRows(database), isEmpty);
    },
  );
}

Future<List<Transaction>> localRows(db.AppDatabase database) =>
    TransactionLocalDataSource(database).getTransactionsByUserId('u');
