import '../local/datasources/expense_local_datasource.dart';
import '../local/datasources/money_local_datasource.dart';
import '../local/datasources/processed_sms_local_datasource.dart';
import '../local/datasources/transaction_local_datasource.dart';
import '../remote/datasources/sms_remote_datasource.dart';
import '../remote/datasources/transaction_remote_datasource.dart';
import '../../core/utils/app_logger.dart';
import '../local/datasources/detected_card_local_datasource.dart';
import 'sms_sync_state_store.dart';

/// Complete data reset for the transaction/SMS subsystem (requirement #1).
///
/// Clears ALL generated/test data so the app starts fresh: transactions,
/// expenses, SMS metadata, bank movements/accounts, cash movements/wallets,
/// monthly incomes, item usages, detected cards, the local processed-SMS
/// ledger AND the persistent SMS ingestion cursor. Clearing the ledger and the
/// cursor is required: otherwise the deleted history could never be
/// re-ingested and the next scan would wrongly believe everything was already
/// processed.
///
/// Preserves: user auth account, profile, settings, and the
/// sender-to-bank mapping store.
class TransactionDataResetService {
  final TransactionLocalDataSource transactionLocal;
  final TransactionRemoteDataSource transactionRemote;
  final ExpenseLocalDataSource expenseLocal;
  final MoneyLocalDataSource moneyLocal;
  final SmsRemoteDataSource smsRemote;
  final DetectedCardLocalDataSource detectedCardLocal;
  final ProcessedSmsLocalDataSource processedSmsLocal;
  final SmsSyncStateStore syncStateStore;

  TransactionDataResetService({
    required this.transactionLocal,
    required this.transactionRemote,
    required this.expenseLocal,
    required this.moneyLocal,
    required this.smsRemote,
    required this.detectedCardLocal,
    required this.processedSmsLocal,
    required this.syncStateStore,
  });

  /// Resets all transaction-related data for [userId].
  Future<ResetCounts> reset(String userId) async {
    final counts = ResetCounts();
    logInfo('DATA_RESET_START userId=$userId');

    // 1. Local transactions.
    final txns = await transactionLocal.getTransactionsByUserId(userId);
    for (final t in txns) {
      await transactionLocal.deleteTransaction(t.id);
      counts.transactions++;
    }

    // 2. Local expenses.
    final expenses = await expenseLocal.getExpenses(userId);
    for (final e in expenses) {
      await expenseLocal.deleteExpense(e.id);
      counts.expenses++;
    }

    // 3. Local bank movements + accounts.
    final accounts = await moneyLocal.getBankAccounts(userId);
    for (final a in accounts) {
      final movements = await moneyLocal.getMovementsForAccount(a.id);
      for (final m in movements) {
        await moneyLocal.deleteBankMovement(m.id);
        counts.bankMovements++;
      }
      await moneyLocal.deleteBankAccount(a.id);
      counts.bankAccounts++;
    }

    // 4. Local cash movements + wallet.
    final wallet = await moneyLocal.getWallet(userId);
    if (wallet != null) {
      final cashMovements = await moneyLocal.getCashMovements(wallet.id);
      for (final m in cashMovements) {
        await moneyLocal.deleteCashMovement(m.id);
        counts.cashMovements++;
      }
      await moneyLocal.deleteWallet(wallet.id);
      counts.wallets++;
    }

    // 5. Local monthly incomes.
    final incomes = await moneyLocal.getMonthlyIncomes(userId);
    for (final i in incomes) {
      await moneyLocal.deleteMonthlyIncome(i.id);
      counts.monthlyIncomes++;
    }

    // 6. Local item usages (current month).
    final now = DateTime.now();
    final usages =
        await moneyLocal.getItemUsages(userId, year: now.year, month: now.month);
    for (final u in usages) {
      await moneyLocal.deleteItemUsage(u.id);
      counts.itemUsages++;
    }

    // 7. Local detected cards.
    final cards = await detectedCardLocal.getCards(userId);
    if (cards.isNotEmpty) {
      await detectedCardLocal.saveCards(userId, []);
      counts.detectedCards = cards.length;
    }

    // 8. Local processed-SMS ledger AND the persistent ingestion cursor.
    // Without this, clearing transactions would be pointless: the ledger
    // would still claim every SMS was processed and the cursor would
    // point at the newest message, so the history could never be
    // re-ingested. These two fields make a reset truly "fresh".
    try {
      final cleared = await processedSmsLocal.clearForUser(userId);
      counts.processedSms = cleared;
    } catch (e) {
      logError('DATA_RESET local processed-SMS ledger failed', e);
    }
    try {
      await syncStateStore.clear(userId);
      counts.syncCursorCleared = true;
    } catch (e) {
      logError('DATA_RESET SMS sync cursor clear failed', e);
    }

    // 8. Remote cleanup (best-effort; log failures, do not abort).
    await _remoteCleanup(userId, counts);

    logInfo('DATA_RESET_DONE counts=$counts');
    return counts;
  }

  Future<void> _remoteCleanup(String userId, ResetCounts counts) async {
    try {
      final remoteTxns =
          await transactionRemote.getTransactions(userId: userId, limit: 1000);
      for (final t in remoteTxns) {
        await transactionRemote.deleteTransaction(t.id);
        counts.remoteTransactions++;
      }
    } catch (e) {
      logError('DATA_RESET remote transactions failed', e);
    }

    try {
      final sms = await smsRemote.getSmsMessages(userId: userId, limit: 1000);
      counts.remoteSmsMessages = sms.length;
    } catch (e) {
      logError('DATA_RESET remote SMS failed', e);
    }
  }
}

/// Record counts cleared by a reset operation.
class ResetCounts {
  int transactions = 0;
  int expenses = 0;
  int bankMovements = 0;
  int bankAccounts = 0;
  int cashMovements = 0;
  int wallets = 0;
  int monthlyIncomes = 0;
  int itemUsages = 0;
  int detectedCards = 0;
  int remoteTransactions = 0;
  int remoteSmsMessages = 0;
  int processedSms = 0;
  bool syncCursorCleared = false;

  @override
  String toString() =>
      'ResetCounts(txns=$transactions, expenses=$expenses, bankMovements=$bankMovements, '
      'bankAccounts=$bankAccounts, cashMovements=$cashMovements, wallets=$wallets, '
      'monthlyIncomes=$monthlyIncomes, itemUsages=$itemUsages, detectedCards=$detectedCards, '
      'remoteTxns=$remoteTransactions, remoteSms=$remoteSmsMessages, '
      'processedSms=$processedSms, cursorCleared=$syncCursorCleared)';
}