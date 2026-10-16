import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/database/app_database.dart' as db;
import '../data/models/item_model.dart' as item_models;
import '../data/remote/datasources/auth_remote_datasource.dart';
import '../data/remote/datasources/transaction_remote_datasource.dart';
import '../data/remote/datasources/item_remote_datasource.dart';
import '../data/remote/datasources/category_remote_datasource.dart';
import '../data/remote/datasources/cash_wallet_remote_datasource.dart';
import '../data/remote/datasources/expense_remote_datasource.dart';
import '../data/remote/datasources/budget_remote_datasource.dart';
import '../data/remote/datasources/recurring_expense_remote_datasource.dart';
import '../data/remote/datasources/analytics_remote_datasource.dart';
import '../data/remote/datasources/bank_remote_datasource.dart';
import '../data/remote/datasources/ai_remote_datasource.dart';
import '../data/remote/datasources/money_remote_datasource.dart';
import '../data/remote/datasources/profile_remote_datasource.dart';
import '../data/remote/datasources/sms_remote_datasource.dart';
import '../data/remote/datasources/detected_card_remote_datasource.dart';
import '../data/models/money_model.dart';
import '../data/models/transaction_model.dart';
import '../data/local/datasources/transaction_local_datasource.dart';
import '../data/local/datasources/money_local_datasource.dart';
import '../data/local/datasources/item_local_datasource.dart';
import '../data/local/datasources/expense_local_datasource.dart';
import '../data/local/datasources/detected_card_local_datasource.dart';
import '../data/local/datasources/processed_sms_local_datasource.dart';
import '../data/local/datasources/sms_message_local_datasource.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/item_repository.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/cash_wallet_repository.dart';
import '../data/repositories/budget_repository.dart';
import '../data/repositories/recurring_expense_repository.dart';
import '../data/repositories/analytics_repository.dart';
import '../data/repositories/ai_repository.dart';
import '../data/repositories/money_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/detected_card_repository.dart';
import '../data/models/detected_card_model.dart';
import '../data/services/card_balance_calculator.dart';
import '../data/services/card_ownership.dart';
import '../data/services/smart_card_resolution_service.dart';
import '../data/services/sms_transaction_processor.dart';
import '../data/services/sms_ingestion_service.dart';
import '../data/services/sms_polling_service.dart';
import '../data/services/sms_sync_state_store.dart';
import '../data/services/transaction_data_reset_service.dart';
import '../data/services/bank_sender_mapping_store.dart';
import 'services/sms_inbox_service.dart';
import '../data/services/high_frequency_service.dart';
import '../data/services/item_image_service.dart';
import '../data/models/user_model.dart';
import 'localization/preferences_provider.dart';
import 'utils/app_logger.dart';

// Database Provider
final appDatabaseProvider = Provider<db.AppDatabase>((ref) {
  return db.AppDatabase();
});

// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Remote Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSource(supabaseClient);
});

final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return TransactionRemoteDataSource(supabaseClient);
});

final itemRemoteDataSourceProvider = Provider<ItemRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ItemRemoteDataSource(supabaseClient);
});

final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CategoryRemoteDataSource(supabaseClient);
});

final cashWalletRemoteDataSourceProvider =
    Provider<CashWalletRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CashWalletRemoteDataSource(supabaseClient);
});

final expenseRemoteDataSourceProvider =
    Provider<ExpenseRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ExpenseRemoteDataSource(supabaseClient);
});

final budgetRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return BudgetRemoteDataSource(supabaseClient);
});

final recurringExpenseRemoteDataSourceProvider =
    Provider<RecurringExpenseRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return RecurringExpenseRemoteDataSource(supabaseClient);
});

final analyticsRemoteDataSourceProvider =
    Provider<AnalyticsRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AnalyticsRemoteDataSource(supabaseClient);
});

final aiRemoteDataSourceProvider = Provider<AIRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AIRemoteDataSource(supabaseClient);
});

final bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return BankRemoteDataSource(supabaseClient);
});

// Local Data Sources
final transactionLocalDataSourceProvider =
    Provider<TransactionLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return TransactionLocalDataSource(database);
});

final moneyLocalDataSourceProvider = Provider<MoneyLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return MoneyLocalDataSource(database);
});

final itemLocalDataSourceProvider = Provider<ItemLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ItemLocalDataSource(database);
});

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ExpenseLocalDataSource(database);
});

final moneyRemoteDataSourceProvider = Provider<MoneyRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return MoneyRemoteDataSource(supabaseClient);
});

// Auth State — reactive stream from Supabase (for listening to changes)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authDataSource = ref.watch(authRemoteDataSourceProvider);
  return authDataSource.getAuthStateChanges();
});

/// Current user — reads directly from Supabase for immediate availability.
/// This avoids the delay caused by waiting for the auth state stream to emit.
final currentUserProvider = Provider<User?>((ref) {
  // Also watch the stream so we rebuild on auth changes
  ref.watch(authStateProvider);
  return Supabase.instance.client.auth.currentUser;
});

/// Current session — reads directly from Supabase for immediate availability.
final currentSessionProvider = Provider<Session?>((ref) {
  ref.watch(authStateProvider);
  return Supabase.instance.client.auth.currentSession;
});

/// Whether a user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// Current user id (null when signed out)
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.id;
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepository(authDataSource);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final remoteDataSource = ref.watch(transactionRemoteDataSourceProvider);
  final localDataSource = ref.watch(transactionLocalDataSourceProvider);
  final moneyLocal = ref.watch(moneyLocalDataSourceProvider);
  return TransactionRepository(
    remoteDataSource,
    localDataSource,
    moneyRemoteDataSource: ref.watch(moneyRemoteDataSourceProvider),
    smsRemoteDataSource: ref.watch(smsRemoteDataSourceProvider),
    deleteTransactionMovements: moneyLocal.deleteMovementsForTransaction,
    detachSmsTransaction: ref.watch(smsMessageLocalDataSourceProvider).detachTransaction,
    reconcileTransactionMovements: (previous, next) async {
      await moneyLocal.deleteMovementsForTransaction(next.id);
      if (next.status != TransactionStatus.confirmed) return;
      final delta = next.type.isIncoming
          ? next.amountMinor
          : next.type.isOutgoing && next.type != TransactionType.cash_expense
              ? -next.amountMinor
              : 0;
      if (delta != 0 && next.bankId != null) {
        final accounts = await moneyLocal.getBankAccounts(next.userId);
        final account = accounts.where((a) => a.bankId == next.bankId).toList();
        if (account.isNotEmpty) {
          await moneyLocal.insertBankMovement(BankAccountMovement(
            id: 'bank-${next.id}',
            accountId: account.first.id,
            userId: next.userId,
            type: delta > 0 ? 'in' : 'out',
            amountMinor: delta.abs(),
            referenceType: 'transaction',
            referenceId: next.id,
            movementDate: next.transactionDate,
          ));
        }
      }
      if (next.type == TransactionType.atm_withdrawal ||
          next.type == TransactionType.cash_expense) {
        var wallet = await moneyLocal.getWallet(next.userId);
        if (wallet == null) {
          wallet = item_models.CashWallet(
            id: const Uuid().v4(),
            userId: next.userId,
            currency: next.currency,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await moneyLocal.insertWallet(wallet);
        }
        await moneyLocal.insertCashMovement(item_models.CashMovement(
          id: 'cash-${next.id}',
          userId: next.userId,
          walletId: wallet.id,
          type: next.type.name,
          amountMinor: next.amountMinor,
          referenceType: 'transaction',
          referenceId: next.id,
          movementDate: next.transactionDate,
          createdAt: DateTime.now(),
        ));
      }
    },
  );
});

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final remoteDataSource = ref.watch(itemRemoteDataSourceProvider);
  final localDataSource = ref.watch(itemLocalDataSourceProvider);
  return ItemRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final remoteDataSource = ref.watch(expenseRemoteDataSourceProvider);
  final localDataSource = ref.watch(expenseLocalDataSourceProvider);
  return ExpenseRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepository(remoteDataSource: remoteDataSource);
});

