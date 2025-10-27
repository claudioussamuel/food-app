import 'package:flutter/cupertino.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_chip.dart';
import 'package:foodu/features/home_action_menu/controller/search_controller.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

Widget buildChipList(RxList<String> items, {bool isRecentSearch = false, bool isCuisine = false}) {
  final controller = SearchPageController.instance;
  
  return Wrap(
    runSpacing: TSizes.sm,
    spacing: TSizes.sm,
    children: items.map((item) => TCustomChip(
      label: item,
      onTap: () {
        if (isRecentSearch) {
          controller.selectRecentSearch(item);
        } else if (isCuisine) {
          controller.searchByCategory(item);
        } else {
          // For cuisine searches, set the search text and perform search
          controller.searchController.text = item;
          controller.updateSearchText(item);
        }
      },
    )).toList(),
  );
}
