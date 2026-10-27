import '../entities/item_model.dart' as items;
import '../entities/detected_card_model.dart';
import '../entities/money_model.dart';
import '../entities/transaction_model.dart';
import '../services/card_balance_calculator.dart';
import '../services/card_ownership.dart';
import '../entities/card_resolution_result.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class MoneyRepository {
  Future<List<MonthlyIncome>> getMonthlyIncomes(String userId,
      {int? year, int? month});

  Future<void> addMonthlyIncome(
      {required String userId,
      required int year,
      required int month,
      String? label,
      required int amountMinor});

  Future<bool> purchaseItemWithCash({
    required String userId,
    required items.Item item,
    required String cardLast4,
    String? bankName,
    String? purchaseId,
  });

  Future<void> retryItemCashMovements(String userId);

  Future<void> purchaseItemWithCard(
      {required String userId,
      required items.Item item,
      required String cardLast4,
      String? bankName});

  Future<void> addBalanceManually({
    required String userId,
    required String cardLast4,
    required int amountMinor,
    String? bankName,
    String currency = 'EGP',
    String? note,
  });

  Future<CardBalance> getCardBalance(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<List<Transaction>> getUnassignedTransactions(String userId);

  Future<List<Transaction>> getTransactionsForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<SmartResolutionResult> learnCardIdentity({
    required String userId,
    required String transactionId,
    required String? last4,
    String? bankIdentityOverride,
  });

  Future<DetectedCard?> findLearnedCardIdentity({
    required String userId,
    required String last4,
    String? bankName,
  });

  Future<DetectedCard?> findLearnedSmsCard(
      {required String userId,
      required String? sender,
      required String body,
      required String? bankName,
      required TransactionType? type});

  Future<CardOwnershipResolution> previewCardIdentity({
    required String userId,
    String? last4,
    String? bankIdentity,
  });

  Future<SmartResolutionResult> resolveCardIdentityForUserInput({
    required String userId,
    required String transactionId,
    String? last4,
    String? bankIdentity,
  });

  Future<int> backfillCardIdentities(String userId);

  Future<int> getFixedAmountForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<int?> getMaxAddableForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<bool> canAddBalanceForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<void> setFixedAmountForCard({
    required String userId,
    required String cardLast4,
    required int fixedAmountMinor,
    String? bankName,
    bool? cashWithdrawalEnabled,
  });

  Future<int> getMyBalanceForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<int> getDeductedMoneyForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<bool> isPocketCashVisibleForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<int> getPocketCashForCard(
    String userId,
    String cardLast4, {
    String? bankName,
  });

  Future<List<UserBankAccount>> getBankAccounts(String userId);

  Future<int> getMonthlyIncomeSum(String userId, int year, int month);

  Future<MoneySummary> getMoneySummary(String userId);

  Future<bool> recordSmsTransaction(
      {required String userId,
      required Transaction transaction,
      String? accountId});
}
