import '../../../../core/state/load_state.dart';
import '../../../../domain/usecases/update_profile.dart';
import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/user_model.dart';
import '../../../../domain/repositories/profile_repository.dart';

class ProfileCubit extends AsyncCubit<UserProfile?> {
  final UserProfileRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  ProfileCubit(this._repository, this._userId, this._onChanged);
  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(null);
      return Future.value();
    }
    return load(() => _repository.getProfile(userId));
  }

  Future<void> save(
      {required String userId,
      required String name,
      required String phone}) async {
    final previous = state.value;
    replace(LoadState.loading(value: previous));
    try {
      final result = await UpdateProfile(_repository)(
          userId: userId, name: name, phone: phone);
      if (isClosed || _userId() != userId) return;
      replace(LoadState.data(result));
      _onChanged();
    } catch (error, stack) {
      if (!isClosed && _userId() == userId) {
        replace(LoadState.failure(error, stack, value: previous));
      }
      rethrow;
    }
  }
}
