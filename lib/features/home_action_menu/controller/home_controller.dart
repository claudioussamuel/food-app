import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/features/home_action_menu/controller/category_controller.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final ProductRepository _productRepository = ProductRepository();

  List<String> categoryName = [
    'Hamburger',
    'Pizza',
    'Noodles',
    'Meat',
    'Vegetable',
    'Dessert',
    'Drink',
    'More',
  ];

  List<String> categoryImage = [
    TImages.burger,
    TImages.pizza,
    TImages.noodles,
    TImages.meat,
    TImages.vegetable,
    TImages.dessert,
    TImages.drink,
    TImages.others,
  ];

  final List<Map<String, dynamic>> foodItems = [
    {
      'imageUrl': TImages.mixedSalad,
      'title': 'Mixid Salad bomb',
      'distance': '1.5 km',
      'rating': '4.8',
      'reviewsCount': '1.2k',
      'price': '6.0',
      'deliveryFee': '2.0',
      'isFavorite': false,
    },
    {
      'imageUrl': TImages.fruitSalad,
      'title': 'Fruit Salad',
      'distance': '1.5 km',
      'rating': '4.8',
      'reviewsCount': '1.2k',
      'price': '6.0',
      'deliveryFee': '2.0',
      'isFavorite': false,
    },
    {
      'imageUrl': TImages.mozarellaCheese,
      'title': 'Mozarella Cheese',
      'distance': '1.5 km',
      'rating': '4.8',
      'reviewsCount': '1.2k',
      'price': '6.0',
      'deliveryFee': '2.0',
      'isFavorite': true,
    },
    {
      'imageUrl': TImages.pizzaHut,
      'title': 'Pizza Hut',
      'distance': '1.5 km',
      'rating': '4.8',
      'reviewsCount': '1.2k',
      'price': '6.0',
      'deliveryFee': '2.0',
      'isFavorite': true,
    },
    {
      'imageUrl': TImages.vegeterianNoodels,
      'title': 'Pizza Hut',
      'distance': '1.5 km',
      'rating': '4.8',
      'reviewsCount': '1.2k',
      'price': '6.0',
      'deliveryFee': '2.0',
      'isFavorite': false,
    },
  ];

  var selectedChipIndex = 0.obs;

  void selectChip(int index) {
    selectedChipIndex.value = index;
  }

  /// Get products stream filtered by selected category and current branch
  Stream<List<FoodModel>> get filteredProducts {
    final categoryController = Get.find<CategoryController>();
    final branchController = Get.find<BranchController>();
    
    final selectedBranch = branchController.selectedBranch.value;
    if (selectedBranch == null) {
      // No branch selected, return empty stream
      return Stream.value(<FoodModel>[]);
    }
    
    // Get category ID instead of name for filtering
    final selectedCategoryId = selectedChipIndex.value == 0
        ? 'All'
        : categoryController.categories[selectedChipIndex.value - 1].id;

    return _productRepository.productsByCategoryAndBranch(selectedCategoryId, selectedBranch.id);
  }

  /// Get all products stream for current branch
  Stream<List<FoodModel>> get allProducts {
    final branchController = Get.find<BranchController>();
    final selectedBranch = branchController.selectedBranch.value;
    
    if (selectedBranch == null) {
      // No branch selected, return empty stream
      return Stream.value(<FoodModel>[]);
    }
    
    return _productRepository.productsForBranch(selectedBranch.id);
  }

  /// Get products for a specific branch
  Stream<List<FoodModel>> getProductsForBranch(String branchId) {
    return _productRepository.productsForBranch(branchId);
  }

  /// Get products filtered by category for a specific branch
  Stream<List<FoodModel>> getProductsByCategoryAndBranch(String categoryId, String branchId) {
    return _productRepository.productsByCategoryAndBranch(categoryId, branchId);
  }

  // Get chip list names from CategoryController (branch-filtered)
  List<String> get chipListName {
    final categoryController = Get.find<CategoryController>();
    return categoryController.branchCategoryNames;
  }

  // Get chip list images from CategoryController (branch-filtered)
  List<String> get chipListImage {
    final categoryController = Get.find<CategoryController>();
    final images = categoryController.branchCategoryImages;
    // Replace empty string with default "All" image
    return images.map((image) => image.isEmpty ? TImages.all : image).toList();
  }
}
