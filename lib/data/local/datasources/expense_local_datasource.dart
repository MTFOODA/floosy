import 'package:drift/drift.dart';
import '../../models/transaction_model.dart';
import '../database/app_database.dart' as db;

/// Offline-first storage for expenses, expense items and item usage rows.
/// Kept separate from the money ledger so repositories stay focused.
class ExpenseLocalDataSource {
  final db.AppDatabase _db;

  ExpenseLocalDataSource(this._db);

  Future<void> insertExpense(Expense expense) async {
    await _db.into(_db.expenses).insert(db.ExpensesCompanion(
          id: Value(expense.id),
          userId: Value(expense.userId),
          transactionId: Value(expense.transactionId),
          categoryId: Value(expense.categoryId),
          amountMinor: Value(expense.amountMinor),
          currency: Value(expense.currency),
          expenseDate: Value(expense.expenseDate),
          paymentMethod: Value(expense.paymentMethod.name),
          merchantId: Value(expense.merchantId),
          notes: Value(expense.notes),
          createdAt: Value(expense.createdAt ?? DateTime.now()),
          updatedAt: Value(expense.updatedAt ?? DateTime.now()),
        ));
  }

  Future<List<Expense>> getExpenses(String userId) async {
    final rows = await (_db.select(_db.expenses)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.expenseDate, mode: OrderingMode.desc)
          ]))
        .get();
    return rows.map(_mapExpense).toList();
  }

  Future<void> deleteExpense(String id) async {
    await (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }

  Future<void> insertExpenseItem(ExpenseItem item) async {
    await _db.into(_db.expenseItems).insert(db.ExpenseItemsCompanion(
          id: Value(item.id),
          expenseId: Value(item.expenseId),
          itemId: Value(item.itemId),
          quantity: Value(item.quantity),
          unitPriceMinor: Value(item.unitPriceMinor),
          totalPriceMinor: Value(item.totalPriceMinor),
          createdAt: Value(item.createdAt ?? DateTime.now()),
        ));
  }

  Future<List<ExpenseItem>> getExpenseItems(String expenseId) async {
    final rows = await (_db.select(_db.expenseItems)
          ..where((t) => t.expenseId.equals(expenseId)))
        .get();
    return rows
        .map((r) => ExpenseItem(
              id: r.id,
              expenseId: r.expenseId,
              itemId: r.itemId,
              quantity: r.quantity,
              unitPriceMinor: r.unitPriceMinor,
              totalPriceMinor: r.totalPriceMinor,
              createdAt: r.createdAt,
            ))
        .toList();
  }

  Expense _mapExpense(db.Expense row) {
    return Expense(
      id: row.id,
      userId: row.userId,
      transactionId: row.transactionId,
      categoryId: row.categoryId,
      amountMinor: row.amountMinor,
      currency: row.currency,
      expenseDate: row.expenseDate,
      paymentMethod:
          row.paymentMethod == 'cash' ? PaymentMethod.cash : PaymentMethod.card,
      merchantId: row.merchantId,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
