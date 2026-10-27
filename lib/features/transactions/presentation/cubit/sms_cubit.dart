import '../../../../core/state/async_cubit.dart';
import '../../../../core/state/load_state.dart';
import '../../../../domain/entities/sms_ingestion_result.dart';
import '../../../../domain/repositories/sms_repository.dart';
import '../../../../domain/repositories/bank_message_import_repository.dart';
import '../../../../domain/entities/imported_bank_message.dart';

class SmsCubit extends AsyncCubit<SmsIngestionResult> {
  final SmsRepository _repository;
  SmsCubit(this._repository);
  void start() => _repository.start();
  void stop() => _repository.stop();
  Future<void> bindUser(String? userId) async {
    if (_repository case final BankMessageImportRepository imports) {
      await imports.bindUser(userId);
    }
  }

  BankMessageImportRepository get _imports =>
      _repository as BankMessageImportRepository;
  Future<BankMessageInbox> importedMessages() => _imports.getInbox();
  Future<void> setImportEnabled(bool enabled) => _imports.setEnabled(enabled);
  Future<void> addImportedMessage(String sender, String body, DateTime date) =>
      _imports.addMessage(sender, body, date);
  Future<void> retryImportedMessage(String id) => _imports.retryMessage(id);
  Future<void> discardImportedMessage(String id) => _imports.discardMessage(id);
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
