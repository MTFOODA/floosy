import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';

void main() {
  group('SMSParser — English SMS', () {
    test('parses a card purchase SMS', () async {
      const sms = 'CIB: Purchase of EGP 50.00 at KOSHARY ABU TAREK on card '
          '****1234. Available balance EGP 5000.00';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 5000); // 50.00 EGP = 5000 minor
      expect(result.fingerprint, isNotEmpty);
      expect(result.needsReview, isFalse);
      expect(result.bankName, contains('Commercial International Bank'));
    });

    test('parses an ATM withdrawal SMS', () async {
      const sms = 'CIB: ATM withdrawal of EGP 1000.00 from atm downtown. '
          'Available balance EGP 4000.00';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.atm_withdrawal);
      expect(result.amountMinor, 100000); // 1000 EGP
    });

    test('parses an InstaPay transfer received SMS', () async {
      const sms = 'InstaPay: You received EGP 1,500.00 from ahmed@example. '
          'Balance EGP 5500.00';

      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');

      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 150000);
    });

    test('parses an InstaPay transfer sent SMS', () async {
      const sms = 'InstaPay: You sent EGP 300.00 to sara@example. '
          'Ref 889922. Balance EGP 5200.00';

      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');

      expect(result.type, TransactionType.transfer_out);
      expect(result.amountMinor, 30000);
    });

    test('parses a wallet (Vodafone Cash) received SMS', () async {
      const sms =
          'Vodafone Cash: received transfer of EGP 200 from 01001234567. '
          'Wallet balance EGP 700.00';

      final result =
          await SMSParser.parse(smsContent: sms, sender: 'Vodafone Cash');

      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 20000);
    });

    test('parses a wallet (Vodafone Cash) sent SMS', () async {
      const sms = 'Vodafone Cash: You sent EGP 75.00 to 01112345678. '
          'Wallet balance EGP 625.00';

      final result =
          await SMSParser.parse(smsContent: sms, sender: 'Vodafone Cash');

      expect(result.type, TransactionType.transfer_out);
      expect(result.amountMinor, 7500);
    });

    test('flags unknown transaction type for review (no guessing)', () async {
      const sms =
          'CIB: Your statement is ready. Balance EGP 9000.00 Reference 55331';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, isNull);
      expect(result.needsReview, isTrue);
    });
  });

  group('SMSParser — Arabic SMS', () {
    test('parses an Arabic purchase SMS', () async {
      const sms = 'CIB: تم خصم 150.00 جنيه شراء من كارفور. '
          'الرصيد المتاح 4850.00 جنيه';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 15000);
    });

    test('parses an Arabic ATM withdrawal SMS', () async {
      const sms = 'CIB: سحب مبلغ 2000.00 جنيه من ماكينة الصراف الآلي. '
          'الرصيد المتاح 2850.00 جنيه';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.atm_withdrawal);
      expect(result.amountMinor, 200000);
    });

    test('parses Arabic-Indic digits', () async {
      const sms = 'CIB: تم خصم ٥٠ جنيه شراء من محل. الرصيد المتاح ٤٨٥٠ جنيه';

      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 5000);
    });

    test('parses an Arabic InstaPay received SMS', () async {
      const sms = 'انستا باي: تم استلام تحويل لحظي بمبلغ 800.00 جنيه من محمد';

      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');

      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 80000);
    });

    test('parses an Arabic wallet sent SMS', () async {
      const sms = 'فودافون كاش: تم تحويل 45.00 جنيه من محفظتك إلى 01001234567';

      final result =
          await SMSParser.parse(smsContent: sms, sender: 'Vodafone Cash');

      expect(result.type, TransactionType.transfer_out);
      expect(result.amountMinor, 4500);
    });
  });

  group('SMSParser — bank detection', () {
    test('detects bank from sender code', () async {
      final result = await SMSParser.parse(
        smsContent: 'Purchase of EGP 50.00 at Carrefour',
        sender: 'CIB',
      );
      expect(result.bankName, contains('Commercial International Bank'));
    });

    test('detects bank from body text', () async {
      final result = await SMSParser.parse(
        smsContent: 'Banque Misr: purchase of EGP 25.00 at a shop',
        sender: 'unknown-sender',
      );
      expect(result.bankName, contains('Misr'));
    });

    test('returns unknown bank without guessing', () async {
      final result = await SMSParser.parse(
        smsContent: 'Purchase of EGP 50.00 at Carrefour',
        sender: '9999',
      );
      // The parser does not invent a bank when none is detected.
      expect(result.hasBank, isFalse);
    });
  });

  group('SMSParser — duplicate protection', () {
    test('same SMS produces the same fingerprint', () async {
      const sms = 'CIB: Purchase of EGP 25.50 at AMAZON on card ****9999';

      final first = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      final second = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(first.fingerprint, second.fingerprint);
    });

    test('balance drift does not change the fingerprint', () async {
      const sms1 = 'CIB: Purchase of EGP 25.50 at AMAZON. '
          'Available balance EGP 5000.00';
      const sms2 = 'CIB: Purchase of EGP 25.50 at AMAZON. '
          'Available balance EGP 4974.50';

      final first = await SMSParser.parse(smsContent: sms1, sender: 'CIB');
      final second = await SMSParser.parse(smsContent: sms2, sender: 'CIB');

      expect(first.fingerprint, second.fingerprint);
    });

    test('different amounts produce different fingerprints', () async {
      const sms1 = 'CIB: Purchase of EGP 25.50 at AMAZON';
      const sms2 = 'CIB: Purchase of EGP 55.50 at AMAZON';

      final first = await SMSParser.parse(smsContent: sms1, sender: 'CIB');
      final second = await SMSParser.parse(smsContent: sms2, sender: 'CIB');

      expect(first.fingerprint, isNot(second.fingerprint));
    });
  });

  group('SMSParser — privacy & misc', () {
    test('preview is sanitized and truncated (no raw storage)', () async {
      final longBody = 'CIB: ${'x' * 300}';
      final result = await SMSParser.parse(smsContent: longBody, sender: 'CIB');
      expect(result.preview.length, lessThanOrEqualTo(120));
    });

    test('non-financial SMS is not classified', () async {
      const sms = 'Hello, this is a promotional message with no money info';

      final result = await SMSParser.parse(smsContent: sms, sender: 'PROMO');

      expect(result.type, isNull);
      expect(result.needsReview, isTrue);
    });

    test('matchesBankPattern still works', () async {
      const bank = Bank(
        id: 'bank-1',
        name: 'Commercial International Bank',
        code: 'CIB',
      );
      expect(
        SMSParser.matchesBankPattern('CIB: Purchase 10 EGP', bank),
        isTrue,
      );
      expect(
        SMSParser.matchesBankPattern('Other bank message', bank),
        isFalse,
      );
    });
  });

  group('SMSParser — currency detection (requirement #3)', () {
    test('detects USD amount and currency', () async {
      const sms = 'ENBD: Purchase of \$25.50 at Amazon on card ****4582. '
          'Balance \$1,200.00';
      final result = await SMSParser.parse(smsContent: sms, sender: 'ENBD');
      expect(result.currency, 'USD');
      expect(result.amountMinor, 2550); // 25.50 USD
      expect(result.cardLast4, '4582');
    });

    test('detects EUR before amount', () async {
      const sms = 'HSBC: Online purchase EUR 120.00 at eBay card ****7712';
      final result = await SMSParser.parse(smsContent: sms, sender: 'HSBC');
      expect(result.currency, 'EUR');
      expect(result.amountMinor, 12000);
    });

    test('detects SAR via bank heuristic (ENBD → AED fallback path)', () async {
      const sms = 'ENBD: Payment of 500 at merchant card ****3301';
      final result = await SMSParser.parse(smsContent: sms, sender: 'ENBD');
      // ENBD is a Gulf bank → AED heuristic applies.
      expect(result.currency, 'AED');
    });

    test('defaults to EGP when no foreign currency present', () async {
      const sms = 'CIB: Purchase of EGP 100 at Carrefour card ****9900';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.currency, 'EGP');
      expect(result.amountMinor, 10000);
    });

    test('detects ج.م (Arabic pound symbol)', () async {
      const sms = 'بنك مصر: شراء 200 ج.م من متجر نور بطاقة ****1144';
      final result = await SMSParser.parse(smsContent: sms, sender: 'MISR');
      expect(result.currency, 'EGP');
    });

    test('detects جم amount format (EGP currency with جم)', () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.currency, 'EGP');
      expect(result.amountMinor, 1000); // 10.00 EGP = 1000 minor units
    });

    test('detects جم with spacing', () async {
      const sms = 'FAISAL BANK: تم تحويل IPN بمبلغ 10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.currency, 'EGP');
      expect(result.amountMinor, 1000); // 10.00 EGP = 1000 minor units
    });
  });

  group('SMSParser — Faisal Bank (requirement #5)', () {
    test('detects Faisal Bank from sender', () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.bankName, contains('Faisal'));
    });

    test('parses Faisal Bank transfer with correct direction', () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجeci 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.type, TransactionType.transfer_out);
      expect(result.amountMinor, 1000);
      expect(result.currency, 'EGP');
    });

    test('Faisal Bank reference number is not treated as card last-4',
        () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.cardLast4, isNull);
    });

    test('حسابكم is not treated as merchant', () async {
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.merchant, isNull);
    });

    test('حسابكم is not treated as merchant (alternate)', () async {
      const sms = 'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.merchant, isNull);
    });
  });

  group('SMSParser — transaction types (requirement #2)', () {
    test('classifies deposit', () async {
      const sms = 'CIB: Cash deposit of EGP 2,000.00 to your account. '
          'Balance EGP 7000.00';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      // Deposit maps to income (credit).
      expect(result.type, TransactionType.income);
    });

    test('classifies Arabic deposit (تم إيداع)', () async {
      const sms = 'الأهلي: تم إيداع 1000 جنيه في حسابك بطاقة ****2233';
      final result = await SMSParser.parse(smsContent: sms, sender: 'NBE');
      expect(result.type, TransactionType.income);
      expect(result.cardLast4, '2233');
    });

    test('classifies transfer received (استقبلت تحويل)', () async {
      const sms = 'CIB: استقبلت تحويل 500 جنيه من أحمد بطاقة ****4455';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.transfer_in);
    });

    test('classifies online purchase', () async {
      const sms =
          'CIB: Online purchase of EGP 349.99 at Jumia via card ****6677';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.purchase);
      expect(result.cardLast4, '6677');
    });

    test('classifies Arabic online purchase (شراء اونلاين)', () async {
      const sms = 'بنك مصر: شراء اونلاين 250 ج.م من نون بطاقة ****8899';
      final result = await SMSParser.parse(smsContent: sms, sender: 'MISR');
      expect(result.type, TransactionType.purchase);
    });

    test('classifies transfer sent (تم تحويل)', () async {
      const sms = 'CIB: تم تحويل 800 جنيه إلى سارة بطاقة ****0011';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.transfer_out);
    });

    test('transfer with خصم is NOT classified as purchase', () async {
      // "خصم" (deduction) appears in transfer SMS but should not trigger
      // purchase classification when "تحويل" (transfer) is present.
      const sms =
          'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
      final result =
          await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
      expect(result.type, TransactionType.transfer_out);
    });

    test('ambiguous تحويل without direction is NOT outgoing', () async {
      // "تحويل" alone without directional context should not be classified
      // as a specific direction — it stays unknown for review.
      const sms = 'CIB: تحويل مبلغ 500 جنيه';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      // No directional indicators → should be null (unknown), not transfer_out.
      expect(result.type, isNull);
    });

    test('ATM withdrawal with سحب is correctly classified', () async {
      const sms = 'CIB: سحب نقدي من ماكينة الصراف الآلي بمبلغ 1000 جنيه';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.atm_withdrawal);
    });

    test('deposit with إيداع is correctly classified as income', () async {
      const sms = 'CIB: تم إيداع مبلغ 2000 جنيه في حسابكم';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.income);
    });

    test('purchase with شراء is correctly classified', () async {
      const sms = 'CIB: شراء بمبلغ 150 جنيه من كارفور بطاقة ****1234';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.purchase);
    });

    test('transfer received with استقبلت is correctly classified', () async {
      const sms = 'CIB: استقبلت تحويل مبلغ 750 جنيه من محمد';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.transfer_in);
    });
  });

  group('SMSParser — edge cases (requirement #14)', () {
    test('does not crash on empty SMS', () async {
      const sms = '';
      final result = await SMSParser.parse(smsContent: sms, sender: '');
      expect(result.type, isNull);
      expect(result.needsReview, isTrue);
    });

    test('does not crash on malformed SMS', () async {
      const sms = '!!! @@@ ### \$\$\$ %%% ^^^ &&& *** ((( )))';
      final result = await SMSParser.parse(smsContent: sms, sender: '???');
      // Should not throw; safely returns parse result.
      expect(result, isNotNull);
    });

    test('SMS without card number still parses amount and type', () async {
      const sms = 'CIB: ATM withdrawal of EGP 500 from downtown atm';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.atm_withdrawal);
      expect(result.amountMinor, 50000);
      expect(result.cardLast4, isNull);
    });
  });

  group('SMSParser — sender recognition (requirement #3)', () {
    test(
        'recognized bank/wallet senders are accepted without the literal '
        'word "bank"/"wallet"', () {
      const senders = [
        'CIB',
        'NBE',
        'QNB',
        'MISR',
        'IPN',
        'InstaPay',
        'Vodafone Cash',
        'VodafoneC',
        'FAISAL BANK',
        'Faisal Bank',
      ];
      for (final sender in senders) {
        expect(
          SMSParser.isRecognizedBankOrWalletSender(sender: sender),
          isTrue,
          reason: 'sender "$sender" must be recognized as a bank/wallet',
        );
      }
    });

    test('recognized senders also pass with remote bank data', () {
      final banks = [
        const Bank(
            id: 'b1', name: 'Faisal Bank', nameAr: 'بنك فيصل', code: 'FAISAL'),
        const Bank(
            id: 'b2',
            name: 'QNB Egypt',
            nameAr: 'بنك قطر الوطني مصر',
            code: 'QNB'),
      ];
      expect(
        SMSParser.isRecognizedBankOrWalletSender(
            sender: 'FAISAL BANK', knownBanks: banks),
        isTrue,
      );
      expect(
        SMSParser.isRecognizedBankOrWalletSender(
            sender: 'QNB', knownBanks: banks),
        isTrue,
      );
    });

    test('unrelated senders are rejected before any financial parsing', () {
      const senders = [
        'TELECOM ADS',
        'PROMO',
        'DELIVERY',
        'FOOTBALL CLUB',
        '12345',
        '',
      ];
      for (final sender in senders) {
        expect(
          SMSParser.isRecognizedBankOrWalletSender(sender: sender),
          isFalse,
          reason: 'sender "$sender" must NOT be recognized',
        );
      }
    });
  });
  group('SMSParser — new Egyptian purchase & IPN received-transfer patterns',
      () {
    test('Pattern 1: card purchase with compact text', () async {
      const sms = 'تمت عملية بمبلغ1200.00 EGPببطاقة2307** في12/09/26-15:40 '
          'عند GEIDEAE*COTTONIL ABDIN EG';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 120000); // 1200.00 EGP
      expect(result.currency, 'EGP');
      // `2307**` and `**2325` are the SAME thing in this bank's rendering: the
      // digits the bank chose to reveal ARE the card's last four. The trailing
      // asterisks are an alignment artifact, not a prefix marker.
      expect(result.cardLast4, '2307',
          reason: 'a card label introduces the last four in either mask layout');
      expect(result.merchant, 'GEIDEAE*COTTONIL ABDIN EG');
      expect(result.needsReview, isFalse);
      expect(result.transferMethod, isNull);
      expect(result.accountLast4, isNull);
    });

    test('Pattern 1b: the same message with a LEAD mask yields the real last 4',
        () async {
      // `**2307` puts the mask in front of the digits, which is the layout that
      // genuinely reveals the last four.
      const sms = 'تمت عملية بمبلغ1200.00 EGPببطاقة**2307 في12/09/26-15:40 '
          'عند GEIDEAE*COTTONIL ABDIN EG';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.cardLast4, '2307',
          reason: 'digits after a leading mask really are the last four');
    });

    test('Pattern 2: mobile / internet-banking deduction (purchase)', () async {
      const sms = 'تم خصم مبلغ 1614.14 جم / الموبايل والانترنت البنكي من '
          'حسابك , يوم 11/09/2026 16:49.';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 161414); // 1614.14 EGP
      expect(result.currency, 'EGP');
      expect(result.cardLast4, isNull); // never invents a card number
      expect(result.needsReview, isFalse);
    });

    test('Pattern 3: IPN received transfer ("الى" variant)', () async {
      const sms = 'تم إضافة تحويل IPN الى حسابكم رقم 7505 بمبلغ240';
      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');
      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 24000); // 240.00 EGP
      expect(result.currency, 'EGP');
      expect(result.transferMethod, 'IPN');
      expect(result.accountLast4, '7505');
      expect(result.needsReview, isFalse);
    });

    test('Pattern 3: IPN received transfer ("إلى" variant, spaced)', () async {
      const sms = 'تم إضافة تحويل IPN إلى حسابكم رقم 7505 بمبلغ 240';
      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');
      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 24000);
      expect(result.transferMethod, 'IPN');
      expect(result.accountLast4, '7505');
    });

    test('Pattern 3: compact whitespace variant still parses', () async {
      const sms = 'تم إضافة تحويل IPN الى حسابكم رقم7505 بمبلغ 240';
      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');
      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 24000);
      expect(result.accountLast4, '7505');
    });

    test('IPN transfer FROM the account stays a transfer_out (regression)',
        () async {
      // "من حسابكم" = FROM your account → money OUT. The existing rule must
      // remain intact; only the "إضافة … إلى حسابكم" pattern is incoming.
      const sms = 'تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم '
          'رقم مرجعي 7351';
      final result = await SMSParser.parse(smsContent: sms, sender: 'IPN');
      expect(result.type, TransactionType.transfer_out);
      expect(result.amountMinor, 1000);
    });
  });
  group('SMSParser - mobile/internet-banking incoming amount', () {
    test('Money added to the account is a transfer_in with source channel',
        () async {
      const sms = 'تم اضافة مبلغ 200.00 جم / الموبايل والانترنت البنكي في '
          'حسابك , يوم 13/09/2026 19:56.';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 20000); // 200.00 EGP
      expect(result.currency, 'EGP');
      expect(result.sourceChannel, 'الموبايل والانترنت البنكي');
      // No card / account / merchant / sender is invented.
      expect(result.cardLast4, isNull);
      expect(result.accountLast4, isNull);
      expect(result.merchant, isNull);
      expect(result.needsReview, isFalse);
    });

    test('the same format with "إضافة" (hamza) is also transfer_in', () async {
      const sms = 'تم إضافة مبلغ 300.00 جم / الموبايل والانترنت البنكي في '
          'حسابك , يوم 10/09/2026 09:30.';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.transfer_in);
      expect(result.amountMinor, 30000);
      expect(result.sourceChannel, 'الموبايل والانترنت البنكي');
    });

    test('the deduction twin still parses as purchase (regression)', () async {
      const sms = 'تم خصم مبلغ 1614.14 جم / الموبايل والانترنت البنكي من '
          'حسابك , يوم 11/09/2026 16:49.';
      final result = await SMSParser.parse(smsContent: sms, sender: 'CIB');

      expect(result.type, TransactionType.purchase);
      expect(result.amountMinor, 161414);
      expect(result.currency, 'EGP');
      // Money OUT → no source-channel / incoming metadata.
      expect(result.sourceChannel, isNull);
    });
  });

  group('SMSParser — date gate (cutoff removed)', () {
    test('historical messages (before old Sept 1 cutoff) ARE eligible now', () {
      expect(
        SMSParser.isWithinSupportedDate(DateTime(2026, 8, 31, 23, 59, 59)),
        isTrue,
      );
      expect(SMSParser.isWithinSupportedDate(DateTime(2026, 9, 1)), isTrue);
      expect(
        SMSParser.isWithinSupportedDate(DateTime(2026, 9, 10, 14, 30)),
        isTrue,
      );
    });

    test('missing message date is rejected (no guessing)', () {
      expect(SMSParser.isWithinSupportedDate(null), isFalse);
    });
  });
}
