import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'item_image_service.dart';
import '../local/datasources/private_record_store.dart';

class PrivateItemImageService extends ItemImageService {
  final PrivateRecordStore store;
  PrivateItemImageService(super.client, this.store);
  @override
  Future<String?> uploadImage({
    required String userId,
    required String itemId,
    required String filePath,
  }) async {
    if (store.owner != userId) throw StateError('Account changed');
    final ext = filePath.split('.').last.toLowerCase();
    final mime = switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/png',
    };
    final bytes = await File(filePath).readAsBytes();
    if (store.owner != userId) throw StateError('Account changed');
    final id = 'item-images/$userId/$itemId';
    await store.database.customStatement(
      '''INSERT INTO private_media(owner,id,mime,payload) VALUES(?,?,?,?)
      ON CONFLICT(owner,id) DO UPDATE SET mime=excluded.mime,payload=excluded.payload''',
      [userId, id, mime, packPrivateData(bytes)],
    );
    return 'vault-media:$id';
  }

  @override
  Future<String?> resolveImage(String reference) async {
    var id = reference;
    if (id.startsWith('vault-media:')) {
      id = id.substring('vault-media:'.length);
    } else if (id.startsWith('https://')) {
      final uri = Uri.tryParse(id);
      if (uri == null || !uri.path.contains('/item-images/')) return null;
      id = 'item-images/${uri.path.split('/item-images/').last}';
    } else {
      id = 'item-images/$id';
    }
    if (!id.startsWith('item-images/${store.owner}/') || id.contains('..')) {
      return null;
    }
    final row = await store.database
        .customSelect(
          'SELECT payload,mime FROM private_media WHERE owner=? AND id=?',
          variables: [Variable(store.owner), Variable(id)],
        )
        .getSingleOrNull();
    if (row == null) return null;
    final mime = row.read<String>('mime');
    if (!mime.startsWith('image/')) return null;
    return 'data:$mime;base64,${base64Encode(unpackPrivateData(row.read<Uint8List>('payload')))}';
  }

  @override
  Future<void> deleteImage({
    required String userId,
    required String itemId,
  }) async {
    if (store.owner != userId) throw StateError('Account changed');
    await store.database.customStatement(
      'DELETE FROM private_media WHERE owner=? AND id=?',
      [userId, 'item-images/$userId/$itemId'],
    );
  }
}
