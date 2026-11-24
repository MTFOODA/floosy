import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/salary_plan.dart';
import '../../../../domain/repositories/salary_plan_repository.dart';

class SalaryPlanCubit extends AsyncCubit<SalaryCycleSummary> {
  final SalaryPlanRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;

  SalaryPlanCubit(this._repository, this._userId, this._onChanged);

  Future<void> reload({DateTime? reference}) {
    final userId = _userId();
    if (userId == null) {
      clear(empty());
      return Future.value();
    }
    return load(() => _repository.summaryFor(userId, reference: reference));
  }

  Future<void> configure({
    required int monthlySalaryMinor,
    required int cycleStartDay,
    required int startingBalanceMinor,
    bool autoDetectSalary = true,
  }) async {
    final userId = _userId();
    if (userId == null) throw StateError('Sign in first');
    await _repository.configure(
      userId,
      monthlySalaryMinor: monthlySalaryMinor,
      cycleStartDay: cycleStartDay,
      startingBalanceMinor: startingBalanceMinor,
      autoDetectSalary: autoDetectSalary,
    );
    await reload();
    _onChanged();
  }

  static SalaryCycleSummary empty() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return SalaryCycleSummary(
      plan: null,
      start: start,
      endExclusive: DateTime(now.year, now.month + 1, 1),
    );
  }
}
