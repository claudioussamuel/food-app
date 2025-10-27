import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  // Observable list of products
  var products = <FoodModel>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;

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

  /// Pick image from gallery and upload to Firebase Storage
  Future<String?> pickImageAndUpload({String? suggestedName}) async {
    try {
      isUploading.value = true;
      
      // Pick image from gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = suggestedName != null 
          ? '${suggestedName}_${DateTime.now().millisecondsSinceEpoch}.jpg'
          : 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child('products/$fileName');

      // Upload the file
      final uploadTask = imageRef.putFile(File(image.path));
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    } finally {
      isUploading.value = false;
    }
  }
}
