import 'package:uuid/uuid.dart';
import '../domain/usecases/create_manual_transaction.dart';
import '../domain/usecases/delete_transaction.dart';
import '../domain/usecases/get_financial_overview.dart';
import '../features/ai/presentation/cubit/ai_chat_cubit.dart';
import '../domain/usecases/save_transaction_edit.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization/preferences_cubit.dart';
import '../core/services/app_lock_cubit.dart';
import '../core/state/bank_catalog_cubit.dart';
import '../core/state/refresh_cubit.dart';
import '../domain/usecases/load_finances.dart';
import '../domain/usecases/load_items.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/dashboard/presentation/cubit/finance_cubit.dart';
import '../features/items/presentation/cubit/items_cubit.dart';
import '../features/settings/presentation/cubit/cards_cubit.dart';
import '../features/settings/presentation/cubit/profile_cubit.dart';
import '../features/settings/presentation/cubit/bank_mappings_cubit.dart';
import '../features/budgets/presentation/cubit/budgets_cubit.dart';
import '../features/analytics/presentation/cubit/analytics_cubit.dart';
import '../features/pocket_cash/presentation/cubit/pocket_cash_cubit.dart';
import '../features/transactions/presentation/cubit/transaction_commands_cubit.dart';
import '../features/transactions/presentation/cubit/sms_cubit.dart';
import '../features/transactions/presentation/state/transaction_display_filter.dart';
import 'app_repositories.dart';

/// Owns app-lifetime Cubits and coordinates account/data changes outside widgets.
/// No Cubit subscribes to another Cubit.
class AppRuntime {
  final AppRepositories repositories;
  late final auth = AuthCubit(repositories.auth);
  late final locale = LocaleCubit(repositories.preferences);
  late final theme = ThemeModeCubit(repositories.preferences);
  late final selection = SelectedCardCubit(repositories.preferences);
  late final lock = AppLockCubit(repositories.biometrics);
  final refresh = RefreshCubit();
  late final banks = BankCatalogCubit(repositories.queries);
  late final cards = CardsCubit(
      repositories.cards, repositories.money, _userId, refresh.refresh);
  late final finance = FinanceCubit(
      repositories.money,
      _userId,
      () => (selection.state.last4, selection.state.bankName),
      repositories.cards.getCards,
      refresh.refresh);
  late final items = ItemsCubit(
      repositories.items, repositories.queries, _userId, refresh.refresh);
  late final profile =
      ProfileCubit(repositories.profile, _userId, refresh.refresh);
  late final budgets = BudgetsCubit(repositories.budgets, _userId);
  late final analytics = AnalyticsCubit(repositories.transactions, _userId);
  late final cash =
      PocketCashCubit(repositories.cash, _userId, refresh.refresh);
  late final transactions = TransactionCommandsCubit(
      repositories.transactions,
      _userId,
      refresh.refresh,
      (userId) => SaveTransactionEdit(
          userId: userId,
          transactionRepository: repositories.transactions,
          moneyRepository: repositories.money,
          cardRepository: repositories.cards,
          bankCatalogLoader: repositories.queries.getBanks),
      DeleteTransaction(repositories.transactions, repositories.cards),
      CreateManualTransaction(repositories.transactions,
          createId: const Uuid().v4));
  late final sms = SmsCubit(repositories.sms);
  late final mappings = BankMappingsCubit(repositories.mappings);
  late final chat = AIChatCubit(
      GetFinancialOverview(
          transactions: repositories.transactions,
          money: repositories.money,
          items: repositories.items,
          budgets: repositories.budgets),
      _userId);
  final filter = TransactionFilterCubit();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  String? _previousUser;
  bool _closed = false;
  List<Object?> _cardFinancialSignature = const [];
  AppRuntime(this.repositories) {
    _subscriptions.add(auth.stream.listen(_authenticationChanged));
    _subscriptions.add(refresh.stream.listen((_) => reload()));
    _subscriptions.add(selection.stream.listen((_) => finance.reload()));
    _subscriptions.add(cards.stream.listen((state) async {
      if (state.isLoading || state.hasError || _userId() == null) return;
      final values = state.value ?? const [];
      final signature = <Object?>[
        for (final card in values)
          (
            card.id,
            card.last4,
            card.bankName,
            card.isCreditCard,
            card.creditLimitMinor,
            card.currentBalanceMinor,
            card.cashWithdrawalEnabled
          )
      ];
      final changed = signature.length != _cardFinancialSignature.length ||
          List.generate(signature.length,
                  (i) => signature[i] != _cardFinancialSignature[i])
              .any((value) => value);
      _cardFinancialSignature = signature;
      finance.updateCardDisplay(values);
      await selection.reconcileCards(values);
      if (!_closed && changed) await finance.reload();
    }));
    _authenticationChanged(auth.state);
    banks.reload();
  }
  String? _userId() => auth.state.userId;
  void _authenticationChanged(AuthenticationState state) {
    lock.handleAuthentication(
        userId: state.userId,
        event: state.event,
        hasError: state.error != null);
    if (_previousUser == state.userId) return;
    _previousUser = state.userId;
    _cardFinancialSignature = const [];
    // Never retain a previous account's values during a new account's load.
    finance.clear(FinanceSnapshot.empty());
    items.clear(const ItemsSnapshot());
    cards.clear(const []);
    profile.clear(null);
    budgets.clear(const []);
    analytics.clear(const []);
    cash.clear((0, const []));
    filter.clear();
    transactions.reset();
    chat.reset();
    if (state.userId != null) {
      repositories.money
          .retryItemCashMovements(state.userId!)
          .catchError((Object _) {});
      reload();
    }
  }

  Future<void> reload() async {
    if (_closed) return;
    await Future.wait([
      cards.reload(),
      finance.reload(),
      items.reload(),
      profile.reload(),
      budgets.reload(),
      analytics.reload(),
      cash.reload()
    ]);
  }

  Future<void> close() async {
    _closed = true;
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    final cubits = <BlocBase<dynamic>>[
      auth,
      locale,
      theme,
      selection,
      lock,
      refresh,
      banks,
      cards,
      finance,
      items,
      profile,
      budgets,
      analytics,
      cash,
      transactions,
      sms,
      mappings,
      filter,
      chat
    ];
    await Future.wait(cubits.map((cubit) => cubit.close()));
  }
}