final cashWalletRepositoryProvider = Provider<CashWalletRepository>((ref) {
  final remoteDataSource = ref.watch(cashWalletRemoteDataSourceProvider);
  return CashWalletRepository(remoteDataSource: remoteDataSource);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final remoteDataSource = ref.watch(budgetRemoteDataSourceProvider);
  return BudgetRepository(remoteDataSource: remoteDataSource);
});

final recurringExpenseRepositoryProvider =
    Provider<RecurringExpenseRepository>((ref) {
  final remoteDataSource = ref.watch(recurringExpenseRemoteDataSourceProvider);
  return RecurringExpenseRepository(remoteDataSource: remoteDataSource);
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final remoteDataSource = ref.watch(analyticsRemoteDataSourceProvider);
  return AnalyticsRepository(remoteDataSource: remoteDataSource);
});

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final remoteDataSource = ref.watch(aiRemoteDataSourceProvider);
  return AIRepository(remoteDataSource: remoteDataSource);
});

final moneyRepositoryProvider = Provider<MoneyRepository>((ref) {
  final remote = ref.watch(moneyRemoteDataSourceProvider);
  final local = ref.watch(moneyLocalDataSourceProvider);
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final cashWalletRepo = ref.watch(cashWalletRepositoryProvider);
  final expenseRepo = ref.watch(expenseRepositoryProvider);
  // CRITICAL: the detected-card repository must be injected. Without it
  // `MoneyRepository._findCardByLast4` always resolves to null, which
  // silently disables every card-scoped rule:
  //   * the credit-card Fixed-Amount (credit limit) enforcement,
  //   * the credit-card Pocket-Cash eligibility rule,
  //   * the credit-card opening balance used by `getMyBalanceForCard`.
  final detectedCardRepo = ref.watch(detectedCardRepositoryProvider);
  return MoneyRepository(
    remote: remote,
    local: local,
    transactionRepository: transactionRepo,
    cashWalletRepository: cashWalletRepo,
    expenseRepository: expenseRepo,
    detectedCardRepository: detectedCardRepo,
    // The SMS detection record is the existing bridge between a transaction's
    // bank UUID and a detected card's bank NAME. Wiring it lets the smart
    // resolver qualify an ambiguous Last 4 by bank, without inventing a second
    // bank-matching mechanism.
    smsMessageLocalDataSource: ref.watch(smsMessageLocalDataSourceProvider),
    // Supabase mirror of a local card_id write. Best-effort: the local store is
    // the source of truth and a remote failure must never roll it back.
    remoteCardIdWriter: (transactionId, cardId) async {
      try {
        await remote
            .updateTransactionCardId(transactionId, cardId)
            .timeout(const Duration(seconds: 15));
      } catch (e) {
        logError('MONEY_CARD_ID_REMOTE_SYNC_FAILED id=$transactionId', e);
      }
    },
  );
});

/// Resolves a user-entered Card Last 4 for a transaction: assigns the
/// transaction and propagates to other unresolved rows that provably share the
/// same card identity.
///
/// This is an ACTION, not a read: it is invoked by the user from the
/// transaction-resolution flow. On success it invalidates every provider that
/// displays card state, so My Balance, Deducted Money, Pocket Cash, the
/// transaction list and the red dots all refresh immediately — no app restart.
class CardIdentityResolverController {
  CardIdentityResolverController(this._ref);

  final Ref _ref;
  bool _busy = false;

  bool get isBusy => _busy;

