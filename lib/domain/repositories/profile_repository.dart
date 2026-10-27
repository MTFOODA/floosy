import '../entities/user_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class UserProfileRepository {
  Future<UserProfile?> getProfile(String userId);

  Future<UserProfile> updateProfile(UserProfile profile);

  Future<void> setLanguage(String userId, String languageCode);
}
