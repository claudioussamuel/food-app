import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/data/repositories/menu/category_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  // Observable list of categories
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;

  final CategoryRepository _categoryRepository = CategoryRepository();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch all categories from Firestore
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _categoryRepository.getAllItems();
      categories.value = fetchedCategories;
    } catch (e) {
      print('Error fetching categories: $e');
      // You can add error handling here, like showing a snackbar
    } finally {
      isLoading.value = false;
    }
  }

  /// Get categories as stream for real-time updates
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _categoryRepository.categories();
  }

  /// Get categories for current branch
  Stream<List<CategoryModel>> getCategoriesForCurrentBranch() {
    final branchController = Get.find<BranchController>();
    final selectedBranch = branchController.selectedBranch.value;
    
    if (selectedBranch == null) {
      // No branch selected, return empty stream
      return Stream.value(<CategoryModel>[]);
    }
    
    return _categoryRepository.categoriesForBranch(selectedBranch.id);
  }

  /// Get categories for a specific branch
  Stream<List<CategoryModel>> getCategoriesForBranch(String branchId) {
    return _categoryRepository.categoriesForBranch(branchId);
  }

  /// Get category names for chip list
  List<String> get categoryNames {
    return ['All', ...categories.map((category) => category.name).toList()];
  }
  
  /// Get category names for chip list filtered by current branch
  List<String> get branchCategoryNames {
    final branchController = Get.find<BranchController>();
    final selectedBranch = branchController.selectedBranch.value;
    
    if (selectedBranch == null) {
      return ['All']; // Only show "All" if no branch selected
    }
    
    final branchCategories = categories.where((category) {
      // Include categories that have availableBranches containing the selected branch
      // OR categories that don't have availableBranches set (legacy categories)
      return category.availableBranches?.contains(selectedBranch.id) ?? true;
    }).toList();
    
    return ['All', ...branchCategories.map((category) => category.name).toList()];
  }
  
  /// Get category images for chip list
  List<String> get categoryImages {
    return ['', ...categories.map((category) => category.image).toList()];
  }
  
  /// Get category images for chip list filtered by current branch
  List<String> get branchCategoryImages {
    final branchController = Get.find<BranchController>();
    final selectedBranch = branchController.selectedBranch.value;
    
    if (selectedBranch == null) {
      return ['']; // Only show empty image for "All" if no branch selected
    }
    
    final branchCategories = categories.where((category) {
      // Include categories that have availableBranches containing the selected branch
      // OR categories that don't have availableBranches set (legacy categories)
      return category.availableBranches?.contains(selectedBranch.id) ?? true;
    }).toList();
    
    return ['', ...branchCategories.map((category) => category.image).toList()];
  }

  /// Add new category
  Future<void> addCategory({
    required String name,
    required String imageUrl,
  }) async {
    try {
      isLoading.value = true;
      final category = CategoryModel(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        image: imageUrl,
      );
      await _categoryRepository.addItem(category);
      await fetchCategories(); // Refresh the list
      Get.snackbar('Success', 'Category added successfully');
    } catch (e) {
      print('Error adding category: $e');
      Get.snackbar('Error', 'Failed to add category');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new category with branch assignment
  Future<void> addCategoryWithBranches({
    required String name,
    required String imageUrl,
    required List<String> availableBranches,
  }) async {
    try {
      isLoading.value = true;
      final category = CategoryModel(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        image: imageUrl,
        availableBranches: availableBranches,
      );
      await _categoryRepository.addItem(category);
      await fetchCategories(); // Refresh the list
      Get.snackbar('Success', 'Category added successfully');
    } catch (e) {
      print('Error adding category: $e');
      Get.snackbar('Error', 'Failed to add category');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing category (Admin function)
  Future<void> updateCategory({required String id, required String name, required String imageUrl}) async {
    try {
      final category = CategoryModel(
        id: id,
        name: name,
        image: imageUrl,
      );
      await _categoryRepository.updateItem(category);
      await fetchCategories(); // Refresh the list
      Get.snackbar('Success', 'Category updated successfully');
    } catch (e) {
      print('Error updating category: $e');
      Get.snackbar('Error', 'Failed to update category');
    }
  }

  /// Update existing category with branch assignment (Admin function)
  Future<void> updateCategoryWithBranches({
    required String id, 
    required String name, 
    required String imageUrl,
    required List<String> availableBranches,
  }) async {
    try {
      final category = CategoryModel(
        id: id,
        name: name,
        image: imageUrl,
        availableBranches: availableBranches,
      );
      await _categoryRepository.updateItem(category);
      await fetchCategories(); // Refresh the list
      Get.snackbar('Success', 'Category updated successfully');
    } catch (e) {
      print('Error updating category: $e');
      Get.snackbar('Error', 'Failed to update category');
    }
  }

  /// Delete category (Admin function)
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      await _categoryRepository.deleteItem(category);
      await fetchCategories(); // Refresh the list
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      print('Error deleting category: $e');
      Get.snackbar('Error', 'Failed to delete category');
    }
  }

  /// Pick image from gallery and upload to Firebase Storage with progress tracking (Admin function)
  Future<String?> pickImageAndUpload({String? suggestedName, int retryCount = 0}) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;
      
      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image == null) {
        isUploading.value = false;
        return null;
      }

      // Read file as bytes (works on all platforms)
      final bytes = await image.readAsBytes();
      
      // Validate file size (max 5MB)
      if (bytes.length > 5 * 1024 * 1024) {
        Get.snackbar(
          'Error',
          'Image size must be less than 5MB',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isUploading.value = false;
        return null;
      }

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = suggestedName != null 
          ? '${suggestedName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg'
          : 'category_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child('categories/$fileName');

      // Detect image format
      String contentType;
      String extension;
      
      // Check for PNG signature
      if (bytes.length > 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        contentType = 'image/png';
        extension = 'png';
      } else {
        contentType = 'image/jpeg';
        extension = 'jpg';
      }
      
      // Update filename with correct extension
      final correctedFileName = suggestedName != null 
          ? '${suggestedName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.$extension'
          : 'category_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final correctedImageRef = storageRef.child('categories/$correctedFileName');

      // Upload using putData (works on all platforms)
      final uploadTask = correctedImageRef.putData(
        bytes,
        SettableMetadata(contentType: contentType),
      );
      
      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(uploadProgress.value * 100).toStringAsFixed(1)}%');
      });
      
      // Wait for upload to complete
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Success feedback
      Get.snackbar(
        'Success',
        'Image uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase error uploading image: ${e.code} - ${e.message}');
      
      // Retry logic for network errors
      if (retryCount < 2 && (e.code == 'network-request-failed' || e.code == 'timeout')) {
        Get.snackbar(
          'Retrying',
          'Network issue detected. Retrying upload... (${retryCount + 1}/2)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        await Future.delayed(const Duration(seconds: 2));
        return pickImageAndUpload(suggestedName: suggestedName, retryCount: retryCount + 1);
      }
      
      Get.snackbar(
        'Upload Failed',
        'Failed to upload image: ${e.message ?? "Unknown error"}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }
}