  /// LEARNS a persistent `Bank + Last 4 -> Card` identity from the user's
  /// explicit confirmation, then refreshes all dependent state.
  ///
  /// This is what the long-press -> Edit -> enter Last 4 -> Save flow calls. The
  /// bank comes from the transaction itself unless the user explicitly retyped
  /// it, so they never have to re-select the bank they did not change.
  Future<SmartResolutionResult> learn({
    required String transactionId,
    required String? last4,
    String? bankIdentityOverride,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return const SmartResolutionResult(resolution: Unresolved('no_user'));
    }
    _busy = true;
    try {
      final result = await _ref.read(moneyRepositoryProvider).learnCardIdentity(
            userId: userId,
            transactionId: transactionId,
            last4: last4,
            bankIdentityOverride: bankIdentityOverride,
          );
      // Ownership is persisted BEFORE any of these are read again, so the
      // refreshed balances are computed from the final, correct ownership.
      if (result.transactionAssigned) _invalidateCardState();
      return result;
    } finally {
      _busy = false;
    }
  }

  /// Runs the resolution and refreshes all dependent state.
  Future<SmartResolutionResult> resolve({
    required String transactionId,
    String? last4,
    String? bankIdentity,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      return const SmartResolutionResult(resolution: Unresolved('no_user'));
    }
    _busy = true;
    try {
      final result = await _ref.read(moneyRepositoryProvider)
          .resolveCardIdentityForUserInput(
            userId: userId,
            transactionId: transactionId,
            last4: last4,
            bankIdentity: bankIdentity,
          );
      // Ownership is persisted BEFORE any of these are read again, so the
      // refreshed balances are computed from the final, correct ownership.
      _invalidateCardState();
      return result;
    } finally {
      _busy = false;
    }
  }

  /// Re-runs deterministic resolution for every unresolved transaction.
  Future<int> backfill() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) return 0;
    _busy = true;
    try {
      final repaired =
          await _ref.read(moneyRepositoryProvider).backfillCardIdentities(userId);
      if (repaired > 0) _invalidateCardState();
      return repaired;
    } finally {
      _busy = false;
    }
  }

  /// Everything that displays card ownership or per-card money.
  void _invalidateCardState() {
    _ref.invalidate(unassignedTransactionsProvider);
    _ref.invalidate(moneySummaryProvider);
    _ref.invalidate(selectedCardMoneySummaryProvider);
    _ref.invalidate(selectedCardFullBalanceProvider);
    _ref.invalidate(canAddSelectedCardBalanceProvider);
    _ref.invalidate(detectedCardsProvider);
  }
}

final cardIdentityResolverControllerProvider =
    Provider<CardIdentityResolverController>((ref) {
  return CardIdentityResolverController(ref);
});

/// Dashboard money summary (My Balance, Deducted Money, Pocket Cash).
final moneySummaryProvider =
    FutureProvider.autoDispose<MoneySummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return const MoneySummary(
        myBalanceMinor: 0,
        deductedMinor: 0,
        pocketCashMinor: 0,
        monthlyIncomeMinor: 0);
  }
  return ref.watch(moneyRepositoryProvider).getMoneySummary(userId);
});

// ── Detected Cards ────────────────────────────────────────────────────────────

final detectedCardLocalDataSourceProvider =
    Provider<DetectedCardLocalDataSource>((ref) {
  return DetectedCardLocalDataSource();
});

final detectedCardRepositoryProvider = Provider<DetectedCardRepository>((ref) {
  return DetectedCardRepository(
    local: ref.watch(detectedCardLocalDataSourceProvider),
    remote: DetectedCardRemoteDataSource(ref.watch(supabaseClientProvider)),
  );
});

