import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import '../../domain/repositories/backup_repository.dart';
import '../local/datasources/private_record_store.dart';

const _magic = [70, 76, 79, 79, 83, 89, 66, 49]; // FLOOSYB1
const _maxFile = 64 * 1024 * 1024;
const _maxPlain = 128 * 1024 * 1024;
const _controls = [
  'test-reset-2026-11-21',
  'sms-current-month-history-v1',
  'sms-promotion-repair-v1',
];

List<int> _random(int size) {
  final random = Random.secure();
  return List.generate(size, (_) => random.nextInt(256));
}

Future<SecretKey> _key(String password, List<int> salt) => Pbkdf2(
  macAlgorithm: Hmac.sha256(),
  iterations: 600000,
  bits: 256,
).deriveKeyFromPassword(password: password, nonce: salt);

// Top-level launchers keep database, Auth and platform handles out of closures
// sent to the worker isolate.
Future<Uint8List> _encryptInWorker(List<int> plain, String password) =>
    Isolate.run(() => _encrypt(plain, password));
Future<Map<String, dynamic>> _decryptInWorker(
  Uint8List bytes,
  String password,
) => Isolate.run(() => _decrypt(bytes, password));

Future<Uint8List> _encrypt(List<int> plain, String password) async {
  if (plain.length > _maxPlain) throw const BackupFailure('tooLarge');
  final salt = _random(16);
  final box = await AesGcm.with256bits().encrypt(
    gzip.encode(plain),
    secretKey: await _key(password, salt),
    nonce: _random(12),
    aad: _magic,
  );
  final bytes = Uint8List.fromList([
    ..._magic,
    ...salt,
    ...box.nonce,
    ...box.mac.bytes,
    ...box.cipherText,
  ]);
  if (bytes.length > _maxFile) throw const BackupFailure('tooLarge');
  return bytes;
}

class _BoundedBytes implements Sink<List<int>> {
  final bytes = BytesBuilder(copy: false);
  @override
  void add(List<int> chunk) {
    if (bytes.length + chunk.length > _maxPlain) {
      throw const BackupFailure('tooLarge');
    }
    bytes.add(chunk);
  }

  @override
  void close() {}
}

Future<Map<String, dynamic>> _decrypt(Uint8List bytes, String password) async {
  if (bytes.length > _maxFile) throw const BackupFailure('tooLarge');
  if (bytes.length < 53 ||
      !List.generate(8, (i) => bytes[i] == _magic[i]).every((v) => v)) {
    throw const BackupFailure('invalid');
  }
  List<int> compressed;
  try {
    compressed = await AesGcm.with256bits().decrypt(
      SecretBox(
        bytes.sublist(52),
        nonce: bytes.sublist(24, 36),
        mac: Mac(bytes.sublist(36, 52)),
      ),
      secretKey: await _key(password, bytes.sublist(8, 24)),
      aad: _magic,
    );
  } on SecretBoxAuthenticationError {
    throw const BackupFailure('passwordOrDamage');
  }
  final sink = _BoundedBytes();
  final converter = gzip.decoder.startChunkedConversion(sink);
  converter.add(compressed);
  converter.close();
  final decoded = jsonDecode(utf8.decode(sink.bytes.takeBytes()));
  if (decoded is! Map<String, dynamic>) throw const BackupFailure('invalid');
  return decoded;
}

/// Account-scoped logical snapshot: the device vault key and Auth credentials
/// never leave secure storage. Only the password-encrypted file leaves the app.
class EncryptedBackupService implements BackupRepository {
  final PrivateRecordStore store;
  final Future<void> Function(String user)? afterRestore;
  EncryptedBackupService(this.store, {this.afterRestore});
  List<String> get _tables => [
    ...store.database.allTables.map((t) => t.actualTableName),
    'private_records',
    'sms_payloads',
    'private_media',
  ];
  void _owner(String user) {
    if (store.owner != user) throw const BackupFailure('account');
  }

