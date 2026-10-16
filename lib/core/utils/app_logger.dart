import 'package:logger/logger.dart';

/// Central application logger. Replaces raw `print` calls in production
/// code so that log output is leveled, filterable and strip-able.
final Logger _logger = Logger(
  printer: PrettyPrinter(
      methodCount: 0, dateTimeFormat: DateTimeFormat.none, colors: false),
);

void logDebug(String message) => _logger.d(message);

void logInfo(String message) => _logger.i(message);

void logWarning(String message) => _logger.w(message);

void logError(String message, [Object? error, StackTrace? stackTrace]) =>
    _logger.e(message, error: error, stackTrace: stackTrace);
