import '../data/services/transaction_movement_reconciler.dart';
import 'package:flutter/foundation.dart';
import '../core/services/ios_bank_message_bridge.dart';
import '../data/services/ios_bank_message_repository.dart';
import '../domain/repositories/sms_repository.dart';
import '../core/utils/app_logger.dart';
import 'app_repositories.dart';
import '../config/sms_import_config.dart';
import '../data/services/egp_exchange_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/database/app_database.dart' as db;
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
import '../data/services/sms_transaction_processor.dart';
import '../data/services/sms_ingestion_service.dart';
import '../data/services/sms_polling_service.dart';
import '../data/services/sms_sync_state_store.dart';
import '../data/services/transaction_data_reset_service.dart';
import '../data/services/bank_sender_mapping_store.dart';
import '../core/services/sms_inbox_service.dart';
import '../data/services/high_frequency_service.dart';
import '../data/services/item_image_service.dart';
import '../domain/entities/user_model.dart';
import '../data/repositories/account_repository.dart';
import '../data/repositories/financial_queries_repository.dart';
import '../data/repositories/app_preferences_repository.dart';
import '../core/services/biometric_lock_service.dart';

/// The only place that constructs infrastructure and concrete repositories.
/// Presentation receives domain ports through its feature Cubits.
class AppDependencies {
  String? Function() currentUserId = () => null;
  void Function() onDataChanged = () {};
  AppDependencies(
      {SupabaseClient? client,
      db.AppDatabase? database,
      TransactionRemoteDataSource? transactionRemote,
      MoneyRemoteDataSource? moneyRemote,
      SmsRemoteDataSource? smsRemote,
      DetectedCardRepository? cards,
      TransactionRepository? transactions})
      : supabaseClient = client ?? Supabase.instance.client,
        appDatabase = database ?? db.AppDatabase() {
    transactionRemoteDataSource =
        transactionRemote ?? TransactionRemoteDataSource(supabaseClient);
    moneyRemoteDataSource =
        moneyRemote ?? MoneyRemoteDataSource(supabaseClient);
    smsRemoteDataSource = smsRemote ?? SmsRemoteDataSource(supabaseClient);
    detectedCardRepository = cards ??
        DetectedCardRepository(
            local: detectedCardLocalDataSource,
            remote: DetectedCardRemoteDataSource(supabaseClient));
    _transactionOverride = transactions;
  }
  TransactionRepository? _transactionOverride;
  late final accountRepository = SupabaseAccountRepository(authRepository);
  late final preferences = SharedAppPreferences();
  late final biometrics = BiometricLockService();
  late final queries = FinancialQueries(
      banks: bankRemoteDataSource,
      money: moneyLocalDataSource,
      transactions: transactionRepository,
      frequency: highFrequencyService,
      images: itemImageService);
  final db.AppDatabase appDatabase;

  final SupabaseClient supabaseClient;

