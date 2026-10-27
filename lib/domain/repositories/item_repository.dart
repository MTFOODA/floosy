import '../entities/item_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class ItemRepository {
  Future<List<Item>> getActiveItems(String userId);

  Future<List<Item>> getAllItems(String userId);

  Future<Item?> getItem(String itemId);

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
  });

  Future<Item> updateItem(Item item);

  Future<void> updatePrice({
    required String itemId,
    required int newPriceMinor,
  });

  Future<List<ItemPriceHistory>> getPriceHistory(String itemId);

  Future<void> archiveItem(String itemId);

  Future<void> deactivateItem(String itemId);

  Future<void> deleteItem(String itemId);

  Future<List<Item>> searchItems({
    required String userId,
    required String query,
  });

  Future<List<Item>> getItemsByCategory({
    required String userId,
    required String categoryId,
  });
}
