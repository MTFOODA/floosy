import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import '../state/load_state.dart';

class AppLockState {
  final String? userId;
  final String? unlockedUserId;
  final bool authenticating;
  final LoadState<bool> enabled;
  const AppLockState(
      {this.userId,
      this.unlockedUserId,
      this.authenticating = false,
      this.enabled = const LoadState.loading()});
  bool get required =>
      userId != null &&
      unlockedUserId != userId &&
      (enabled.isLoading || enabled.hasError || enabled.value == true);
  bool get biometricAvailable =>
      userId != null && unlockedUserId != userId && enabled.value == true;
}

class AppLockCubit extends Cubit<AppLockState> {
  final BiometricRepository _biometrics;
  int _attempt = 0;
  int _preferenceRead = 0;
  AppLockCubit(this._biometrics) : super(const AppLockState());

  void handleAuthentication(
      {required String? userId, AccountEvent? event, bool hasError = false}) {
    final changed = userId != state.userId;
    if (changed) {
      _attempt++;
      emit(AppLockState(userId: userId));
      reloadEnabled();
    }
    if (hasError) return;
    if (event == AccountEvent.signedIn && userId != null) {
      markVerified(userId);
    }
    if (event == AccountEvent.signedOut) reset();
  }

  Future<void> reloadEnabled() async {
    final userId = state.userId;
    final read = ++_preferenceRead;
    if (userId == null) return;
    LoadState<bool> enabled;
    try {
      enabled = LoadState.data(await _biometrics.isEnabled(userId));
    } catch (error, stack) {
      enabled = LoadState.failure(error, stack);
    }
    if (isClosed || read != _preferenceRead || state.userId != userId) return;
    emit(AppLockState(
        userId: userId,
        unlockedUserId: state.unlockedUserId,
        authenticating: state.authenticating,
        enabled: enabled));
  }

  void reset() {
    _attempt++;
    emit(AppLockState(userId: state.userId, enabled: state.enabled));
  }

  void lockAfterBackgrounding() {
    if (!state.authenticating) reset();
  }

  void markVerified(String userId) {
    if (state.userId != userId) return;
    _attempt++;
    emit(AppLockState(
        userId: userId, unlockedUserId: userId, enabled: state.enabled));
  }

  Future<bool> setEnabled(String userId, bool enabled, String reason) async {
    final ok = await _biometrics.setEnabled(userId, enabled, reason);
    if (!ok || isClosed || state.userId != userId) return false;
    markVerified(userId);
    await reloadEnabled();
    return true;
  }

  Future<bool> unlockWithBiometrics(String reason) async {
    final userId = state.userId;
    if (state.authenticating || userId == null || state.enabled.value != true) {
      return false;
    }
    final attempt = ++_attempt;
    emit(AppLockState(
        userId: userId, authenticating: true, enabled: state.enabled));
    final ok = await _biometrics.authenticate(reason);
    if (isClosed || attempt != _attempt) return false;
    final unlocked = ok && state.userId == userId;
    emit(AppLockState(
        userId: state.userId,
        unlockedUserId: unlocked ? userId : null,
        enabled: state.enabled));
    return unlocked;
  }
}
