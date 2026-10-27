import '../../../../core/state/async_cubit.dart';
import '../../../../domain/repositories/sms_repository.dart';

class BankMappingsCubit extends AsyncCubit<List<String>> {
  final BankMappingsRepository _repository;
  BankMappingsCubit(this._repository);
  Future<List<String>> getUnknownSenders(String userId) =>
      _repository.getUnknownSenders(userId);
  Future<void> setMapping(String userId, String sender, String bankName) async {
    await _repository.setMapping(userId, sender, bankName);
    await load(() => _repository.getUnknownSenders(userId));
  }
}
