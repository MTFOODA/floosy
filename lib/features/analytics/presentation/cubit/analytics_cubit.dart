import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../../domain/repositories/transaction_repository.dart';

class AnalyticsCubit extends AsyncCubit<List<Transaction>> {
  final TransactionRepository _repository;
  final String? Function() _userId;
  AnalyticsCubit(this._repository, this._userId);
  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(const []);
      return Future.value();
    }
    return load(() => _repository.getTransactions(userId: userId, limit: 500));
  }
}
