import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../abstract/base_repository.dart';
import '../../../features/personalization/models/profile_model.dart';

/// Repository for managing user profile data in Firestore
class ProfileRepository extends TBaseRepositoryController<ProfileModel> {
  static ProfileRepository get instance => Get.find();

  /// Collection reference for profiles
  final String _collection = 'profiles';

  /// Get current user ID
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<List<ProfileModel>> fetchAllItems() async {
    final snapshot = await db.collection(_collection).get();
    return snapshot.docs
        .map((doc) => ProfileModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<ProfileModel> fetchSingleItem(String id) async {
    final doc = await db.collection(_collection).doc(id).get();
    if (!doc.exists) {
      throw 'Profile not found';
    }
    return ProfileModel.fromMap(doc.data()!);
  }

  /// Fetch current user's profile
  Future<ProfileModel?>? fetchCurrentUserProfile() async {
    if (_currentUserId == null) return null;

    try {
      return await fetchSingleItem(_currentUserId!);
    } catch (e) {
      return null; // Profile doesn't exist yet
    }
  }

  @override
  Future<String> addItem(ProfileModel profile) async {
    final docId = _currentUserId ?? db.collection(_collection).doc().id;

    final profileWithTimestamp = profile.copyWith(
      id: docId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await db
        .collection(_collection)
        .doc(docId)
        .set(profileWithTimestamp.toMap());
    return docId;
  }

  @override
  Future<void> updateItem(ProfileModel profile) async {
    if (profile.id == null) {
      throw 'Profile ID is required for update';
    }

    final profileWithTimestamp = profile.copyWith(
      updatedAt: DateTime.now(),
    );

    await db
        .collection(_collection)
        .doc(profile.id)
        .update(profileWithTimestamp.toMap());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    json['updatedAt'] = Timestamp.fromDate(DateTime.now());
    await db.collection(_collection).doc(id).update(json);
  }

  @override
  Future<void> deleteItem(ProfileModel profile) async {
    if (profile.id == null) {
      throw 'Profile ID is required for deletion';
    }
    await db.collection(_collection).doc(profile.id).delete();
  }

  @override
  Query fetchLimitedItems(int limit) {
    return db.collection(_collection).limit(limit);
  }

  @override
  ProfileModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return ProfileModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// Save or update current user's profile
  Future<String> saveCurrentUserProfile(ProfileModel profile) async {
    if (_currentUserId == null) {
      throw 'User not authenticated';
    }

    // Check if profile already exists
    final existingProfile = await fetchCurrentUserProfile();

    if (existingProfile != null) {
      // Update existing profile
      final updatedProfile = profile.copyWith(
        id: _currentUserId,
        createdAt: existingProfile.createdAt,
      );
      await updateItemRecord(updatedProfile);
      return _currentUserId!;
    } else {
      // Create new profile
      return await addNewItem(profile);
    }
  }

  /// Update current user's profile image
  Future<void> updateProfileImage(String imagePath) async {
    if (_currentUserId == null) {
      throw 'User not authenticated';
    }

    await updateSingleItemRecord(_currentUserId!, {
      'profileImagePath': imagePath,
    });
  }

  /// Check if current user has a profile
  Future<bool> hasProfile() async {
    if (_currentUserId == null) return false;

    try {
      await fetchSingleItem(_currentUserId!);
      return true;
    } catch (e) {
      return false;
    }
  }
}
