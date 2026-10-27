import 'package:flutter/services.dart';
import '../../domain/entities/imported_bank_message.dart';

/// Reads only messages explicitly handed to Floosy by Shortcuts or its UI.
/// No SMS database access or message content in URLs/logs is involved.
class IosBankMessageBridge {
  final MethodChannel channel;
  const IosBankMessageBridge({
    this.channel = const MethodChannel('floosy/bank_message_import'),
  });

  Future<void> bindUser(String? userId) =>
      channel.invokeMethod<void>('bindUser', {'userId': userId});

  Future<BankMessageInbox> inbox(String userId) async {
    final result = await channel
        .invokeMapMethod<String, dynamic>('inbox', {'userId': userId});
    if (result == null) throw StateError('Missing import inbox');
    final messages = <ImportedBankMessage>[];
    for (final value in result['messages'] as List? ?? const []) {
      final entry = Map<String, dynamic>.from(value as Map);
      messages.add(ImportedBankMessage(
        id: entry['id'] as String,
        sender: entry['sender'] as String,
        body: entry['body'] as String,
        receivedAt: DateTime.fromMillisecondsSinceEpoch(
            (entry['receivedAt'] as num).toInt()),
        needsReview: entry['needsReview'] == true,
      ));
    }
    return BankMessageInbox(
        enabled: result['enabled'] == true, messages: messages);
  }

  Future<void> setEnabled(String userId, bool enabled) => channel
      .invokeMethod<void>('setEnabled', {'userId': userId, 'enabled': enabled});

  Future<void> addMessage(
          String userId, String sender, String body, DateTime receivedAt) =>
      channel.invokeMethod<void>('addMessage', {
        'userId': userId,
        'sender': sender,
        'body': body,
        'receivedAt': receivedAt.millisecondsSinceEpoch,
      });

  Future<void> updateMessage(String userId, String id, String action) =>
      channel.invokeMethod<void>(
          'updateMessage', {'userId': userId, 'id': id, 'action': action});
}
