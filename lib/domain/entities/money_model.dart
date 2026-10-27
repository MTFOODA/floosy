import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_model.freezed.dart';
part 'money_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

DateTime _dateTimeFromJsonRequired(dynamic value) =>
    DateTime.parse(value.toString()).toUtc();

/// A monthly income/salary entry for the user (e.g. "September Salary").
@freezed
class MonthlyIncome with _$MonthlyIncome {
  const factory MonthlyIncome({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int year,
    required int month,
    String? label,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'bank_account_id') String? bankAccountId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _MonthlyIncome;

  factory MonthlyIncome.fromJson(Map<String, dynamic> json) =>
      _$MonthlyIncomeFromJson(json);
}

/// A user-owned bank account (multi-bank support).
@freezed
class UserBankAccount with _$UserBankAccount {
  const factory UserBankAccount({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'bank_id') String? bankId,
    @JsonKey(name: 'account_last4') String? accountLast4,
    @JsonKey(name: 'opening_balance_minor') @Default(0) int openingBalanceMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _UserBankAccount;

  factory UserBankAccount.fromJson(Map<String, dynamic> json) =>
      _$UserBankAccountFromJson(json);
}

/// Ledger movement on a bank account. The balance is always derived from
/// the ledger, never stored as a mutable sum.
@freezed
class BankAccountMovement with _$BankAccountMovement {
  const factory BankAccountMovement({
    required String id,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // 'in' | 'out'
    @JsonKey(name: 'amount_minor') required int amountMinor,
    String? description,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime movementDate,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _BankAccountMovement;

  factory BankAccountMovement.fromJson(Map<String, dynamic> json) =>
      _$BankAccountMovementFromJson(json);
}

/// A bank account with its derived current balance (opening + in - out).
class BankAccountWithBalance {
  final UserBankAccount account;
  final int balanceMinor;

  const BankAccountWithBalance({
    required this.account,
    required this.balanceMinor,
  });
}

/// Snapshot of the dashboard money figures.
///
/// All values are stored/computed in integer minor units (piasters for EGP).
class MoneySummary {
  /// Total bank money = sum of every active account balance.
  final int myBalanceMinor;

  /// Money actually spent/sent this month:
  /// purchases + cash expenses + transfers sent.
  final int deductedMinor;

  /// Physical cash currently available after ATM withdrawals.
  final int pocketCashMinor;

  /// Sum of all monthly income entries for the current month.
  final int monthlyIncomeMinor;

  final List<BankAccountWithBalance> accounts;

  const MoneySummary({
    required this.myBalanceMinor,
    required this.deductedMinor,
    required this.pocketCashMinor,
    required this.monthlyIncomeMinor,
    this.accounts = const [],
  });

  /// Returns a MoneySummary with all values set to zero.
  /// Used when no card is selected on the dashboard.
  factory MoneySummary.zero() => const MoneySummary(
        myBalanceMinor: 0,
        deductedMinor: 0,
        pocketCashMinor: 0,
        monthlyIncomeMinor: 0,
      );

  MoneySummary copyWith({
    int? myBalanceMinor,
    int? deductedMinor,
    int? pocketCashMinor,
    int? monthlyIncomeMinor,
    List<BankAccountWithBalance>? accounts,
  }) {
    return MoneySummary(
      myBalanceMinor: myBalanceMinor ?? this.myBalanceMinor,
      deductedMinor: deductedMinor ?? this.deductedMinor,
      pocketCashMinor: pocketCashMinor ?? this.pocketCashMinor,
      monthlyIncomeMinor: monthlyIncomeMinor ?? this.monthlyIncomeMinor,
      accounts: accounts ?? this.accounts,
    );
  }
}

/// Exception thrown when Pocket Cash is not enough to cover an expense.
class InsufficientPocketCashException implements Exception {
  final int requiredMinor;
  final int availableMinor;
  const InsufficientPocketCashException({
    required this.requiredMinor,
    required this.availableMinor,
  });

  @override
  String toString() =>
      'Not enough Pocket Cash (need ${requiredMinor / 100}, have ${availableMinor / 100}).';
}
