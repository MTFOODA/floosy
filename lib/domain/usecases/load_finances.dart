import '../entities/detected_card_model.dart';
import '../entities/money_model.dart';
import '../entities/transaction_model.dart';
import '../repositories/money_repository.dart';
import '../services/card_balance_calculator.dart';
import '../services/card_ownership.dart';

class FinanceSnapshot {
  final DetectedCard? card;
  final MoneySummary summary;
  final MoneySummary globalSummary;
  final CardBalance balance;
  final bool canAddBalance;
  final bool pocketCashVisible;
  final List<Transaction> unassigned;
  final List<MonthlyIncome> monthlyIncomes;
  const FinanceSnapshot(
      {this.card,
      required this.summary,
      required this.globalSummary,
      this.balance = CardBalance.zero,
      this.canAddBalance = false,
      this.pocketCashVisible = true,
      this.unassigned = const [],
      this.monthlyIncomes = const []});
  factory FinanceSnapshot.empty() => FinanceSnapshot(
      summary: MoneySummary.zero(), globalSummary: MoneySummary.zero());

  FinanceSnapshot withCard(DetectedCard? value) => FinanceSnapshot(
      card: value,
      summary: summary,
      globalSummary: globalSummary,
      balance: balance,
      canAddBalance: canAddBalance,
      pocketCashVisible: pocketCashVisible,
      unassigned: List.unmodifiable(unassigned),
      monthlyIncomes: monthlyIncomes);
}

/// Resolves an unambiguous bank + last4 before any balance is requested.
class LoadFinances {
  final MoneyRepository _money;
  const LoadFinances(this._money);
  Future<FinanceSnapshot> call(
      {required String userId,
      required List<DetectedCard> cards,
      required String? last4,
      required String? bankName,
      DateTime? now}) async {
    final bank = normalizeBankIdentity(bankName);
    final matches = cards
        .where((c) =>
            c.last4 == last4 &&
            (bank == null || normalizeBankIdentity(c.bankName) == bank))
        .toList();
    final card = matches.length == 1 ? matches.single : null;
    final date = now ?? DateTime.now();
    final global = await _money.getMoneySummary(userId);
    final unassigned = await _money.getUnassignedTransactions(userId);
    final incomes = await _money.getMonthlyIncomes(userId,
        year: date.year, month: date.month);
    if (card == null) {
      return FinanceSnapshot(
          summary: MoneySummary.zero(),
          globalSummary: global,
          unassigned: List.unmodifiable(unassigned),
          monthlyIncomes: List.unmodifiable(incomes));
    }
    final balance = await _money.getCardBalance(userId, card.last4,
        bankName: card.bankName);
    final income =
        await _money.getMonthlyIncomeSum(userId, date.year, date.month);
    return FinanceSnapshot(
        card: card,
        globalSummary: global,
        balance: balance,
        summary: MoneySummary(
            myBalanceMinor: balance.myBalanceMinor,
            deductedMinor: balance.deductedMinor,
            pocketCashMinor: balance.pocketCashMinor,
            monthlyIncomeMinor: income),
        canAddBalance: await _money.canAddBalanceForCard(userId, card.last4,
            bankName: card.bankName),
        pocketCashVisible: await _money.isPocketCashVisibleForCard(
            userId, card.last4,
            bankName: card.bankName),
        unassigned: List.unmodifiable(unassigned),
        monthlyIncomes: List.unmodifiable(incomes));
  }
}
