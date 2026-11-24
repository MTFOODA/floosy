import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;
import 'vault_key_store.dart';

String _sql(String value) => "'${value.replaceAll("'", "''")}'";
String _identifier(String value) => '"${value.replaceAll('"', '""')}"';

void unlockVault(Database database, String key) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(key)) {
    throw const VaultAccessException('invalid_key');
  }
  if (database.select('PRAGMA cipher').isEmpty) {
    throw const VaultAccessException('encryption_unavailable');
  }
  database.execute("PRAGMA cipher = 'chacha20'");
  database.execute('PRAGMA key = ${_sql(key)}');
  database.select('SELECT count(*) FROM sqlite_master');
  database.execute('PRAGMA secure_delete = ON');
  database.execute('PRAGMA temp_store = MEMORY');
}

/// Stable content digests include every table, column and row, not just counts.
Map<String, String> vaultDigests(Database database) {
  final tables = database.select(
    "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
  );
  return {
    for (final table in tables)
      table['name'] as String: sha256
          .convert(
            utf8.encode(
              jsonEncode(
                database
                    .select(
                      'SELECT * FROM ${_identifier(table['name'] as String)}',
                    )
                    .map(
                      (r) => sha256
                          .convert(
                            utf8.encode(
                              jsonEncode(Map<String, dynamic>.from(r)),
                            ),
                          )
                          .toString(),
                    )
                    .toList()
                  ..sort(),
              ),
            ),
          )
          .toString(),
  };
}

/// Resume safely after termination; do not remove the legacy source until the
/// encrypted copy has been reopened, checked, and compared in full.
void prepareEncryptedVault({
  required String legacyPath,
  required String vaultPath,
  required String key,
  bool importLegacy = true,
}) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(key)) {
    throw const VaultAccessException('invalid_key');
  }
  final vault = File(vaultPath);
  final legacy = File(legacyPath);
  final temporary = File('$vaultPath.migrating');
  if (vault.existsSync()) {
    final database = sqlite3.open(vaultPath);
    try {
      unlockVault(database, key);
    } finally {
      database.close();
    }
    if (importLegacy && legacy.existsSync()) {
      _removeVerifiedLegacy(legacyPath, vaultPath, key);
    }
    return;
  }
  if (!importLegacy || !legacy.existsSync()) {
    if (temporary.existsSync()) {
      throw const VaultAccessException('incomplete_migration_without_source');
    }
    final database = sqlite3.open(vaultPath);
    try {
      unlockVault(database, key);
      database.execute('PRAGMA user_version = 0');
    } finally {
      database.close();
    }
    return;
  }
  if (temporary.existsSync()) temporary.deleteSync();
  final original = sqlite3.open(legacyPath);
  late Map<String, String> before;
  try {
    original.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    before = vaultDigests(original);
    original.execute('VACUUM INTO ${_sql(temporary.path)}');
  } finally {
    original.close();
  }
  final copy = sqlite3.open(temporary.path);
  try {
    if (copy.select('PRAGMA cipher').isEmpty) {
      throw const VaultAccessException('encryption_unavailable');
    }
    copy.execute("PRAGMA cipher = 'chacha20'");
    copy.execute('PRAGMA rekey = ${_sql(key)}');
  } finally {
    copy.close();
  }
  final verify = sqlite3.open(temporary.path);
  try {
    unlockVault(verify, key);
    if (verify.select('PRAGMA integrity_check').single.values.single != 'ok' ||
        jsonEncode(vaultDigests(verify)) != jsonEncode(before)) {
      throw const VaultAccessException('migration_verification_failed');
    }
  } finally {
    verify.close();
  }
  temporary.renameSync(vaultPath);
  _removeVerifiedLegacy(legacyPath, vaultPath, key);
}

/// One-off cleanup explicitly authorized for the old test installation. Never
/// traverse directories or remove the active encrypted vault/key/auth settings.
void retireTestDatabaseFiles({
  required String activePath,
  required List<String> retiredPaths,
}) {
  String canonical(String path) {
    final value = p.normalize(p.absolute(path));
    return Platform.isWindows ? value.toLowerCase() : value;
  }

  final active = canonical(activePath);
  for (final path in retiredPaths) {
    if (canonical(path) == active) {
      throw ArgumentError('Cannot retire active vault');
    }
  }
  for (final path in retiredPaths) {
    for (final suffix in [
      '',
      '-wal',
      '-shm',
      '-journal',
      '.migrating',
      '.migrating-wal',
      '.migrating-shm',
      '.migrating-journal',
    ]) {
      final file = File('$path$suffix');
      if (file.existsSync()) file.deleteSync();
    }
  }
}

void _removeVerifiedLegacy(String legacyPath, String vaultPath, String key) {
  final original = sqlite3.open(legacyPath);
  final encrypted = sqlite3.open(vaultPath);
  try {
    unlockVault(encrypted, key);
    if (jsonEncode(vaultDigests(original)) !=
        jsonEncode(vaultDigests(encrypted))) {
      throw const VaultAccessException('legacy_conflict');
    }
  } finally {
    original.close();
    encrypted.close();
  }
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final file = File('$legacyPath$suffix');
    if (file.existsSync()) file.deleteSync();
  }
}
