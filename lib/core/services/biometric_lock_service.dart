import 'package:flutter/foundation.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricLockService implements BiometricRepository {
  final LocalAuthentication _auth;
  BiometricLockService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  @override
  Future<bool> isEnabled(String userId) async =>
      (await SharedPreferences.getInstance())
          .getBool('floosy_biometric_$userId') ??
      false;

  @override
  Future<bool> authenticate(String reason) async {
    if (kIsWeb) return false;
    try {
      if (!await _auth.isDeviceSupported()) return false;
      return await _auth.authenticate(
          localizedReason: reason,
          biometricOnly: defaultTargetPlatform != TargetPlatform.windows,
          persistAcrossBackgrounding: true);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> setEnabled(String userId, bool enabled, String reason) async {
    if (!await authenticate(reason)) return false;
    return (await SharedPreferences.getInstance())
        .setBool('floosy_biometric_$userId', enabled);
  }
}