  late final AuthRemoteDataSource authRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return AuthRemoteDataSource(supabaseClient);
  })();

  late final TransactionRemoteDataSource transactionRemoteDataSource;

  late final ItemRemoteDataSource itemRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return ItemRemoteDataSource(supabaseClient);
  })();

  late final CategoryRemoteDataSource categoryRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return CategoryRemoteDataSource(supabaseClient);
  })();

  late final CashWalletRemoteDataSource cashWalletRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return CashWalletRemoteDataSource(supabaseClient);
  })();

  late final ExpenseRemoteDataSource expenseRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return ExpenseRemoteDataSource(supabaseClient);
  })();

  late final BudgetRemoteDataSource budgetRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return BudgetRemoteDataSource(supabaseClient);
  })();

  late final RecurringExpenseRemoteDataSource recurringExpenseRemoteDataSource =
      (() {
    final supabaseClient = this.supabaseClient;
    return RecurringExpenseRemoteDataSource(supabaseClient);
  })();

  late final AnalyticsRemoteDataSource analyticsRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return AnalyticsRemoteDataSource(supabaseClient);
  })();

  late final AIRemoteDataSource aiRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return AIRemoteDataSource(supabaseClient);
  })();

  late final BankRemoteDataSource bankRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return BankRemoteDataSource(supabaseClient);
  })();

  late final TransactionLocalDataSource transactionLocalDataSource = (() {
    final database = appDatabase;
    return TransactionLocalDataSource(database);
  })();

  late final MoneyLocalDataSource moneyLocalDataSource = (() {
    final database = appDatabase;
    return MoneyLocalDataSource(database);
  })();

  late final ItemLocalDataSource itemLocalDataSource = (() {
    final database = appDatabase;
    return ItemLocalDataSource(database);
  })();

  late final ExpenseLocalDataSource expenseLocalDataSource = (() {
    final database = appDatabase;
    return ExpenseLocalDataSource(database);
  })();

  late final MoneyRemoteDataSource moneyRemoteDataSource;

  late final AuthRepository authRepository = (() {
    final authDataSource = authRemoteDataSource;
    return AuthRepository(authDataSource);
  })();

  late final transactionMovementReconciler =
      TransactionMovementReconciler(moneyLocalDataSource);

  late final TransactionRepository transactionRepository =
      _transactionOverride ??
          (() {
            final remoteDataSource = transactionRemoteDataSource;
            final localDataSource = transactionLocalDataSource;
            final moneyLocal = moneyLocalDataSource;
            return TransactionRepository(
              remoteDataSource,
              localDataSource,
              moneyRemoteDataSource: moneyRemoteDataSource,
              smsRemoteDataSource: smsRemoteDataSource,
              deleteTransactionMovements:
                  moneyLocal.deleteMovementsForTransaction,
              detachSmsTransaction: smsMessageLocalDataSource.detachTransaction,
              reconcileTransactionMovements:
                  transactionMovementReconciler.reconcile,
            );
          })();

  late final itemRepository = ItemRepository(
      remoteDataSource: itemRemoteDataSource,
      localDataSource: itemLocalDataSource);
  late final expenseRepository = ExpenseRepository(
      remoteDataSource: expenseRemoteDataSource,
      localDataSource: expenseLocalDataSource);
  late final categoryRepository =
      CategoryRepository(remoteDataSource: categoryRemoteDataSource);
  late final cashWalletRepository =
      CashWalletRepository(remoteDataSource: cashWalletRemoteDataSource);
  late final budgetRepository =
      BudgetRepository(remoteDataSource: budgetRemoteDataSource);
  late final recurringExpenseRepository = RecurringExpenseRepository(
      remoteDataSource: recurringExpenseRemoteDataSource);
  late final analyticsRepository =
      AnalyticsRepository(remoteDataSource: analyticsRemoteDataSource);
  late final aiRepository = AIRepository(remoteDataSource: aiRemoteDataSource);
  late final MoneyRepository moneyRepository = MoneyRepository(
    remote: moneyRemoteDataSource,
    local: moneyLocalDataSource,
    transactionRepository: transactionRepository,
    cashWalletRepository: cashWalletRepository,
    expenseRepository: expenseRepository,
    detectedCardRepository: detectedCardRepository,
    smsMessageLocalDataSource: smsMessageLocalDataSource,
    remoteCardIdWriter: (transactionId, cardId) async {
      try {
        await moneyRemoteDataSource
            .updateTransactionCardId(transactionId, cardId)
            .timeout(const Duration(seconds: 15));
      } catch (error) {
        logError('MONEY_CARD_ID_REMOTE_SYNC_FAILED id=$transactionId', error);
      }
    },
  );

  late final DetectedCardLocalDataSource detectedCardLocalDataSource = (() {
    return DetectedCardLocalDataSource();
  })();

  late final DetectedCardRepository detectedCardRepository;

  late final SMSTransactionProcessor smsTransactionProcessor = (() {
    final moneyRepo = moneyRepository;
    final detectedCardRepo = detectedCardRepository;
    final smsRemote = smsRemoteDataSource;
    return SMSTransactionProcessor(
      exchangeService: EgpExchangeService(),
      moneyRepository: moneyRepo,
      detectedCardRepository: detectedCardRepo,
      smsRemoteDataSource: smsRemote,
      bankSenderMappingStore: bankSenderMappingStore,
      // ROOT-CAUSE FIX (repeated SMS re-processing): the local processed-SMS
      // ledger MUST be injected. Without it `markProcessed` was never called in
      // production, so `knownHashesLocal` always returned an empty set and every
      // single scan re-parsed every inbox message it saw — the 5-second poller
      // therefore re-processed the same SMS over and over, hammering the platform
      // channel, the parser and the network (the MIUI ANR). The ledger is the
      // authoritative per-message "already processed" identity.
      processedSmsLocalDataSource: processedSmsLocalDataSource,
      smsMessageLocalDataSource: smsMessageLocalDataSource,
    );
  })();

  late final SmsRemoteDataSource smsRemoteDataSource;

  late final BankSenderMappingStore bankSenderMappingStore = (() {
    return BankSenderMappingStore();
  })();

  late final SmsInboxService smsInboxService = (() {
    return SmsInboxService();
  })();

  late final SmsSyncStateStore smsSyncStateStore = (() {
    return SmsSyncStateStore();
  })();

  late final SmsMessageLocalDataSource smsMessageLocalDataSource = (() {
    return SmsMessageLocalDataSource(appDatabase);
  })();

  late final ProcessedSmsLocalDataSource processedSmsLocalDataSource = (() {
    return ProcessedSmsLocalDataSource(appDatabase);
  })();

  late final SmsIngestionService smsIngestionService = (() {
    return SmsIngestionService(
      importStart: SmsImportConfig.start,
      inboxService: smsInboxService,
      processor: smsTransactionProcessor,
      smsRemoteDataSource: smsRemoteDataSource,
      processedSmsLocalDataSource: processedSmsLocalDataSource,
    );
  })();

  late final SmsPollingService smsPollingService = (() {
    final service = SmsPollingService(
      ingestion: smsIngestionService,
      resolveUserId: () async => currentUserId(),
      resolveKnownBanks: () async {
        try {
          return await queries.getBanks();
        } catch (_) {
          // Catalog unavailable - the parser still detects banks statically.
          return const <Bank>[];
        }
      },
      syncStateStore: smsSyncStateStore,
      processedSmsLocalDataSource: processedSmsLocalDataSource,
      onTransactionsCreated: (count) {
        // Refresh financial state everywhere (Home summary, per-card summary,
        // detected cards, transaction lists) without blocking or rebuilding
        // the poller.
        onDataChanged();
      },
    );
    return service;
  })();

  late final SmsRepository smsRepository = _createSmsRepository();
  SmsRepository _createSmsRepository() {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return smsPollingService;
    }
    return IosBankMessageRepository(
      bridge: const IosBankMessageBridge(),
      isProcessed: processedSmsLocalDataSource.isProcessed,
      process: (userId, message) async {
        List<Bank> banks;
        try {
          banks = await queries.getBanks().timeout(const Duration(seconds: 8));
        } catch (_) {
          banks = const [];
        }
        return smsTransactionProcessor.process(
          userId: userId,
          sender: message.sender,
          smsContent: message.body,
          receivedAt: message.receivedAt,
          knownBanks: banks,
        );
      },
      onChanged: () => onDataChanged(),
    );
  }

  late final TransactionDataResetService transactionDataResetService = (() {
    return TransactionDataResetService(
      transactionLocal: transactionLocalDataSource,
      transactionRemote: transactionRemoteDataSource,
      expenseLocal: expenseLocalDataSource,
      moneyLocal: moneyLocalDataSource,
      smsRemote: smsRemoteDataSource,
      detectedCardLocal: detectedCardLocalDataSource,
      processedSmsLocal: processedSmsLocalDataSource,
      syncStateStore: smsSyncStateStore,
    );
  })();

  late final HighFrequencyService highFrequencyService = (() {
    final local = moneyLocalDataSource;
    return HighFrequencyService(local);
  })();

  late final ItemImageService itemImageService = (() {
    return ItemImageService(supabaseClient);
  })();

  late final ProfileRemoteDataSource profileRemoteDataSource = (() {
    final supabaseClient = this.supabaseClient;
    return ProfileRemoteDataSource(supabaseClient);
  })();

  late final UserProfileRepository profileRepository = (() {
    final remote = profileRemoteDataSource;
    return UserProfileRepository(remoteDataSource: remote);
  })();
  AppRepositories repositories() => AppRepositories(
      auth: accountRepository,
      preferences: preferences,
      biometrics: biometrics,
      money: moneyRepository,
      items: itemRepository,
      cards: detectedCardRepository,
      profile: profileRepository,
      budgets: budgetRepository,
      transactions: transactionRepository,
      cash: cashWalletRepository,
      queries: queries,
      sms: smsRepository,
      mappings: bankSenderMappingStore);
  Future<void> close() async {
    smsRepository.stop();
    await appDatabase.close();
  }
}
