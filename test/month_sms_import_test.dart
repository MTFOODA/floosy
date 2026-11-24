import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/config/sms_import_config.dart';
import 'package:floosy/core/services/sms_inbox_service.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/services/fresh_start_service.dart';
import 'package:floosy/data/services/private_sms_sync_state_store.dart';
import 'package:floosy/data/services/sms_polling_service.dart';
import 'package:floosy/data/services/sms_sync_state_store.dart';

class _Inbox extends SmsInboxService {
  bool permitted = true;
  bool failRead = false;
  final messages = <SmsInboxMessage>[];
  final windows = <({DateTime? since, DateTime? until})>[];
  @override
  Future<bool> hasPermissions() async => permitted;
  @override
  Future<List<SmsInboxMessage>> readInbox({
    int maxCount = 200,
    DateTime? sinceDate,
    DateTime? untilDate,
  }) async {
    windows.add((since: sinceDate, until: untilDate));
    if (failRead) throw StateError('Inbox unavailable');
    final filtered =
        messages
            .where(
              (m) =>
                  (sinceDate == null || !m.date.isBefore(sinceDate)) &&
                  (untilDate == null || !m.date.isAfter(untilDate)),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return filtered.take(maxCount).toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDependencies dependencies;
  late SupabaseClient client;
  late _Inbox inbox;
  final month = DateTime(DateTime.now().year, DateTime.now().month);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    inbox = _Inbox();
    client = SupabaseClient(
      'https://floosy.supabase.co',
      'test-key',
      httpClient: MockClient((request) async {
        // The public catalog is allowed; financial traffic fails the test.
        expect(request.url.path, '/rest/v1/banks');
        return http.Response(
          '[]',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    dependencies = AppDependencies(
      client: client,
      database: db.AppDatabase(NativeDatabase.memory()),
      inbox: inbox,
    );
    dependencies.currentUserId = () => 'u';
    await dependencies.prepareUser('u');
  });
  tearDown(() async {
    await dependencies.close();
    await client.dispose();
  });

  test(
    'first day uses the local calendar including January and leap February',
    () {
      expect(
        SmsImportConfig.startFor(DateTime(2026, 1, 21, 15)),
        DateTime(2026, 1),
      );
      expect(
        SmsImportConfig.startFor(DateTime(2024, 2, 29, 23)),
        DateTime(2024, 2),
      );
      expect(
        SmsImportConfig.startFor(DateTime.utc(2026, 11, 21)),
        DateTime.utc(2026, 11),
      );
    },
  );

  test(
    'old cutoff upgrade preserves new records and runs once across month changes',
    () async {
      final store = dependencies.privateRecords;
      await store.delete('preferences', FreshStartService.smsMonthHistory);
      await store.put('items', {'id': 'keep', 'name': 'My purchase'});
      final cursors = PrivateSmsSyncStateStore(store);
      await cursors.write(
        'u',
        SmsSyncState(
          historyComplete: true,
          firstAllowedAt: DateTime(2026, 11, 20),
          lastProcessedAt: DateTime(2026, 11, 20),
        ),
      );
      await FreshStartService(
        store,
        now: () => DateTime(2026, 11, 21),
      ).initialize('u');
      final upgraded = await cursors.read('u');
      expect(upgraded.historyComplete, isFalse);
      expect(upgraded.firstAllowedAt, DateTime(2026, 11).toUtc());
      expect(upgraded.lastProcessedAt, isNull);
      expect(await store.get('items', 'keep'), isNotNull);
      final progressed = upgraded.copyWith(
        historyComplete: true,
        lastProcessedAt: DateTime(2026, 11, 22),
        pagesScanned: 3,
      );
      await cursors.write('u', progressed);
      await FreshStartService(
        store,
        now: () => DateTime(2026, 12, 2),
      ).initialize('u');
      expect(await cursors.read('u'), progressed);
      expect(await store.get('items', 'keep'), isNotNull);
    },
  );

  test(
    'real pipeline imports month-start purchase, excludes older SMS and OTP, and dedupes after restart',
    () async {
      inbox.messages.addAll([
        SmsInboxMessage(
          sender: 'CIB',
          body:
              'Purchase of EGP 125.50 using card ending 1234 at TEST SHOP. Available balance EGP 9000.00.',
          date: month,
        ),
        SmsInboxMessage(
          sender: 'CIB',
          body: 'Purchase of EGP 888.00 using card ending 1234 at OLD SHOP.',
          date: month.subtract(const Duration(milliseconds: 1)),
        ),
        SmsInboxMessage(
          sender: 'CIB',
          body: 'Your OTP is 654321. Do not share this code.',
          date: month.add(const Duration(minutes: 1)),
        ),
      ]);
      var notifications = 0;
      dependencies.onDataChanged = () => notifications++;
      final first = await dependencies.smsPollingService.scanNow(
        fullScan: true,
      );
      expect(first.transactionsCreated, 1);
      expect(first.scanned, 2);
      expect(notifications, 1);
      final rows = await dependencies.transactionRepository.getTransactions(
        userId: 'u',
      );
      expect(rows.single.amountMinor, 12550);
      expect(rows.single.transactionDate.isAtSameMomentAs(month), isTrue);
      expect(
        await dependencies.detectedCardRepository.getCards('u'),
        hasLength(1),
      );
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isTrue,
      );
      final restart = SmsPollingService(
        ingestion: dependencies.smsIngestionService,
        resolveUserId: () async => 'u',
        resolveKnownBanks: () async => [],
        syncStateStore: dependencies.smsSyncStateStore,
        processedSmsLocalDataSource: dependencies.processedSmsLocalDataSource,
      );
      final again = await restart.scanNow(fullScan: true);
      expect(again.transactionsCreated, 0);
      expect(
        await dependencies.transactionRepository.getTransactions(userId: 'u'),
        hasLength(1),
      );
      expect(
        inbox.windows.every(
          (w) => w.since != null && !w.since!.isBefore(month),
        ),
        isTrue,
      );
    },
  );

  test(
    'permission denial and read failure keep history pending until a successful read',
    () async {
      inbox.permitted = false;
      expect(
        (await dependencies.smsPollingService.scanNow(fullScan: true)).errors,
        1,
      );
      expect(inbox.windows, isEmpty);
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isFalse,
      );
      inbox.permitted = true;
      inbox.failRead = true;
      expect(
        (await dependencies.smsPollingService.scanNow(fullScan: true)).errors,
        1,
      );
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isFalse,
      );
      inbox.failRead = false;
      expect(
        (await dependencies.smsPollingService.scanNow(fullScan: true)).errors,
        0,
      );
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isTrue,
      );
    },
  );

