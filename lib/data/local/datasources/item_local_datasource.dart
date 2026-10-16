import 'package:drift/drift.dart';
import '../../models/item_model.dart';
import '../database/app_database.dart' as db;

/// Offline-first storage for reusable items backed by Drift.
class ItemLocalDataSource {
  final db.AppDatabase _db;

  ItemLocalDataSource(this._db);

  Future<void> insertItem(Item item) async {
    await _db.into(_db.items).insert(db.ItemsCompanion(
          id: Value(item.id),
          userId: Value(item.userId),
          name: Value(item.name),
          nameAr: Value(item.nameAr),
          description: Value(item.description),
          priceMinor: Value(item.priceMinor),
          currency: Value(item.currency),
          categoryId: Value(item.categoryId),
          icon: Value(item.icon),
          imageUrl: Value(item.imageUrl),
          isActive: Value(item.isActive),
          isArchived: Value(item.isArchived),
          createdAt: Value(item.createdAt ?? DateTime.now()),
          updatedAt: Value(item.updatedAt ?? DateTime.now()),
        ));
  }

  /// Atomic upsert used by the remote→local synchronization path.
  ///
  /// When the row does not exist it is INSERTed; when it already exists
  /// every column (including `image_url`, `is_active`, `is_archived` and
  /// `updated_at`) is overwritten with the remote values. This replaces the
  /// previous blind INSERT which crashed with
  /// `UNIQUE constraint failed: items.id` on every refetch.
  Future<void> upsertItem(Item item) async {
    await _db.into(_db.items).insertOnConflictUpdate(db.ItemsCompanion(
          id: Value(item.id),
          userId: Value(item.userId),
          name: Value(item.name),
          nameAr: Value(item.nameAr),
          description: Value(item.description),
          priceMinor: Value(item.priceMinor),
          currency: Value(item.currency),
          categoryId: Value(item.categoryId),
          icon: Value(item.icon),
          imageUrl: Value(item.imageUrl),
          isActive: Value(item.isActive),
          isArchived: Value(item.isArchived),
          createdAt: Value(item.createdAt ?? DateTime.now()),
          updatedAt: Value(item.updatedAt ?? DateTime.now()),
        ));
  }

  Future<List<Item>> getItems(String userId, {bool activeOnly = false}) async {
    final query = _db.select(_db.items)
      ..where((t) {
        var expr = t.userId.equals(userId);
        if (activeOnly) {
          expr = expr & t.isActive.equals(true) & t.isArchived.equals(false);
        }
        return expr;
      })
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    final rows = await query.get();
    return rows.map(_mapItem).toList();
  }

  Future<Item?> getItem(String itemId) async {
    final row = await (_db.select(_db.items)..where((t) => t.id.equals(itemId)))
        .getSingleOrNull();
    return row == null ? null : _mapItem(row);
  }

  Future<void> updateItem(Item item) async {
    await (_db.update(_db.items)..where((t) => t.id.equals(item.id))).write(
      db.ItemsCompanion(
        name: Value(item.name),
        nameAr: Value(item.nameAr),
        description: Value(item.description),
        priceMinor: Value(item.priceMinor),
        currency: Value(item.currency),
        categoryId: Value(item.categoryId),
        icon: Value(item.icon),
        imageUrl: Value(item.imageUrl),
        isActive: Value(item.isActive),
        isArchived: Value(item.isArchived),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    await (_db.delete(_db.items)..where((t) => t.id.equals(itemId))).go();
  }

  Item _mapItem(db.Item row) {
    return Item(
      id: row.id,
      userId: row.userId,
      name: row.name,
      nameAr: row.nameAr,
      description: row.description,
      priceMinor: row.priceMinor,
      currency: row.currency,
      categoryId: row.categoryId,
      icon: row.icon,
      imageUrl: row.imageUrl,
      isActive: row.isActive,
      isArchived: row.isArchived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
