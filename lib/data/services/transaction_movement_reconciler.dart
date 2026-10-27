import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_model.dart';
import '../../domain/entities/money_model.dart';
import '../../domain/entities/item_model.dart' as item_models;
import '../local/datasources/money_local_datasource.dart';

/// Rebuilds derived ledger movements after a committed transaction edit.
class TransactionMovementReconciler {
  final MoneyLocalDataSource moneyLocal;
  const TransactionMovementReconciler(this.moneyLocal);

  Future<void> reconcile(Transaction previous, Transaction next) async {
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
            updatedAt: DateTime.now());
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
  }
}
