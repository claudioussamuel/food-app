import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:get/get.dart';

class BranchRepository extends GetxController {
  static BranchRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'branches';

  /// Get all branches
  Future<List<BranchModel>> getAllItems() async {
    try {
      // Run migration on first fetch to ensure all branches have branchId
      await migrateBranchIds();
      
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => BranchModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Failed to fetch branches: $e';
    }
  }

  /// Add new branch
  Future<void> addItem(BranchModel branch) async {
    try {
      final docRef = branch.id.isNotEmpty 
          ? _firestore.collection(_collectionName).doc(branch.id)
          : _firestore.collection(_collectionName).doc();
      
      // Ensure ID matches document ID
      final branchData = branch.toJson();
      branchData['id'] = docRef.id;
      
      print('💾 DEBUG: Adding branch with ID: "${docRef.id}"');
      await docRef.set(branchData);
    } catch (e) {
      throw 'Failed to add branch: $e';
    }
  }

  /// Update branch
  Future<void> updateItem(BranchModel branch) async {
    try {
      // Ensure ID matches document ID
      final branchData = branch.toJson();
      branchData['id'] = branch.id;
      branchData['updatedAt'] = DateTime.now().toIso8601String();
      
      print('💾 DEBUG: Updating branch with ID: "${branch.id}"');
      await _firestore.collection(_collectionName).doc(branch.id).update(branchData);
    } catch (e) {
      throw 'Failed to update branch: $e';
    }
  }

  /// Delete branch
  Future<void> deleteItem(BranchModel branch) async {
    try {
      await _firestore.collection(_collectionName).doc(branch.id).delete();
    } catch (e) {
      throw 'Failed to delete branch: $e';
    }
  }

  /// Get all active branches
  Future<List<BranchModel>> getActiveBranches() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => BranchModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Failed to get active branches: $e';
    }
  }

  /// Get branches stream for real-time updates
  Stream<List<BranchModel>> branches({bool activeOnly = false}) {
    try {
      Query query = _firestore.collection(_collectionName).orderBy('name');
      
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => BranchModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList());
    } catch (e) {
      throw 'Failed to get branches stream: $e';
    }
  }

  /// Search branches by name or address
  Future<List<BranchModel>> searchBranches(String searchTerm) async {
    try {
      final nameResults = await _firestore
          .collection(_collectionName)
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      final addressResults = await _firestore
          .collection(_collectionName)
          .where('address', isGreaterThanOrEqualTo: searchTerm)
          .where('address', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      // Combine results and remove duplicates
      final Set<String> seenIds = {};
      final List<BranchModel> branches = [];

      for (final doc in [...nameResults.docs, ...addressResults.docs]) {
        if (!seenIds.contains(doc.id)) {
          seenIds.add(doc.id);
          branches.add(BranchModel.fromSnapshot(doc));
        }
      }

      return branches;
    } catch (e) {
      throw 'Failed to search branches: $e';
    }
  }

  /// Get branches near a location (simple implementation)
  Future<List<BranchModel>> getBranchesNearLocation(
    double latitude, 
    double longitude, 
    {double radiusKm = 10.0}
  ) async {
    try {
      // Simple implementation - get all branches and filter by distance
      final allBranches = await getActiveBranches();
      
      return allBranches.where((branch) {
        final distance = branch.distanceFrom(latitude, longitude);
        // Simple distance check (not accurate for large distances)
        return distance <= (radiusKm * radiusKm / 10000); // Rough approximation
      }).toList();
    } catch (e) {
      throw 'Failed to get nearby branches: $e';
    }
  }

  /// Toggle branch active status
  Future<void> toggleBranchStatus(String branchId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(branchId).get();
      if (doc.exists) {
        final currentStatus = doc.data()?['isActive'] ?? true;
        await _firestore.collection(_collectionName).doc(branchId).update({
          'isActive': !currentStatus,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw 'Failed to toggle branch status: $e';
    }
  }

  /// Get branch statistics
  Future<Map<String, int>> getBranchStats() async {
    try {
      final allBranches = await getAllItems();
      final activeBranches = allBranches.where((branch) => branch.isActive).length;
      final inactiveBranches = allBranches.length - activeBranches;

      return {
        'total': allBranches.length,
        'active': activeBranches,
        'inactive': inactiveBranches,
      };
    } catch (e) {
      throw 'Failed to get branch statistics: $e';
    }
  }
  
  /// Migrate existing branches to ensure they have id field matching document ID
  Future<void> migrateBranchIds() async {
    try {
      print('🔄 DEBUG: Starting branch ID migration...');
      final snapshot = await _firestore.collection(_collectionName).get();
      
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final documentId = doc.id;
        
        // Check if id field is missing or doesn't match document ID
        if (data['id'] == null || data['id'] != documentId) {
          print('🔄 Migrating branch: "${data['name']}" (ID: "$documentId")');
          
          await doc.reference.update({
            'id': documentId, // Ensure id field matches document ID
            'updatedAt': DateTime.now().toIso8601String(),
          });
        }
        
        // Remove legacy branchId field if it exists
        if (data.containsKey('branchId')) {
          print('🔄 Removing legacy branchId field from: "${data['name']}"');
          await doc.reference.update({
            'branchId': FieldValue.delete(),
          });
        }
      }
      
      print('✅ Branch ID migration completed!');
    } catch (e) {
      print('❌ Branch ID migration failed: $e');
      throw 'Failed to migrate branch IDs: $e';
    }
  }
}
