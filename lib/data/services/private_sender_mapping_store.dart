import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/datasources/private_record_store.dart';
import 'bank_sender_mapping_store.dart';

class PrivateSenderMappingStore extends BankSenderMappingStore {
  final PrivateRecordStore store;
  PrivateSenderMappingStore(this.store);
  String _key(String sender) => sender.trim().toUpperCase();
  Future<Map<String, dynamic>> _state(String user) async {
    if (user != store.owner) throw StateError('Account changed');
    final existing = await store.get('preferences', 'sender-state');
    final prefs = await SharedPreferences.getInstance();
    final mapKey = 'floosy_bank_sender_map_$user';
    final unknownKey = 'floosy_unknown_senders_$user';
    final rejectedKey = 'floosy_rejected_senders_$user';
    if (existing != null) {
      // Resume cleanup if the previous run stopped after the verified write.
      for (final key in [mapKey, unknownKey, rejectedKey]) {
        await prefs.remove(key);
      }
      return existing;
    }
    final value = {
      'id': 'sender-state',
      'mapping': Map<String, dynamic>.from(
        jsonDecode(prefs.getString(mapKey) ?? '{}') as Map,
      ),
      'unknown': jsonDecode(prefs.getString(unknownKey) ?? '[]') as List,
      'rejected': prefs.getStringList(rejectedKey) ?? <String>[],
    };
    await store.put('preferences', value);
    final saved = await store.get('preferences', 'sender-state');
    if (saved == null ||
        jsonEncode(saved['mapping']) != jsonEncode(value['mapping']) ||
        jsonEncode(saved['unknown']) != jsonEncode(value['unknown']) ||
        jsonEncode(saved['rejected']) != jsonEncode(value['rejected'])) {
      throw StateError('Sender preferences migration failed');
    }
    for (final key in [mapKey, unknownKey, rejectedKey]) {
      await prefs.remove(key);
    }
    return value;
  }

  Future<void> _change(
    String user,
    void Function(Map<String, dynamic>) edit,
  ) async {
    await store.database.transaction(() async {
      final value = await _state(user);
      edit(value);
      await store.put('preferences', value);
    });
  }

  @override
  Future<List<String>> getRejectedSenders(String userId) async =>
      List<String>.from(
        (await _state(userId))['rejected'] as List,
      ).map(_key).toSet().toList();
  @override
  Future<bool> isRejected(String userId, String sender) async =>
      (await getRejectedSenders(userId)).contains(_key(sender));
  @override
  Future<String?> getBankForSender(String userId, String sender) async {
    final state = await _state(userId);
    if (List<String>.from(state['rejected'] as List).contains(_key(sender))) {
      return null;
    }
    return (state['mapping'] as Map)[_key(sender)] as String?;
  }

  @override
  Future<List<String>> getUnknownSenders(String userId) async {
    final state = await _state(userId);
    final rejected = Set<String>.from(state['rejected'] as List);
    return List<String>.from(
      state['unknown'] as List,
    ).map(_key).where((s) => !rejected.contains(s)).toSet().toList();
  }

  @override
  Future<void> markUnknown(String userId, String sender) async {
    final key = _key(sender);
    if (key.isEmpty) return;
    await _change(userId, (state) {
      if ((state['rejected'] as List).contains(key) ||
          (state['mapping'] as Map).containsKey(key)) {
        return;
      }
      state['unknown'] = {
        ...List<String>.from(state['unknown'] as List),
        key,
      }.toList();
    });
  }

  @override
  Future<void> setMapping(String userId, String sender, String bankName) async {
    final key = _key(sender);
    if (key.isEmpty || bankName.trim().isEmpty) return;
    await _change(userId, (state) {
      if ((state['rejected'] as List).contains(key)) {
        throw StateError('Restore sender first');
      }
      (state['mapping'] as Map)[key] = bankName.trim();
      (state['unknown'] as List).removeWhere((s) => _key(s as String) == key);
    });
  }

  @override
  Future<void> rejectSender(String userId, String sender) async {
    final key = _key(sender);
    if (key.isEmpty) return;
    await _change(userId, (state) {
      state['rejected'] = {
        ...List<String>.from(state['rejected'] as List),
        key,
      }.toList();
      (state['mapping'] as Map).remove(key);
      (state['unknown'] as List).removeWhere((s) => _key(s as String) == key);
    });
  }

  @override
  Future<void> restoreSender(String userId, String sender) async {
    final key = _key(sender);
    await _change(userId, (state) {
      (state['rejected'] as List).removeWhere((s) => _key(s as String) == key);
      state['unknown'] = {
        ...List<String>.from(state['unknown'] as List),
        key,
      }.toList();
    });
  }
}
