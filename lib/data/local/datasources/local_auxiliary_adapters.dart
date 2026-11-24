import 'package:uuid/uuid.dart';
import '../../../domain/entities/item_model.dart';
import '../../../domain/entities/budget_model.dart';
import '../../../domain/entities/analytics_model.dart';
import '../../../domain/entities/transaction_model.dart';
import '../../../domain/entities/ai_model.dart';
import '../../remote/datasources/category_remote_datasource.dart';
import '../../remote/datasources/budget_remote_datasource.dart';
import '../../remote/datasources/recurring_expense_remote_datasource.dart';
import '../../remote/datasources/analytics_remote_datasource.dart';
import '../../remote/datasources/ai_remote_datasource.dart';
import 'private_record_store.dart';
import 'expense_local_datasource.dart';
import 'transaction_local_datasource.dart';
import 'money_local_datasource.dart';

class LocalCategoryAdapter extends CategoryRemoteDataSource {
  final PrivateRecordStore store;
  LocalCategoryAdapter(super.client, this.store);
  @override
  Future<List<Category>> getSystemCategories() async => (await store.list(
    'categories',
  )).map(Category.fromJson).where((c) => c.isSystem).toList();
  @override
  Future<List<Category>> getUserCategories(String userId) async =>
      (await store.list(
        'categories',
        userId: userId,
      )).map(Category.fromJson).toList();
  @override
  Future<Category?> getCategory(String categoryId) async {
    final r = await store.get('categories', categoryId);
    return r == null ? null : Category.fromJson(r);
  }

  @override
  Future<Category> createCategory(Category category) async =>
      Category.fromJson(await store.put('categories', category.toJson()));
  @override
  Future<Category> updateCategory(Category category) async {
    final old = await getCategory(category.id);
    if (old == null || old.isSystem) {
      throw StateError('Category cannot be edited');
    }
    return createCategory(category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final c = await getCategory(categoryId);
    if (c?.isSystem == true) throw StateError('System category');
    await store.delete('categories', categoryId);
  }

  @override
  Future<List<Category>> getSubcategories(String parentId) async =>
      (await getUserCategories(
        store.owner,
      )).where((c) => c.parentId == parentId).toList();
}

class LocalBudgetAdapter extends BudgetRemoteDataSource {
  final PrivateRecordStore store;
  LocalBudgetAdapter(super.client, this.store);
  @override
  Future<List<Budget>> getBudgets(String userId) async => (await store.list(
    'budgets',
    userId: userId,
  )).map(Budget.fromJson).toList();
  @override
  Future<Budget?> getBudget(String budgetId) async {
    final r = await store.get('budgets', budgetId);
    return r == null ? null : Budget.fromJson(r);
  }

  @override
  Future<Budget> createBudget(Budget budget) async =>
      Budget.fromJson(await store.put('budgets', budget.toJson()));
  @override
  Future<Budget> updateBudget(Budget budget) async {
    if (await getBudget(budget.id) == null) {
      throw StateError('Budget not found');
    }
    return createBudget(budget);
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    await store.delete('budgets', budgetId);
    for (final c in await getBudgetCategories(budgetId)) {
      await store.delete('budget_categories', c.id);
    }
  }

  @override
  Future<BudgetCategory> setBudgetCategory(
    String budgetId,
    String categoryId,
    int limitMinor,
  ) async {
    if (await getBudget(budgetId) == null) throw StateError('Budget not found');
    final old = (await getBudgetCategories(
      budgetId,
    )).where((r) => r.categoryId == categoryId).firstOrNull;
    return BudgetCategory.fromJson(
      await store.put('budget_categories', {
        'id': old?.id ?? const Uuid().v4(),
        'budget_id': budgetId,
        'category_id': categoryId,
        'limit_minor': limitMinor,
      }),
    );
  }

  @override
  Future<List<BudgetCategory>> getBudgetCategories(String budgetId) async =>
      (await store.list('budget_categories'))
          .where((r) => r['budget_id'] == budgetId)
          .map(BudgetCategory.fromJson)
          .toList();
  @override
  Future<void> removeBudgetCategory(String budgetId, String categoryId) async {
    for (final c in await getBudgetCategories(budgetId)) {
      if (c.categoryId == categoryId) {
        await store.delete('budget_categories', c.id);
      }
    }
  }

  @override
  Future<Map<String, int>> getCurrentSpending(String budgetId) async {
    final budget = await getBudget(budgetId);
    if (budget == null) return {};
    final expenses = await ExpenseLocalDataSource(
      store.database,
    ).getExpenses(store.owner);
    final result = <String, int>{};
    for (final e in expenses) {
      if (e.categoryId != null &&
          !e.expenseDate.isBefore(budget.startDate) &&
          !e.expenseDate.isAfter(budget.endDate)) {
        result[e.categoryId!] = (result[e.categoryId!] ?? 0) + e.amountMinor;
      }
    }
    return result;
  }
}

class LocalRecurringAdapter extends RecurringExpenseRemoteDataSource {
  final PrivateRecordStore store;
  LocalRecurringAdapter(super.client, this.store);
  @override
  Future<List<RecurringExpense>> getRecurringExpenses(String userId) async =>
      (await store.list(
        'recurring_expenses',
        userId: userId,
      )).map(RecurringExpense.fromJson).toList();
  @override
  Future<RecurringExpense?> getRecurringExpense(String expenseId) async {
    final r = await store.get('recurring_expenses', expenseId);
    return r == null ? null : RecurringExpense.fromJson(r);
  }

