import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/services/sms_parser_service.dart';

void main() {
  test('debug جم file bytes', () async {
    const sms = 'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';
    // ignore: avoid_print
    print('SMS codeunits: ${sms.codeUnits}');
    final amt = SMSParser.extractAmount(sms);
    // ignore: avoid_print
    print('extractAmount => $amt');
    final cur = SMSParser.detectCurrency(sms);
    // ignore: avoid_print
    print('currency => $cur');
    final r = await SMSParser.parse(smsContent: sms, sender: 'FAISAL BANK');
    // ignore: avoid_print
    print('parsed amount=${r.amountMinor} cur=${r.currency} type=${r.type} card=${r.cardLast4} merch=${r.merchant} bank=${r.bankName}');
    // raw regex sanity
    final rx = RegExp(r'([\d][\d.,]*)\s*(?:egp|ج\.م|جنيه|جم|le|e\s?£)', caseSensitive: false);
    // ignore: avoid_print
    print('sanity hasMatch=${rx.hasMatch(sms)} first=${rx.firstMatch(sms)?.group(0)} g1=${rx.firstMatch(sms)?.group(1)}');
    // Read source file bytes around extractAmount
    final src = await File('lib/data/services/sms_parser_service.dart').readAsString();
    final i = src.indexOf('static int? extractAmount');
    final snippet = src.substring(i, i + 900);
    // ignore: avoid_print
    print('---SNIPPET START---');
    // ignore: avoid_print
    print(snippet);
    // ignore: avoid_print
    print('---SNIPPET END---');
    // ignore: avoid_print
    print('snippet units around first RegExp: ${snippet.substring(snippet.indexOf('RegExp'), snippet.indexOf('RegExp')+120).codeUnits}');
  });
}
