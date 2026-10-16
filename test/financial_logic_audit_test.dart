import "package:flutter_test/flutter_test.dart";
import "package:floosy/data/models/transaction_model.dart";
import "package:floosy/data/models/money_model.dart";
import "package:floosy/data/models/detected_card_model.dart";
import "package:floosy/data/services/sms_parser_service.dart";

void main() {
  group("SMS Parser - Direction & Card Identification", () {
    test("incoming transfer is correctly identified as transfer_in", () async {
      const sms = "InstaPay: You received EGP 1,500.00 from ahmed@example. Balance EGP 5500.00";
      final result = await SMSParser.parse(smsContent: sms, sender: "IPN");
      expect(result.type, TransactionType.transfer_in);
      expect(result.type?.isIncoming, isTrue);
      expect(result.type?.isOutgoing, isFalse);
    });

    test("outgoing transfer is correctly identified as transfer_out", () async {
      const sms = "InstaPay: You sent EGP 300.00 to sara@example. Ref 889922. Balance EGP 5200.00";
      final result = await SMSParser.parse(smsContent: sms, sender: "IPN");
      expect(result.type, TransactionType.transfer_out);
      expect(result.type?.isIncoming, isFalse);
      expect(result.type?.isOutgoing, isTrue);
    });

    test("purchase is correctly identified as purchase", () async {
      const sms = "CIB: Purchase of EGP 50.00 at KOSHARY ABU TAREK on card ****1234. Available balance EGP 5000.00";
      final result = await SMSParser.parse(smsContent: sms, sender: "CIB");
      expect(result.type, TransactionType.purchase);
      expect(result.cardLast4, "1234");
    });

    test("ATM withdrawal is correctly identified", () async {
      const sms = "CIB: ATM withdrawal of EGP 1000.00 from atm downtown. Available balance EGP 4000.00";
      final result = await SMSParser.parse(smsContent: sms, sender: "CIB");
      expect(result.type, TransactionType.atm_withdrawal);
    });

    test("Arabic added money is incoming", () async {
      // Restored literal: the original source had the Arabic characters
      // corrupted into '?' placeholders, which made this test impossible to
      // pass. This is the mobile-banking "amount added to the account" form
      // the parser documents (money IN -> transfer_in).
      const sms =
          'CIB: تم اضافة مبلغ 500.00 جم / الموبايل والانترنت البنكي في حسابك , يوم 12/09/26';
      final result = await SMSParser.parse(smsContent: sms, sender: "CIB");
      expect(result.type, TransactionType.transfer_in);
      expect(result.type?.isIncoming, isTrue);
    });
  });

  group("TransactionType - Financial Rules", () {
    test("income is incoming and does not count towards deducted", () {
      expect(TransactionType.income.isIncoming, isTrue);
      expect(TransactionType.income.isOutgoing, isFalse);
      expect(TransactionType.income.countsTowardsDeducted, isFalse);
    });

    test("transfer_in is incoming and does not count towards deducted", () {
      expect(TransactionType.transfer_in.isIncoming, isTrue);
      expect(TransactionType.transfer_in.isOutgoing, isFalse);
      expect(TransactionType.transfer_in.countsTowardsDeducted, isFalse);
    });

    test("purchase is outgoing and counts towards deducted", () {
      expect(TransactionType.purchase.isIncoming, isFalse);
      expect(TransactionType.purchase.isOutgoing, isTrue);
      expect(TransactionType.purchase.countsTowardsDeducted, isTrue);
    });

    test("atm_withdrawal is outgoing but does NOT count towards deducted", () {
      expect(TransactionType.atm_withdrawal.isIncoming, isFalse);
      expect(TransactionType.atm_withdrawal.isOutgoing, isTrue);
      expect(TransactionType.atm_withdrawal.countsTowardsDeducted, isFalse);
    });

    test("cash_expense is outgoing and counts towards deducted", () {
      expect(TransactionType.cash_expense.isIncoming, isFalse);
      expect(TransactionType.cash_expense.isOutgoing, isTrue);
      expect(TransactionType.cash_expense.countsTowardsDeducted, isTrue);
    });

    test("transfer_out is outgoing and counts towards deducted", () {
      expect(TransactionType.transfer_out.isIncoming, isFalse);
      expect(TransactionType.transfer_out.isOutgoing, isTrue);
      expect(TransactionType.transfer_out.countsTowardsDeducted, isTrue);
    });
  });

  group("DetectedCard - Card Isolation", () {
    test("card appearance eye visibility is independent per card", () {
      final cardA = DetectedCard(
        id: "card-a",
        userId: "user1",
        last4: "1234",
        appearance: const CardAppearance(eyeVisible: false),
      );
      final cardB = DetectedCard(
        id: "card-b",
        userId: "user1",
        last4: "5678",
        appearance: const CardAppearance(eyeVisible: true),
      );
      
      expect(cardA.appearance.eyeVisible, isFalse);
      expect(cardB.appearance.eyeVisible, isTrue);
    });

    test("credit card has credit limit and balance tracking", () {
      final creditCard = DetectedCard(
        id: "credit-1",
        userId: "user1",
        last4: "1111",
        isCreditCard: true,
        creditLimitMinor: 1000000,
        currentBalanceMinor: 500000,
      );
      
      expect(creditCard.isCreditCard, isTrue);
      expect(creditCard.creditLimitMinor, 1000000);
      expect(creditCard.currentBalanceMinor, 500000);
    });

    test("debit card does not have credit limit", () {
      final debitCard = DetectedCard(
        id: "debit-1",
        userId: "user1",
        last4: "2222",
        isCreditCard: false,
      );
      
      expect(debitCard.isCreditCard, isFalse);
      expect(debitCard.creditLimitMinor, 0);
      expect(debitCard.currentBalanceMinor, 0);
    });
  });

  group("MoneySummary - Card-Specific Values", () {
    test("MoneySummary stores card-specific values", () {
      const summary = MoneySummary(
        myBalanceMinor: 500000,
        deductedMinor: 200000,
        pocketCashMinor: 100000,
        monthlyIncomeMinor: 300000,
      );
      
      expect(summary.myBalanceMinor, 500000);
      expect(summary.deductedMinor, 200000);
      expect(summary.pocketCashMinor, 100000);
      expect(summary.monthlyIncomeMinor, 300000);
    });

    test("MoneySummary.zero returns all zeros", () {
      final zero = MoneySummary.zero();
      expect(zero.myBalanceMinor, 0);
      expect(zero.deductedMinor, 0);
      expect(zero.pocketCashMinor, 0);
      expect(zero.monthlyIncomeMinor, 0);
    });
  });
}