  @override
  Future<RecurringExpense> createRecurringExpense(
    RecurringExpense expense,
  ) async => RecurringExpense.fromJson(
    await store.put('recurring_expenses', expense.toJson()),
  );
  @override
  Future<RecurringExpense> updateRecurringExpense(
    RecurringExpense expense,
  ) async {
    if (await getRecurringExpense(expense.id) == null) {
      throw StateError('Record not found');
    }
    return createRecurringExpense(expense);
  }

  @override
  Future<void> deleteRecurringExpense(String expenseId) async {
    await store.delete('recurring_expenses', expenseId);
  }

  @override
  Future<List<RecurringExpenseOccurrence>> getOccurrences(
    String recurringExpenseId,
  ) async => (await store.list('recurring_expense_occurrences'))
      .where((r) => r['recurring_expense_id'] == recurringExpenseId)
      .map(RecurringExpenseOccurrence.fromJson)
      .toList();
  @override
  Future<void> markOccurrenceAsPaid(
    String occurrenceId,
    String? transactionId,
  ) async {
    await store.patch('recurring_expense_occurrences', occurrenceId, {
      'status': 'paid',
      'transaction_id': transactionId,
    });
  }
}

class LocalAnalyticsAdapter extends AnalyticsRemoteDataSource {
  final PrivateRecordStore store;
  LocalAnalyticsAdapter(super.client, this.store);
  @override
  Future<MonthlyReport?> getMonthlyReport({
    required String userId,
    required int year,
    required int month,
  }) async {
    if (userId != store.owner) throw StateError('Account changed');
    final rows =
        (await TransactionLocalDataSource(
          store.database,
        ).getTransactionsByUserId(userId)).where(
          (t) =>
              t.status == TransactionStatus.confirmed &&
              t.transactionDate.year == year &&
              t.transactionDate.month == month,
        );
    var income = 0, expense = 0, card = 0, cash = 0, atm = 0;
    for (final t in rows) {
      if (t.type.isIncoming) income += t.amountMinor;
      if (t.type == TransactionType.atm_withdrawal) {
        atm += t.amountMinor;
        continue;
      }
      if (t.type.isOutgoing) {
        expense += t.amountMinor;
        if (t.type == TransactionType.cash_expense) {
          cash += t.amountMinor;
        } else {
          card += t.amountMinor;
        }
      }
    }
    return MonthlyReport(
      id: 'local-$year-$month',
      userId: userId,
      year: year,
      month: month,
      totalIncomeMinor: income,
      totalExpensesMinor: expense,
      cardExpensesMinor: card,
      cashExpensesMinor: cash,
      atmWithdrawalsMinor: atm,
    );
  }

  @override
  Future<List<MonthlyReport>> getMonthlyReports(String userId) async {
    final rows = await TransactionLocalDataSource(
      store.database,
    ).getTransactionsByUserId(userId);
    final months =
        rows
            .map((t) => (t.transactionDate.year, t.transactionDate.month))
            .toSet()
            .toList()
          ..sort(
            (a, b) =>
                b.$1 == a.$1 ? b.$2.compareTo(a.$2) : b.$1.compareTo(a.$1),
          );
    return [
      for (final date in months)
        (await getMonthlyReport(
          userId: userId,
          year: date.$1,
          month: date.$2,
        ))!,
    ];
  }

  @override
  Future<List<MonthlyItemStatistic>> getItemStatistics({
    required String userId,
    required int year,
    required int month,
  }) async {
    if (userId != store.owner) throw StateError('Account changed');
    final usages = await MoneyLocalDataSource(
      store.database,
    ).getItemUsages(userId, year: year, month: month);
    final totals = <String, (int, int, int)>{};
    for (final row in usages) {
      final old = totals[row.itemId] ?? (0, 0, 0);
      totals[row.itemId] = (
        old.$1 + row.quantity,
        old.$2 + row.totalAmountMinor,
        old.$3 + 1,
      );
    }
    return [
      for (final entry in totals.entries)
        MonthlyItemStatistic(
          id: 'local-${entry.key}-$year-$month',
          userId: userId,
          itemId: entry.key,
          year: year,
          month: month,
          quantity: entry.value.$1,
          totalSpendingMinor: entry.value.$2,
          purchaseEvents: entry.value.$3,
          averagePriceMinor: entry.value.$1 == 0
              ? 0
              : entry.value.$2 ~/ entry.value.$1,
        ),
    ];
  }

