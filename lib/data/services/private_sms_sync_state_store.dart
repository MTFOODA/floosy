import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/datasources/private_record_store.dart';
import 'sms_sync_state_store.dart';

class PrivateSmsSyncStateStore extends SmsSyncStateStore {
  final PrivateRecordStore store;
  PrivateSmsSyncStateStore(this.store);
  @override
  Future<SmsSyncState> read(String userId) async {
    if (userId != store.owner) throw StateError('Account changed');
    final saved = await store.get('preferences', 'sms-cursor');
    final prefs = await SharedPreferences.getInstance();
    final key = 'floosy_sms_sync_state_$userId';
    final legacy = prefs.getString(key);
    if (saved != null) {
      final state = SmsSyncState.fromJson(saved);
      await prefs.remove(key);
      return state;
    }
    if (legacy == null) return SmsSyncState.empty;
    final parsed = SmsSyncState.fromJson(
      Map<String, dynamic>.from(jsonDecode(legacy) as Map),
    );
    await write(userId, parsed);
    if (SmsSyncState.fromJson(
          (await store.get('preferences', 'sms-cursor'))!,
        ) !=
        parsed) {
      throw StateError('Cursor migration failed');
    }
    await prefs.remove(key);
    return parsed;
  }

  @override
  Future<void> write(String userId, SmsSyncState state) async {
    await store.put('preferences', {
      'id': 'sms-cursor',
      ...state.toJson(),
    }, userId: userId);
  }

  @override
  Future<void> clear(String userId) async {
    if (userId != store.owner) throw StateError('Account changed');
    await store.delete('preferences', 'sms-cursor');
  }
}
