/// Money helpers. All amounts in Floosy are stored as integers in minor
/// currency units (piasters for EGP) — never floating point.
String formatMoney(int minor, {String symbol = 'EGP'}) {
  final major = minor / 100;
  final text = major == major.roundToDouble()
      ? major.toStringAsFixed(0)
      : major.toStringAsFixed(2);
  return '$text $symbol';
}

String formatMoneySigned(int minor, {String symbol = 'EGP'}) {
  final sign = minor >= 0 ? '+' : '-';
  return '$sign${formatMoney(minor.abs(), symbol: symbol)}';
}

String normalizeMoneyDigits(String input) => input.replaceAllMapped(
  RegExp(r'[\u0660-\u0669\u06F0-\u06F9]'),
  (match) => (match[0]!.codeUnitAt(0) & 0xF).toString(),
);

int? parseMoneyMinor(String input) {
  var value = normalizeMoneyDigits(
    input.trim(),
  ).replaceAll(RegExp(r'[\s\u066C]'), '').replaceAll('٫', '.');
  if (RegExp(r'^-?\d{1,3}(\.\d{3})+,\d{1,2}$').hasMatch(value)) {
    value = value.replaceAll('.', '').replaceAll(',', '.');
  } else if (RegExp(r'^-?\d{1,3}(\.\d{3})+\.\d{1,2}$').hasMatch(value)) {
    final decimal = value.lastIndexOf('.');
    value =
        value.substring(0, decimal).replaceAll('.', '') +
        value.substring(decimal);
  } else if (RegExp(r'^-?\d{1,3}(,\d{3})+(\.\d{1,2})?$').hasMatch(value)) {
    value = value.replaceAll(',', '');
  } else if (RegExp(r'^-?\d+,\d{1,2}$').hasMatch(value)) {
    value = value.replaceAll(',', '.');
  }
  final match = RegExp(r'^(-?)(\d{1,13})(?:\.(\d{1,2}))?$').firstMatch(value);
  if (match == null) return null;
  final major = int.parse(match[2]!);
  final minor = int.parse((match[3] ?? '').padRight(2, '0'));
  return (match[1] == '-' ? -1 : 1) * (major * 100 + minor);
}
