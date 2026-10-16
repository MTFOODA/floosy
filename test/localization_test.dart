import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards against startup crashes from malformed localization data.
/// Mirrors the exact load path of `AppLocalizations.load`:
/// rootBundle.loadString -> json.decode.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const requiredKeys = [
    'tooMuchRepayment', // CreditLimitExceededException snackbar message
    'repaymentAmount',
    'repaymentSuccess',
    'remainingAfterRepayment',
    'creditCardRepayment',
    'resetTransactionDataDone',
  ];

  Future<Map<String, dynamic>> loadArb(String languageCode) async {
    final jsonString =
        await rootBundle.loadString('assets/translations/app_$languageCode.arb');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  test('app_en.arb parses as valid JSON', () async {
    final parsed = await loadArb('en');
    expect(parsed, isNotEmpty);
  });

  test('app_ar.arb parses as valid JSON', () async {
    final parsed = await loadArb('ar');
    expect(parsed, isNotEmpty);
  });

  test('both locales expose the same key set', () async {
    final en = await loadArb('en');
    final ar = await loadArb('ar');
    expect(ar.keys.toSet(), equals(en.keys.toSet()));
  });

  test('required repayment/localization keys exist in both locales', () async {
    final en = await loadArb('en');
    final ar = await loadArb('ar');
    for (final key in requiredKeys) {
      expect(en[key], isA<String>(), reason: 'missing EN key: $key');
      expect(ar[key], isA<String>(), reason: 'missing AR key: $key');
    }
    expect(en['tooMuchRepayment'], contains('repay'));
    expect(ar['tooMuchRepayment'], isNotEmpty);
  });
}
