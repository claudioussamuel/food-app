import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFoodItemModel {
  String id, name, description, image;
  List<String> categoryName;
  double price;
  int cartQuantity;
  double distance;
  double rating;
  int reviews;
  final List<SearchFoodItemModel> recommendedItems;

  SearchFoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.price,
    required this.image,
    this.cartQuantity = 0,
    this.distance = 0.0,
    this.rating = 0.0,
    this.reviews = 0,
    this.recommendedItems = const [],
  });

  // Create from FoodModel for compatibility
  factory SearchFoodItemModel.fromFoodModel(dynamic foodModel) {
    return SearchFoodItemModel(
      id: foodModel.id,
      name: foodModel.name,
      description: foodModel.description,
      categoryName: foodModel.categoryName,
      price: foodModel.price,
      image: foodModel.image,
      cartQuantity: foodModel.cartQuantity,
    );
  }

  factory SearchFoodItemModel.fromJson(DocumentSnapshot data) {
    final map = (data.data() as Map<String, dynamic>?) ?? {};

    // Helpers for safe reads
    T safeGet<T>(String key, T fallback) {
      if (!map.containsKey(key) || map[key] == null) return fallback;
      final value = map[key];
      if (T == double && value is int) return (value.toDouble()) as T;
      if (T == int && value is double) return (value.toInt()) as T;
      return value as T;
    }

    final List<dynamic> rawCategories = safeGet<List<dynamic>>('categoryName', const []);
    final categories = rawCategories.map((e) => e.toString()).toList();

    return SearchFoodItemModel(
      id: data.id,
      name: safeGet<String>('name', ''),
      description: safeGet<String>('description', ''),
      categoryName: categories,
      price: safeGet<double>('price', 0.0),
      image: safeGet<String>('image', ''),
      cartQuantity: safeGet<int>('cartQuantity', 0),
      distance: safeGet<double>('distance', 0.0), // default if missing
      rating: safeGet<double>('rating', 0.0),     // default if missing
      reviews: safeGet<int>('reviews', 0),        // default if missing
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categoryName': categoryName,
        'price': price,
        'image': image,
        'cartQuantity': cartQuantity,
        'distance': distance,
        'rating': rating,
        'reviews': reviews,
      };
}
