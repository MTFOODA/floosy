import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import '../security/vault_key_store.dart';
import '../security/encrypted_vault.dart';

LazyDatabase connectToDatabase() => LazyDatabase(() async {
  final support = await getApplicationSupportDirectory();
  final documents = await getApplicationDocumentsDirectory();
  final directory = Directory(p.join(support.path, 'FloosyVault'));
  await directory.create(recursive: true);
  if (Platform.isIOS) {
    await const MethodChannel(
      'floosy/private_vault',
    ).invokeMethod<void>('prepareVault');
  }
  // The owner approved discarding every old test ledger. This generation must
  // never import v1/legacy files or depend on a cloud snapshot to open.
  final path = p.join(directory.path, 'floosy-vault-v2.db');
  final key = await loadVaultKey(
    const DeviceVaultKeyStore(),
    encryptedDataExists:
        await File(path).exists() || await File('$path.migrating').exists(),
  );
  final legacyPath = p.join(documents.path, 'floosy.db');
  return NativeDatabase.createInBackground(
    File(path),
    isolateSetup: () {
      prepareEncryptedVault(
        legacyPath: legacyPath,
        vaultPath: path,
        key: key,
        importLegacy: false,
      );
      retireTestDatabaseFiles(
        activePath: path,
        retiredPaths: [
          legacyPath,
          p.join(directory.path, 'floosy-vault-v1.db'),
          p.join(support.path, 'floosy-vault-v1.db'),
        ],
      );
    },
    setup: (raw) => unlockVault(raw, key),
    logStatements: false,
  );
});
