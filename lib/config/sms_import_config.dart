/// Temporary validation baseline: midnight in Cairo on 22 October 2026.
/// Override with --dart-define=SMS_IMPORT_START=<ISO-8601 instant>.
class SmsImportConfig {
  static DateTime get start =>
      DateTime.parse(const String.fromEnvironment('SMS_IMPORT_START',
          defaultValue: '2026-10-22T00:00:00+03:00'));
}
