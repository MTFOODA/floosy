import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import '../../config/supabase_config.dart';
import '../local/datasources/private_record_store.dart';
import 'legacy_financial_manifest.dart';
import 'legacy_data_projection.dart';

abstract interface class LegacyReadOnlySource {
  Future<List<Map<String, dynamic>>> page(
    LegacyTable table,
    String userId,
    String? afterId,
  );
}

/// A deliberately separate, GET-only path. No admin key, uploads, updates,
/// RPCs or deletes. PostgREST RLS and explicit owner/parent validation both apply.
class AuthenticatedLegacyReader implements LegacyReadOnlySource {
  final http.Client client;
  final String? Function() token;
  final String? Function() activeUser;
  AuthenticatedLegacyReader(this.client, this.token, this.activeUser);
  @override
  Future<List<Map<String, dynamic>>> page(
    LegacyTable table,
    String userId,
    String? afterId,
  ) async {
    if (!legacyFinancialTables.any((t) => t.name == table.name) ||
        activeUser() != userId ||
        token() == null) {
      throw StateError('Account changed');
    }
    final query = <String, String>{
      'select': '*',
      'order': 'id.asc',
      'limit': '200',
      if (afterId != null) 'id': 'gt.$afterId',
    };
    if (table.hasOwner) {
      if (table.name == 'categories') {
        query['or'] = '(user_id.eq.$userId,user_id.is.null)';
      } else {
        query['user_id'] = 'eq.$userId';
      }
    }
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/${table.name}',
    ).replace(queryParameters: query);
    final response = await client
        .get(
          uri,
          headers: {
            'apikey': SupabaseConfig.publishableKey,
            'Authorization': 'Bearer ${token()}',
          },
        )
        .timeout(const Duration(seconds: 25));
    if (activeUser() != userId) throw StateError('Account changed');
    if (response.statusCode != 200 && response.statusCode != 206) {
      throw StateError('Legacy import read failed');
    }
    return (jsonDecode(response.body) as List)
        .map((r) => Map<String, dynamic>.from(r as Map))
        .toList();
  }
}

dynamic _canonical(dynamic value) {
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return {for (final key in keys) key: _canonical(value[key])};
  }
  if (value is List) return value.map(_canonical).toList();
  return value;
}

String _advance(String digest, Map<String, dynamic> row) => sha256
    .convert(utf8.encode('$digest${jsonEncode(_canonical(row))}'))
    .toString();

class LegacyFinancialImport {
  final PrivateRecordStore store;
  final LegacyReadOnlySource source;
  final void Function(int completed, int total)? progress;
  final Future<void> Function(String user)? importMedia;
  LegacyFinancialImport(
    this.store,
    this.source, {
    this.progress,
    this.importMedia,
  });
  static const completeStage = 'legacy-financial-import-v1';
  Future<Map<String, dynamic>?> _journal(String user, String stage) async {
    final r = await store.database
        .customSelect(
          'SELECT payload FROM migration_journal WHERE owner=? AND stage=?',
          variables: [Variable(user), Variable(stage)],
        )
        .getSingleOrNull();
    return r == null
        ? null
        : Map<String, dynamic>.from(
            jsonDecode(
                  utf8.decode(unpackPrivateData(r.read<Uint8List>('payload'))),
                )
                as Map,
          );
  }

  Future<void> _save(
    String user,
    String stage,
    Map<String, dynamic> value,
  ) => store.database.customStatement(
    'INSERT INTO migration_journal(owner,stage,payload) VALUES(?,?,?) ON CONFLICT(owner,stage) DO UPDATE SET payload=excluded.payload',
    [user, stage, packPrivateData(utf8.encode(jsonEncode(value)))],
  );
  Future<bool> completed(String user) async =>
      (await _journal(user, completeStage))?['verified'] == true;

