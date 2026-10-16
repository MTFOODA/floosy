import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/item_model.dart';
import 'package:floosy/data/models/budget_model.dart';

// Stand-in for the private _parseTransactionType in TransactionLocalDataSource.
// Mirrors the fixed logic: compare e.toString() == value directly.
TransactionType _testParseTransactionType(String value) {
  return TransactionType.values.firstWhere(
    (e) => e.toString() == value,
    orElse: () => TransactionType.purchase,
  );
}

// Simulates the getDeductedForMonth / getIncomingForMonth logic
// using the fixed _parseTransactionType and the type extension getters.
Map<String, int> calculateBuckets(List<Transaction> txs) {
  var deducted = 0;
  var myBalance = 0;
  var pocketCash = 0;
  for (final t in txs) {
    final type = _testParseTransactionType(t.type.toString());
    if (type == TransactionType.atm_withdrawal) {
      pocketCash += t.amountMinor;
    } else if (type.countsTowardsDeducted) {
      deducted += t.amountMinor;
    } else if (type.isIncoming) {
      myBalance += t.amountMinor;
    }
  }
  return {
    'deducted': deducted,
    'myBalance': myBalance,
    'pocketCash': pocketCash,
  };
}

Transaction _makeTxn(TransactionType type, int amountMinor) {
  return Transaction(
    id: 't-${type.name}-$amountMinor',
    userId: 'user-1',
    type: type,
    source: TransactionSource.sms,
    amountMinor: amountMinor,
    currency: 'EGP',
    transactionDate: DateTime.utc(2026, 9, 15),
    fingerprint: 'fp-$amountMinor',
  );
}

