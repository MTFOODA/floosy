import '../entities/salary_plan.dart';

abstract interface class SalaryPlanRepository {
  Future<SalaryPlan?> getPlan(
    String userId, {
    required String cardId,
    bool migrateLegacy = true,
  });

  Future<void> configure(
    String userId, {
    required int monthlySalaryMinor,
    required int cycleStartDay,
    required int startingBalanceMinor,
    required String cardId,
    required String cardLast4,
    String? bankName,
    bool autoDetectSalary = true,
    DateTime? effectiveFrom,
  });

  Future<SalaryCycleSummary> summaryFor(
    String userId, {
    required String cardId,
    DateTime? reference,
  });
}
