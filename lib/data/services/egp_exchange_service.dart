import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EgpConversion {
  final int amountMinor;
  final double rate;
  final String rateDate;
  const EgpConversion(this.amountMinor, this.rate, this.rateDate);
}

/// Historical daily reference rates. No SMS, account or user data is sent.
/// Missing rates stay reviewable; a foreign amount is never treated as EGP.
class EgpExchangeService {
  final http.Client? client;
  EgpExchangeService({this.client});

  Future<EgpConversion?> convert(
      int amountMinor, String currency, DateTime date) async {
    if (currency == 'EGP') return EgpConversion(amountMinor, 1, '');
    final day = '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final key = 'floosy_fx_${currency}_$day';
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(key);
      dynamic rows;
      if (cached != null) {
        rows = jsonDecode(cached);
      } else {
        final uri = Uri.https('api.frankfurter.dev', '/v2/rates',
            {'base': currency, 'quotes': 'EGP', 'date': day});
        final response = await (client?.get(uri) ?? http.get(uri))
            .timeout(const Duration(seconds: 6));
        if (response.statusCode != 200) return null;
        rows = jsonDecode(response.body);
      }
      if (rows is! List || rows.length != 1) return null;
      final row = rows.single as Map<String, dynamic>;
      final rate = (row['rate'] as num?)?.toDouble();
      final rateDate = DateTime.tryParse(row['date']?.toString() ?? '');
      if (row['base'] != currency ||
          row['quote'] != 'EGP' ||
          rate == null ||
          !rate.isFinite ||
          rate <= 0 ||
          rateDate == null ||
          rateDate.isAfter(DateTime.parse(day)) ||
          DateTime.parse(day).difference(rateDate).inDays > 7) {
        return null;
      }
      await prefs.setString(key, jsonEncode(rows));
      return EgpConversion(
          (amountMinor * rate).round(), rate, row['date'] as String);
    } catch (_) {
      return null;
    }
  }
}
