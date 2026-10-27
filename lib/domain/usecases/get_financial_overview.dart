import '../entities/money_model.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/money_repository.dart';
import '../repositories/item_repository.dart';
import '../repositories/budget_repository.dart';

class FinancialOverview {
  final MoneySummary summary;
  final int transactionCount;
  final int largestTransactionMinor;
  final int itemCount;
  final int budgetCount;
  const FinancialOverview(
      {required this.summary,
      required this.transactionCount,
      required this.largestTransactionMinor,
      required this.itemCount,
      required this.budgetCount});
}

/// Supplies facts from the user's ledger; presentation composes the response.
class GetFinancialOverview {
  final TransactionRepository transactions;
  final MoneyRepository money;
  final ItemRepository items;
  final BudgetRepository budgets;
  const GetFinancialOverview(
      {required this.transactions,
      required this.money,
      required this.items,
      required this.budgets});
  Future<FinancialOverview> call(String userId) async {
    final rows = await transactions.getTransactions(userId: userId, limit: 200);
    return FinancialOverview(
        summary: await money.getMoneySummary(userId),
        transactionCount: rows.length,
        largestTransactionMinor: rows.fold(
            0, (max, row) => row.amountMinor > max ? row.amountMinor : max),
        itemCount: (await items.getActiveItems(userId)).length,
        budgetCount: (await budgets.getActiveBudgets(userId)).length);
  }
}
