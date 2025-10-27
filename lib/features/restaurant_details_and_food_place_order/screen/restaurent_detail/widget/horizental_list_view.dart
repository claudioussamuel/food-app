import 'package:flutter/cupertino.dart';
import 'package:foodu/utils/constants/sizes.dart';

import '../../../controller/restaurant_controller.dart';
import 'vertical_food_card_restaurent.dart';

class HorizontalFoodList extends StatelessWidget {
  const HorizontalFoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RestaurantController.instance;
    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.foodItems.length,
          itemBuilder: (context, index) {
            final item = controller.foodItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: VerticalFoodCardRestaurant(
                imageUrl: item['imageUrl'],
                title: item['title'],
                price: item['price'],
                badgeText: item['badgeText'],
              ),
            );
          },
        ),
      ),
    );
  }
}
