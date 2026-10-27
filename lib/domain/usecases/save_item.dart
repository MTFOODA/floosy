import '../entities/item_model.dart';
import '../entities/image_reference.dart';
import '../repositories/item_repository.dart';
import '../repositories/financial_queries_repository.dart';

class ItemDraft {
  final Item? existing;
  final String userId;
  final String name;
  final String? nameAr;
  final int priceMinor;
  final String icon;
  final String? pickedImagePath;
  const ItemDraft(
      {this.existing,
      required this.userId,
      required this.name,
      this.nameAr,
      required this.priceMinor,
      required this.icon,
      this.pickedImagePath});
}

/// Saves the item, uploads only a newly picked device file, and records price
/// history. Failed uploads preserve an existing image reference.
class SaveItem {
  final ItemRepository _items;
  final FinancialQueriesRepository _images;
  const SaveItem(this._items, this._images);
  Future<Item> call(ItemDraft draft) async {
    if (draft.name.trim().isEmpty || draft.priceMinor <= 0) {
      throw ArgumentError('A name and positive price are required');
    }
    final existing = draft.existing;
    if (existing != null && existing.userId != draft.userId) {
      throw ArgumentError('Item does not belong to this account');
    }
    var item = existing ??
        await _items.createItem(
            userId: draft.userId,
            name: draft.name.trim(),
            nameAr: draft.nameAr,
            priceMinor: draft.priceMinor,
            currency: 'EGP',
            icon: draft.icon);
    String? image = item.imageUrl;
    final path = draft.pickedImagePath;
    if (path != null && isLocalFilePath(path)) {
      image = await _images.uploadImage(
              userId: draft.userId, itemId: item.id, filePath: path) ??
          image;
    }
    if (existing != null || image != item.imageUrl) {
      item = await _items.updateItem(item.copyWith(
          name: draft.name.trim(),
          nameAr: draft.nameAr,
          priceMinor: draft.priceMinor,
          icon: draft.icon,
          imageUrl: image));
    }
    if (existing != null && existing.priceMinor != draft.priceMinor) {
      await _items.updatePrice(
          itemId: existing.id, newPriceMinor: draft.priceMinor);
    }
    return item;
  }
}
