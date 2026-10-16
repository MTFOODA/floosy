import 'package:supabase_flutter/supabase_flutter.dart';
import '../remote/datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await _remoteDataSource.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _remoteDataSource.resetPassword(email: email);
  }

  Future<void> resendConfirmationEmail({
    required String email,
  }) async {
    await _remoteDataSource.resendConfirmationEmail(email: email);
  }

  Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    return await _remoteDataSource.updatePassword(newPassword: newPassword);
  }

  Session? getCurrentSession() {
    return _remoteDataSource.getCurrentSession();
  }

  User? getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  Stream<AuthState> getAuthStateChanges() {
    return _remoteDataSource.getAuthStateChanges();
  }
}
