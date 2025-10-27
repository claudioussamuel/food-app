import 'package:foodu/data/abstract/base_repository.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository extends TBaseRepositoryController<CategoryModel> {
  final String _collection = 'categories';

  Stream<List<CategoryModel>> categories() => db
      .collection(_collection)
      .snapshots()
      .map((q) => q.docs.map((d) => CategoryModel.fromJson(d)).toList());

  /// Get categories filtered by branch ID
  Stream<List<CategoryModel>> categoriesByBranch(String branchId) => db
      .collection(_collection)
      .where('branchId', isEqualTo: branchId)
      .snapshots()
      .map((q) => q.docs.map((d) => CategoryModel.fromJson(d)).toList());

  /// Get categories available in multiple branches (using availableBranches array)
  Stream<List<CategoryModel>> categoriesByAvailableBranches(String branchId) => db
      .collection(_collection)
      .where('availableBranches', arrayContains: branchId)
      .snapshots()
      .map((q) => q.docs.map((d) => CategoryModel.fromJson(d)).toList());

  /// Get categories for a specific branch (checks both branchId and availableBranches)
  Stream<List<CategoryModel>> categoriesForBranch(String branchId) {
    return db
        .collection(_collection)
        .where('availableBranches', arrayContains: branchId)
        .snapshots()
        .map((q) => q.docs.map((d) => CategoryModel.fromJson(d)).toList());
  }

  /// Get categories for a specific branch as Future (for one-time fetch)
  Future<List<CategoryModel>> categoriesForBranchOnce(String branchId) async {
    final snapshot = await db
        .collection(_collection)
        .where('availableBranches', arrayContains: branchId)
        .get();
    return snapshot.docs.map((d) => CategoryModel.fromJson(d)).toList();
  }

  @override
  Future<List<CategoryModel>> fetchAllItems() async {
    final snapshot = await db.collection(_collection).get();
    return snapshot.docs.map((d) => CategoryModel.fromJson(d)).toList();
  }

  @override
  Future<CategoryModel> fetchSingleItem(String id) async {
    final doc = await db.collection(_collection).doc(id).get();
    return CategoryModel.fromJson(doc);
  }

  @override
  Future<String> addItem(CategoryModel item) async {
    final doc = db.collection(_collection).doc();
    await doc.set(item.toJson());
    return doc.id;
  }

  @override
  Future<void> updateItem(CategoryModel item) async {
    await db.collection(_collection).doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection(_collection).doc(id).update(json);
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    await db.collection(_collection).doc(item.id).delete();
  }

  @override
  Query fetchLimitedItems(int limit) {
    return db.collection(_collection).limit(limit);
  }

  @override
  CategoryModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return CategoryModel.fromJson(doc);
  }
}
