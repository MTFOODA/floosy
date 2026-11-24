import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import '../local/datasources/private_record_store.dart';

/// UI appearance stays in preferences; bank-qualified selection stays encrypted
/// and belongs to the signed-in account.
class PrivateAppPreferences extends SharedAppPreferences {
  final PrivateRecordStore store;
  PrivateAppPreferences(this.store);
  bool _private(String key) => key.startsWith('floosy_selected_card_');
  @override
  Future<String?> read(String key) async {
    if (!_private(key)) return super.read(key);
    // Old selection keys had no owner. Recompute selection from this account's
    // cards rather than attributing another account's choice to this user.
    await super.remove(key);
    if (store.activeUser() == null) return null;
    try {
      return (await store.get('preferences', key))?['value'] as String?;
    } catch (_) {
      // The preparation gate handles vault access failures. A missing UI
      // selection must never bypass that gate or cause an uncaught startup.
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    if (!_private(key)) return super.write(key, value);
    if (store.activeUser() == null) return;
    await store.put('preferences', {'id': key, 'value': value});
  }

  @override
  Future<void> remove(String key) async {
    if (!_private(key)) return super.remove(key);
    await super.remove(key);
    if (store.activeUser() != null) await store.delete('preferences', key);
  }
}

class SharedAppPreferences implements AppPreferencesRepository {
  @override
  Future<String?> read(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  @override
  Future<void> write(String key, String value) async {
    await (await SharedPreferences.getInstance()).setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await (await SharedPreferences.getInstance()).remove(key);
  }
}
