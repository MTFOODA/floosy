import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

Uint8List packPrivateData(List<int> raw) {
  final packed = gzip.encode(raw);
  return Uint8List.fromList(
    packed.length < raw.length ? [1, ...packed] : [0, ...raw],
  );
}

List<int> unpackPrivateData(List<int> bytes) =>
    bytes.first == 1 ? gzip.decode(bytes.sublist(1)) : bytes.sublist(1);

/// Compact extension storage inside the encrypted database. No plain JSON
/// files/preferences; every access is scoped to the active account.
class PrivateRecordStore {
  final AppDatabase database;
  final String? Function() activeUser;
  PrivateRecordStore(this.database, this.activeUser);
  String get owner => activeUser() ?? (throw StateError('Sign in first'));

  Future<List<Map<String, dynamic>>> list(
    String kind, {
    String? userId,
    String? afterId,
    int? limit,
  }) async {
    final user = userId ?? owner;
    if (activeUser() != user) throw StateError('Account changed');
    final rows = await database
        .customSelect(
          'SELECT payload FROM private_records WHERE owner = ? AND kind = ? ${afterId == null ? "" : "AND id > ?"} ORDER BY id ${limit == null ? "" : "LIMIT ?"}',
          variables: [
            Variable(user),
            Variable(kind),
            if (afterId != null) Variable(afterId),
            if (limit != null) Variable(limit),
          ],
        )
        .get();
    return rows
        .map(
          (r) => Map<String, dynamic>.from(
            jsonDecode(
                  utf8.decode(unpackPrivateData(r.read<Uint8List>('payload'))),
                )
                as Map,
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>?> get(String kind, String id) async {
    final rows = await database
        .customSelect(
          'SELECT payload FROM private_records WHERE owner = ? AND kind = ? AND id = ?',
          variables: [Variable(owner), Variable(kind), Variable(id)],
        )
        .get();
    return rows.isEmpty
        ? null
        : Map<String, dynamic>.from(
            jsonDecode(
                  utf8.decode(
                    unpackPrivateData(rows.single.read<Uint8List>('payload')),
                  ),
                )
                as Map,
          );
  }

  Future<Map<String, dynamic>> put(
    String kind,
    Map<String, dynamic> value, {
    String? userId,
    bool onlyIfMissing = false,
    bool timestamps = true,
  }) async {
    final user = userId ?? owner;
    if (activeUser() != user ||
        (value['user_id'] != null && value['user_id'] != user)) {
      throw StateError('Account changed');
    }
    final row = Map<String, dynamic>.from(value);
    if ((row['id']?.toString() ?? '').isEmpty) row['id'] = const Uuid().v4();
    if (timestamps) {
      row['created_at'] ??= DateTime.now().toUtc().toIso8601String();
      row['updated_at'] ??= row['created_at'];
    }
    await database.customStatement(
      '''INSERT INTO private_records(owner,kind,id,payload) VALUES(?,?,?,?)
      ON CONFLICT(owner,kind,id) ${onlyIfMissing ? 'DO NOTHING' : 'DO UPDATE SET payload=excluded.payload'}''',
      [user, kind, row['id'], packPrivateData(utf8.encode(jsonEncode(row)))],
    );
    return row;
  }

  Future<void> delete(String kind, String id) => database.customStatement(
    'DELETE FROM private_records WHERE owner=? AND kind=? AND id=?',
    [owner, kind, id],
  );
  Future<Map<String, dynamic>> patch(
    String kind,
    String id,
    Map<String, dynamic> changes,
  ) async {
    final row = await get(kind, id);
    if (row == null) throw StateError('Record not found');
    return put(kind, {
      ...row,
      ...changes,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
