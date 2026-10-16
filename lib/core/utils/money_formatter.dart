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
