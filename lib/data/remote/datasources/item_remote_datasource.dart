import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/item_model.dart';

/// Remote data source for items, categories, merchants, cash wallets and
/// cash movements (all live in [item_model.dart] domain models).
class ItemRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  ItemRemoteDataSource(this._supabaseClient);

  Future<List<Item>> getActiveItems(String userId) async {
    final response = await _supabaseClient
        .from('items')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .eq('is_archived', false)
        .order('name');
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> getAllItems(String userId) async {
    final response = await _supabaseClient
        .from('items')
        .select()
        .eq('user_id', userId)
        .order('name');
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<Item?> getItem(String itemId) async {
    final response = await _supabaseClient
        .from('items')
        .select()
        .eq('id', itemId)
        .maybeSingle();
    return response == null ? null : Item.fromJson(response);
  }

  Future<Item> createItem(Item item) async {
    final withId = item.id.isEmpty ? item.copyWith(id: _uuid.v4()) : item;
    final response = await _supabaseClient
        .from('items')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return Item.fromJson(response);
  }

  Future<Item> updateItem(Item item) async {
    final response = await _supabaseClient
        .from('items')
        .update(item.toJson()..remove('created_at'))
        .eq('id', item.id)
        .select()
        .single();
    return Item.fromJson(response);
  }

  /// Updates the item price and records a new entry in item_price_history.
  /// Historical transactions keep their original amounts.
  Future<void> updatePrice(String itemId, int newPriceMinor) async {
    final now = DateTime.now().toUtc();
    await _supabaseClient.from('items').update({
      'price_minor': newPriceMinor,
      'updated_at': now.toIso8601String()
    }).eq('id', itemId);

    // Close any open price-history row, then open a new one.
    await _supabaseClient
        .from('item_price_history')
        .update({'effective_to': now.toIso8601String()})
        .eq('item_id', itemId)
        .filter('effective_to', 'is', null);

    await _supabaseClient.from('item_price_history').insert({
      'id': _uuid.v4(),
      'item_id': itemId,
      'price_minor': newPriceMinor,
      'effective_from': now.toIso8601String(),
    });
  }

  Future<List<ItemPriceHistory>> getPriceHistory(String itemId) async {
    final response = await _supabaseClient
        .from('item_price_history')
        .select()
        .eq('item_id', itemId)
        .order('effective_from', ascending: false);
    return (response as List)
        .map((json) => ItemPriceHistory.fromJson(json))
        .toList();
  }

  Future<void> archiveItem(String itemId) async {
    await _supabaseClient
        .from('items')
        .update({'is_archived': true, 'is_active': false}).eq('id', itemId);
  }

  Future<void> deactivateItem(String itemId) async {
    await _supabaseClient
        .from('items')
        .update({'is_active': false}).eq('id', itemId);
  }

  Future<void> deleteItem(String itemId) async {
    await _supabaseClient.from('items').delete().eq('id', itemId);
  }
}
