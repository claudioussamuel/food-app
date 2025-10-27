import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodu/data/abstract/base_repository.dart';
import 'package:foodu/features/home_action_menu/model/search_food_item_model.dart';

class SearchRepository extends TBaseRepositoryController<SearchFoodItemModel> {
  final String _collection = 'products';

  /// Search products by name or description
  Stream<List<SearchFoodItemModel>> searchProducts(String searchQuery) {
    if (searchQuery.isEmpty) {
      return Stream.value([]);
    }

    // Convert search query to lowercase for case-insensitive search
    final query = searchQuery.toLowerCase();

    return db
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SearchFoodItemModel.fromJson(doc))
          .where((product) {
        // Search in name, description, and category
        final name = product.name.toLowerCase();
        final description = product.description.toLowerCase();
        final categories = product.categoryName.map((cat) => cat.toLowerCase()).join(' ');
        
        return name.contains(query) || 
               description.contains(query) || 
               categories.contains(query);
      }).toList();
    });
  }

  /// Get all products as SearchFoodItemModel
  Stream<List<SearchFoodItemModel>> getAllSearchProducts() => db
      .collection(_collection)
      .snapshots()
      .map((q) => q.docs.map((d) => SearchFoodItemModel.fromJson(d)).toList());

  /// Get products by category ID for search
  Stream<List<SearchFoodItemModel>> searchProductsByCategory(String categoryId, String searchQuery) {
    Query query = db.collection(_collection);
    
    if (categoryId != 'All') {
      query = query.where('categoryName', arrayContains: categoryId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SearchFoodItemModel.fromJson(doc))
          .where((product) {
        if (searchQuery.isEmpty) return true;
        
        final query = searchQuery.toLowerCase();
        final name = product.name.toLowerCase();
        final description = product.description.toLowerCase();
        
        return name.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Future<List<SearchFoodItemModel>> fetchAllItems() async {
    final snapshot = await db.collection(_collection).get();
    return snapshot.docs.map((d) => SearchFoodItemModel.fromJson(d)).toList();
  }

  @override
  Future<SearchFoodItemModel> fetchSingleItem(String id) async {
    final doc = await db.collection(_collection).doc(id).get();
    return SearchFoodItemModel.fromJson(doc);
  }

  @override
  Future<String> addItem(SearchFoodItemModel item) async {
    final doc = db.collection(_collection).doc();
    await doc.set(item.toJson());
    return doc.id;
  }

  @override
  Future<void> updateItem(SearchFoodItemModel item) async {
    await db.collection(_collection).doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection(_collection).doc(id).update(json);
  }

  @override
  Future<void> deleteItem(SearchFoodItemModel item) async {
    await db.collection(_collection).doc(item.id).delete();
  }

  @override
  Query fetchLimitedItems(int limit) {
    return db.collection(_collection).limit(limit);
  }

  @override
  SearchFoodItemModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return SearchFoodItemModel.fromJson(doc);
  }
}
