import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/datasources/private_record_store.dart';
import 'private_sms_sync_state_store.dart';
import 'sms_sync_state_store.dart';
import '../local/system_categories.dart';
import '../../config/sms_import_config.dart';

/// One-off owner-authorized retirement of test data. Auth preferences and
/// profile/account settings are deliberately outside this allowlist.
class FreshStartService {
  static const epoch = 'test-reset-2026-11-21';
  static const smsMonthHistory = 'sms-current-month-history-v1';
  final PrivateRecordStore store;
  final DateTime Function() now;
  final Map<String, Future<void>> _running = {};
  FreshStartService(this.store, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  Future<void> initialize(String user) => _running.putIfAbsent(user, () {
    return _initialize(user).whenComplete(() {
      _running.remove(user);
    });
  });
  Future<void> _initialize(String user) async {
    if (store.owner != user) throw StateError('Account changed');
    final db = store.database;
    final prefs = await SharedPreferences.getInstance();
    await db.transaction(() async {
      final marker = await db
          .customSelect(
            'SELECT stage FROM migration_journal WHERE owner=? AND stage=?',
            variables: [const Variable('_device'), const Variable(epoch)],
          )
          .getSingleOrNull();
      if (marker == null) {
        for (final table in db.allTables) {
          await db.customStatement('DELETE FROM "${table.actualTableName}"');
        }
        for (final table in [
          'private_records',
          'sms_payloads',
          'private_media',
          'migration_journal',
        ]) {
          await db.customStatement('DELETE FROM $table');
        }
        const prefixes = [
          'floosy_detected_cards_',
          'floosy_bank_sender_map_',
          'floosy_unknown_senders_',
          'floosy_rejected_senders_',
          'floosy_sms_sync_state_',
          'floosy_selected_card_',
          'floosy_fx_',
        ];
        for (final key
            in prefs
                .getKeys()
                .where((key) => prefixes.any(key.startsWith))
                .toList()) {
          if (!await prefs.remove(key)) {
            throw StateError('Test preference cleanup failed');
          }
        }
        if (store.owner != user) throw StateError('Account changed');
        await db.customStatement(
          'INSERT INTO migration_journal(owner,stage,payload) VALUES(?,?,?)',
          ['_device', epoch, packPrivateData(utf8.encode('{"reset":true}'))],
        );
      }
      if (await store.get('preferences', epoch) == null) {
        for (final category in systemCategorySeeds) {
          await store.put('categories', category, onlyIfMissing: true);
        }
        final start = now().toUtc();
        await store.put('preferences', {
          'id': epoch,
          'started_at': start.toIso8601String(),
        });
      }
      // Upgrade the previous "new messages only" cursor exactly once. Keep
      // all financial rows and dedupe ledgers, so already imported SMS are safe.
      if (await store.get('preferences', smsMonthHistory) == null) {
        final started = now();
        final floor = SmsImportConfig.startFor(started).toUtc();
        await PrivateSmsSyncStateStore(store).write(
          user,
          SmsSyncState(firstAllowedAt: floor, updatedAt: started.toUtc()),
        );
        await store.put('preferences', {
          'id': smsMonthHistory,
          'first_allowed_at': floor.toIso8601String(),
        });
      }
      if (store.owner != user) throw StateError('Account changed');
    });
  }
}
