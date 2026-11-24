import 'transaction_model.dart';

/// Encrypted on-device income configuration. Its configured opening value is
/// applied to the selected debit-card baseline; later movements remain in the
/// single existing ledger and are never duplicated here.
class SalaryPlan {
  /// The one debit card this income plan belongs to. Salary never leaks to a
  /// second card just because both cards belong to the same user.
  final String? cardId;
  final String? cardLast4;
  final String? bankName;
  final int monthlySalaryMinor;
  final int cycleStartDay;
  final int startingBalanceMinor;
  final bool autoDetectSalary;
  final DateTime effectiveFrom;

  const SalaryPlan({
    this.cardId,
    this.cardLast4,
    this.bankName,
    required this.monthlySalaryMinor,
    required this.cycleStartDay,
    required this.startingBalanceMinor,
    required this.autoDetectSalary,
    required this.effectiveFrom,
  });

  Map<String, dynamic> toJson(String id) => {
    'id': id,
    'card_id': cardId,
    'card_last4': cardLast4,
    'bank_name': bankName,
    'monthly_salary_minor': monthlySalaryMinor,
    'cycle_start_day': cycleStartDay,
    'starting_balance_minor': startingBalanceMinor,
    'auto_detect_salary': autoDetectSalary,
    'effective_from': effectiveFrom.toUtc().toIso8601String(),
  };

  factory SalaryPlan.fromJson(Map<String, dynamic> json) => SalaryPlan(
    cardId: json['card_id'] as String?,
    cardLast4: json['card_last4'] as String?,
    bankName: json['bank_name'] as String?,
    monthlySalaryMinor: (json['monthly_salary_minor'] as num?)?.toInt() ?? 0,
    cycleStartDay: ((json['cycle_start_day'] as num?)?.toInt() ?? 1)
        .clamp(1, 31)
        .toInt(),
    startingBalanceMinor:
        (json['starting_balance_minor'] as num?)?.toInt() ?? 0,
    autoDetectSalary: json['auto_detect_salary'] != false,
    effectiveFrom:
        DateTime.tryParse(
          json['effective_from']?.toString() ?? '',
        )?.toLocal() ??
        DateTime.now(),
  );
}

/// Auditable numbers used by the home salary card and the local advisor.
class SalaryCycleSummary {
  final SalaryPlan? plan;
  final DateTime start;
  final DateTime endExclusive;
  final int purchaseCount;
  final int purchaseMinor;
  final int withdrawalCount;
  final int withdrawalMinor;
  final int transferCount;
  final int transferMinor;
  final int cashExpenseCount;
  final int cashExpenseMinor;
  final int salaryMessageCount;
  final int salaryMessageMinor;
  final int trackedItemCount;

  const SalaryCycleSummary({
    required this.plan,
    required this.start,
    required this.endExclusive,
    this.purchaseCount = 0,
    this.purchaseMinor = 0,
    this.withdrawalCount = 0,
    this.withdrawalMinor = 0,
    this.transferCount = 0,
    this.transferMinor = 0,
    this.cashExpenseCount = 0,
    this.cashExpenseMinor = 0,
    this.salaryMessageCount = 0,
    this.salaryMessageMinor = 0,
    this.trackedItemCount = 0,
  });

  int get salaryMinor => plan?.monthlySalaryMinor ?? 0;

  /// A withdrawal consumes salary allocation once. Cash expenses are kept
  /// separate because they spend pocket cash created by that withdrawal.
  int get allocatedSpendMinor =>
      purchaseMinor + withdrawalMinor + transferMinor;
  int get remainingMinor =>
      (salaryMinor - allocatedSpendMinor).clamp(0, salaryMinor).toInt();
  int get totalActivityMinor =>
      purchaseMinor + withdrawalMinor + transferMinor + cashExpenseMinor;
  int get transactionCount =>
      purchaseCount + withdrawalCount + transferCount + cashExpenseCount;
  double get withdrawalRatio =>
      salaryMinor == 0 ? 0 : withdrawalMinor / salaryMinor;
  bool get hasSalaryEvidence => salaryMessageCount > 0;
  bool get isConfigured => plan != null && salaryMinor > 0;
}

bool isSalaryTransactionText(String? value) {
  final text = (value ?? '').toLowerCase();
  return RegExp(
    r'(?:(?:\bsalary\b|\bpayroll\b|\bwage\b)|\u0631\u0627\u062a\u0628|\u0645\u0631\u062a\u0628|\u0623\u062c\u0631|\u0627\u062c\u0648\u0631)',
  ).hasMatch(text);
}

bool isConfirmedOutgoing(Transaction transaction) =>
    transaction.status == TransactionStatus.confirmed &&
    transaction.type.isOutgoing;
