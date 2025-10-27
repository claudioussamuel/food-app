import 'package:foodu/data/abstract/base_repository.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository extends TBaseRepositoryController<FoodModel> {
  final String _collection = 'products';

  Stream<List<FoodModel>> products() => db
      .collection(_collection)
      .snapshots()
      .map((q) => q.docs.map((d) => FoodModel.fromJson(d)).toList());

  /// Get products filtered by branch ID
  Stream<List<FoodModel>> productsByBranch(String branchId) => db
      .collection(_collection)
      .where('branchId', isEqualTo: branchId)
      .snapshots()
      .map((q) => q.docs.map((d) => FoodModel.fromJson(d)).toList());

  /// Get products available in multiple branches (using availableBranches array)
  Stream<List<FoodModel>> productsByAvailableBranches(String branchId) => db
      .collection(_collection)
      .where('availableBranches', arrayContains: branchId)
      .snapshots()
      .map((q) => q.docs.map((d) => FoodModel.fromJson(d)).toList());

  /// Get products for a specific branch (checks both branchId and availableBranches)
  Stream<List<FoodModel>> productsForBranch(String branchId) {
    return db
        .collection(_collection)
        .where('availableBranches', arrayContains: branchId)
        .snapshots()
        .map((q) => q.docs.map((d) => FoodModel.fromJson(d)).toList());
  }

  /// Get products for a specific branch as Future (for one-time fetch)
  Future<List<FoodModel>> productsForBranchOnce(String branchId) async {
    final snapshot = await db
        .collection(_collection)
        .where('availableBranches', arrayContains: branchId)
        .get();
    return snapshot.docs.map((d) => FoodModel.fromJson(d)).toList();
  }

  /// Get products filtered by category ID
  Stream<List<FoodModel>> productsByCategory(String categoryId) {
    if (categoryId == 'All') {
      return products();
    }

    return db
        .collection(_collection)
        .where('categoryName', arrayContains: categoryId)
        .snapshots()
        .map((q) => q.docs.map((d) => FoodModel.fromJson(d)).toList());
  }

  /// Get products filtered by category ID and branch
  /// Note: Firestore only allows one array-contains filter per query
  /// So we filter by branch first, then filter by category in-memory
  Stream<List<FoodModel>> productsByCategoryAndBranch(String categoryId, String branchId) {
    return db
        .collection(_collection)
        .where('availableBranches', arrayContains: branchId)
        .snapshots()
        .map((q) {
          final products = q.docs.map((d) => FoodModel.fromJson(d)).toList();
          
          // If "All" category, return all products for this branch
          if (categoryId == 'All') {
            return products;
          }
          
          // Filter by category ID in-memory (categoryName field contains category IDs)
          return products.where((product) {
            return product.categoryName.contains(categoryId);
          }).toList();
        });
  }

  @override
  Future<List<FoodModel>> fetchAllItems() async {
    final snapshot = await db.collection(_collection).get();
    return snapshot.docs.map((d) => FoodModel.fromJson(d)).toList();
  }

  @override
  Future<FoodModel> fetchSingleItem(String id) async {
    final doc = await db.collection(_collection).doc(id).get();
    return FoodModel.fromJson(doc);
  }

  @override
  Future<String> addItem(FoodModel item) async {
    final doc = db.collection(_collection).doc();
    await doc.set(item.toJson());
    return doc.id;
  }

  @override
  Future<void> updateItem(FoodModel item) async {
    await db.collection(_collection).doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection(_collection).doc(id).update(json);
  }

  @override
  Future<void> deleteItem(FoodModel item) async {
    await db.collection(_collection).doc(item.id).delete();
  }

  @override
  Query fetchLimitedItems(int limit) {
    return db.collection(_collection).limit(limit);
  }

  @override
  FoodModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return FoodModel.fromJson(doc);
  }
}