void main() {
  group('Transaction model', () {
    test('round-trips through Supabase snake_case JSON', () {
      final transaction = Transaction(
        id: 't-1',
        userId: 'user-1',
        bankId: 'bank-1',
        type: TransactionType.purchase,
        source: TransactionSource.sms,
        amountMinor: 12550,
        currency: 'EGP',
        transactionDate: DateTime.utc(2026, 1, 15, 10, 30),
        merchantName: 'Carrefour',
        cardLast4: '1234',
        fingerprint: 'abc123',
      );

      final json = transaction.toJson();
      // Money stays integer minor units — never doubles.
      expect(json['amount_minor'], 12550);
      expect(json['user_id'], 'user-1');
      expect(json['transaction_date'], contains('2026-01-15'));

      final restored = Transaction.fromJson(json);
      expect(restored, transaction);
    });

    test('expense JSON uses payment_method enum and minor units', () {
      final expense = Expense(
        id: 'e-1',
        userId: 'user-1',
        categoryId: 'cat-1',
        amountMinor: 9900,
        expenseDate: DateTime.utc(2026, 2, 1),
        paymentMethod: PaymentMethod.cash,
      );

      final json = expense.toJson();
      expect(json['amount_minor'], 9900);
      expect(json['payment_method'], 'cash');

      final restored = Expense.fromJson(json);
      expect(restored, expense);
    });

    test('SMS message maps message_hash and processing fields', () {
      final message = SMSMessage(
        id: 's-1',
        userId: 'user-1',
        sender: 'CIB',
        messageHash: 'hash-1',
        receivedAt: DateTime.utc(2026, 2, 1, 9),
        processingStatus: 'processed',
        transactionId: 't-9',
        confidence: 0.9,
      );

      final restored = SMSMessage.fromJson(message.toJson());
      expect(restored, message);
    });
  });

  group('Item model', () {
    test('round-trips with price in minor units and archive flags', () {
      const item = Item(
        id: 'i-1',
        userId: 'user-1',
        name: 'Water',
        nameAr: 'مياه',
        priceMinor: 500,
        currency: 'EGP',
        isActive: true,
        isArchived: false,
      );

      final json = item.toJson();
      expect(json['price_minor'], 500);
      expect(json['name_ar'], 'مياه');

      final restored = Item.fromJson(json);
      expect(restored, item);
    });

    test('cash movement ledger entry maps reference fields', () {
      final movement = CashMovement(
        id: 'm-1',
        userId: 'user-1',
        walletId: 'w-1',
        type: 'atm_withdrawal',
        amountMinor: 100000,
        referenceType: 'transaction',
        referenceId: 't-2',
        description: 'ATM withdrawal',
        movementDate: DateTime.utc(2026, 2, 1, 12),
      );

      final restored = CashMovement.fromJson(movement.toJson());
      expect(restored, movement);
    });
  });

  group('Budget model', () {
    test('recurring expense keeps frequency enum through JSON', () {
      final expense = RecurringExpense(
        id: 'r-1',
        userId: 'user-1',
        name: 'Rent',
        amountMinor: 500000,
        frequency: RecurringFrequency.monthly,
        nextDueDate: DateTime.utc(2026, 3, 1),
        startDate: DateTime.utc(2026, 1, 1),
      );

      final json = expense.toJson();
      expect(json['frequency'], 'monthly');
      expect(json['amount_minor'], 500000);

      final restored = RecurringExpense.fromJson(json);
      expect(restored, expense);
    });

    test('saving recommendation maps reduction percentage', () {
      const rec = SavingRecommendation(
        id: 'sr-1',
        userId: 'user-1',
        itemId: 'i-1',
        baselineAmountMinor: 30000,
        currentAmountMinor: 30000,
        reductionPercentage: 10,
        estimatedSavingMinor: 3000,
        month: 2,
        year: 2026,
      );

      final restored = SavingRecommendation.fromJson(rec.toJson());
      expect(restored, rec);
    });
  });

  group('Transaction type parsing (regression)', () {
    test('all enum values round-trip through toString() parsing', () {
      // Regression: _parseTransactionType used to prepend 'TransactionType.'
      // again, causing all values to fall back to purchase.
      for (final type in TransactionType.values) {
        final stored = type.toString(); // "TransactionType.purchase" etc.
        final parsed = _testParseTransactionType(stored);
        expect(parsed, type,
            reason: '$type should round-trip through stored value "$stored"');
      }
    });

    test('unknown stored value falls back to purchase', () {
      final parsed = _testParseTransactionType('TransactionType.unknown');
      expect(parsed, TransactionType.purchase);
    });

    test('malformed stored value falls back to purchase', () {
      final parsed = _testParseTransactionType('garbage');
      expect(parsed, TransactionType.purchase);
    });
  });

  group('Balance bucket mapping (regression)', () {
    test('purchase → Deducted, NOT Pocket Cash', () {
      expect(TransactionType.purchase.countsTowardsDeducted, isTrue);
      expect(TransactionType.purchase.isOutgoing, isTrue);
    });

    test('transfer_out → Deducted, NOT Pocket Cash', () {
      expect(TransactionType.transfer_out.countsTowardsDeducted, isTrue);
      expect(TransactionType.transfer_out.isOutgoing, isTrue);
    });

    test('atm_withdrawal → Pocket Cash, NOT Deducted', () {
      expect(TransactionType.atm_withdrawal.isOutgoing, isTrue);
      // ATM withdrawal reduces bank balance (outgoing) but goes to Pocket Cash,
      // not Deducted.
      expect(TransactionType.atm_withdrawal.countsTowardsDeducted, isFalse);
    });

    test('transfer_in → My Balance, NOT Pocket Cash', () {
      expect(TransactionType.transfer_in.isIncoming, isTrue);
      expect(TransactionType.transfer_in.countsTowardsDeducted, isFalse);
    });

    test('income → My Balance, NOT Pocket Cash', () {
      expect(TransactionType.income.isIncoming, isTrue);
      expect(TransactionType.income.countsTowardsDeducted, isFalse);
    });
  });

  group('DashboardBalanceCalculationRegression', () {
    test('mixed transaction set maps to correct buckets', () {
      final txs = [
        _makeTxn(TransactionType.purchase, 100), // Deducted
        _makeTxn(TransactionType.purchase, 50), // Deducted (online purchase)
        _makeTxn(TransactionType.transfer_out, 200), // Deducted
        _makeTxn(TransactionType.atm_withdrawal, 300), // Pocket Cash
        _makeTxn(TransactionType.transfer_in, 150), // My Balance
        _makeTxn(TransactionType.income, 250), // My Balance (deposit)
      ];

      final buckets = calculateBuckets(txs);

      expect(buckets['deducted'], 100 + 50 + 200); // 350
      expect(buckets['pocketCash'], 300);
      expect(buckets['myBalance'], 150 + 250); // 400
    });

    test('purchase never goes to Pocket Cash', () {
      final txs = [_makeTxn(TransactionType.purchase, 999)];
      final buckets = calculateBuckets(txs);
      expect(buckets['pocketCash'], 0);
      expect(buckets['deducted'], 999);
    });

    test('ATM withdrawal never goes to Deducted', () {
      final txs = [_makeTxn(TransactionType.atm_withdrawal, 500)];
      final buckets = calculateBuckets(txs);
      expect(buckets['deducted'], 0);
      expect(buckets['pocketCash'], 500);
    });

    test('incoming transfer never goes to Pocket Cash', () {
      final txs = [_makeTxn(TransactionType.transfer_in, 400)];
      final buckets = calculateBuckets(txs);
      expect(buckets['pocketCash'], 0);
      expect(buckets['myBalance'], 400);
    });
  });

}
