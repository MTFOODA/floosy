import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/domain/entities/user_model.dart';
import 'package:floosy/domain/entities/transaction_model.dart';

void main() {
  final corpus =
      jsonDecode(File('assets/data/bank_sms_corpus.json').readAsStringSync())
          as Map<String, dynamic>;
  test(
    'every supported institution has a bundled logo and labelled samples',
    () {
      final codes = BankCatalog.all.map((b) => b.code).toSet();
      expect(codes.length, BankCatalog.all.length);
      expect(
        (corpus['institutions'] as List).map((b) => b['code']).toSet(),
        codes,
      );
      for (final bank in BankCatalog.all) {
        expect(File(bank.logoAsset).existsSync(), isTrue, reason: bank.code);
      }
    },
  );
  test(
    'all labelled samples parse offline and retain real remote bank ids',
    () async {
      final failures = <String>[];
      for (final raw in corpus['samples'] as List) {
        final row = raw as Map<String, dynamic>;
        final expected = row['expected'] as Map<String, dynamic>;
        final sender = row['sender'] as String;
        final body = row['body'] as String;
        expect(SMSParser.isSupportedSender(sender), isTrue);
        final parsed = await SMSParser.parse(sender: sender, smsContent: body);
        // Corpus direction describes the money movement. The classifier's raw
        // keyword direction score can be zero for a type such as ATM withdrawal.
        final direction = parsed.type == null
            ? 0
            : parsed.type!.isIncoming
            ? 1
            : parsed.type!.isOutgoing
            ? -1
            : 0;
        expect(
          BankCatalog.byIdentity(parsed.bankName)?.code,
          expected['bank_code'],
        );
        if (parsed.type?.name != expected['type'] ||
            parsed.amountMinor != expected['amount_minor'] ||
            parsed.cardLast4 != expected['card_last4'] ||
            direction != expected['direction']) {
          failures.add(
            '${row['id']}: type=${parsed.type?.name}, amount=${parsed.amountMinor}, card=${parsed.cardLast4}; expected=$expected',
          );
        }
        expect(parsed.currency, expected['currency']);
        if (expected['type'] != null) {
          final bank = BankCatalog.byIdentity(sender)!;
          final remote = await SMSParser.parse(
            sender: sender,
            smsContent: body,
            knownBanks: [
              Bank(id: 'real-server-id', name: bank.name, code: bank.code),
            ],
          );
          expect(remote.bankId, 'real-server-id');
        }
      }
      expect(failures, isEmpty);
    },
  );
  test(
    'bank identity comes from the sender before transfer body references',
    () {
      expect(
        SMSParser.detectBank(
          sender: 'AAIB',
          body: 'Transfer sent to Arab International Bank',
        )?.code,
        'AAIB',
      );
      expect(
        SMSParser.detectBank(
          sender: 'AIB',
          body: 'Transfer received from Arab African International Bank',
        )?.code,
        'AIB',
      );
      expect(
        SMSParser.detectBank(
          sender: 'SC',
          body: 'Transfer from Suez Canal Bank',
        )?.code,
        'SC',
      );
    },
  );
  test(
    'generic words, short substrings and empty senders cannot select a bank',
    () {
      const remote = [
        Bank(id: 'cib', name: 'Commercial International Bank', code: 'CIB'),
      ];
      for (final sender in [
        'Other Bank',
        'Egypt',
        'National',
        'Prescription',
        'Subscribe',
        'scar',
        '',
      ]) {
        expect(
          SMSParser.isSupportedSender(sender, knownBanks: remote),
          isFalse,
          reason: sender,
        );
        expect(
          SMSParser.detectBank(
            sender: sender,
            body: 'Purchase EGP 10',
            knownBanks: remote,
          ),
          isNull,
          reason: sender,
        );
      }
    },
  );
  test(
    'old identities resolve to their current bank without duplicate brands',
    () {
      expect(BankCatalog.byIdentity('ALEX2')?.code, 'ALEX');
      expect(BankCatalog.byIdentity('Ahli United Bank')?.code, 'KFH');
      expect(BankCatalog.byIdentity('aiBANK')?.code, 'NXT');
      expect(BankCatalog.byIdentity('QNB Alahli')?.code, 'QNB');
      expect(BankCatalog.byIdentity('Bank Audi')?.code, 'FAB');
    },
  );
}