/// All detected cards for the current user, sorted by last4.
/// Exposed as a Stream so the Detected Cards page rebuilds live as new SMS
/// messages are processed (requirement #8 — dynamic count).
final detectedCardsProvider =
    StreamProvider.autoDispose<List<DetectedCard>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();
  final repository = ref.watch(detectedCardRepositoryProvider);
  // Wrap the list load in a stream: emit immediately, then on invalidation.
  return repository.getCards(userId).asStream();
});

/// Static bank catalog merged with the remote catalog for SMS detection.
final bankCatalogProvider = FutureProvider<List<Bank>>((ref) async {
  try {
    final remote = ref.watch(bankRemoteDataSourceProvider);
    return await remote.getActiveBanks();
  } catch (e) {
    return const <Bank>[];
  }
});

final smsTransactionProcessorProvider =
    Provider<SMSTransactionProcessor>((ref) {
  final moneyRepo = ref.watch(moneyRepositoryProvider);
  final detectedCardRepo = ref.watch(detectedCardRepositoryProvider);
  final smsRemote = ref.watch(smsRemoteDataSourceProvider);
  return SMSTransactionProcessor(
    moneyRepository: moneyRepo,
    detectedCardRepository: detectedCardRepo,
    smsRemoteDataSource: smsRemote,
    bankSenderMappingStore: ref.watch(bankSenderMappingStoreProvider),
    // ROOT-CAUSE FIX (repeated SMS re-processing): the local processed-SMS
    // ledger MUST be injected. Without it `markProcessed` was never called in
    // production, so `knownHashesLocal` always returned an empty set and every
    // single scan re-parsed every inbox message it saw — the 5-second poller
    // therefore re-processed the same SMS over and over, hammering the platform
    // channel, the parser and the network (the MIUI ANR). The ledger is the
    // authoritative per-message "already processed" identity.
    processedSmsLocalDataSource: ref.watch(processedSmsLocalDataSourceProvider),
    smsMessageLocalDataSource: ref.watch(smsMessageLocalDataSourceProvider),
  );
});

final smsRemoteDataSourceProvider = Provider<SmsRemoteDataSource>((ref) {
  return SmsRemoteDataSource(ref.watch(supabaseClientProvider));
});

/// Per-user SMS sender → bank name mapping ("Unknown Bank" fallback).
final bankSenderMappingStoreProvider = Provider<BankSenderMappingStore>((ref) {
  return BankSenderMappingStore();
});

/// SMS inbox retrieval via the Android platform channel.
final smsInboxServiceProvider = Provider<SmsInboxService>((ref) {
  return SmsInboxService();
});

/// NOTE (architecture): the old `detectionRangeNotifierProvider` was removed.
///
/// It merged two independent concepts into one persisted object: "which SMS
/// may be detected" (ingestion) and "which transactions the Transactions page
/// shows" (display). Ingestion is now driven by [smsSyncStateStoreProvider] +
/// the local processed-SMS ledger; display is driven by the Transactions
/// screen's own `TransactionDisplayFilter` (filter icon). Never reintroduce a
/// display value into the SMS pipeline.

/// Persistent per-user SMS ingestion watermark (first scan vs. incremental).
///
/// Replaces the old Settings-based "Detection Range" for SMS PROCESSING: which
/// SMS still need processing is decided by this cursor plus the processed-SMS
/// ledger, never by a display filter.
final smsSyncStateStoreProvider = Provider<SmsSyncStateStore>((ref) {
  return SmsSyncStateStore();
});

final smsMessageLocalDataSourceProvider =
    Provider<SmsMessageLocalDataSource>((ref) {
  return SmsMessageLocalDataSource(ref.watch(appDatabaseProvider));
});

/// Local per-message processed-SMS ledger (authoritative dedupe source).
///
/// Survives restarts and works offline. One row per successfully detected SMS.
final processedSmsLocalDataSourceProvider =
    Provider<ProcessedSmsLocalDataSource>((ref) {
  return ProcessedSmsLocalDataSource(ref.watch(appDatabaseProvider));
});