  Future<void> run(String user) async {
    if (store.owner != user) throw StateError('Account changed');
    if (await completed(user)) {
      await _compact(user);
      return;
    }
    // Stage first. A failed or interrupted download cannot expose half a ledger.
    var done = 0;
    for (final table in legacyFinancialTables) {
      final savedCheckpoint = await _journal(user, 'download:${table.name}');
      if (savedCheckpoint == null) {
        await store.database.customStatement(
          'DELETE FROM private_records WHERE owner=? AND kind=?',
          [user, 'stage:${table.name}'],
        );
      }
      var checkpoint = savedCheckpoint ?? <String, dynamic>{};
      var cursor = checkpoint['cursor'] as String?;
      var digest = checkpoint['digest'] as String? ?? '';
      var count = checkpoint['count'] as int? ?? 0;
      while (checkpoint['complete'] != true) {
        final rows = await source.page(table, user, cursor);
        if (store.owner != user) throw StateError('Account changed');
        await store.database.transaction(() async {
          for (final row in rows) {
            final id = row['id'];
            if (id is! String ||
                id.isEmpty ||
                row.keys.any((key) => !table.columns.contains(key))) {
              throw StateError('Legacy schema changed');
            }
            if (table.hasOwner &&
                row['user_id'] != user &&
                !(table.name == 'categories' && row['user_id'] == null)) {
              throw StateError('Foreign owner');
            }
            if (table.parentKey != null &&
                await store.get(
                      'stage:${table.parentTable}',
                      row[table.parentKey] as String,
                    ) ==
                    null) {
              throw StateError('Legacy parent not available');
            }
            await store.put(
              'stage:${table.name}',
              row,
              userId: user,
              timestamps: false,
            );
            final saved = await store.get('stage:${table.name}', id);
            if (jsonEncode(_canonical(saved)) != jsonEncode(_canonical(row))) {
              throw StateError('Legacy staging verification failed');
            }
            digest = _advance(digest, row);
            cursor = id;
            count++;
          }
          checkpoint = {
            'cursor': cursor,
            'digest': digest,
            'count': count,
            'complete': rows.length < 200,
          };
          await _save(user, 'download:${table.name}', checkpoint);
        });
      }
      progress?.call(++done, legacyFinancialTables.length * 2);
    }
    // Read the remote snapshot again. Concurrent edits/deletes must not be
    // mistaken for a fully verified migration.
    for (final table in legacyFinancialTables) {
      String? cursor;
      var digest = '';
      var count = 0;
      while (true) {
        final rows = await source.page(table, user, cursor);
        for (final row in rows) {
          digest = _advance(digest, row);
          cursor = row['id'] as String;
          count++;
        }
        if (rows.length < 200) break;
      }
      final expected = await _journal(user, 'download:${table.name}');
      if (expected?['digest'] != digest || expected?['count'] != count) {
        // Preserve staged evidence and the original local ledger. Start this
        // table again on retry; source data is never erased or modified.
        await store.database.customStatement(
          'DELETE FROM migration_journal WHERE owner=? AND stage=?',
          [user, 'download:${table.name}'],
        );
        throw StateError('Legacy data changed; retry the import');
      }
      progress?.call(++done, legacyFinancialTables.length * 2);
    }
    if (store.owner != user) throw StateError('Account changed');
    await importMedia?.call(user);
    await store.database.transaction(() async {
      final projection = LegacyDataProjection(store);
      for (final table in legacyFinancialTables) {
        String? cursor;
        while (true) {
          final rows = await store.list(
            'stage:${table.name}',
            userId: user,
            afterId: cursor,
            limit: 200,
          );
          for (final row in rows) {
            await projection.project(table.name, row);
            cursor = row['id'] as String;
          }
          if (rows.length < 200) break;
        }
      }
      if (store.owner != user) throw StateError('Account changed');
      await _save(user, completeStage, {
        'verified': true,
        'tables': legacyFinancialTables.length,
        'finished_at': DateTime.now().toUtc().toIso8601String(),
      });
      // No duplicate raw SMS archive after a successful atomic projection.
      await store.database.customStatement(
        "DELETE FROM private_records WHERE owner=? AND kind LIKE 'stage:%'",
        [user],
      );
    });
    await _compact(user);
  }

  Future<void> _compact(String user) async {
    final checkpoint = await _journal(user, completeStage);
    if (checkpoint?['compacted'] == true) return;
    if (store.owner != user) throw StateError('Account changed');
    try {
      // Reclaim pages formerly occupied by staging and uncompressed SMS.
      // Native SQLite retains the active encryption settings during VACUUM.
      await store.database.customStatement('VACUUM');
    } catch (_) {
      // Low free space must not invalidate an already verified import.
      // Leave the flag unset so a later launch retries compaction safely.
      return;
    }
    if (store.owner != user) throw StateError('Account changed');
    await _save(user, completeStage, {...checkpoint!, 'compacted': true});
  }
}
