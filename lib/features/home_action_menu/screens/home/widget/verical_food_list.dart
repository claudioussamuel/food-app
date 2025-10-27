import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/food_card_horizental.dart';
import 'package:foodu/features/home_action_menu/controller/home_controller.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:get/get.dart';

import '../../../../restaurant_details_and_food_place_order/screen/restaurent_detail/restaurent_detail_screen.dart';

class VerticalFoodList extends StatelessWidget {
  const VerticalFoodList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    // Ensure CartController is available
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    final cartController = CartController.instance;

    return Obx(() {
      return StreamBuilder<List<FoodModel>>(
        stream: controller.filteredProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No products found'),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Obx(() => TFoodCardHorizontal(
                    imageUrl: product.image,
                    title: product.name,
                    rating: product.rating.toStringAsFixed(1),
                    reviewCount: _formatReviewCount(product.reviewCount),
                    price: product.price.toString(),
                    isInCart: cartController.isFavorite(product.id),
                    onAddToCart: () => cartController.toggleFavorite(product),
                    onTap: () => Get.to(() => RestaurantDetailScreen(product: product)),
                  ));
            },
          );
        },
      );
    });
  }

  /// Helper method to format review count (e.g., 1200 -> "1.2k", 1000 -> "1000", 500 -> "500")
  String _formatReviewCount(int count) {
    if (count > 1000) {
      double formatted = count / 1000.0;
      return '${formatted.toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