/// One-shot "scan the inbox and process bank messages" orchestrator.
///
/// Single shared instance used by the 5-second poller and by pull-to-refresh.
final smsIngestionServiceProvider = Provider<SmsIngestionService>((ref) {
  return SmsIngestionService(
    inboxService: ref.watch(smsInboxServiceProvider),
    processor: ref.watch(smsTransactionProcessorProvider),
    smsRemoteDataSource: ref.watch(smsRemoteDataSourceProvider),
    processedSmsLocalDataSource: ref.watch(processedSmsLocalDataSourceProvider),
  );
});

/// Bumped whenever new SMS-derived transactions are created - screens that
/// keep a local transaction list listen to this to refresh immediately.
final transactionsRefreshTickProvider = StateProvider<int>((ref) => 0);

/// Central 5-second bank-SMS polling. ONE app-lifetime instance - started once
/// from `main.dart`, never from widgets/builds.
///
/// First-run behavior: one bounded historical page per scan until the inbox
/// history is fully ingested; every later scan only checks messages newer than
/// the persisted cursor. This provider never depends on a display filter.
final smsPollingServiceProvider = Provider<SmsPollingService>((ref) {
  final service = SmsPollingService(
    ingestion: ref.watch(smsIngestionServiceProvider),
    resolveUserId: () async => ref.read(currentUserIdProvider),
    resolveKnownBanks: () async {
      try {
        return await ref.read(bankCatalogProvider.future);
      } catch (_) {
        // Catalog unavailable - the parser still detects banks statically.
        return const <Bank>[];
      }
    },
    syncStateStore: ref.watch(smsSyncStateStoreProvider),
    processedSmsLocalDataSource: ref.watch(processedSmsLocalDataSourceProvider),
    onTransactionsCreated: (count) {
      // Refresh financial state everywhere (Home summary, per-card summary,
      // detected cards, transaction lists) without blocking or rebuilding
      // the poller.
      ref.invalidate(moneySummaryProvider);
      ref.invalidate(selectedCardMoneySummaryProvider);
      ref.invalidate(detectedCardsProvider);
      ref.read(transactionsRefreshTickProvider.notifier).state++;
    },
  );
  ref.onDispose(service.stop);
  return service;
});

/// Complete transaction/SMS data reset (requirement #1). Clears all
/// generated/test data (transactions, expenses, money ledger, detected cards,
/// the local processed-SMS ledger and the SMS ingestion cursor) so the app
/// starts fresh and re-ingests bank/wallet SMS from history on next launch.
final transactionDataResetServiceProvider =
    Provider<TransactionDataResetService>((ref) {
  return TransactionDataResetService(
    transactionLocal: ref.watch(transactionLocalDataSourceProvider),
    transactionRemote: ref.watch(transactionRemoteDataSourceProvider),
    expenseLocal: ref.watch(expenseLocalDataSourceProvider),
    moneyLocal: ref.watch(moneyLocalDataSourceProvider),
    smsRemote: ref.watch(smsRemoteDataSourceProvider),
    detectedCardLocal: ref.watch(detectedCardLocalDataSourceProvider),
    processedSmsLocal: ref.watch(processedSmsLocalDataSourceProvider),
    syncStateStore: ref.watch(smsSyncStateStoreProvider),
  );
});

final highFrequencyServiceProvider = Provider<HighFrequencyService>((ref) {
  final local = ref.watch(moneyLocalDataSourceProvider);
  return HighFrequencyService(local);
});

final itemImageServiceProvider = Provider<ItemImageService>((ref) {
  return ItemImageService(ref.watch(supabaseClientProvider));
});

// ── Profile ─────────────────────────────────────────────────────────────────

final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ProfileRemoteDataSource(supabaseClient);
});

final profileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final remote = ref.watch(profileRemoteDataSourceProvider);
  return UserProfileRepository(remoteDataSource: remote);
});

/// Stream of the current user's profile (email is always from auth session).
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile(userId);
});

