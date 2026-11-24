import 'data_preparation_cubit.dart';
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
import '../features/dashboard/presentation/cubit/salary_plan_cubit.dart';
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
import '../domain/repositories/sms_repository.dart';

/// Owns app-lifetime Cubits and coordinates account/data changes outside widgets.
/// No Cubit subscribes to another Cubit.
class AppRuntime {
  Future<T> withSmsSuspended<T>(Future<T> Function() action) async {
    final user = _userId();
    if (user == null) throw StateError('Sign in first');
    final repository = repositories.sms;
    repository.stop();
    try {
      if (repository is SmsMaintenanceRepository) {
        await (repository as SmsMaintenanceRepository).waitForIdle();
      }
      if (_userId() != user) throw StateError('Account changed');
      return await action();
    } finally {
      if (repository is SmsMaintenanceRepository) {
        (repository as SmsMaintenanceRepository).resetMemory();
      }
      if (_userId() == user && !_closed) {
        repository.start();
        await selection.reload();
        refresh.refresh();
      }
    }
  }

  final Duration preparationTimeout;
  final Map<String, Future<void>> _preparations = {};
  final AppRepositories repositories;
  late final auth = AuthCubit(repositories.auth);
  late final locale = LocaleCubit(repositories.preferences);
  late final theme = ThemeModeCubit(repositories.preferences);
  late final selection = SelectedCardCubit(repositories.preferences);
  late final lock = AppLockCubit(repositories.biometrics);
  final refresh = RefreshCubit();
  final preparation = DataPreparationCubit();
  int _preparationGeneration = 0;
  String? _readyUser;
  late final banks = BankCatalogCubit(repositories.queries);
  late final cards = CardsCubit(
    repositories.cards,
    repositories.money,
    _userId,
    refresh.refresh,
  );
  late final finance = FinanceCubit(
    repositories.money,
    _userId,
    () => (selection.state.last4, selection.state.bankName),
    repositories.cards.getCards,
    refresh.refresh,
  );
  late final items = ItemsCubit(
    repositories.items,
    repositories.queries,
    _userId,
    refresh.refresh,
  );
  late final profile = ProfileCubit(
    repositories.profile,
    _userId,
    refresh.refresh,
  );
  late final budgets = BudgetsCubit(repositories.budgets, _userId);
  late final analytics = AnalyticsCubit(repositories.transactions, _userId);
  late final cash = PocketCashCubit(
    repositories.cash,
    _userId,
    refresh.refresh,
  );
  late final salary = SalaryPlanCubit(
    repositories.salary,
    _userId,
    () => finance.state.map((snapshot) => snapshot.card).value,
    refresh.refresh,
  );
  late final transactions = TransactionCommandsCubit(
    repositories.transactions,
    _userId,
    refresh.refresh,
    (userId) => SaveTransactionEdit(
      userId: userId,
      transactionRepository: repositories.transactions,
      moneyRepository: repositories.money,
      cardRepository: repositories.cards,
      bankCatalogLoader: repositories.queries.getBanks,
    ),
    DeleteTransaction(repositories.transactions, repositories.cards),
    CreateManualTransaction(
      repositories.transactions,
      createId: const Uuid().v4,
    ),
  );
  late final sms = SmsCubit(repositories.sms);
  late final mappings = BankMappingsCubit(repositories.mappings);
  late final chat = AIChatCubit(
    GetFinancialOverview(
      transactions: repositories.transactions,
      money: repositories.money,
      items: repositories.items,
      budgets: repositories.budgets,
    ),
    repositories.salary,
    _userId,
    () => finance.state.map((snapshot) => snapshot.card).value,
  );
  final filter = TransactionFilterCubit();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  String? _previousUser;
  bool _closed = false;
  List<Object?> _cardFinancialSignature = const [];
  AppRuntime(
    this.repositories, {
    this.preparationTimeout = const Duration(seconds: 20),
  }) {
    _subscriptions.add(auth.stream.listen(_authenticationChanged));
    _subscriptions.add(refresh.stream.listen((_) => reload()));
    _subscriptions.add(selection.stream.listen((_) async {
      await finance.reload();
      await salary.reload();
    }));
    _subscriptions.add(
      cards.stream.listen((state) async {
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
              card.cashWithdrawalEnabled,
            ),
        ];
        final changed =
            signature.length != _cardFinancialSignature.length ||
            List.generate(
              signature.length,
              (i) => signature[i] != _cardFinancialSignature[i],
            ).any((value) => value);
        _cardFinancialSignature = signature;
        finance.updateCardDisplay(values);
        await selection.reconcileCards(values);
        if (!_closed && changed) await finance.reload();
      }),
    );
    _authenticationChanged(auth.state);
    banks.reload();
  }
  String? _userId() => _readyUser == auth.state.userId ? _readyUser : null;
  void _authenticationChanged(AuthenticationState state) {
    lock.handleAuthentication(
      userId: state.userId,
      event: state.event,
      hasError: state.error != null,
    );
    if (_previousUser == state.userId) return;
    _previousUser = state.userId;
    _readyUser = null;
    _preparationGeneration++;
    selection.resetForAccount();
    sms.stop();
    unawaited(sms.bindUser(null).catchError((Object _) {}));
    _cardFinancialSignature = const [];
    // Never retain a previous account's values during a new account's load.
    finance.clear(FinanceSnapshot.empty());
    items.clear(const ItemsSnapshot());
    cards.clear(const []);
    profile.clear(null);
    budgets.clear(const []);
    analytics.clear(const []);
    cash.clear((0, const []));
    salary.clear(SalaryPlanCubit.empty());
    filter.clear();
    transactions.reset();
    chat.reset();
    if (state.userId != null) {
      unawaited(retryPreparation());
    } else {
      preparation.ready(null);
    }
  }

  Future<void> retryPreparation() async {
    final user = auth.state.userId;
    if (user == null || _closed) return;
    final generation = ++_preparationGeneration;
    preparation.loading(user);
    _readyUser = null;
    sms.stop();
    try {
      await (() async {
        await _preparations.putIfAbsent(
          user,
          () => Future<void>.sync(() => repositories.prepareUser?.call(user))
              .whenComplete(() {
                _preparations.remove(user);
              }),
        );
        if (_closed ||
            generation != _preparationGeneration ||
            auth.state.userId != user) {
          return;
        }
        await selection.reload();
        if (_closed ||
            generation != _preparationGeneration ||
            auth.state.userId != user) {
          return;
        }
        await sms.bindUser(user);
      })().timeout(preparationTimeout);
      if (_closed ||
          generation != _preparationGeneration ||
          auth.state.userId != user) {
        return;
      }
      _readyUser = user;
      if (_closed || generation != _preparationGeneration) return;
      preparation.ready(user);
      sms.start();
      await reload();
    } catch (error) {
      if (!_closed && generation == _preparationGeneration) {
        _preparationGeneration++;
        _readyUser = null;
        sms.stop();
        unawaited(sms.bindUser(null).catchError((Object _) {}));
        preparation.failed(user, timedOut: error is TimeoutException);
      }
    }
  }

  Future<void> reload() async {
    if (_closed || _userId() == null) return;
    // Salary plans are card-scoped. Refresh the selected-card snapshot before
    // asking the salary cubit which plan belongs to the current screen.
    await cards.reload();
    await Future.wait([
      finance.reload(),
      items.reload(),
      profile.reload(),
      budgets.reload(),
      analytics.reload(),
      cash.reload(),
    ]);
    await salary.reload();
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
      preparation,
      banks,
      cards,
      finance,
      items,
      profile,
      budgets,
      analytics,
      cash,
      salary,
      transactions,
      sms,
      mappings,
      filter,
      chat,
    ];
    await Future.wait(cubits.map((cubit) => cubit.close()));
  }
}
