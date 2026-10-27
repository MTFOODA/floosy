import '../entities/item_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class CategoryRepository {
  Future<List<Category>> getSystemCategories();

  Future<List<Category>> getUserCategories(String userId);

  Future<Category?> getCategory(String categoryId);

  Future<Category> createCategory({
    required String userId,
    required String name,
    required String nameAr,
    required String icon,
    required String type,
    String? parentId,
  });

  Future<Category> updateCategory(Category category);

  Future<void> deleteCategory(String categoryId);

  Future<List<Category>> getExpenseCategories(String userId);

  Future<List<Category>> getIncomeCategories(String userId);

  Future<List<Category>> getSubcategories(String parentId);

  Future<void> deactivateCategory(String categoryId);
}