// ── Localization & Theme ─────────────────────────────────────────────────────

final localeNotifierProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final themeModeNotifierProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// ── Items (shared so Home and Manage Items stay in sync) ────────────────────

/// Resolves an item's stored image reference to a displayable (signed) URL.
/// The `item-images` bucket is private, so plain public URLs 400 when loaded
/// by `Image.network` — signed URLs are required to render.
final itemDisplayUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, storedRef) {
  return resolveItemImageUrlAsync(storedRef);
});

/// Dashboard/home items — the single source of truth for the user's ACTIVE
/// items. Both Home and Manage Items invalidate this on any mutation so a
/// deleted item disappears everywhere immediately.
final dashboardItemsProvider = FutureProvider.autoDispose
    .family<List<item_models.Item>, String>((ref, userId) async {
  final repo = ref.watch(itemRepositoryProvider);
  return repo.getActiveItems(userId);
});

/// ── Selected card state (ONE source of truth) ──────────────────────────────
///
/// `card_last4` is THE card identity across the whole app: detected cards,
/// transactions, summaries and item purchases all key on it.
///
/// State chain:
///   SelectedCardNotifier (persisted SharedPreferences `card_last4`)
///     → selectedCardLast4Provider   (authoritative selected-card identity)
///     → selectedCardProvider        (resolves the full DetectedCard for UI)
///     → selectedCardMoneySummaryProvider (card-scoped money figures)
final selectedCardNotifierProvider =
    StateNotifierProvider<SelectedCardNotifier, String?>((ref) {
  return SelectedCardNotifier();
});

/// The selected card's `card_last4`, or null when no card is selected.
/// This is the authoritative selected-card value every consumer must read.
final selectedCardLast4Provider = Provider<String?>((ref) {
  return ref.watch(selectedCardNotifierProvider);
});

/// The selected card's persisted bank qualifier, or null for legacy
/// last4-only selections.
final selectedCardBankNameProvider = Provider<String?>((ref) {
  ref.watch(selectedCardNotifierProvider);
  return ref.read(selectedCardNotifierProvider.notifier).bankName;
});

/// The selected card's full [DetectedCard] object (for UI display only —
/// bank name, appearance, etc.), or null if none selected / no longer exists.
final selectedCardProvider =
    FutureProvider.autoDispose<DetectedCard?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final selectedLast4 = ref.watch(selectedCardLast4Provider);
  final selectedBankName = ref.watch(selectedCardBankNameProvider);
  if (userId == null || selectedLast4 == null) return null;
  final cards = await ref.watch(detectedCardsProvider.future);
  final matches = cards
      .where((card) =>
          card.last4 == selectedLast4 &&
          (selectedBankName == null || card.bankName == selectedBankName))
      .toList();
  return matches.length == 1 ? matches.single : null;
});

/// Card-specific money summary for the selected card.
///
/// Shows My Balance, Pocket Cash, Deducted Money for the currently
/// selected detected card ONLY — every query is scoped by `card_last4`.
///
/// No card selected (or the selected card no longer exists) → ZERO values.
/// Never falls back to the global all-cards summary.
final selectedCardMoneySummaryProvider =
    FutureProvider.autoDispose<MoneySummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final selectedCard = await ref.watch(selectedCardProvider.future);
  if (userId == null || selectedCard == null) {
    return MoneySummary.zero();
  }

  final repo = ref.watch(moneyRepositoryProvider);
  final now = DateTime.now();
  final cardLast4 = selectedCard.last4;
  final cardBankName = selectedCard.bankName;

  final myBalance =
      await repo.getMyBalanceForCard(userId, cardLast4, bankName: cardBankName);
  final pocketCash = await repo.getPocketCashForCard(userId, cardLast4,
      bankName: cardBankName);
  final deducted = await repo.getDeductedMoneyForCard(userId, cardLast4,
      bankName: cardBankName);
  final monthlyIncome =
      await repo.getMonthlyIncomeSum(userId, now.year, now.month);

  // Temporary diagnostic (no sensitive data beyond what the UI already shows).
  // Remove after runtime verification.
  logInfo('CARD_SUMMARY last4=$cardLast4 balance=$myBalance '
      'pocketCash=$pocketCash deducted=$deducted');

  return MoneySummary(
    myBalanceMinor: myBalance,
    deductedMinor: deducted,
    pocketCashMinor: pocketCash,
    monthlyIncomeMinor: monthlyIncome,
  );
});

