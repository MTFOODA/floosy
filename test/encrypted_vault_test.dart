import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:drift/native.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/security/encrypted_vault.dart';
import 'package:floosy/data/local/security/vault_key_store.dart';

class _Keys implements VaultKeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String key) async {
    value = key;
  }
}

void main() {
  final key = List.filled(64, 'a').join();
  late Directory directory;
  setUp(
    () => directory = Directory.systemTemp.createTempSync(
      'floosy-encryption-test-',
    ),
  );
  tearDown(() => directory.deleteSync(recursive: true));
  test(
    'device key is persisted and never silently replaced when data exists',
    () async {
      final keys = _Keys();
      final generated = await loadVaultKey(keys, encryptedDataExists: false);
      expect(generated.length, 64);
      expect(await loadVaultKey(keys, encryptedDataExists: true), generated);
      keys.value = null;
      await expectLater(
        loadVaultKey(keys, encryptedDataExists: true),
        throwsA(isA<VaultAccessException>()),
      );
      expect(keys.value, isNull);
    },
  );
  test(
    'encrypted database reopens with its key and refuses missing/wrong keys',
    () {
      final path = '${directory.path}/vault.db';
      prepareEncryptedVault(
        legacyPath: '${directory.path}/legacy.db',
        vaultPath: path,
        key: key,
      );
      final write = sqlite3.open(path);
      unlockVault(write, key);
      write.execute('CREATE TABLE secrets (message TEXT)');
      write.execute("INSERT INTO secrets VALUES ('PRIVATE_FINANCIAL_MARKER')");
      write.close();
      expect(
        String.fromCharCodes(
          File(path).readAsBytesSync(),
        ).contains('PRIVATE_FINANCIAL_MARKER'),
        isFalse,
      );
      final plain = sqlite3.open(path);
      expect(
        () => plain.select('SELECT * FROM secrets'),
        throwsA(isA<SqliteException>()),
      );
      plain.close();
      final wrong = sqlite3.open(path);
      expect(
        () => unlockVault(wrong, List.filled(64, 'b').join()),
        throwsA(isA<SqliteException>()),
      );
      wrong.close();
      final read = sqlite3.open(path);
      unlockVault(read, key);
      expect(
        read.select('SELECT message FROM secrets').single['message'],
        'PRIVATE_FINANCIAL_MARKER',
      );
      read.close();
    },
  );
  test(
    'legacy migration preserves rows, integer balances, schema version and WAL commits',
    () {
      final legacy = '${directory.path}/legacy.db';
      final encrypted = '${directory.path}/vault.db';
      final original = sqlite3.open(legacy);
      original.execute('PRAGMA journal_mode=WAL');
      original.execute('PRAGMA user_version=5');
      original.execute(
        'CREATE TABLE movements(id TEXT PRIMARY KEY, amount INTEGER, body TEXT)',
      );
      original.execute(
        "INSERT INTO movements VALUES ('one',12550,'bank message'),('two',-35000,'second message')",
      );
      original.close();
      prepareEncryptedVault(legacyPath: legacy, vaultPath: encrypted, key: key);
      expect(File(legacy).existsSync(), isFalse);
      final read = sqlite3.open(encrypted);
      unlockVault(read, key);
      expect(read.select('PRAGMA user_version').single.values.single, 5);
      expect(
        read
            .select('SELECT sum(amount) AS total FROM movements')
            .single['total'],
        -22450,
      );
      expect(read.select('SELECT * FROM movements').length, 2);
      read.close();
      prepareEncryptedVault(legacyPath: legacy, vaultPath: encrypted, key: key);
    },
  );
  test('compaction reclaims pages without losing encryption or balances', () {
    final path = '${directory.path}/vault.db';
    prepareEncryptedVault(
      legacyPath: '${directory.path}/missing.db',
      vaultPath: path,
      key: key,
    );
    final database = sqlite3.open(path);
    unlockVault(database, key);
    database.execute('CREATE TABLE money(amount INTEGER, marker TEXT)');
    database.execute(
      "INSERT INTO money VALUES(123456,'PRIVATE_BALANCE_MARKER')",
    );
    database.execute('CREATE TABLE staging(payload BLOB)');
    database.execute('INSERT INTO staging VALUES(randomblob(1048576))');
    database.execute('DELETE FROM staging');
    final before = File(path).lengthSync();
    database.execute('VACUUM');
    database.close();
    expect(File(path).lengthSync(), lessThan(before));
    expect(
      String.fromCharCodes(File(path).readAsBytesSync()),
      isNot(contains('PRIVATE_BALANCE_MARKER')),
    );
    final reopened = sqlite3.open(path);
    unlockVault(reopened, key);
    expect(
      reopened.select('SELECT amount FROM money').single['amount'],
      123456,
    );
    reopened.close();
  });
  test(
    'fresh generation opens in a real background isolate without reading retired test files',
    () async {
      final legacy = '${directory.path}/legacy.db';
      final active = '${directory.path}/fresh.db';
      File(legacy).writeAsStringSync(
        'obsolete test data, deliberately not a valid SQLite file',
      );
      final database = db.AppDatabase(
        NativeDatabase.createInBackground(
          File(active),
          isolateSetup: () {
            prepareEncryptedVault(
              legacyPath: legacy,
              vaultPath: active,
              key: key,
              importLegacy: false,
            );
            retireTestDatabaseFiles(activePath: active, retiredPaths: [legacy]);
          },
          setup: (raw) => unlockVault(raw, key),
        ),
      );
      try {
        await database
            .customSelect('SELECT 1')
            .get()
            .timeout(const Duration(seconds: 5));
        expect(File(legacy).existsSync(), isFalse);
        await database.customStatement(
          "INSERT INTO items(id,user_id,name,price_minor) VALUES('new','u','Item',12345)",
        );
      } finally {
        await database.close();
      }
      final reopened = sqlite3.open(active);
      unlockVault(reopened, key);
      expect(
        reopened.select('SELECT price_minor FROM items').single['price_minor'],
        12345,
      );
      reopened.close();
      expect(
        () =>
            retireTestDatabaseFiles(activePath: active, retiredPaths: [active]),
        throwsArgumentError,
      );
      expect(File(active).existsSync(), isTrue);
    },
  );
  test('failed encryption keeps the only source intact', () {
    final legacy = '${directory.path}/legacy.db';
    final encrypted = '${directory.path}/vault.db';
    final original = sqlite3.open(legacy);
    original.execute('CREATE TABLE balances(amount INTEGER)');
    original.execute('INSERT INTO balances VALUES(70000)');
    original.close();
    expect(
      () => prepareEncryptedVault(
        legacyPath: legacy,
        vaultPath: encrypted,
        key: 'invalid',
      ),
      throwsA(anything),
    );
    expect(File(legacy).existsSync(), isTrue);
    final read = sqlite3.open(legacy);
    expect(read.select('SELECT amount FROM balances').single['amount'], 70000);
    read.close();
  });
}
