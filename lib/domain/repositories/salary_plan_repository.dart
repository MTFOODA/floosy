import '../entities/salary_plan.dart';

abstract interface class SalaryPlanRepository {
  Future<SalaryPlan?> getPlan(String userId);

  Future<void> configure(
    String userId, {
    required int monthlySalaryMinor,
    required int cycleStartDay,
    required int startingBalanceMinor,
    bool autoDetectSalary = true,
    DateTime? effectiveFrom,
  });

  Future<SalaryCycleSummary> summaryFor(String userId, {DateTime? reference});
}