  String _scope(String table) => table == 'expense_items'
      ? 'expense_id IN (SELECT id FROM expenses WHERE user_id=?)'
      : '${table.startsWith('private_') || table == 'sms_payloads' ? 'owner' : 'user_id'}=?';
  bool _control(Map<String, dynamic> row) =>
      row['kind'] == 'preferences' && _controls.contains(row['id']);
  Future<List<Map<String, dynamic>>> _rows(String table, String user) async {
    final order = table == 'sms_payloads'
        ? '"hash"'
        : table == 'private_records'
        ? '"id","kind"'
        : '"id"';
    final rows = await store.database
        .customSelect(
          'SELECT * FROM "$table" WHERE ${_scope(table)} ORDER BY $order',
          variables: [Variable(user)],
        )
        .get();
    return rows
        .map((r) => Map<String, dynamic>.from(r.data))
        .where((r) => table != 'private_records' || !_control(r))
        .map(
          (row) => row.map(
            (key, value) => MapEntry(
              key,
              value is Uint8List ? {'blob': base64Encode(value)} : value,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<Uint8List> create(String user, String password) async {
    _owner(user);
    if (password.runes.length < 10) throw const BackupFailure('shortPassword');
    final snapshot = await store.database.transaction(() async {
      final tables = <String, dynamic>{};
      for (final table in _tables) {
        tables[table] = await _rows(table, user);
      }
      _owner(user);
      return {
        'format': 'FloosyBackup',
        'version': 1,
        'schema': store.database.schemaVersion,
        'owner': user,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'tables': tables,
      };
    });
    final plain = utf8.encode(jsonEncode(snapshot));
    final encrypted = await _encryptInWorker(plain, password);
    _owner(user);
    return encrypted;
  }

  Future<Map<String, dynamic>> _open(
    String user,
    Uint8List bytes,
    String password,
  ) async {
    _owner(user);
    try {
      final data = await _decryptInWorker(bytes, password);
      _owner(user);
      if (data['owner'] != user) throw const BackupFailure('account');
      if (data['format'] != 'FloosyBackup' ||
          data['version'] != 1 ||
          data['schema'] != store.database.schemaVersion ||
          data['tables'] is! Map ||
          DateTime.tryParse(data['created_at']?.toString() ?? '') == null) {
        throw const BackupFailure('invalid');
      }
      final tables = data['tables'] as Map;
      if (tables.length != _tables.length ||
          !_tables.every(tables.containsKey)) {
        throw const BackupFailure('invalid');
      }
      for (final table in _tables) {
        final info = await store.database
            .customSelect('PRAGMA table_info("$table")')
            .get();
        final columns = info.map((r) => r.read<String>('name')).toSet();
        if (tables[table] is! List) throw const BackupFailure('invalid');
        for (final raw in tables[table] as List) {
          if (raw is! Map ||
              raw.length != columns.length ||
              !columns.every(raw.containsKey)) {
            throw const BackupFailure('invalid');
          }
          final row = Map<String, dynamic>.from(raw);
          if (table != 'expense_items' &&
              row[columns.contains('owner') ? 'owner' : 'user_id'] != user) {
            throw const BackupFailure('account');
          }
          if (table == 'private_records' && _control(row)) {
            throw const BackupFailure('invalid');
          }
          for (final value in row.values) {
            if (value is Map) {
              if (value.length != 1 || value['blob'] is! String) {
                throw const BackupFailure('invalid');
              }
              base64Decode(value['blob'] as String);
            } else if (value != null && value is! String && value is! num) {
              throw const BackupFailure('invalid');
            }
          }
        }
      }
      final expenses = (tables['expenses'] as List).map((r) => r['id']).toSet();
      if ((tables['expense_items'] as List).any(
        (r) => !expenses.contains(r['expense_id']),
      )) {
        throw const BackupFailure('invalid');
      }
      return data;
    } on BackupFailure {
      rethrow;
    } catch (_) {
      throw const BackupFailure('invalid');
    }
  }

  @override
  Future<BackupSummary> inspect(
    String user,
    Uint8List bytes,
    String password,
  ) async {
    final data = await _open(user, bytes, password);
    return BackupSummary(
      DateTime.parse(data['created_at'] as String),
      ((data['tables'] as Map)['transactions'] as List).length,
    );
  }

  @override
  Future<void> restore(String user, Uint8List bytes, String password) async {
    final data = await _open(
      user,
      bytes,
      password,
    ); // Authenticate before touching any row.
    final tables = data['tables'] as Map;
    await store.database.transaction(() async {
      _owner(user);
      await store.database.customStatement(
        'DELETE FROM expense_items WHERE ${_scope('expense_items')}',
        [user],
      );
      for (final table in _tables.reversed.where((t) => t != 'expense_items')) {
        if (table == 'private_records') {
          for (final row in await _rows(table, user)) {
            await store.database.customStatement(
              'DELETE FROM private_records WHERE owner=? AND kind=? AND id=?',
              [user, row['kind'], row['id']],
            );
          }
        } else {
          await store.database.customStatement(
            'DELETE FROM "$table" WHERE ${_scope(table)}',
            [user],
          );
        }
      }
      for (final table in _tables) {
        for (final raw in tables[table] as List) {
          final row = Map<String, dynamic>.from(raw as Map);
          final values = row.values
              .map((v) => v is Map ? base64Decode(v['blob'] as String) : v)
              .toList();
          await store.database.customStatement(
            'INSERT INTO "$table" (${row.keys.map((k) => '"$k"').join(',')}) VALUES (${List.filled(row.length, '?').join(',')})',
            values,
          );
        }
      }
      // Read every restored row back before committing: includes exact integer
      // amounts, movements, card configuration, compressed SMS and image bytes.
      for (final table in _tables) {
        if (jsonEncode(await _rows(table, user)) != jsonEncode(tables[table])) {
          throw const BackupFailure('verification');
        }
      }
      await afterRestore?.call(user);
      _owner(user);
    });
  }
}
