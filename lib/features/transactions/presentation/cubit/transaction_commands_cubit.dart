import '../../../../domain/usecases/create_manual_transaction.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import '../../../../domain/usecases/save_transaction_edit.dart';
import '../../../../domain/entities/card_resolution_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../../domain/repositories/transaction_repository.dart';

class TransactionCommandState {
  final int pending;
  final int revision;
  final Object? error;
  const TransactionCommandState(
      {this.pending = 0, this.revision = 0, this.error});
  bool get busy => pending > 0;
}

class TransactionCommandsCubit extends Cubit<TransactionCommandState> {
  final TransactionRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  final SaveTransactionEdit Function(String) _editor;
  final DeleteTransaction _delete;
  final CreateManualTransaction _manual;
  int _epoch = 0;
  void reset() {
    _epoch++;
    if (!isClosed) emit(const TransactionCommandState());
  }

  Future<T> _execute<T>(Future<T> Function() command) async {
    final epoch = _epoch;
    emit(TransactionCommandState(
        pending: state.pending + 1, revision: state.revision));
    try {
      final result = await command();
      if (epoch == _epoch) _onChanged();
      if (!isClosed && epoch == _epoch) {
        emit(TransactionCommandState(
            pending: state.pending - 1, revision: state.revision + 1));
      }
      return result;
    } catch (error) {
      if (!isClosed && epoch == _epoch) {
        emit(TransactionCommandState(
            pending: state.pending - 1,
            revision: state.revision,
            error: error));
      }
      rethrow;
    }
  }

  TransactionCommandsCubit(this._repository, this._userId, this._onChanged,
      this._editor, this._delete, this._manual)
      : super(const TransactionCommandState());
  Future<void> createManual(
      {required TransactionType type,
      required int amountMinor,
      required String currency,
      String? note}) async {
    final userId = _userId();
    if (userId == null) throw StateError('Sign in first');
    await _execute(() => _manual(
        userId: userId,
        type: type,
        amountMinor: amountMinor,
        currency: currency,
        note: note));
  }

  Future<SmartResolutionResult?> saveEdit(TransactionEditDraft draft) async {
    final userId = _userId();
    if (userId == null) return null;
    return _execute(() => _editor(userId).save(draft));
  }

  Future<Transaction> createTransaction({
    required Transaction transaction,
  }) async {
    return _execute(
        () => _repository.createTransaction(transaction: transaction));
  }

  Future<List<Transaction>> getTransactions({
    required String userId,
    bool syncWithRemote = true,
    int limit = 100,
  }) =>
      _repository.getTransactions(
          userId: userId, syncWithRemote: syncWithRemote, limit: limit);

  Future<void> deleteTransaction({
    required String transactionId,
  }) async {
    final userId = _userId();
    if (userId == null) return;
    await _execute(() => _delete(userId: userId, transactionId: transactionId));
  }

  Future<List<Transaction>> getTransactionsByRange({
    required String userId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    bool syncWithRemote = true,
    int limit = 100,
  }) =>
      _repository.getTransactionsByRange(
          userId: userId,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          syncWithRemote: syncWithRemote,
          limit: limit);
}
