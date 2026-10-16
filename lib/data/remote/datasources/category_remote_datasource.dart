import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/item_model.dart';

class CategoryRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  CategoryRemoteDataSource(this._supabaseClient);

  /// System (global) categories have a null user_id.
  Future<List<Category>> getSystemCategories() async {
    final response = await _supabaseClient
        .from('categories')
        .select()
        .filter('user_id', 'is', null)
        .order('name');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Category>> getUserCategories(String userId) async {
    final response = await _supabaseClient
        .from('categories')
        .select()
        .or('user_id.is.null,user_id.eq.$userId')
        .order('name');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<Category?> getCategory(String categoryId) async {
    final response = await _supabaseClient
        .from('categories')
        .select()
        .eq('id', categoryId)
        .maybeSingle();
    return response == null ? null : Category.fromJson(response);
  }

  Future<Category> createCategory(Category category) async {
    final withId =
        category.id.isEmpty ? category.copyWith(id: _uuid.v4()) : category;
    final response = await _supabaseClient
        .from('categories')
        .insert(withId.toJson()
          ..remove('created_at')
          ..remove('updated_at'))
        .select()
        .single();
    return Category.fromJson(response);
  }

  Future<Category> updateCategory(Category category) async {
    final response = await _supabaseClient
        .from('categories')
        .update(category.toJson()..remove('created_at'))
        .eq('id', category.id)
        .select()
        .single();
    return Category.fromJson(response);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _supabaseClient.from('categories').delete().eq('id', categoryId);
  }

  Future<List<Category>> getSubcategories(String parentId) async {
    final response = await _supabaseClient
        .from('categories')
        .select()
        .eq('parent_id', parentId)
        .order('name');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }
}
