import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/item_local_datasource.dart';
import 'package:floosy/data/models/item_model.dart';
import 'package:floosy/data/services/item_image_service.dart';

/// Regression tests for the Item IMAGE end-to-end persistence contract.
///
/// The app stores an image by uploading the picked local file to the
/// `item-images` Supabase bucket and persisting the resulting STORAGE PATH
/// (`{userId}/{itemId}.{ext}`) into the `items.image_url` column. These tests
/// pin the two invariants that previously broke the feature:
///
///  1. The reference must survive every mapping layer unchanged (Supabase
///     snake_case JSON, Drift local cache insert/update/upsert) — it must
///     never be dropped, nulled or replaced with a local temp path.
///  2. The edit save path must only treat REAL local file paths as new uploads
///     — a persisted storage path (or URL) must never be passed to the upload
///     service, because that nulls out the existing image.
void main() {
  group('Item image reference — Supabase snake_case JSON mapping', () {
    test('image_url storage path survives toJson/fromJson (create+update payload)', () {
      const storagePath =
          '3f9a6c20-7d5e-4b1a-9f0c-123456789abc/'
          'a8b7c6d5-e4f3-a2b1-0987-654321fedcba.jpg';
      const item = Item(
        id: 'item-1',
        userId: '3f9a6c20-7d5e-4b1a-9f0c-123456789abc',
        name: 'Water',
        priceMinor: 500,
        imageUrl: storagePath,
      );

      final json = item.toJson();
      final wireValue = json['image_url'] as String;
      expect(wireValue, equals(storagePath));
      // The database row must never receive a local/device file path.
      expect(wireValue.startsWith('/'), isFalse);
      expect(wireValue.contains('\\'), isFalse);

      final restored = Item.fromJson(json);
      expect(restored.imageUrl, equals(storagePath));
    });

    test('stale local temp paths are round-tripped verbatim AND flagged as local (never persisted as the display ref)', () {
      const tempAndroidPath = '/storage/emulated/0/Pictures/floosy_12345.jpg';
      final roundTripped = Item.fromJson(const Item(
        id: 'item-2',
        userId: 'user-1',
        name: 'Coffee',
        priceMinor: 300,
        imageUrl: tempAndroidPath,
      ).toJson());
      expect(roundTripped.imageUrl, equals(tempAndroidPath));
      // The save path guard must refuse to upload it as-is — this value must
      // go through the upload service which replaces it with a storage path.
      expect(isLocalFilePath(tempAndroidPath), isTrue);
    });
  });

  group('Item image reference — Drift local datasource (offline cache)', () {
    const storagePath =
        'user-12345678-1234-1234-1234-123456789012/'
        'item-aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee.png';

    late db.AppDatabase database;
    late ItemLocalDataSource items;

    setUp(() {
      // Fresh in-memory SQLite per test — mirrors sms_pipeline_test /
      // money_summary_test so there is no on-disk state between tests.
      database = db.AppDatabase(NativeDatabase.memory());
      items = ItemLocalDataSource(database);
    });

    tearDown(() => database.close());

    test('insert → select preserves image_url (create path)', () async {
      await items.insertItem(Item(
        id: 'item-1',
        userId: 'user-1',
        name: 'Water',
        priceMinor: 500,
        imageUrl: storagePath,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ));
      final loaded = await items.getItems('user-1');
      expect(loaded, hasLength(1));
      expect(loaded.first.imageUrl, equals(storagePath));
    });

    test('update without touching the image keeps image_url (edit path)', () async {
      final original = Item(
        id: 'item-1',
        userId: 'user-1',
        name: 'Water',
        priceMinor: 500,
        imageUrl: storagePath,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      await items.insertItem(original);
      await items.updateItem(original.copyWith(name: 'Water 1L', priceMinor: 600));

      final loadedMaybe = await items.getItem('item-1');
      expect(loadedMaybe, isNotNull);
      final loaded = loadedMaybe!;
      expect(loaded.name, equals('Water 1L'));
      expect(loaded.priceMinor, equals(600));
      expect(loaded.imageUrl, equals(storagePath),
          reason: 'editing name/price must NOT wipe the existing image_url');
    });

    test('upsert (remote→local sync) keeps image_url', () async {
      final remote = Item(
        id: 'item-1',
        userId: 'user-1',
        name: 'Water',
        priceMinor: 500,
        imageUrl: storagePath,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );
      await items.upsertItem(remote);
      final loaded = await items.getItems('user-1', activeOnly: true);
      expect(loaded, hasLength(1));
      expect(loaded.first.imageUrl, equals(storagePath));
    });
  });

  group('isLocalFilePath guard (edit save path)', () {
    test('recognizes real picker/local device paths as upload candidates', () {
      expect(isLocalFilePath(r'C:\Users\demo\Pictures\pic.jpg'), isTrue);
      expect(isLocalFilePath('/storage/emulated/0/pic.jpg'), isTrue);
      expect(isLocalFilePath('/data/user/0/pic.jpg'), isTrue);
      expect(isLocalFilePath('/var/mobile/pic.jpg'), isTrue);
      expect(isLocalFilePath('/home/demo/pic.jpg'), isTrue);
    });

    test('persisted storage paths and URLs are NOT local files', () {
      expect(isLocalFilePath('user-1/item-1.jpg'), isFalse);
      expect(isLocalFilePath('user-1/item-1.jpeg'), isFalse);
      expect(
          isLocalFilePath('3f9a6c20-7d5e-4b1a-9f0c-123456789abc/item-1.png'),
          isFalse);
      expect(
          isLocalFilePath(
              'https://xyz.supabase.co/object/sign/item-images/user-1/item-1.jpg'),
          isFalse);
    });
  });
}