import 'dart:convert';
import 'package:drift/drift.dart';
import '../local/datasources/private_record_store.dart';

/// Earlier app versions could cache auxiliary records in typed tables. Move
/// those into the compact store before older cloud values can fill gaps.
Future<void> migrateLegacyLocalRecords(PrivateRecordStore store) async {
  if (await store.get('preferences', 'local-record-migration-v1') != null) {
    return;
  }
  final owner = store.owner;
  await store.database.transaction(() async {
    for (final table in [
      'categories',
      'budgets',
      'recurring_expenses',
      'alerts',
    ]) {
      final rows = await store.database
          .customSelect(
            'SELECT * FROM $table WHERE user_id=? ${table == 'categories' ? 'OR user_id IS NULL' : ''}',
            variables: [Variable(owner)],
          )
          .get();
      for (final raw in rows) {
        final row = Map<String, dynamic>.from(raw.data);
        for (final key in row.keys.toList()) {
          final value = row[key];
          if (value is int && (key.endsWith('_at') || key.endsWith('_date'))) {
            row[key] = DateTime.fromMillisecondsSinceEpoch(
              value * 1000,
              isUtc: true,
            ).toIso8601String();
          } else if (key.startsWith('is_')) {
            row[key] = value == 1 || value == true;
          }
        }
        await store.put(table, row, onlyIfMissing: true, timestamps: false);
        if (jsonEncode(await store.get(table, row['id'] as String)) !=
            jsonEncode(row)) {
          throw StateError('Local record migration verification failed');
        }
      }
    }
    if (store.owner != owner) throw StateError('Account changed');
    await store.put('preferences', {
      'id': 'local-record-migration-v1',
      'verified': true,
    });
  });
}
