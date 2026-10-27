import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/auth_session.dart';
import '../../../../domain/repositories/auth_repository.dart';

enum AuthenticationAction {
  idle,
  password,
  google,
  registration,
  signOut,
  passwordReset,
  resend
}

class AuthenticationState {
  final AccountSession? session;
  final AccountEvent? event;
  final Object? error;
  final AuthenticationAction action;
  final bool googlePending;
  const AuthenticationState(
      {this.session,
      this.event,
      this.error,
      this.action = AuthenticationAction.idle,
      this.googlePending = false});
  AccountUser? get user => session?.user;
  String? get userId => user?.id;
  bool get working => action != AuthenticationAction.idle;
  bool get resending => action == AuthenticationAction.resend;
}

class AuthCubit extends Cubit<AuthenticationState> {
  final AccountRepository _repository;
  late final StreamSubscription<AccountUpdate> _subscription;
  int _operation = 0;
  AuthCubit(this._repository)
      : super(AuthenticationState(session: _repository.session)) {
    _subscription = _repository.changes.listen((update) {
      final complete = update.event == AccountEvent.signedIn ||
          update.event == AccountEvent.signedOut;
      if (complete) _operation++;
      emit(AuthenticationState(
          session: update.session,
          event: update.event,
          action: complete ? AuthenticationAction.idle : state.action,
          googlePending: complete ? false : state.googlePending));
    }, onError: (Object error, StackTrace stack) {
      _operation++;
      // An error must never replay an earlier signedIn event to the app lock.
      emit(AuthenticationState(session: state.session, error: error));
    });
  }
  void _action(AuthenticationAction action, {bool? googlePending}) {
    if (isClosed) return;
    // Only SDK events carry AccountEvent.signedIn, never operation updates.
    emit(AuthenticationState(
        session: state.session,
        action: action,
        googlePending: googlePending ?? state.googlePending));
  }

  Future<T> _run<T>(
      AuthenticationAction action, Future<T> Function() execute) async {
    if (state.working || state.googlePending) {
      throw StateError('Authentication is already pending');
    }
    final operation = ++_operation;
    _action(action);
    try {
      return await execute();
    } finally {
      if (!isClosed && operation == _operation) {
        _action(AuthenticationAction.idle);
      }
    }
  }

  Future<void> signIn({required String email, required String password}) =>
      _run(AuthenticationAction.password,
          () => _repository.signIn(email: email, password: password));
  Future<void> signUp(
          {required String email,
          required String password,
          String? fullName}) =>
      _run(
          AuthenticationAction.registration,
          () => _repository.signUp(
              email: email, password: password, fullName: fullName));
  Future<bool> signInWithGoogle() async {
    if (state.working || state.googlePending) return false;
    final operation = ++_operation;
    _action(AuthenticationAction.google, googlePending: true);
    try {
      final launched = await _repository.signInWithGoogle();
      if (!launched && !isClosed && operation == _operation) {
        _action(AuthenticationAction.idle, googlePending: false);
      }
      return launched;
    } catch (_) {
      if (!isClosed && operation == _operation) {
        _action(AuthenticationAction.idle, googlePending: false);
      }
      rethrow;
    } finally {
      if (!isClosed && operation == _operation) {
        _action(AuthenticationAction.idle);
      }
    }
  }

  void cancelGoogle() {
    if (state.action == AuthenticationAction.google) return;
    _operation++;
    _action(AuthenticationAction.idle, googlePending: false);
  }

  Future<void> signOut() async {
    _operation++;
    _action(AuthenticationAction.signOut, googlePending: false);
    try {
      await _repository.signOut();
    } finally {
      if (!isClosed) _action(AuthenticationAction.idle, googlePending: false);
    }
  }

  Future<void> resetPassword({required String email}) => _run(
      AuthenticationAction.passwordReset,
      () => _repository.resetPassword(email: email));
  Future<void> resendConfirmationEmail({required String email}) => _run(
      AuthenticationAction.resend,
      () => _repository.resendConfirmationEmail(email: email));
  @override
  Future<void> close() async {
    _operation++;
    await _subscription.cancel();
    await super.close();
  }
}
