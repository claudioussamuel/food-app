import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:foodu/data/repositories/menu/category_repository.dart';
import 'package:foodu/data/repositories/menu/search_repository.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/home_action_menu/model/search_food_item_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchPageController extends GetxController {
  static SearchPageController get instance => Get.find();

  final SearchRepository _searchRepository = SearchRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final GetStorage _storage = GetStorage();
  
  var searchText = ''.obs;
  TextEditingController searchController = TextEditingController();
  var searchFoodItems = <SearchFoodItemModel>[].obs;
  var isLoading = false.obs;
  // favorites state (ids)
  final RxSet<String> _favoriteIds = <String>{}.obs;
  
  // Categories from Firestore
  var categories = <CategoryModel>[].obs;
  var isCategoriesLoading = false.obs;
  
  StreamSubscription<List<SearchFoodItemModel>>? _searchSubscription;
  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;

  // Recent searches from local storage
  var recentSearches = <String>[].obs;
  // Popular cuisines - all categories from Firestore
  var popularCuisines = <String>[].obs;
  // All cuisines - all products from Firestore
  var allCuisines = <String>[].obs;
  
  // Map to convert category names to IDs for search
  final Map<String, String> _categoryNameToId = {};

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty search results
    searchFoodItems.clear();
    // Load categories from Firestore
    _loadCategories();
    // Load all products for allCuisines
    _loadAllProducts();
    // Load recent searches from local storage
    _loadRecentSearches();
  }

  // Favorites API
  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    update();
  }

  void _loadCategories() {
    isCategoriesLoading.value = true;
    
    _categoriesSubscription = _categoryRepository.categories().listen(
      (categoryList) {
        if (kDebugMode) print('Categories loaded: ${categoryList.length} items');
        categories.assignAll(categoryList);
        // Update popular cuisines with category names and build name-to-ID map
        _categoryNameToId.clear();
        final categoryNames = categoryList.map((cat) {
          _categoryNameToId[cat.name] = cat.id;
          return cat.name;
        }).toList();
        if (kDebugMode) print('Category names: $categoryNames');
        popularCuisines.assignAll(categoryNames);
        isCategoriesLoading.value = false;
      },
      onError: (error) {
        if (kDebugMode) print('Categories error: $error');
        isCategoriesLoading.value = false;
        Get.snackbar('Error', 'Failed to load categories: $error');
      },
    );
  }

  void _loadAllProducts() {
    if (kDebugMode) print('Loading all products...');
    _searchRepository.getAllSearchProducts().listen(
      (productList) {
        if (kDebugMode) print('Products loaded: ${productList.length} items');
        // Update all cuisines with product names
        final productNames = productList.map((product) => product.name).toList();
        if (kDebugMode) print('Product names: $productNames');
        allCuisines.assignAll(productNames);
      },
      onError: (error) {
        if (kDebugMode) print('Products error: $error');
        Get.snackbar('Error', 'Failed to load products: $error');
      },
    );
  }

  void _loadRecentSearches() {
    final savedSearches = _storage.read<List<dynamic>>('recent_searches');
    if (savedSearches != null) {
      recentSearches.assignAll(savedSearches.cast<String>());
    }
  }

  void _saveRecentSearches() {
    _storage.write('recent_searches', recentSearches.toList());
  }

  @override
  void onClose() {
    _searchSubscription?.cancel();
    _categoriesSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void updateSearchText(String text) {
    if (kDebugMode) print('Search text: $text');
    searchText.value = text;
    
    // Cancel previous search subscription
    _searchSubscription?.cancel();
    
    if (text.isEmpty) {
      searchFoodItems.clear();
      return;
    }

    // Add to recent searches if not already present
    if (text.length > 2 && !recentSearches.contains(text)) {
      recentSearches.insert(0, text);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
      // Save to local storage
      _saveRecentSearches();
    }

    // Start new search
    _performSearch(text);
  }

  void _performSearch(String query) {
    isLoading.value = true;
    
    _searchSubscription = _searchRepository.searchProducts(query).listen(
      (results) {
        searchFoodItems.assignAll(results);
        isLoading.value = false;
      },
      onError: (error) {
        if (kDebugMode) print('Search error: $error');
        searchFoodItems.clear();
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to search Meals: $error');
      },
    );
  }

  void searchByCategory(String category) {
    isLoading.value = true;
    _searchSubscription?.cancel();
    
    // Convert category name to ID if it's not 'All' and exists in the map
    final categoryId = category == 'All' ? 'All' : (_categoryNameToId[category] ?? category);
    
    _searchSubscription = _searchRepository.searchProductsByCategory(categoryId, searchText.value).listen(
      (results) {
        searchFoodItems.assignAll(results);
        isLoading.value = false;
      },
      onError: (error) {
        if (kDebugMode) print('Category search error: $error');
        searchFoodItems.clear();
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to search by category: $error');
      },
    );
  }

  void selectRecentSearch(String searchTerm) {
    searchController.text = searchTerm;
    updateSearchText(searchTerm);
  }

  void clearRecentSearches() {
    recentSearches.clear();
    _storage.remove('recent_searches');
  }

  void removeRecentSearch(String searchTerm) {
    recentSearches.remove(searchTerm);
    _saveRecentSearches();
  }

  // Cart integration
  void addToCart(SearchFoodItemModel item) {
    final cartController = CartController.instance;
    
    // Convert SearchFoodItemModel to FoodModel for cart compatibility
    final foodModel = FoodModel(
      id: item.id,
      name: item.name,
      description: item.description,
      categoryName: item.categoryName,
      price: item.price,
      image: item.image,
      cartQuantity: 1,
    );
    
    cartController.toggleFavorite(foodModel);
    
    // Also mark as favorite in search controller
    if (!_favoriteIds.contains(item.id)) {
      _favoriteIds.add(item.id);
      update(); // Trigger UI rebuild
    }
    
    Get.snackbar('Added to Cart', '${item.name} has been added to your cart');
  }

  bool isInCart(String itemId) {
    final cartController = CartController.instance;
    return cartController.isFavorite(itemId);
  }
}
