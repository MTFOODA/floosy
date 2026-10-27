import '../entities/user_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final UserProfileRepository _repository;
  const UpdateProfile(this._repository);
  Future<UserProfile> call(
      {required String userId,
      required String name,
      required String phone}) async {
    final current = await _repository.getProfile(userId);
    if (current != null && current.id != userId) {
      throw StateError('Profile account mismatch');
    }
    return _repository.updateProfile((current ?? UserProfile(id: userId))
        .copyWith(fullName: name.trim(), phone: phone.trim()));
  }
}
