import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/item_model.dart';
import 'package:floosy/data/models/money_model.dart';
import 'package:floosy/data/models/transaction_model.dart';

/// Real-Drift regression tests for the Dashboard money buckets.
///
/// These exercise the ACTUAL queries used by `MoneyRepository.getMoneySummary`
/// (and the SMS pipeline's persistence layer) — not a pure re-implementation —
/// using the exact enum strings stored on disk
/// (`TransactionStatus.confirmed`, `TransactionType.purchase`, …).
void main() {
  group('MoneySummary balance buckets (real Drift datasource)', () {
    late db.AppDatabase database;
    late MoneyLocalDataSource money;
    late TransactionLocalDataSource transactions;

    setUp(() {
      // Fresh in-memory SQLite per test — no platform path provider, no
      // shared on-disk state between tests.
      database = db.AppDatabase(NativeDatabase.memory());
      money = MoneyLocalDataSource(database);
      transactions = TransactionLocalDataSource(database);
    });

    tearDown(() => database.close());

    Future<void> addTxn(
      String id,
      TransactionType type,
      int amountMinor, {
      String? bankId,
      TransactionStatus status = TransactionStatus.confirmed,
    }) async {
      await transactions.insertTransaction(Transaction(
        id: id,
        userId: 'user-1',
        bankId: bankId,
        type: type,
        source: TransactionSource.sms,
        amountMinor: amountMinor,
        currency: 'EGP',
        transactionDate: DateTime(2026, 9, 15, 12),
        fingerprint: 'fp-$id',
        status: status,
      ));
    }

    test('mixed set → Deducted 350, Pocket Cash 300, My Balance 400', () async {
      await addTxn('a', TransactionType.purchase, 100);
      await addTxn('b', TransactionType.purchase, 50); // online purchase
      await addTxn('c', TransactionType.transfer_out, 200);
      await addTxn('d', TransactionType.atm_withdrawal, 300);
      await addTxn('e', TransactionType.transfer_in, 150);
      await addTxn('f', TransactionType.income, 250);

      expect(await money.getDeductedForMonth('user-1', 2026, 9), 350);
      expect(await money.getUnrepresentedIncomingSum('user-1'), 400);

      // ATM withdrawal is the ONLY way Pocket Cash grows.
      await money.insertWallet(
          const CashWallet(id: 'w-1', userId: 'user-1', currency: 'EGP'));
      await money.insertCashMovement(CashMovement(
        id: 'cm-d',
        userId: 'user-1',
        walletId: 'w-1',
        type: 'atm_withdrawal',
        amountMinor: 300,
        referenceType: 'transaction',
        referenceId: 'd',
        movementDate: DateTime(2026, 9, 15, 12),
      ));
      expect(await money.getCashBalance('user-1'), 300);
    });

    test('incoming already in a linked bank account is NOT double counted',
        () async {
      await money.insertBankAccount(
          const UserBankAccount(
              id: 'acc-1', userId: 'user-1', name: 'FAISAL', bankId: 'b1'));
      await addTxn('g', TransactionType.transfer_in, 150, bankId: 'b1');
      await money.insertBankMovement(BankAccountMovement(
        id: 'bm-g',
        accountId: 'acc-1',
        userId: 'user-1',
        type: 'in',
        amountMinor: 150,
        referenceType: 'transaction',
        referenceId: 'g',
        movementDate: DateTime(2026, 9, 15, 12),
      ));

      // The 150 EGP is already in the account balance → not added again.
      expect(await money.getUnrepresentedIncomingSum('user-1'), 0);
      expect(await money.getBankAccountBalance('acc-1'), 150);
    });

    test('manual incoming without any account still lands on My Balance',
        () async {
      await addTxn('j', TransactionType.transfer_in, 150);
      await addTxn('k', TransactionType.income, 250);
      expect(await money.getUnrepresentedIncomingSum('user-1'), 400);
    });

    test('pending transactions count nothing in any bucket', () async {
      await addTxn('h', TransactionType.income, 500,
          status: TransactionStatus.pending);
      await addTxn('i', TransactionType.purchase, 500,
          status: TransactionStatus.pending);
      expect(await money.getDeductedForMonth('user-1', 2026, 9), 0);
      expect(await money.getUnrepresentedIncomingSum('user-1'), 0);
    });

    test('transactions after the month window are excluded from Deducted',
        () async {
      await addTxn('l', TransactionType.purchase, 100);
      // Next month — out of the September window.
      await transactions.insertTransaction(Transaction(
        id: 'm',
        userId: 'user-1',
        type: TransactionType.purchase,
        source: TransactionSource.sms,
        amountMinor: 200,
        currency: 'EGP',
        transactionDate: DateTime(2026, 10, 2, 12),
        fingerprint: 'fp-m',
      ));
      expect(await money.getDeductedForMonth('user-1', 2026, 9), 100);
    });
  });
}