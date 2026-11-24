import '../../domain/entities/salary_plan.dart';
import '../../domain/entities/transaction_model.dart';
import '../../domain/repositories/salary_plan_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../local/datasources/private_record_store.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../local/datasources/money_local_datasource.dart';

/// Encrypted, device-local salary-cycle analytics. The selected account balance
/// remains derived from the existing ledger; this repository groups that same
/// movement history by the user's payroll cycle.
class LocalSalaryPlanRepository implements SalaryPlanRepository {
  static const _activeKind = 'salary_plan';
  static const _historyKind = 'salary_plan_history';
  static const _activeId = 'active';

  final PrivateRecordStore _records;
  final TransactionRepository _transactions;
  final SmsMessageLocalDataSource _messages;
  final MoneyLocalDataSource _money;

  LocalSalaryPlanRepository(
    this._records,
    this._transactions,
    this._messages,
    this._money,
  );

  @override
  Future<SalaryPlan?> getPlan(String userId) async {
    final value = await _records.get(_activeKind, _activeId);
    return value == null ? null : SalaryPlan.fromJson(value);
  }

  @override
  Future<void> configure(
    String userId, {
    required int monthlySalaryMinor,
    required int cycleStartDay,
    required int startingBalanceMinor,
    bool autoDetectSalary = true,
    DateTime? effectiveFrom,
  }) async {
    if (monthlySalaryMinor <= 0) {
      throw ArgumentError.value(monthlySalaryMinor, 'monthlySalaryMinor');
    }
    final safeDay = cycleStartDay.clamp(1, 31).toInt();
    final base = effectiveFrom ?? _cycleStart(DateTime.now(), safeDay);
    final plan = SalaryPlan(
      monthlySalaryMinor: monthlySalaryMinor,
      cycleStartDay: safeDay,
      startingBalanceMinor: startingBalanceMinor < 0 ? 0 : startingBalanceMinor,
      autoDetectSalary: autoDetectSalary,
      effectiveFrom: base,
    );
    final historyId = 'plan-${base.toUtc().millisecondsSinceEpoch}';
    await _records.put(_historyKind, plan.toJson(historyId));
    await _records.put(_activeKind, plan.toJson(_activeId));
  }

  @override
  Future<SalaryCycleSummary> summaryFor(
    String userId, {
    DateTime? reference,
  }) async {
    final at = reference ?? DateTime.now();
    final active = await getPlan(userId);
    final configuredStart = active == null
        ? null
        : _cycleStart(at, active.cycleStartDay);
    final plan = configuredStart == null
        ? null
        : await _planForCycle(userId, configuredStart, active!);
    // Months before the user first configured a plan keep their transaction
    // evidence, but are not retroactively assigned today's salary settings.
    final start = plan == null
        ? DateTime(at.year, at.month, 1)
        : _cycleStart(at, plan.cycleStartDay);
    final end = plan == null
        ? DateTime(start.year, start.month + 1, 1)
        : _nextCycleStart(start, plan.cycleStartDay);
    final transactions = await _transactions.getTransactionsByRange(
      userId: userId,
      startDateTime: start,
      endDateTime: end.subtract(const Duration(microseconds: 1)),
      syncWithRemote: false,
      limit: 10000,
    );
    final linked = plan?.autoDetectSalary == true
        ? await _messages.linkedMessages(userId)
        : const [];
    final salaryTransactionIds = {
      for (final message in linked)
        if (message.transactionId != null &&
            message.receivedAt.compareTo(start) >= 0 &&
            message.receivedAt.compareTo(end) < 0 &&
            isSalaryTransactionText(message.messageBody))
          message.transactionId!,
    };
    var trackedItems = 0;
    for (
      var cursor = DateTime(start.year, start.month, 1);
      cursor.isBefore(end);
      cursor = DateTime(cursor.year, cursor.month + 1, 1)
    ) {
      final usages = await _money.getItemUsages(
        userId,
        year: cursor.year,
        month: cursor.month,
      );
      trackedItems += usages
          .where(
            (usage) =>
                !usage.usageDate.isBefore(start) &&
                usage.usageDate.isBefore(end),
          )
          .fold<int>(0, (sum, usage) => sum + usage.quantity);
    }
    var purchases = 0, purchaseMinor = 0;
    var withdrawals = 0, withdrawalMinor = 0;
    var transfers = 0, transferMinor = 0;
    var cashExpenses = 0, cashExpenseMinor = 0;
    var salaryMessages = 0, salaryMessageMinor = 0;
    for (final transaction in transactions) {
      if (transaction.status != TransactionStatus.confirmed) continue;
      if (transaction.type == TransactionType.income &&
          (salaryTransactionIds.contains(transaction.id) ||
              isSalaryTransactionText(transaction.merchantName) ||
              isSalaryTransactionText(transaction.notes))) {
        salaryMessages++;
        salaryMessageMinor += transaction.amountMinor;
      }
      if (!isConfirmedOutgoing(transaction)) continue;
      switch (transaction.type) {
        case TransactionType.purchase:
          purchases++;
          purchaseMinor += transaction.amountMinor;
        case TransactionType.atm_withdrawal:
          withdrawals++;
          withdrawalMinor += transaction.amountMinor;
        case TransactionType.transfer_out:
          transfers++;
          transferMinor += transaction.amountMinor;
        case TransactionType.cash_expense:
          cashExpenses++;
          cashExpenseMinor += transaction.amountMinor;
        default:
          break;
      }
    }
    return SalaryCycleSummary(
      plan: plan,
      start: start,
      endExclusive: end,
      purchaseCount: purchases,
      purchaseMinor: purchaseMinor,
      withdrawalCount: withdrawals,
      withdrawalMinor: withdrawalMinor,
      transferCount: transfers,
      transferMinor: transferMinor,
      cashExpenseCount: cashExpenses,
      cashExpenseMinor: cashExpenseMinor,
      salaryMessageCount: salaryMessages,
      salaryMessageMinor: salaryMessageMinor,
      trackedItemCount: trackedItems,
    );
  }

  Future<SalaryPlan?> _planForCycle(
    String userId,
    DateTime cycleStart,
    SalaryPlan active,
  ) async {
    final history = await _records.list(_historyKind, userId: userId);
    final candidates =
        history
            .map(SalaryPlan.fromJson)
            .where((plan) => !plan.effectiveFrom.isAfter(cycleStart))
            .toList()
          ..sort((a, b) => b.effectiveFrom.compareTo(a.effectiveFrom));
    if (candidates.isNotEmpty) return candidates.first;
    return active.effectiveFrom.isAfter(cycleStart) ? null : active;
  }

  static DateTime _cycleStart(DateTime value, int requestedDay) {
    final day = _clampedDay(value.year, value.month, requestedDay);
    final thisMonth = DateTime(value.year, value.month, day);
    if (value.compareTo(thisMonth) >= 0) return thisMonth;
    final previousMonth = DateTime(value.year, value.month - 1, 1);
    return DateTime(
      previousMonth.year,
      previousMonth.month,
      _clampedDay(previousMonth.year, previousMonth.month, requestedDay),
    );
  }

  static DateTime _nextCycleStart(DateTime start, int requestedDay) {
    final next = DateTime(start.year, start.month + 1, 1);
    return DateTime(
      next.year,
      next.month,
      _clampedDay(next.year, next.month, requestedDay),
    );
  }

  static int _clampedDay(int year, int month, int requested) =>
      requested.clamp(1, DateTime(year, month + 1, 0).day).toInt();
}