  test(
    'history is paged with the same month floor and terminates at an exact full-page boundary',
    () async {
      // One full page, including the boundary message at midnight on day one.
      inbox.messages.addAll(
        List.generate(
          SmsPollingService.historyPageSize,
          (i) => SmsInboxMessage(
            sender: 'DELIVERY',
            body: 'Package $i',
            date: month.add(Duration(minutes: i)),
          ),
        ),
      );
      final first = await dependencies.smsPollingService.scanNow(
        fullScan: true,
      );
      expect(first.scanned, SmsPollingService.historyPageSize);
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isFalse,
      );
      await dependencies.smsPollingService.scanNow(fullScan: true);
      expect(
        (await dependencies.smsSyncStateStore.read('u')).historyComplete,
        isTrue,
      );
      expect(
        inbox.windows.every((w) => w.since!.isAtSameMomentAs(month)),
        isTrue,
      );
      expect(inbox.windows.last.until!.isAtSameMomentAs(month), isTrue);
      // A cursor strictly below the floor must return empty, never jump to newest.
      final bounded = await dependencies.smsIngestionService.scanAndProcess(
        userId: 'u',
        since: month,
        before: month.subtract(const Duration(milliseconds: 1)),
      );
      expect(bounded.scanned, 0);
      expect(inbox.windows, hasLength(2));
    },
  );

  test(
    'resuming immediately retries permission without restarting a stopped poller',
    () async {
      final poller = dependencies.smsPollingService;
      poller.start();
      await poller.scanNow(fullScan: true); // Joins automatic first page.
      final count = poller.scansCompleted;
      poller.didChangeAppLifecycleState(AppLifecycleState.paused);
      poller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await poller.scanNow(fullScan: true);
      expect(poller.scansCompleted, greaterThan(count));
      poller.stop();
      final stopped = poller.scansCompleted;
      poller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(poller.scansCompleted, stopped);
    },
  );
}
