import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_repository.dart';

/// SDK objects and errors stop at this adapter; tokens never enter view state.
class SupabaseAccountRepository implements AccountRepository {
  final AuthRepository _source;
  SupabaseAccountRepository(this._source);

  static AccountSession? mapSession(Session? session) => session == null
      ? null
      : AccountSession(AccountUser(
          id: session.user.id,
          email: session.user.email,
          userMetadata: Map.unmodifiable(session.user.userMetadata ?? {})));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthException catch (error) {
      throw AuthenticationFailure(error.message, code: error.code);
    }
  }

  @override
  AccountSession? get session => mapSession(_source.getCurrentSession());
  @override
  Stream<AccountUpdate> get changes => _source
          .getAuthStateChanges()
          .map((event) => AccountUpdate(
              AccountEvent.values.byName(event.event.name),
              mapSession(event.session)))
          .handleError((Object error) {
        if (error is AuthException) {
          throw AuthenticationFailure(error.message, code: error.code);
        }
        throw error;
      });
  @override
  Future<void> signIn({required String email, required String password}) =>
      _guard(() async {
        await _source.signIn(email: email, password: password);
      });
  @override
  Future<void> signUp(
          {required String email,
          required String password,
          String? fullName}) =>
      _guard(() async {
        await _source.signUp(
            email: email, password: password, fullName: fullName);
      });
  @override
  Future<bool> signInWithGoogle() => _guard(_source.signInWithGoogle);
  @override
  Future<void> signOut() => _guard(_source.signOut);
  @override
  Future<void> resetPassword({required String email}) =>
      _guard(() => _source.resetPassword(email: email));
  @override
  Future<void> resendConfirmationEmail({required String email}) =>
      _guard(() => _source.resendConfirmationEmail(email: email));
}
