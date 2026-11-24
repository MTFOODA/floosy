/// Initial history starts at midnight on the first day of the device's month.
/// Persist this once per account; later months must not discard an unread gap.
class SmsImportConfig {
  static DateTime get start => startFor(DateTime.now());

  static DateTime startFor(DateTime now) {
    const override = String.fromEnvironment('SMS_IMPORT_START');
    if (override.isNotEmpty) return DateTime.parse(override);
    return now.isUtc
        ? DateTime.utc(now.year, now.month)
        : DateTime(now.year, now.month);
  }
}