  @override
  Future<List<SavingRecommendation>> getSavingRecommendations(
    String userId,
  ) async => (await store.list('saving_recommendations', userId: userId))
      .map(SavingRecommendation.fromJson)
      .where((r) => r.status == RecommendationStatus.active)
      .toList();
  @override
  Future<List<SavingGoal>> getSavingGoals(String userId) async =>
      (await store.list(
        'saving_goals',
        userId: userId,
      )).map(SavingGoal.fromJson).toList();
  @override
  Future<SavingGoal> createSavingGoal(SavingGoal goal) async =>
      SavingGoal.fromJson(await store.put('saving_goals', goal.toJson()));
  @override
  Future<List<Alert>> getAlerts(String userId) async =>
      (await store.list('alerts', userId: userId)).map(Alert.fromJson).toList();
  @override
  Future<void> markAlertAsRead(String alertId) async {
    await store.patch('alerts', alertId, {'is_read': true});
  }

  @override
  Future<Alert> createAlert(Alert alert) async =>
      Alert.fromJson(await store.put('alerts', alert.toJson()));
}

class LocalAiAdapter extends AIRemoteDataSource {
  final PrivateRecordStore store;
  final LocalAnalyticsAdapter analytics;
  LocalAiAdapter(super.client, this.store)
    : analytics = LocalAnalyticsAdapter(client, store);
  @override
  Future<List<AIConversation>> getConversations(String userId) async =>
      (await store.list(
        'ai_conversations',
        userId: userId,
      )).map(AIConversation.fromJson).toList();
  @override
  Future<AIConversation?> getConversation(String conversationId) async {
    final r = await store.get('ai_conversations', conversationId);
    return r == null ? null : AIConversation.fromJson(r);
  }

  @override
  Future<AIConversation> createConversation(
    AIConversation conversation,
  ) async => AIConversation.fromJson(
    await store.put('ai_conversations', conversation.toJson()),
  );
  @override
  Future<void> deleteConversation(String conversationId) async {
    await store.delete('ai_conversations', conversationId);
    for (final m in await getMessages(conversationId)) {
      await store.delete('ai_messages', m.id);
    }
  }

  @override
  Future<List<AIMessage>> getMessages(String conversationId) async =>
      (await store.list('ai_messages'))
          .where((r) => r['conversation_id'] == conversationId)
          .map(AIMessage.fromJson)
          .toList();
  @override
  Future<AIMessage> addMessage(AIMessage message) async =>
      AIMessage.fromJson(await store.put('ai_messages', message.toJson()));
  @override
  Future<List<AIAction>> getPendingActions(String userId) async =>
      (await store.list('ai_actions', userId: userId))
          .map(AIAction.fromJson)
          .where((r) => r.status == AIActionStatus.pending_confirmation)
          .toList();
  @override
  Future<AIAction?> getAction(String actionId) async {
    final r = await store.get('ai_actions', actionId);
    return r == null ? null : AIAction.fromJson(r);
  }

  @override
  Future<AIAction> createAction(AIAction action) async =>
      AIAction.fromJson(await store.put('ai_actions', action.toJson()));
  @override
  Future<AIAction> updateActionStatus(
    String actionId,
    AIActionStatus status,
  ) async => AIAction.fromJson(
    await store.patch('ai_actions', actionId, {
      'status': status.name,
      if (status == AIActionStatus.confirmed)
        'confirmed_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
  @override
  Future<AIAction> completeAction(
    String actionId,
    Map<String, dynamic> result,
  ) async => AIAction.fromJson(
    await store.patch('ai_actions', actionId, {
      'status': 'completed',
      'result': result,
      'completed_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
  @override
  Future<AIAction> failAction(String actionId, String errorMessage) async =>
      AIAction.fromJson(
        await store.patch('ai_actions', actionId, {
          'status': 'failed',
          'result': {'error': errorMessage},
        }),
      );
  @override
  Future<Map<String, dynamic>> getFinancialSummary(String userId) async {
    final now = DateTime.now();
    final report = (await analytics.getMonthlyReport(
      userId: userId,
      year: now.year,
      month: now.month,
    ))!;
    return {
      'month': now.month,
      'year': now.year,
      'total_expenses_minor': report.totalExpensesMinor,
      'card_expenses_minor': report.cardExpensesMinor,
      'cash_expenses_minor': report.cashExpensesMinor,
      'cash_balance_minor': await MoneyLocalDataSource(
        store.database,
      ).getCashBalance(userId),
    };
  }

  @override
  Future<List<String>> getRecommendations(String userId) async {
    final now = DateTime.now();
    final recommendations = await store.list(
      'saving_recommendations',
      userId: userId,
    );
    return recommendations
        .where((r) => r['year'] == now.year && r['month'] == now.month)
        .map(
          (r) =>
              'Potential saving: ${r['estimated_saving_minor']} minor units.',
        )
        .toList();
  }
}
