import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/food_card_vertical.dart';
import 'package:foodu/features/home_action_menu/controller/home_controller.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../restaurant_details_and_food_place_order/screen/restaurent_detail/restaurent_detail_screen.dart';

class HorizontalFoodList extends StatelessWidget {
  const HorizontalFoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    // Ensure CartController is available
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    final cartController = CartController.instance;

    return SizedBox(
      height: 325,
      child: Obx(() {
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
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Obx(() => TFoodCardVertical(
                        imageUrl: product.image,
                        title: product.name,
                        price: product.price.toString(),
                        isInCart: cartController.isFavorite(product.id),
                        onAddToCart: () =>
                            cartController.toggleFavorite(product),
                        onTap: () =>
                            Get.to(RestaurantDetailScreen(product: product)),
                      )),
                );
              },
            );
          },
        );
      }),
    );
  }
}
