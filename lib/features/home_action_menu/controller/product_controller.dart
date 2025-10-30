import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  // Observable list of products
  var products = <FoodModel>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;

  final ProductRepository _productRepository = ProductRepository();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// Fetch all products from Firestore
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final fetchedProducts = await _productRepository.getAllItems();
      products.value = fetchedProducts;
    } catch (e) {
      print('Error fetching products: $e');
      // You can add error handling here, like showing a snackbar
    } finally {
      isLoading.value = false;
    }
  }

  /// Get products as stream for real-time updates
  Stream<List<FoodModel>> getProductsStream() {
    return _productRepository.products();
  }

  /// Add new product
  Future<void> addProduct(FoodModel product) async {
    try {
      await _productRepository.addItem(product);
      await fetchProducts(); // Refresh the list
    } catch (e) {
      print('Error adding product: $e');
      Get.snackbar('Error', 'Failed to add product');
    }
  }

  /// Update existing product
  Future<void> updateProduct(FoodModel product) async {
    try {
      await _productRepository.updateItem(product);
      await fetchProducts(); // Refresh the list
    } catch (e) {
      print('Error updating product: $e');
      Get.snackbar('Error', 'Failed to update product');
    }
  }

  /// Delete product
  Future<void> deleteProduct(FoodModel product) async {
    try {
      await _productRepository.deleteItem(product);
      await fetchProducts(); // Refresh the list
    } catch (e) {
      print('Error deleting product: $e');
      Get.snackbar('Error', 'Failed to delete product');
    }
  }

  /// Pick image from gallery and upload to Firebase Storage with progress tracking
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
          : 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child('products/$fileName');

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
          : 'product_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final correctedImageRef = storageRef.child('products/$correctedFileName');

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
