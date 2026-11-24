import 'package:flutter/foundation.dart';

/// Call sites may contain financial values or SDK exception payloads. Never
/// print caller messages, exceptions, stacks, IDs, amounts, senders or bodies.
/// Release builds are silent; debug builds expose only fixed severity markers.
void logDebug(String message) {
  if (kDebugMode) debugPrint('FLOOSY_DEBUG_EVENT');
}

void logInfo(String message) {
  if (kDebugMode) debugPrint('FLOOSY_INFO_EVENT');
}

void logWarning(String message) {
  if (kDebugMode) debugPrint('FLOOSY_WARNING_EVENT');
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) debugPrint('FLOOSY_ERROR_EVENT');
}
