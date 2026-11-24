import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/supabase_config.dart';

/// Auth data source backed by Supabase Auth. Identity is always taken from
/// the session (auth.uid()) — never from client-supplied user ids.
class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final http.Client Function() _verificationClient;

  AuthRemoteDataSource(
    this._supabaseClient, {
    http.Client Function()? verificationClient,
  }) : _verificationClient = verificationClient ?? http.Client.new;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _supabaseClient.auth.currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      throw const AuthException(
        'Sign in with an email and password first',
        code: 'password_login_required',
      );
    }
    if (currentPassword.isEmpty ||
        newPassword.length < 6 ||
        currentPassword == newPassword) {
      throw const AuthException(
        'Invalid password change',
        code: 'invalid_password_change',
      );
    }
    // Isolate verification from the app session. Re-signing into the main
    // client emits signedIn and can reset navigation/import/biometric state.
    // A standalone SDK client also broadcasts signedIn on web. Use an isolated
    // HTTP request so verification cannot replace any tab's current session.
    final verifier = _verificationClient();
    String? verificationToken;
    final headers = {
      'apikey': SupabaseConfig.publishableKey,
      'Content-Type': 'application/json',
    };
    try {
      final response = await verifier
          .post(
            Uri.parse(
              '${SupabaseConfig.url}/auth/v1/token?grant_type=password',
            ),
            headers: headers,
            body: jsonEncode({'email': email, 'password': currentPassword}),
          )
          .timeout(const Duration(seconds: 20));
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        throw AuthException(
          'Password verification failed',
          code:
              result['error_code'] as String? ?? 'password_verification_failed',
        );
      }
      verificationToken = result['access_token'] as String?;
      if (verificationToken == null ||
          (result['user'] as Map?)?['id'] != user.id ||
          _supabaseClient.auth.currentUser?.id != user.id) {
        throw const AuthException('Account changed', code: 'session_not_found');
      }
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword, currentPassword: currentPassword),
      );
    } finally {
      // Revoke only the short-lived verification session.
      try {
        if (verificationToken != null) {
          await verifier
              .post(
                Uri.parse('${SupabaseConfig.url}/auth/v1/logout?scope=local'),
                headers: {
                  ...headers,
                  'Authorization': 'Bearer $verificationToken',
                },
              )
              .timeout(const Duration(seconds: 5));
        }
      } catch (_) {
        // A cleanup failure must not report a successful update as failed.
      }
      verifier.close();
    }
  }

  Future<bool> signInWithGoogle() => _supabaseClient.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: kIsWeb ? Uri.base.origin : SupabaseConfig.authRedirectUrl,
    authScreenLaunchMode: LaunchMode.externalApplication,
    queryParams: const {'prompt': 'select_account'},
  );

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
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
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
    await _supabaseClient.auth.resend(email: email, type: OtpType.signup);
  }

  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _supabaseClient.auth.updateUser(
      UserAttributes(password: newPassword),
    );
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
