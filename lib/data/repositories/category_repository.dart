import '../../domain/repositories/category_repository.dart' as domain;
import '../../domain/entities/item_model.dart';
import '../remote/datasources/category_remote_datasource.dart';
import '../../core/utils/app_logger.dart';

class CategoryRepository implements domain.CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepository({required this.remoteDataSource});

  /// Get all system categories
  @override
  Future<List<Category>> getSystemCategories() async {
    try {
      return await remoteDataSource.getSystemCategories();
    } catch (e) {
      logError('Error getting system categories: $e');
      return [];
    }
  }

  /// Get all user categories (including system)
  @override
  Future<List<Category>> getUserCategories(String userId) async {
    try {
      return await remoteDataSource.getUserCategories(userId);
    } catch (e) {
      logError('Error getting user categories: $e');
      return [];
    }
  }

  /// Get category by ID
  @override
  Future<Category?> getCategory(String categoryId) async {
    try {
      return await remoteDataSource.getCategory(categoryId);
    } catch (e) {
      logError('Error getting category: $e');
      return null;
    }
  }

  /// Create a new custom category
  @override
  Future<Category> createCategory({
    required String userId,
    required String name,
    required String nameAr,
    required String icon,
    required String type,
    String? parentId,
  }) async {
    final category = Category(
      id: '',
      userId: userId,
      name: name,
      nameAr: nameAr,
      icon: icon,
      type: type,
      parentId: parentId,
      isSystem: false,
      isActive: true,
    );

    try {
      return await remoteDataSource.createCategory(category);
    } catch (e) {
      logError('Error creating category: $e');
      rethrow;
    }
  }

  /// Update a category
  @override
  Future<Category> updateCategory(Category category) async {
    try {
      return await remoteDataSource.updateCategory(category);
    } catch (e) {
      logError('Error updating category: $e');
      rethrow;
    }
  }

  /// Delete a category
  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await remoteDataSource.deleteCategory(categoryId);
    } catch (e) {
      logError('Error deleting category: $e');
      rethrow;
    }
  }

  /// Get expense categories for a user
  @override
  Future<List<Category>> getExpenseCategories(String userId) async {
    try {
      final categories = await getUserCategories(userId);
      return categories
          .where((c) => c.type == 'expense' && c.isActive)
          .toList();
    } catch (e) {
      logError('Error getting expense categories: $e');
      return [];
    }
  }

  /// Get income categories for a user
  @override
  Future<List<Category>> getIncomeCategories(String userId) async {
    try {
      final categories = await getUserCategories(userId);
      return categories.where((c) => c.type == 'income' && c.isActive).toList();
    } catch (e) {
      logError('Error getting income categories: $e');
      return [];
    }
  }

  /// Get subcategories for a parent category
  @override
  Future<List<Category>> getSubcategories(String parentId) async {
    try {
      final categories = await remoteDataSource.getSubcategories(parentId);
      return categories;
    } catch (e) {
      logError('Error getting subcategories: $e');
      return [];
    }
  }

  /// Deactivate a category
  @override
  Future<void> deactivateCategory(String categoryId) async {
    try {
      final category = await remoteDataSource.getCategory(categoryId);
      if (category != null) {
        await remoteDataSource.updateCategory(
          category.copyWith(isActive: false),
        );
      }
    } catch (e) {
      logError('Error deactivating category: $e');
      rethrow;
    }
  }
}
