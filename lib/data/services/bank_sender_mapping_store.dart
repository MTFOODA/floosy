import '../../domain/repositories/sms_repository.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persistent per-user mapping of SMS sender identifiers to bank names.
///
/// Powers the "Unknown Bank" manual fallback (requirement 2A):
///  * automatic bank detection ALWAYS runs first;
///  * when detection fails, the sender is recorded as unknown;
///  * the user assigns a bank name once in Settings → Bank Mappings;
///  * every future SMS from that sender is then automatically attributed
///    to the saved bank — without touching transaction classification.
///
/// Storage is a JSON object under a user-scoped key, so mappings can never
/// leak between accounts (requirement 2A.6). Survives restart and refresh.
class BankSenderMappingStore implements BankMappingsRepository {
  static String _senderKey(String sender) => sender.trim().toUpperCase();
  static String _rejectedKey(String userId) =>
      'floosy_rejected_senders_$userId';

  @override
  Future<List<String>> getRejectedSenders(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_rejectedKey(userId)) ?? [])
        .map(_senderKey)
        .toSet()
        .toList();
  }

  Future<bool> isRejected(String userId, String sender) async =>
      (await getRejectedSenders(userId)).contains(_senderKey(sender));

  @override
  Future<void> rejectSender(String userId, String sender) async {
    final key = _senderKey(sender);
    if (key.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final rejected = {...await getRejectedSenders(userId), key}.toList();
    // Persist rejection first: all scan/import entry points consult it.
    if (!await prefs.setStringList(_rejectedKey(userId), rejected)) {
      throw StateError('Could not save rejected sender');
    }
    final map = _decode(prefs.getString(_mapKey(userId)))..remove(key);
    await prefs.setString(_mapKey(userId), jsonEncode(map));
    final unknown = (await getUnknownSenders(userId))..remove(key);
    await prefs.setString(_unknownKey(userId), jsonEncode(unknown));
  }

  @override
  Future<void> restoreSender(String userId, String sender) async {
    final prefs = await SharedPreferences.getInstance();
    final rejected = (await getRejectedSenders(userId))
      ..remove(_senderKey(sender));
    await prefs.setStringList(_rejectedKey(userId), rejected);
    await markUnknown(userId, sender);
  }

  static String _mapKey(String userId) => 'floosy_bank_sender_map_$userId';
  static String _unknownKey(String userId) => 'floosy_unknown_senders_$userId';

  /// Bank name previously assigned to [sender], or null.
  Future<String?> getBankForSender(String userId, String sender) async {
    final prefs = await SharedPreferences.getInstance();
    final map = _decode(prefs.getString(_mapKey(userId)));
    if (await isRejected(userId, sender)) return null;
    return map[_senderKey(sender)];
  }

  /// Saves (or updates) sender → bank name.
  @override
  Future<void> setMapping(String userId, String sender, String bankName) async {
    if (_senderKey(sender).isEmpty || bankName.trim().isEmpty) return;
    if (await isRejected(userId, sender)) {
      throw StateError('Restore this sender before assigning a bank');
    }
    final prefs = await SharedPreferences.getInstance();
    final map = _decode(prefs.getString(_mapKey(userId)));
    map[_senderKey(sender)] = bankName.trim();
    await prefs.setString(_mapKey(userId), jsonEncode(map));
    // Assigned — remove from the unknown list.
    final unknown = await getUnknownSenders(userId);
    unknown.remove(_senderKey(sender));
    await prefs.setString(_unknownKey(userId), jsonEncode(unknown));
  }

  /// Senders seen in scans whose bank could not be identified.
  @override
  Future<List<String>> getUnknownSenders(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_unknownKey(userId));
    if (raw == null) return [];
    try {
      final list = (jsonDecode(raw) as List).cast<String>();
      final rejected = await getRejectedSenders(userId);
      return list
          .map(_senderKey)
          .where((s) => !rejected.contains(s))
          .toSet()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Records a sender whose bank was not identified. No-op when a mapping
  /// already exists for it.
  Future<void> markUnknown(String userId, String sender) async {
    if (sender.trim().isEmpty) return;
    if (await isRejected(userId, sender)) return;
    if (await getBankForSender(userId, sender) != null) return;
    final prefs = await SharedPreferences.getInstance();
    final unknown = await getUnknownSenders(userId);
    final upper = _senderKey(sender);
    if (!unknown.contains(upper)) {
      unknown.add(upper);
      await prefs.setString(_unknownKey(userId), jsonEncode(unknown));
    }
  }

  Map<String, String> _decode(String? raw) {
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v.toString()),
      );
    } catch (_) {
      return {};
    }
  }
}
