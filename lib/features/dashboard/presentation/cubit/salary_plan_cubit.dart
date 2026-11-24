import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/salary_plan.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../domain/repositories/salary_plan_repository.dart';

class SalaryPlanCubit extends AsyncCubit<SalaryCycleSummary> {
  final SalaryPlanRepository _repository;
  final String? Function() _userId;
  final DetectedCard? Function() _selectedCard;
  final void Function() _onChanged;

  SalaryPlanCubit(
    this._repository,
    this._userId,
    this._selectedCard,
    this._onChanged,
  );

  Future<void> reload({DateTime? reference}) {
    final userId = _userId();
    if (userId == null) {
      clear(empty());
      return Future.value();
    }
    final card = _selectedCard();
    if (card == null || card.isCreditCard) {
      clear(empty());
      return Future.value();
    }
    return load(
      () => _repository.summaryFor(
        userId,
        cardId: card.id,
        reference: reference,
      ),
    );
  }

  Future<void> configure({
    required int monthlySalaryMinor,
    required int cycleStartDay,
    required int startingBalanceMinor,
    bool autoDetectSalary = true,
  }) async {
    final userId = _userId();
    if (userId == null) throw StateError('Sign in first');
    final card = _selectedCard();
    if (card == null || card.isCreditCard) {
      throw StateError('Salary plans require a debit card');
    }
    await _repository.configure(
      userId,
      monthlySalaryMinor: monthlySalaryMinor,
      cycleStartDay: cycleStartDay,
      startingBalanceMinor: startingBalanceMinor,
      cardId: card.id,
      cardLast4: card.last4,
      bankName: card.bankName,
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
