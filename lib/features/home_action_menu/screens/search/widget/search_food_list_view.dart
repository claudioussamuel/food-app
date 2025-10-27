import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/controller/search_controller.dart';
import 'package:foodu/features/home_action_menu/screens/search/widget/search_food_card.dart';
import 'package:get/get.dart';

class SearchFoodListView extends StatelessWidget {
  const SearchFoodListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SearchPageController.instance;
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.searchFoodItems.length,
        itemBuilder: (context, index) {
          return SearchFoodCard(foodItem: controller.searchFoodItems[index]);
        },
      );
    });
  }
}
