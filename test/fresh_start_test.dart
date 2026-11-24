import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/testing.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/private_record_store.dart';
import 'package:floosy/data/services/fresh_start_service.dart';
import 'package:floosy/data/services/private_sms_sync_state_store.dart';
import 'package:floosy/data/services/sms_sync_state_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'authorized reset removes test ledgers/preferences once and preserves Auth and all new records',
    () async {
      SharedPreferences.setMockInitialValues({
        'supabase.auth.token': 'keep-session',
        'floosy_language_code': 'en',
        'floosy_detected_cards_u': '[{"old":"test"}]',
        'floosy_bank_sender_map_u': '{"OLD":"CIB"}',
        'floosy_sms_sync_state_u': '{}',
        'floosy_rejected_senders_u': ['OLD'],
      });
      final database = db.AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      String owner = 'u';
      final store = PrivateRecordStore(database, () => owner);
      await database.customStatement(
        "INSERT INTO items(id,user_id,name,price_minor) VALUES('old','u','Test',500)",
      );
      await store.put('detected_cards', {'id': 'old-card', 'user_id': 'u'});
      await FreshStartService(
        store,
      ).initialize('u').timeout(const Duration(seconds: 3));
      expect(await database.select(database.items).get(), isEmpty);
      expect(await store.list('detected_cards'), isEmpty);
      expect(await store.list('categories'), isNotEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('supabase.auth.token'), 'keep-session');
      expect(prefs.getString('floosy_language_code'), 'en');
      expect(prefs.containsKey('floosy_detected_cards_u'), isFalse);
      final cursor = await PrivateSmsSyncStateStore(store).read('u');
      expect(cursor.historyComplete, isFalse);
      final month = DateTime(DateTime.now().year, DateTime.now().month);
      expect(cursor.firstAllowedAt, month.toUtc());
      expect(cursor.firstAllowedAt, isNotNull);
      expect(
        cursor.incrementalSince(const Duration(minutes: 5)),
        cursor.firstAllowedAt,
      );
      expect(
        SmsSyncState.fromJson(
          cursor.copyWith(pagesScanned: 2).toJson(),
        ).firstAllowedAt,
        cursor.firstAllowedAt,
      );
      await database.customStatement(
        "INSERT INTO items(id,user_id,name,price_minor) VALUES('new','u','New purchase',700)",
      );
      await FreshStartService(store).initialize('u');
      expect((await database.select(database.items).get()).single.id, 'new');
      owner = 'another';
      await FreshStartService(store).initialize('another');
      expect((await database.select(database.items).get()).single.id, 'new');
      expect(
        (await PrivateSmsSyncStateStore(store).read('another')).firstAllowedAt,
        isNotNull,
      );
    },
  );

  test(
    'production preparation opens an empty account offline without a single cloud request',
    () async {
      SharedPreferences.setMockInitialValues({});
      var requests = 0;
      final client = SupabaseClient(
        'https://floosy.supabase.co',
        'test-key',
        httpClient: MockClient((_) async {
          requests++;
          throw StateError('Network unavailable');
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
      await dependencies.prepareUser('u').timeout(const Duration(seconds: 3));
      expect(
        await dependencies.transactionRepository.getTransactions(userId: 'u'),
        isEmpty,
      );
      expect(await dependencies.detectedCardRepository.getCards('u'), isEmpty);
      expect(
        (await dependencies.moneyRepository.getMoneySummary(
          'u',
        )).myBalanceMinor,
        0,
      );
      expect(requests, 0);
      await dependencies.prepareUser('u');
      expect(requests, 0);
    },
  );
}
