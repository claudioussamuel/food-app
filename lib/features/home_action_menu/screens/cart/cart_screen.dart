import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:foodu/features/home_action_menu/screens/cart/widget/food_card_list_cart.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../../restaurant_details_and_food_place_order/screen/checkout_order/checkout_order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title:
            Text('My Cart', style: Theme.of(context).textTheme.headlineSmall!.apply(color: isDark ? TColors.textWhite : TColors.textblack)),
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(child: FoodCardList()),
      ),
      bottomNavigationBar: Obx(() => controller.itemCount > 0 
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
            child: ElevatedButton(
              onPressed: () => Get.to(const CheckoutOrderScreen()),
              child: Text(
                'Basket - ${controller.itemCount} item${controller.itemCount > 1 ? 's' : ''} - GHS ${controller.totalPrice.toStringAsFixed(2)}',
              ),
            ),
          )
        : const SizedBox.shrink()),
    );
  }
}
