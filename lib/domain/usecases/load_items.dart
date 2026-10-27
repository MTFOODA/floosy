import '../entities/item_model.dart';
import '../repositories/item_repository.dart';
import '../repositories/financial_queries_repository.dart';

class ItemsSnapshot {
  final List<Item> all;
  final Map<String, int> usage;
  final Map<String, bool> highFrequency;
  const ItemsSnapshot(
      {this.all = const [],
      this.usage = const {},
      this.highFrequency = const {}});
  List<Item> get active => all
      .where((item) => item.isActive && !item.isArchived)
      .toList(growable: false);
  double usageShare(String id) {
    final total = usage.values.fold<int>(0, (sum, count) => sum + count);
    return total == 0 ? 0 : (usage[id] ?? 0) / total;
  }
}

class LoadItems {
  final ItemRepository _items;
  final FinancialQueriesRepository _queries;
  const LoadItems(this._items, this._queries);
  Future<ItemsSnapshot> call(String userId, {DateTime? now}) async {
    final date = now ?? DateTime.now();
    final items = await _items.getAllItems(userId);
    final usage = await _queries.getConfirmedItemUsageCounts(
        userId, date.year, date.month);
    final high = <String, bool>{};
    for (final item
        in items.where((item) => item.isActive && !item.isArchived)) {
      high[item.id] =
          await _queries.isHighFrequency(userId: userId, itemId: item.id);
    }
    return ItemsSnapshot(
        all: List.unmodifiable(items),
        usage: Map.unmodifiable(usage),
        highFrequency: Map.unmodifiable(high));
  }
}