/// Per-card balance (eye) visibility for the Dashboard's My Balance section.
///
/// Keyed by the card's stable id, so EVERY card owns an INDEPENDENT state:
/// hiding Card A can never hide Card B.
///
/// This provider is deliberately NOT linked to `selectedCardProvider` or to
/// any money provider. Toggling the eye is a pure display concern, so it must
/// not invalidate or recalculate My Balance, Fixed Amount, Deducted Money or
/// Pocket Cash (requirement #10).
final cardEyeVisibleProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, cardId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return true;
  return ref
      .watch(detectedCardRepositoryProvider)
      .getCardEyeVisible(userId, cardId);
});

/// Per-card Pocket Cash visibility for the selected card ("Use Card for Cash
/// Withdrawal"). The optional bank qualifier prevents a same-last4 collision.
final cardPocketCashVisibleProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, cardLast4) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return true;
  final bankName = ref.watch(selectedCardBankNameProvider);
  return ref
      .watch(moneyRepositoryProvider)
      .isPocketCashVisibleForCard(userId, cardLast4, bankName: bankName);
});

/// The FULL per-card figure set (My Balance / Deducted Money / Pocket Cash /
/// Fixed Amount) for the selected card, in one atomic read.
///
/// This is the provider the Dashboard's "+" button consults. It is derived per
/// card from that card's own transactions, so:
///  * a credit card with no Fixed Amount reports `hasFixedAmount == false` and
///    My Balance 0 — the "+" button is disabled until the user configures one;
///  * a credit card with a Fixed Amount reports the exact remaining headroom,
///    so a payment can never push My Balance above the Fixed Amount.
///
/// It is deliberately NOT derived from `selectedCardMoneySummaryProvider`,
/// which exists for the older summary widgets and is kept in sync for them.
final selectedCardFullBalanceProvider =
    FutureProvider.autoDispose<CardBalance>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final selectedCard = await ref.watch(selectedCardProvider.future);
  if (userId == null || selectedCard == null) return CardBalance.zero;
  // Re-read whenever the card's own configuration changes so a Fixed Amount
  // edit is reflected immediately, without any manual cache invalidation.
  await ref.watch(detectedCardsProvider.future);
  return ref
      .watch(moneyRepositoryProvider)
      .getCardBalance(userId, selectedCard.last4,
          bankName: selectedCard.bankName);
});

/// Whether the selected card's "+" (Add My Balance) button may be used.
///
/// A credit card without a Fixed Amount returns false, so the user is forced to
/// configure the limit first. A credit card that has already reached its Fixed
/// Amount also returns false. Debit cards have no Fixed Amount, so they stay
/// enabled as before.
final canAddSelectedCardBalanceProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final selectedCard = await ref.watch(selectedCardProvider.future);
  if (userId == null || selectedCard == null) return false;
  return ref
      .watch(moneyRepositoryProvider)
      .canAddBalanceForCard(userId, selectedCard.last4,
          bankName: selectedCard.bankName);
});

/// Transactions that belong to NO card yet.
///
/// These are shown with the red-dot "needs a card number" indicator and affect
/// no card's balances. They are never silently attached to the selected card.
final unassignedTransactionsProvider =
    FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(moneyRepositoryProvider).getUnassignedTransactions(userId);
});
