abstract interface class AppPreferencesRepository {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

abstract interface class BiometricRepository {
  Future<bool> isEnabled(String userId);
  Future<bool> authenticate(String reason);
  Future<bool> setEnabled(String userId, bool enabled, String reason);
}
