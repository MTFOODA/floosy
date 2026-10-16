import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth data source backed by Supabase Auth. Identity is always taken from
/// the session (auth.uid()) — never from client-supplied user ids.
class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSource(this._supabaseClient);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    Map<String, dynamic>? data,
  }) async {
    final mergedData = Map<String, dynamic>.from(data ?? {});
    if (fullName != null) mergedData['full_name'] = fullName;
    return await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: mergedData.isNotEmpty ? mergedData : null,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabaseClient.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  /// Resends the signup confirmation email so the user can confirm their
  /// address and log in.
  Future<void> resendConfirmationEmail({required String email}) async {
    await _supabaseClient.auth.resend(
      email: email,
      type: OtpType.signup,
    );
  }

  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _supabaseClient.auth
        .updateUser(UserAttributes(password: newPassword));
  }

  Session? getCurrentSession() {
    return _supabaseClient.auth.currentSession;
  }

  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }

  Stream<AuthState> getAuthStateChanges() {
    return _supabaseClient.auth.onAuthStateChange;
  }
}
