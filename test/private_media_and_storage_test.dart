import 'dart:convert';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/private_record_store.dart';
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/services/legacy_media_import.dart';
import 'package:floosy/data/services/private_item_image_service.dart';
import 'package:floosy/data/services/legacy_local_records.dart';
import 'package:floosy/data/services/legacy_data_projection.dart';
import 'package:floosy/domain/entities/detected_card_model.dart';
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late db.AppDatabase database;
  late PrivateRecordStore store;
  String? owner;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    owner = 'u';
    database = db.AppDatabase(NativeDatabase.memory());
    store = PrivateRecordStore(database, () => owner);
  });
  tearDown(() async => database.close());
  test(
    'SMS body occupies one compressed payload and round trips including Arabic',
    () async {
      final source = SmsMessageLocalDataSource(database);
      final body = 'شراء بمبلغ 250.00 جنيه باستخدام البطاقة 1234. ' * 100;
      final message = SMSMessage(
        id: 'one',
        userId: 'u',
        messageHash: 'same',
        messageBody: body,
        receivedAt: DateTime.utc(2026, 11, 20),
      );
      await source.upsert(message);
      await source.upsert(message.copyWith(id: 'two'));
      expect((await database.select(database.smsMessages).get()).length, 1);
      expect(
        (await database.select(database.smsMessages).get()).single.messageBody,
        isNull,
      );
      final packed =
          (await database
                  .customSelect('SELECT payload FROM sms_payloads')
                  .get())
              .single
              .read<Uint8List>('payload');
      expect(packed.length, lessThan(utf8.encode(body).length ~/ 5));
      expect(await source.bodyFor('u', 'same'), body);
      expect(await source.bodyFor('other', 'same'), isNull);
    },
  );
  test(
    'cards migrate before cloud projection, preserve appearance/limits, and alias identities',
    () async {
      final card = DetectedCard(
        id: 'local-card',
        userId: 'u',
        last4: '1234',
        bankName: 'CIB',
        isCreditCard: true,
        creditLimitMinor: 500000,
      );
      SharedPreferences.setMockInitialValues({
        'floosy_detected_cards_u': jsonEncode([card.toJson()]),
      });
      final source = DetectedCardLocalDataSource(records: store);
      expect((await source.getCards('u')).single.creditLimitMinor, 500000);
      expect(
        (await SharedPreferences.getInstance()).containsKey(
          'floosy_detected_cards_u',
        ),
        isFalse,
      );
      await LegacyDataProjection(store).project('detected_cards', {
        ...card.toJson(),
        'id': 'cloud-card',
        'credit_limit_minor': 100000,
      });
      final cards = await source.getCards('u');
      expect(cards.length, 1);
      expect(cards.single.creditLimitMinor, 500000);
      expect(
        await LegacyDataProjection(store).alias('detected_cards', 'cloud-card'),
        'local-card',
      );
      owner = 'other';
      expect(await source.getCards('other'), isEmpty);
      await expectLater(source.getCards('u'), throwsStateError);
    },
  );
  test(
    'existing local auxiliary records are retained before importing older server copies',
    () async {
      await database.customStatement(
        "INSERT INTO budgets(id,user_id,name,amount_minor,start_date,end_date) VALUES('b','u','My budget',20000,1760000000,1799999999)",
      );
      await migrateLegacyLocalRecords(store);
      expect((await store.get('budgets', 'b'))?['amount_minor'], 20000);
      await LegacyDataProjection(store).project('budgets', {
        'id': 'b',
        'user_id': 'u',
        'name': 'Old budget',
        'amount_minor': 10000,
      });
      expect((await store.get('budgets', 'b'))?['amount_minor'], 20000);
      await migrateLegacyLocalRecords(store);
    },
  );
  test(
    'legacy images are downloaded and verified; new images never upload and remain owner scoped',
    () async {
      final calls = <http.Request>[];
      final binary = utf8.encode('synthetic-image-bytes');
      final httpClient = MockClient((request) async {
        calls.add(request);
        if (request.method == 'POST') {
          expect((jsonDecode(request.body) as Map)['prefix'], 'u');
          expect(request.url.path, contains('/object/list/'));
          return http.Response(
            request.url.path.endsWith('item-images')
                ? jsonEncode([
                    {'name': 'old.png', 'id': 'object-id'},
                  ])
                : '[]',
            200,
          );
        }
        expect(request.method, 'GET');
        return http.Response.bytes(
          binary,
          200,
          headers: {'content-type': 'image/png'},
        );
      });
      await LegacyMediaImport(
        httpClient,
        () => 'session-token',
        store,
      ).run('u');
      final supabase = SupabaseClient(
        'https://floosy.supabase.co',
        'test-key',
        httpClient: MockClient(
          (_) async => throw StateError('Unexpected network'),
        ),
      );
      addTearDown(supabase.dispose);
      final images = PrivateItemImageService(supabase, store);
      expect(
        await images.resolveImage('u/old.png'),
        'data:image/png;base64,${base64Encode(binary)}',
      );
      final directory = await Directory.systemTemp.createTemp(
        'floosy-media-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/new.png');
      await file.writeAsBytes(binary);
      final reference = await images.uploadImage(
        userId: 'u',
        itemId: 'item',
        filePath: file.path,
      );
      expect(
        await images.resolveImage(reference!),
        'data:image/png;base64,${base64Encode(binary)}',
      );
      owner = 'other';
      expect(await images.resolveImage(reference), isNull);
      expect(calls.where((r) => !['GET', 'POST'].contains(r.method)), isEmpty);
    },
  );
  test(
    'logs never contain messages, IDs, amounts, errors or stack contents',
    () {
      final previous = debugPrint;
      final lines = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        lines.add(message ?? '');
      };
      try {
        logDebug('SECRET_SMS 1234 EGP 500');
        logInfo('SECRET_ACCOUNT');
        logWarning('SECRET_BALANCE');
        logError(
          'SECRET_NOTE',
          StateError('SECRET_SQL'),
          StackTrace.fromString('SECRET_STACK'),
        );
        expect(lines.join(), isNot(contains('SECRET')));
        expect(lines.join(), isNot(contains('1234')));
      } finally {
        debugPrint = previous;
      }
    },
  );
}
