import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class VaultKeyStore {
  Future<String?> read();
  Future<void> write(String key);
}

class DeviceVaultKeyStore implements VaultKeyStore {
  static const _name = 'floosy.device.vault.v1';
  final FlutterSecureStorage storage;
  const DeviceVaultKeyStore([
    this.storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: false),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
      mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  ]);
  @override
  Future<String?> read() => storage.read(key: _name);
  @override
  Future<void> write(String key) => storage.write(key: _name, value: key);
}

class VaultAccessException implements Exception {
  final String code;
  const VaultAccessException(this.code);
  @override
  String toString() => 'VaultAccessException($code)';
}

Future<String> loadVaultKey(
  VaultKeyStore store, {
  required bool encryptedDataExists,
}) async {
  final existing = await store.read();
  if (existing != null) {
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(existing)) {
      throw const VaultAccessException('invalid_key');
    }
    return existing;
  }
  if (encryptedDataExists) throw const VaultAccessException('missing_key');
  final random = Random.secure();
  final key = List.generate(
    32,
    (_) => random.nextInt(256),
  ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  await store.write(key);
  if (await store.read() != key) {
    throw const VaultAccessException('key_not_persisted');
  }
  return key;
}
