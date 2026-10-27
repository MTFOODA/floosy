import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/money_model.dart';

/// Remote (Supabase) data source for monthly income, user bank accounts and
/// their ledger movements.
class MoneyRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  MoneyRemoteDataSource(this._supabaseClient);

  // ── Monthly income ─────────────────────────────────────────────────────────

  Future<MonthlyIncome> createMonthlyIncome(MonthlyIncome income) async {
    final withId = income.id.isEmpty ? income.copyWith(id: _uuid.v4()) : income;
    final json = withId.toJson()
      ..remove('created_at')
      ..remove('updated_at');
    final response = await _supabaseClient
        .from('monthly_incomes')
        .insert(json)
        .select()
        .single();
    return MonthlyIncome.fromJson(response);
  }

  Future<List<MonthlyIncome>> getMonthlyIncomes(
    String userId, {
    int? year,
    int? month,
  }) async {
    var query =
        _supabaseClient.from('monthly_incomes').select().eq('user_id', userId);
    if (year != null) query = query.eq('year', year);
    if (month != null) query = query.eq('month', month);
    final response = await query
        .order('year', ascending: false)
        .order('month', ascending: false);
    return (response as List)
        .map((json) => MonthlyIncome.fromJson(json))
        .toList();
  }

  Future<void> updateMonthlyIncome(MonthlyIncome income) async {
    await _supabaseClient
        .from('monthly_incomes')
        .update(income.toJson()..remove('created_at'))
        .eq('id', income.id);
  }

  Future<void> deleteMonthlyIncome(String incomeId) async {
    await _supabaseClient.from('monthly_incomes').delete().eq('id', incomeId);
  }

  // ── Bank accounts ──────────────────────────────────────────────────────────

  Future<UserBankAccount> createBankAccount(UserBankAccount account) async {
    final withId =
        account.id.isEmpty ? account.copyWith(id: _uuid.v4()) : account;
    final response = await _supabaseClient
        .from('user_bank_accounts')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return UserBankAccount.fromJson(response);
  }

  Future<List<UserBankAccount>> getBankAccounts(String userId) async {
    final response = await _supabaseClient
        .from('user_bank_accounts')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    return (response as List)
        .map((json) => UserBankAccount.fromJson(json))
        .toList();
  }

  Future<UserBankAccount> updateBankAccount(UserBankAccount account) async {
    final response = await _supabaseClient
        .from('user_bank_accounts')
        .update(account.toJson()..remove('created_at'))
        .eq('id', account.id)
        .select()
        .single();
    return UserBankAccount.fromJson(response);
  }

  Future<void> deleteBankAccount(String accountId) async {
    await _supabaseClient
        .from('user_bank_accounts')
        .delete()
        .eq('id', accountId);
  }

  Future<List<BankAccountWithBalance>> getAccountsWithBalance(
      String userId) async {
    try {
      final rows = (await _supabaseClient.rpc('get_bank_accounts_with_balance',
          params: {'user_id_param': userId})) as List;
      final result = <BankAccountWithBalance>[];
      for (final row in rows) {
        result.add(BankAccountWithBalance(
          account: UserBankAccount(
            id: row['id'],
            userId: userId,
            name: row['name'],
            bankId: row['bank_id'],
            currency: row['currency'],
            openingBalanceMinor: _asInt(row['opening_balance_minor']),
            isActive: row['is_active'] ?? true,
          ),
          balanceMinor: _asInt(row['balance_minor']),
        ));
      }
      return result;
    } catch (_) {
      // Fallback: compute balances from accounts + movements.
      final accounts = await getBankAccounts(userId);
      final movements = await getBankMovements(userId);
      final result = <BankAccountWithBalance>[];
      for (final account in accounts.where((a) => a.isActive)) {
        var balance = account.openingBalanceMinor;
        for (final m in movements.where((m) => m.accountId == account.id)) {
          balance += m.type == 'in' ? m.amountMinor : -m.amountMinor;
        }
        result.add(BankAccountWithBalance(
          account: account,
          balanceMinor: balance,
        ));
      }
      return result;
    }
  }

  Future<int> getTotalBankBalance(String userId) async {
    final response = await _supabaseClient
        .rpc('get_total_bank_balance', params: {'user_id_param': userId});
    return _asInt(response);
  }

  /// Updates only the card_id field of one transaction (Card ↔ Transaction
  /// relationship, requirement #5). Best-effort from the SMS pipeline.
  Future<void> updateTransactionCardId(
      String transactionId, String cardId) async {
    await _supabaseClient
        .from('transactions')
        .update({'card_id': cardId}).eq('id', transactionId);
  }

  Future<void> deleteTransactionMovements(String transactionId) async {
    await _supabaseClient
        .from('user_bank_movements')
        .delete()
        .eq('reference_type', 'transaction')
        .eq('reference_id', transactionId);
    await _supabaseClient
        .from('cash_movements')
        .delete()
        .eq('reference_type', 'transaction')
        .eq('reference_id', transactionId);
  }

  // ── Bank movements (ledger) ────────────────────────────────────────────────

  Future<BankAccountMovement> createBankMovement(
      BankAccountMovement movement) async {
    final withId =
        movement.id.isEmpty ? movement.copyWith(id: _uuid.v4()) : movement;
    final response = await _supabaseClient
        .from('user_bank_movements')
        .insert(withId.toJson()..remove('created_at'))
        .select()
        .single();
    return BankAccountMovement.fromJson(response);
  }

  Future<List<BankAccountMovement>> getBankMovements(String userId) async {
    final response = await _supabaseClient
        .from('user_bank_movements')
        .select()
        .eq('user_id', userId)
        .order('movement_date', ascending: false)
        .limit(500);
    return (response as List)
        .map((json) => BankAccountMovement.fromJson(json))
        .toList();
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
