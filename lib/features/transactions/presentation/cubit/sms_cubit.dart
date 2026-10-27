import '../../../../core/state/async_cubit.dart';
import '../../../../core/state/load_state.dart';
import '../../../../domain/entities/sms_ingestion_result.dart';
import '../../../../domain/repositories/sms_repository.dart';

class SmsCubit extends AsyncCubit<SmsIngestionResult> {
  final SmsRepository _repository;
  SmsCubit(this._repository);
  void start() => _repository.start();
  void stop() => _repository.stop();
  Future<SmsIngestionResult> scanNow() async {
    final result = await _repository.scanNow();
    if (!isClosed) emit(LoadState.data(result));
    return result;
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
