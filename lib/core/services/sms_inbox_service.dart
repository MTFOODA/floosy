import 'package:flutter/services.dart';

import '../utils/app_logger.dart';

/// A single SMS retrieved from the Android inbox.
class SmsInboxMessage {
  final String sender;
  final String body;
  final DateTime date;

  const SmsInboxMessage({
    required this.sender,
    required this.body,
    required this.date,
  });
}

/// Reads the device SMS inbox through the `floosy/sms` platform channel.
///
/// Retrieval is deliberately unfiltered: every inbox message is returned and
/// financial relevance is decided LATER by the parser/classifier, never by
/// the retrieval layer (requirement #7). Diagnostic logs are truncated
/// previews only — full SMS bodies are never logged.
class SmsInboxService {
  static const MethodChannel _channel = MethodChannel('floosy/sms');

  /// True when READ_SMS is granted on the native side.
  Future<bool> hasPermissions() async {
    try {
      return await _channel.invokeMethod<bool>('hasPermissions') ?? false;
    } on PlatformException catch (e) {
      logError('SMS_PERMISSION check failed: ${e.code}', e);
      return false;
    } on MissingPluginException {
      logWarning('SMS_PERMISSION: platform channel unavailable (not Android)');
      return false;
    }
  }

  /// Reads up to [maxCount] most-recent inbox messages. Returns an empty
  /// list when permission is missing or the query fails (never throws).
  ///
  /// [sinceDate] / [untilDate] narrow the native SQL query to the given
  /// window (used by the SMS Detection Range feature): a historical
  /// range-expansion scan fetches exactly the newly relevant portion of the
  /// inbox instead of paging through the newest messages. Both are inclusive
  /// instants; null = unbounded in that direction. This is a RETRIEVAL
  /// optimization only — financial relevance is still decided later by the
  /// parser/classifier (requirement #7).
  Future<List<SmsInboxMessage>> readInbox({
    int maxCount = 200,
    DateTime? sinceDate,
    DateTime? untilDate,
  }) async {
    logInfo('SMS_QUERY: reading inbox (max $maxCount'
        '${sinceDate != null ? ', since ${sinceDate.toIso8601String()}' : ''}'
        '${untilDate != null ? ', until ${untilDate.toIso8601String()}' : ''})');
    try {
      final args = <String, dynamic>{'maxCount': maxCount};
      if (sinceDate != null) {
        args['sinceDateMs'] = sinceDate.millisecondsSinceEpoch;
      }
      if (untilDate != null) {
        args['untilDateMs'] = untilDate.millisecondsSinceEpoch;
      }
      final raw =
          await _channel.invokeMethod<List<dynamic>>('queryInbox', args);
      final messages = <SmsInboxMessage>[];
      for (final entry in raw ?? const []) {
        final map = Map<String, dynamic>.from(entry as Map);
        final message = SmsInboxMessage(
          sender: (map['sender'] as String?) ?? '',
          body: (map['body'] as String?) ?? '',
          date: DateTime.fromMillisecondsSinceEpoch(
            (map['date'] as num?)?.toInt() ?? 0,
          ),
        );
        messages.add(message);
      }
      // LOG FLOOD FIX: one aggregate line per read instead of one line per
      // message. A 200-message historical page used to emit 200 log records —
      // each one a platform-channel write on the main isolate — which was itself
      // a contributor to the MIUI ANR ("DartMessenger ... execute time>50ms").
      // Per-message previews are only emitted for small (incremental) reads.
      logInfo('SMS_READ count=${messages.length}');
      if (messages.isNotEmpty && messages.length <= 5) {
        for (final message in messages) {
          logDebug('SMS_MESSAGE sender=${message.sender} '
              'date=${message.date.toIso8601String()} '
              'bodyLength=${message.body.length} '
              'preview=${_preview(message.body)}');
        }
      }
      return messages;
    } on PlatformException catch (e) {
      logError('SMS_QUERY failed: ${e.code} ${e.message}', e);
      return const [];
    } on MissingPluginException {
      logWarning('SMS_QUERY: platform channel unavailable (not Android)');
      return const [];
    }
  }

  /// Truncated, newline-free preview safe for logs.
  String _preview(String body) {
    final flat = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    return flat.length <= 60 ? flat : '${flat.substring(0, 60)}…';
  }
}
