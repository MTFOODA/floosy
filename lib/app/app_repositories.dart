import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/app_preferences_repository.dart';
import '../domain/repositories/money_repository.dart';
import '../domain/repositories/item_repository.dart';
import '../domain/repositories/detected_card_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/budget_repository.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/repositories/cash_wallet_repository.dart';
import '../domain/repositories/financial_queries_repository.dart';
import '../domain/repositories/sms_repository.dart';

/// Explicit injection seam shared by production and tests.
class AppRepositories {
  final AccountRepository auth;
  final AppPreferencesRepository preferences;
  final BiometricRepository biometrics;
  final MoneyRepository money;
  final ItemRepository items;
  final DetectedCardRepository cards;
  final UserProfileRepository profile;
  final BudgetRepository budgets;
  final TransactionRepository transactions;
  final CashWalletRepository cash;
  final FinancialQueriesRepository queries;
  final SmsRepository sms;
  final BankMappingsRepository mappings;
  const AppRepositories(
      {required this.auth,
      required this.preferences,
      required this.biometrics,
      required this.money,
      required this.items,
      required this.cards,
      required this.profile,
      required this.budgets,
      required this.transactions,
      required this.cash,
      required this.queries,
      required this.sms,
      required this.mappings});
}
