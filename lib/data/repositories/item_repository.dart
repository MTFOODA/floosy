import '../../domain/repositories/item_repository.dart' as domain;
import 'package:uuid/uuid.dart';
import '../../domain/entities/item_model.dart';
import '../remote/datasources/item_remote_datasource.dart';
import '../local/datasources/item_local_datasource.dart';
import '../../core/utils/app_logger.dart';

class ItemRepository implements domain.ItemRepository {
  final ItemRemoteDataSource remoteDataSource;
  final ItemLocalDataSource? localDataSource;

  ItemRepository({
    required this.remoteDataSource,
    this.localDataSource,
  });

  /// Get all active items for a user (local-first, then remote sync).
  @override
  Future<List<Item>> getActiveItems(String userId) async {
    try {
      final remoteItems = await remoteDataSource.getActiveItems(userId);
      await _syncToLocal(remoteItems);
      return remoteItems;
    } catch (e) {
      logError('Error getting active items: $e');
      if (localDataSource != null) {
        try {
          return await localDataSource!.getItems(userId, activeOnly: true);
        } catch (_) {}
      }
      return [];
    }
  }

  /// Get all items including archived for a user.
  @override
  Future<List<Item>> getAllItems(String userId) async {
    try {
      final items = await remoteDataSource.getAllItems(userId);
      await _syncToLocal(items);
      return items;
    } catch (e) {
      logError('Error getting all items: $e');
      if (localDataSource != null) {
        try {
          return await localDataSource!.getItems(userId);
        } catch (_) {}
      }
      return [];
    }
  }

  /// Pushes remote items into the local Drift cache.
  ///
  /// Uses an atomic UPSERT (insert new rows, update existing ones) instead
  /// of a blind INSERT, and wraps each item in its own error boundary so a
  /// single bad row can never abort the whole synchronization — the failure
  /// is logged and the remaining items still sync (requirement #15).
  Future<void> _syncToLocal(List<Item> items) async {
    if (localDataSource == null) return;
    for (final item in items) {
      try {
        await localDataSource!.upsertItem(item);
        logDebug('ITEM_SYNC upserted ${item.id} '
            'image_url=${item.imageUrl == null ? "null" : "set"}');
      } catch (e) {
        logError('ITEM_SYNC failed for item ${item.id}', e);
      }
    }
  }

  /// Get item by ID
  @override
  Future<Item?> getItem(String itemId) async {
    try {
      return await remoteDataSource.getItem(itemId);
    } catch (e) {
      logError('Error getting item: $e');
      return null;
    }
  }

  /// Create a new item
  @override
  Future<Item> createItem({
    required String userId,
    required String name,
    required String? nameAr,
    required int priceMinor,
    required String currency,
    String? categoryId,
    String? description,
    String? icon,
    String? imageUrl,
  }) async {
    final id = const Uuid().v4();
    final item = Item(
      id: id,
      userId: userId,
      name: name,
      nameAr: nameAr,
      description: description,
      priceMinor: priceMinor,
      currency: currency,
      categoryId: categoryId,
      icon: icon,
      imageUrl: imageUrl,
      isActive: true,
      isArchived: false,
    );

    try {
      // Local-first for offline support.
      await localDataSource?.insertItem(item);
      return await remoteDataSource.createItem(item);
    } catch (e) {
      logError('Error creating item: $e');
      // Save locally so the user keeps the item even offline.
      if (localDataSource != null) {
        try {
          await localDataSource!.insertItem(item);
        } catch (_) {}
      }
      rethrow;
    }
  }

  /// Update an existing item
  @override
  Future<Item> updateItem(Item item) async {
    try {
      await localDataSource?.updateItem(item);
      return await remoteDataSource.updateItem(item);
    } catch (e) {
      logError('Error updating item: $e');
      rethrow;
    }
  }

  /// Update item price
  @override
  Future<void> updatePrice({
    required String itemId,
    required int newPriceMinor,
  }) async {
    try {
      await remoteDataSource.updatePrice(itemId, newPriceMinor);
    } catch (e) {
      logError('Error updating price: $e');
      rethrow;
    }
  }

  /// Get price history for an item
  @override
  Future<List<ItemPriceHistory>> getPriceHistory(String itemId) async {
    try {
      return await remoteDataSource.getPriceHistory(itemId);
    } catch (e) {
      logError('Error getting price history: $e');
      return [];
    }
  }

  /// Archive an item
  @override
  Future<void> archiveItem(String itemId) async {
    try {
      await remoteDataSource.archiveItem(itemId);
      final localItem = await localDataSource?.getItem(itemId);
      if (localItem != null) {
        await localDataSource
            ?.updateItem(localItem.copyWith(isArchived: true, isActive: false));
      }
    } catch (e) {
      logError('Error archiving item: $e');
      rethrow;
    }
  }

  /// Deactivate an item
  @override
  Future<void> deactivateItem(String itemId) async {
    try {
      await remoteDataSource.deactivateItem(itemId);
      final localItem = await localDataSource?.getItem(itemId);
      if (localItem != null) {
        await localDataSource?.updateItem(localItem.copyWith(isActive: false));
      }
    } catch (e) {
      logError('Error deactivating item: $e');
      rethrow;
    }
  }

  /// Delete an item
  @override
  Future<void> deleteItem(String itemId) async {
    try {
      await localDataSource?.deleteItem(itemId);
      await remoteDataSource.deleteItem(itemId);
    } catch (e) {
      logError('Error deleting item: $e');
      rethrow;
    }
  }

  /// Search items by name
  @override
  Future<List<Item>> searchItems({
    required String userId,
    required String query,
  }) async {
    try {
      final items = await remoteDataSource.getActiveItems(userId);
      return items
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              (item.nameAr?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    } catch (e) {
      logError('Error searching items: $e');
      return [];
    }
  }

  /// Get items by category
  @override
  Future<List<Item>> getItemsByCategory({
    required String userId,
    required String categoryId,
  }) async {
    try {
      final items = await remoteDataSource.getActiveItems(userId);
      return items.where((item) => item.categoryId == categoryId).toList();
    } catch (e) {
      logError('Error getting items by category: $e');
      return [];
    }
  }
}
