import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/item_model.dart';

void main() {
  group('Transaction model JSON round-trip', () {
    test('serializes and deserializes correctly', () {
      final tx = Transaction(
        id: 'test-id',
        userId: 'user-1',
        type: TransactionType.purchase,
        source: TransactionSource.sms,
        amountMinor: 15000,
        currency: 'EGP',
        transactionDate: DateTime.utc(2026, 1, 15),
        fingerprint: 'abc123',
      );
      final json = tx.toJson();
      expect(json['user_id'], equals('user-1'));
      expect(json['amount_minor'], equals(15000));
      final restored = Transaction.fromJson(json);
      expect(restored.id, equals(tx.id));
      expect(restored.amountMinor, equals(tx.amountMinor));
    });
  });

  test('manual transaction source remains manual after a basic edit', () {
    final transaction = Transaction(
      id: 'manual-1', userId: 'u1', type: TransactionType.purchase,
      source: TransactionSource.manual, amountMinor: 100,
      currency: 'EGP', transactionDate: DateTime.utc(2026), fingerprint: 'manual-1',
    );
    final edited = transaction.copyWith(amountMinor: 250, cardLast4: '1234');
    expect(edited.id, transaction.id);
    expect(edited.source, TransactionSource.manual);
    expect(edited.amountMinor, 250);
    expect(edited.cardLast4, '1234');
  });

  group('Item model JSON round-trip', () {
    test('maps snake_case fields correctly', () {
      const item = Item(
        id: 'item-1',
        userId: 'user-1',
        name: 'Water',
        nameAr: 'مية',
        priceMinor: 500,
        currency: 'EGP',
        isActive: true,
        isArchived: false,
      );
      final json = item.toJson();
      expect(json['user_id'], equals('user-1'));
      expect(json['name_ar'], equals('مية'));
      expect(json['price_minor'], equals(500));
      final restored = Item.fromJson(json);
      expect(restored.name, equals('Water'));
      expect(restored.nameAr, equals('مية'));
      expect(restored.priceMinor, equals(500));
    });
  });

  group('CashMovement model JSON round-trip', () {
    test('serializes correctly', () {
      final movement = CashMovement(
        id: 'mov-1',
        userId: 'user-1',
        walletId: 'wallet-1',
        type: 'atm_withdrawal',
        amountMinor: 100000,
        description: 'ATM withdrawal',
        movementDate: DateTime.utc(2026, 1, 15),
      );
      final json = movement.toJson();
      expect(json['user_id'], equals('user-1'));
      expect(json['wallet_id'], equals('wallet-1'));
      expect(json['amount_minor'], equals(100000));
      final restored = CashMovement.fromJson(json);
      expect(restored.type, equals('atm_withdrawal'));
      expect(restored.amountMinor, equals(100000));
    });
  });

  group('Expense model JSON round-trip', () {
    test('maps payment_method correctly', () {
      final expense = Expense(
        id: 'exp-1',
        userId: 'user-1',
        amountMinor: 5000,
        currency: 'EGP',
        expenseDate: DateTime.utc(2026, 1, 15),
        paymentMethod: PaymentMethod.card,
      );
      final json = expense.toJson();
      expect(json['payment_method'], equals('card'));
      final restored = Expense.fromJson(json);
      expect(restored.paymentMethod, equals(PaymentMethod.card));
    });
  });

  group('SMSMessage model JSON round-trip', () {
    test('preserves the complete detection metadata and relationship', () {
      final sms = SMSMessage(
        id: 'sms-1',
        userId: 'user-1',
        messageHash: 'hash123',
        messageBody: 'Bank purchase',
        receivedAt: DateTime.utc(2026, 1, 15, 10, 30),
        bankIdentified: true,
        typeIdentified: true,
        amountIdentified: true,
        currencyIdentified: true,
        cardLast4Identified: true,
        detectedBankName: 'Faisal Bank',
        detectedType: 'purchase',
        detectedAmountMinor: 50000,
        detectedCurrency: 'EGP',
        detectedCardLast4: '1234',
        transactionId: 'txn-1',
      );
      final json = sms.toJson();
      final restored = SMSMessage.fromJson(json);
      expect(restored.messageBody, 'Bank purchase');
      expect(restored.bankIdentified, isTrue);
      expect(restored.typeIdentified, isTrue);
      expect(restored.amountIdentified, isTrue);
      expect(restored.currencyIdentified, isTrue);
      expect(restored.cardLast4Identified, isTrue);
      expect(restored.detectedCardLast4, '1234');
      expect(restored.transactionId, 'txn-1');
    });
  });

  group('Category model JSON round-trip', () {
    test('handles optional user_id correctly', () {
      const category = Category(
        id: 'cat-1',
        name: 'Food',
        nameAr: 'أكل',
      );
      final json = category.toJson();
      expect(json['name'], equals('Food'));
      final restored = Category.fromJson(json);
      expect(restored.nameAr, equals('أكل'));
    });
  });
}

