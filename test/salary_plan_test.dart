import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/domain/entities/salary_plan.dart';

void main() {
  final plan = SalaryPlan(
    monthlySalaryMinor: 1000000,
    cycleStartDay: 25,
    startingBalanceMinor: 1250000,
    autoDetectSalary: true,
    effectiveFrom: DateTime(2026, 11, 25),
  );

  test('salary allocation does not charge an ATM withdrawal twice', () {
    final summary = SalaryCycleSummary(
      plan: plan,
      start: DateTime(2026, 11, 25),
      endExclusive: DateTime(2026, 12, 25),
      purchaseMinor: 200000,
      withdrawalMinor: 300000,
      transferMinor: 100000,
      cashExpenseMinor: 180000,
    );

    expect(summary.allocatedSpendMinor, 600000);
    expect(summary.remainingMinor, 400000);
    expect(summary.totalActivityMinor, 780000);
  });

  test('salary keyword recognition supports Arabic and English evidence', () {
    expect(isSalaryTransactionText('PAYROLL CREDIT'), isTrue);
    expect(isSalaryTransactionText('تم إيداع راتب نوفمبر'), isTrue);
    expect(isSalaryTransactionText('عرض خصم على المشتريات'), isFalse);
  });

  test('plan round trip keeps the private budgeting settings', () {
    final restored = SalaryPlan.fromJson(plan.toJson('active'));
    expect(restored.monthlySalaryMinor, plan.monthlySalaryMinor);
    expect(restored.cycleStartDay, 25);
    expect(restored.startingBalanceMinor, 1250000);
    expect(restored.autoDetectSalary, isTrue);
  });
}
