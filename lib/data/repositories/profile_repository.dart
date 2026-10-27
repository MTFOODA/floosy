import '../../domain/repositories/profile_repository.dart' as domain;
import '../../domain/entities/user_model.dart';
import '../remote/datasources/profile_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

/// Repository for the user profile. Email is always sourced from the
/// authenticated session — it cannot be edited by the user.
class UserProfileRepository implements domain.UserProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  UserProfileRepository({required this.remoteDataSource});

  @override
  Future<UserProfile?> getProfile(String userId) async {
    try {
      return await remoteDataSource.getProfile(userId);
    } catch (e) {
      logError('Error getting profile: $e');
      return null;
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      return await remoteDataSource.updateProfile(profile);
    } catch (e) {
      logError('Error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> setLanguage(String userId, String languageCode) async {
    try {
      await remoteDataSource.setLanguage(userId, languageCode);
    } catch (e) {
      logError('Error setting language: $e');
    }
  }
}
