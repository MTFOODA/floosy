import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/budget_model.dart';
import '../../../../domain/entities/budget_with_spending.dart';
import '../../../../domain/usecases/load_budgets.dart';
import '../../../../domain/repositories/budget_repository.dart';

class BudgetsCubit extends AsyncCubit<List<BudgetWithSpending>> {
  final BudgetRepository _repository;
  final String? Function() _userId;
  late final LoadBudgets _loadBudgets = LoadBudgets(_repository);
  BudgetsCubit(this._repository, this._userId);
  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(const []);
      return Future.value();
    }
    return load(() => _loadBudgets(userId));
  }

  Future<List<Budget>> getActiveBudgets(String userId) =>
      _repository.getActiveBudgets(userId);
}
