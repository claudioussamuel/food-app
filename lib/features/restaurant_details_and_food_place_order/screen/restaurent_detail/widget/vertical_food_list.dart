import 'package:flutter/cupertino.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:gap/gap.dart';

import '../../../controller/restaurant_controller.dart';
import 'horizental_food_card_restaurent.dart';

class VerticalFoodList extends StatelessWidget {
  const VerticalFoodList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = RestaurantController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: controller.foodItems.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Gap(TSizes.spaceBtwItems),
          itemBuilder: (context, index) {
            final item = controller.foodItems[index];
            return HorizontalFoodCardRestaurant(
              imageUrl: item['imageUrl'],
              title: item['title'],
              price: item['price'],
              badgeText: item['badgeText'],
            );
          }),
    );
  }
}
