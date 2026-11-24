import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/app_repositories.dart';
import 'package:floosy/app/app_runtime.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/domain/entities/auth_session.dart';
import 'package:floosy/domain/entities/sms_ingestion_result.dart';
import 'package:floosy/domain/repositories/auth_repository.dart';
import 'package:floosy/domain/repositories/sms_repository.dart';

class _Account extends Fake implements AccountRepository {
  final updates = StreamController<AccountUpdate>.broadcast(sync: true);
  String? owner = 'u';
  @override
  AccountSession? get session =>
      owner == null ? null : AccountSession(AccountUser(id: owner!));
  @override
  Stream<AccountUpdate> get changes => updates.stream;
  void switchTo(String? user) {
    owner = user;
    updates.add(
      AccountUpdate(
        user == null ? AccountEvent.signedOut : AccountEvent.signedIn,
        session,
      ),
    );
  }
}

class _Sms implements SmsRepository, SmsMaintenanceRepository {
  int starts = 0;
  int resets = 0;
  Completer<void>? idle;
  @override
  Future<void> waitForIdle() async => await idle?.future;
  @override
  void resetMemory() {
    resets++;
  }

  @override
  void start() {
    starts++;
  }

  @override
  void stop() {}
  @override
  Future<SmsIngestionResult> scanNow({bool fullScan = false}) async =>
      const SmsIngestionResult(
        scanned: 0,
        transactionsCreated: 0,
        duplicatesOrSkipped: 0,
        errors: 0,
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDependencies dependencies;
  late SupabaseClient client;
  late _Account account;
  late _Sms sms;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    account = _Account();
    sms = _Sms();
    client = SupabaseClient(
      'https://floosy.supabase.co',
      'test-key',
      httpClient: MockClient(
        (r) async => http.Response(
          r.url.path.endsWith('/profiles') ? 'null' : '[]',
          200,
        ),
      ),
    );
    dependencies = AppDependencies(
      client: client,
      database: db.AppDatabase(NativeDatabase.memory()),
    );
    dependencies.currentUserId = () => account.owner;
  });
  tearDown(() async {
    await dependencies.close();
    await client.dispose();
    await account.updates.close();
  });
  AppRepositories repositories(Future<void> Function(String) prepare) {
    final r = dependencies.repositories();
    return AppRepositories(
      auth: account,
      preferences: r.preferences,
      biometrics: r.biometrics,
      money: r.money,
      items: r.items,
      cards: r.cards,
      profile: r.profile,
      budgets: r.budgets,
      transactions: r.transactions,
      cash: r.cash,
      queries: r.queries,
      sms: sms,
      mappings: r.mappings,
      salary: r.salary,
      prepareUser: prepare,
    );
  }

  test(
    'restore waits for SMS work and resumes polling on success and rollback',
    () async {
      final runtime = AppRuntime(repositories(dependencies.prepareUser));
      addTearDown(runtime.close);
      await runtime.retryPreparation();
      sms.idle = Completer<void>();
      var applied = false;
      final action = runtime.withSmsSuspended(() async {
        applied = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(applied, isFalse);
      sms.idle!.complete();
      await action;
      expect(applied, isTrue);
      expect(sms.resets, 1);
      final starts = sms.starts;
      await expectLater(
        runtime.withSmsSuspended(() async {
          throw StateError('Restore failed');
        }),
        throwsStateError,
      );
      expect(sms.starts, starts + 1);
      expect(sms.resets, 2);
    },
  );
  test(
    'failed preparation keeps imports stopped and retry opens the ledger only after success',
    () async {
      var attempt = 0;
      final first = Completer<void>();
      final retry = Completer<void>();
      final runtime = AppRuntime(
        repositories((_) => ++attempt == 1 ? first.future : retry.future),
      );
      addTearDown(runtime.close);
      expect(runtime.preparation.state.loading, isTrue);
      expect(sms.starts, 0);
      final failed = runtime.preparation.stream.firstWhere((s) => s.failed);
      first.completeError(StateError('offline'));
      await failed;
      expect(sms.starts, 0);
      expect(runtime.finance.state.value?.unassigned, isEmpty);
      final work = runtime.retryPreparation();
      expect(runtime.preparation.state.loading, isTrue);
      retry.complete();
      await work;
      expect(runtime.preparation.state.failed, isFalse);
      expect(runtime.preparation.state.loading, isFalse);
      expect(sms.starts, 1);
    },
  );
  test(
    'a hung startup times out, retries join it, and late completion cannot unlock the UI',
    () async {
      final gate = Completer<void>();
      var calls = 0;
      final runtime = AppRuntime(
        repositories((_) {
          calls++;
          return gate.future;
        }),
        preparationTimeout: const Duration(milliseconds: 80),
      );
      addTearDown(runtime.close);
      final failure = await runtime.preparation.stream.firstWhere(
        (s) => s.failed,
      );
      expect(failure.timedOut, isTrue);
      expect(sms.starts, 0);
      await runtime.retryPreparation();
      expect(calls, 1);
      expect(runtime.preparation.state.timedOut, isTrue);
      gate.complete();
      await Future<void>.delayed(Duration.zero);
      expect(runtime.preparation.state.failed, isTrue);
      expect(sms.starts, 0);
    },
  );
  test(
    'an old account finishing migration cannot unlock or start imports for the next account',
    () async {
      final first = Completer<void>();
      final second = Completer<void>();
      final runtime = AppRuntime(
        repositories((user) => user == 'u' ? first.future : second.future),
      );
      addTearDown(runtime.close);
      final loading = runtime.preparation.stream.firstWhere(
        (s) => s.userId == 'other' && s.loading,
      );
      account.switchTo('other');
      await loading;
      first.complete();
      await Future<void>.delayed(Duration.zero);
      expect(runtime.preparation.state.userId, 'other');
      expect(runtime.preparation.state.loading, isTrue);
      expect(sms.starts, 0);
      final ready = runtime.preparation.stream.firstWhere(
        (s) => s.userId == 'other' && !s.loading && !s.failed,
      );
      second.complete();
      await ready;
      expect(sms.starts, 1);
    },
  );
}
