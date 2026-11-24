import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:crypto/crypto.dart';
import '../../config/supabase_config.dart';
import '../local/datasources/private_record_store.dart';

/// Reads old storage objects into the encrypted vault. POST is used only by
/// Supabase's object-list endpoint (a read operation); no uploads/deletes exist.
class LegacyMediaImport {
  final http.Client client;
  final String? Function() token;
  final PrivateRecordStore store;
  LegacyMediaImport(this.client, this.token, this.store);
  Future<void> run(String user) async {
    for (final bucket in ['item-images', 'receipt-images']) {
      await _folder(user, bucket, '$user/');
    }
  }

  Map<String, String> get _headers => {
    'apikey': SupabaseConfig.publishableKey,
    'Authorization': 'Bearer ${token()}',
    'Content-Type': 'application/json',
  };
  Future<void> _folder(String user, String bucket, String prefix) async {
    if (store.owner != user ||
        token() == null ||
        !prefix.startsWith('$user/') ||
        prefix.contains('..')) {
      throw StateError('Account changed');
    }
    for (var offset = 0; ; offset += 1000) {
      final response = await client
          .post(
            Uri.parse('${SupabaseConfig.url}/storage/v1/object/list/$bucket'),
            headers: _headers,
            body: jsonEncode({
              'prefix': prefix.endsWith('/')
                  ? prefix.substring(0, prefix.length - 1)
                  : prefix,
              'limit': 1000,
              'offset': offset,
              'sortBy': {'column': 'name', 'order': 'asc'},
            }),
          )
          .timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) {
        throw StateError('Legacy media listing failed');
      }
      final objects = jsonDecode(response.body) as List;
      for (final raw in objects) {
        if (store.owner != user) throw StateError('Account changed');
        final item = raw as Map<String, dynamic>;
        final name = item['name'] as String;
        if (name.contains('/') || name.contains('..')) {
          throw StateError('Unexpected storage name');
        }
        final path = '$prefix$name';
        if (item['id'] == null) {
          await _folder(user, bucket, '$path/');
          continue;
        }
        final id = '$bucket/$path';
        final old = await store.database
            .customSelect(
              'SELECT id FROM private_media WHERE owner=? AND id=?',
              variables: [Variable(user), Variable(id)],
            )
            .getSingleOrNull();
        if (old != null) continue;
        final download = await client
            .get(
              Uri.parse(
                '${SupabaseConfig.url}/storage/v1/object/authenticated/$bucket/$path',
              ),
              headers: _headers,
            )
            .timeout(const Duration(seconds: 30));
        if (download.statusCode != 200 || store.owner != user) {
          throw StateError('Legacy media download failed');
        }
        final mime =
            download.headers['content-type']?.split(';').first ??
            'application/octet-stream';
        final expected = sha256.convert(download.bodyBytes).toString();
        await store.database.customStatement(
          'INSERT OR IGNORE INTO private_media(owner,id,mime,payload) VALUES(?,?,?,?)',
          [user, id, mime, packPrivateData(download.bodyBytes)],
        );
        final saved = await store.database
            .customSelect(
              'SELECT payload FROM private_media WHERE owner=? AND id=?',
              variables: [Variable(user), Variable(id)],
            )
            .getSingle();
        if (sha256
                .convert(unpackPrivateData(saved.read<Uint8List>('payload')))
                .toString() !=
            expected) {
          throw StateError('Media verification failed');
        }
      }
      if (objects.length < 1000) break;
    }
  }
}
