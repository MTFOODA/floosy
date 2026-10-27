import '../../../../domain/usecases/save_item.dart';
import '../../../../core/state/async_cubit.dart';
import '../../../../domain/entities/item_model.dart';
import '../../../../domain/repositories/financial_queries_repository.dart';
import '../../../../domain/usecases/load_items.dart';
import '../../../../domain/repositories/item_repository.dart';

class ItemsCubit extends AsyncCubit<ItemsSnapshot> {
  final ItemRepository _repository;
  final String? Function() _userId;
  final void Function() _onChanged;
  final FinancialQueriesRepository _queries;
  late final LoadItems _loadItems = LoadItems(_repository, _queries);
  ItemsCubit(this._repository, this._queries, this._userId, this._onChanged);
  Future<Item> save(ItemDraft draft) async {
    final item = await SaveItem(_repository, _queries)(draft);
    _onChanged();
    return item;
  }

  Future<void> reload() {
    final userId = _userId();
    if (userId == null) {
      clear(const ItemsSnapshot());
      return Future.value();
    }
    return load(() => _loadItems(userId));
  }

  Future<String?> uploadImage(
          {required String userId,
          required String itemId,
          required String filePath}) =>
      _queries.uploadImage(userId: userId, itemId: itemId, filePath: filePath);
  Future<void> deleteImage({required String userId, required String itemId}) =>
      _queries.deleteImage(userId: userId, itemId: itemId);

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
    final result = await _repository.createItem(
        userId: userId,
        name: name,
        nameAr: nameAr,
        priceMinor: priceMinor,
        currency: currency,
        categoryId: categoryId,
        description: description,
        icon: icon,
        imageUrl: imageUrl);
    _onChanged();
    return result;
  }

  Future<Item> updateItem(Item item) async {
    final result = await _repository.updateItem(item);
    _onChanged();
    return result;
  }

  Future<void> updatePrice({
    required String itemId,
    required int newPriceMinor,
  }) async {
    await _repository.updatePrice(itemId: itemId, newPriceMinor: newPriceMinor);
    _onChanged();
  }

  Future<void> archiveItem(String itemId) async {
    await _repository.archiveItem(itemId);
    _onChanged();
  }

  Future<void> deactivateItem(String itemId) async {
    await _repository.deactivateItem(itemId);
    _onChanged();
  }
}
