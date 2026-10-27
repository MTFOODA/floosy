import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/user_model.dart';

/// Remote data source for user profile operations.
/// The email is ALWAYS read-only — it comes from auth.users, not from the
/// editable profiles table. Only full_name, phone, avatar_url, language,
/// currency, etc. can be updated here.
class ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ProfileRemoteDataSource(this._supabaseClient);

  Future<UserProfile?> getProfile(String userId) async {
    final response = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    // Merge the auth user's email (read-only) into the profile.
    final user = _supabaseClient.auth.currentUser;
    final email = user?.email;
    return UserProfile.fromJson(Map<String, dynamic>.from(response))
        .copyWith(email: email);
  }

  /// Update editable profile fields. Email is never updated here.
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null || user.id != profile.id) {
      throw StateError('An authenticated profile owner is required');
    }
    // A profile row can be missing for an older account. Upsert the fields
    // edited by this screen, preserving all existing account preferences.
    final response = await _supabaseClient
        .from('profiles')
        .upsert({
          'id': user.id,
          'full_name': profile.fullName,
          'phone': profile.phone,
        }, onConflict: 'id')
        .select()
        .single();
    // Re-attach email from auth.
    return UserProfile.fromJson(Map<String, dynamic>.from(response))
        .copyWith(email: user.email);
  }

  /// Update the user's language preference (synced between profiles table
  /// and local SharedPreferences via LocaleNotifier).
  Future<void> setLanguage(String userId, String languageCode) async {
    await _supabaseClient
        .from('profiles')
        .update({'language': languageCode}).eq('id', userId);
  }
}
