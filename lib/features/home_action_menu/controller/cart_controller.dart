import 'package:foodu/features/home_action_menu/model/food_card_cart_model.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  final foodCards = <FoodCardCartModel>[].obs;

  /// Favorites tracking (product IDs)
  final RxSet<String> _favoriteIds = <String>{}.obs;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  /// Calculate total price of items in cart
  double get totalPrice {
    return foodCards.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Get total number of items in cart
  int get itemCount => foodCards.length;

  /// Remove item from cart by index and update favorites if linked
  void removeFromCart(int index) {
    if (index >= 0 && index < foodCards.length) {
      final item = foodCards[index];
      // If this cart item is linked to a product, remove from favorites too
      if (item.productId != null) {
        _favoriteIds.remove(item.productId);
      }
      foodCards.removeAt(index);
    }
  }

  /// Toggle favorite and sync with cart list.
  /// If marking as favorite, add an entry mapped to this product.
  /// If un-favoriting, remove the mapped cart entry if it exists.
  void toggleFavorite(FoodModel product) {
    if (isFavorite(product.id)) {
      // Remove from favorites
      _favoriteIds.remove(product.id);
      // Also remove any cart item linked to this product
      final index = foodCards.indexWhere((e) => e.productId == product.id);
      if (index != -1) {
        foodCards.removeAt(index);
      }
    } else {
      // Add to favorites
      _favoriteIds.add(product.id);
      // Add to cart list as a single item entry linked by productId
      foodCards.add(
        FoodCardCartModel(
          imageUrls: [product.image],
          title: product.name,
          description: product.description,
          price: product.price,
          productId: product.id,
        ),
      );
    }
  }
}
