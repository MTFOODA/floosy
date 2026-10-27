import '../entities/auth_session.dart';

abstract interface class AccountRepository {
  AccountSession? get session;
  Stream<AccountUpdate> get changes;
  Future<void> signIn({required String email, required String password});
  Future<void> signUp(
      {required String email, required String password, String? fullName});
  Future<bool> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Future<void> resendConfirmationEmail({required String email});
}
