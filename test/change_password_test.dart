import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/config/supabase_config.dart';
import 'package:floosy/data/remote/datasources/auth_remote_datasource.dart';

void main() {
  const uid = '00000000-0000-4000-8000-000000000001';
  final user = {
    'id': uid,
    'aud': 'authenticated',
    'email': 'test@example.com',
    'app_metadata': {'provider': 'email'},
    'user_metadata': <String, dynamic>{},
    'created_at': '2026-11-20T00:00:00Z',
  };
  Map<String, dynamic> session(String token) => {
    'access_token': token,
    'refresh_token': 'refresh-$token',
    'expires_in': 3600,
    'token_type': 'bearer',
    'user': user,
  };

  test(
    'wrong current password never updates password or replaces the app session',
    () async {
      var updates = 0;
      final main = SupabaseClient(
        SupabaseConfig.url,
        SupabaseConfig.publishableKey,
        authOptions: const AuthClientOptions(autoRefreshToken: false),
        httpClient: MockClient((request) async {
          if (request.method == 'PUT') updates++;
          return http.Response(jsonEncode(session('original')), 200);
        }),
      );
      addTearDown(main.dispose);
      await main.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'old-password',
      );
      final events = <AuthChangeEvent>[];
      final subscription = main.auth.onAuthStateChange.listen(
        (state) => events.add(state.event),
      );
      addTearDown(subscription.cancel);
      final source = AuthRemoteDataSource(
        main,
        verificationClient: () => MockClient((request) async {
          expect(request.url.path, '/auth/v1/token');
          expect(jsonDecode(request.body)['password'], 'wrong-password');
          return http.Response(
            jsonEncode({'error_code': 'invalid_credentials'}),
            400,
          );
        }),
      );
      await expectLater(
        source.changePassword(
          currentPassword: 'wrong-password',
          newPassword: 'new-password',
        ),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            'invalid_credentials',
          ),
        ),
      );
      expect(updates, 0);
      expect(main.auth.currentSession?.accessToken, 'original');
      await Future<void>.delayed(Duration.zero);
      expect(
        events.where((event) => event == AuthChangeEvent.signedOut),
        isEmpty,
      );
    },
  );

  test(
    'verified old password is sent to update, with isolated verification and local cleanup',
    () async {
      Map<String, dynamic>? update;
      final main = SupabaseClient(
        SupabaseConfig.url,
        SupabaseConfig.publishableKey,
        authOptions: const AuthClientOptions(autoRefreshToken: false),
        httpClient: MockClient((request) async {
          if (request.method == 'PUT') {
            update = jsonDecode(request.body) as Map<String, dynamic>;
            expect(request.headers['Authorization'], 'Bearer original');
            return http.Response(jsonEncode(user), 200);
          }
          return http.Response(jsonEncode(session('original')), 200);
        }),
      );
      addTearDown(main.dispose);
      await main.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'old-password',
      );
      var cleaned = false;
      final source = AuthRemoteDataSource(
        main,
        verificationClient: () => MockClient((request) async {
          if (request.url.path.endsWith('/logout')) {
            expect(request.url.queryParameters['scope'], 'local');
            expect(request.headers['Authorization'], 'Bearer verification');
            cleaned = true;
            return http.Response('', 204);
          }
          expect(jsonDecode(request.body)['email'], 'test@example.com');
          return http.Response(jsonEncode(session('verification')), 200);
        }),
      );
      await source.changePassword(
        currentPassword: 'old-password',
        newPassword: 'new-password',
      );
      expect(update?['password'], 'new-password');
      expect(update?['current_password'], 'old-password');
      expect(main.auth.currentSession?.accessToken, 'original');
      expect(cleaned, isTrue);
    },
  );
}
