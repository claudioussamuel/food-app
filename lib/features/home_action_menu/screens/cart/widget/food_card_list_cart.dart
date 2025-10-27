import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:foodu/features/home_action_menu/screens/cart/widget/food_card_horizental_cart.dart';
import 'package:foodu/features/home_action_menu/screens/cart/widget/empty_cart.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/sizes.dart';

class FoodCardList extends StatelessWidget {
  const FoodCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Obx(
      () => controller.foodCards.isEmpty
          ? const EmptyCart()
          : ListView.separated(
        itemCount: controller.foodCards.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Slidable(
            key: const ValueKey(0),
            direction: Axis.horizontal,
            endActionPane: ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                // Use onPressed to add the logic for what will happen on Delete Button
                onPressed: (context) => controller.removeFromCart(index),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(TSizes.cardRadiusLg), topRight: Radius.circular(TSizes.cardRadiusLg)),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,

                label: 'Delete',
                autoClose: true,
              )
            ]),
            child: FoodCardHorizontalCart(
              imageUrl: controller.foodCards[index].imageUrls,
              title: controller.foodCards[index].title,
              description: controller.foodCards[index].description,
              price: controller.foodCards[index].price,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: TSizes.spaceBtwItems,
          );
        },
      ),
    );
  }
}
