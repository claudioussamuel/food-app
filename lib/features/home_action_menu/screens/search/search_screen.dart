import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_text_field.dart';
import 'package:foodu/common/widgets/option_bar.dart';
import 'package:foodu/features/home_action_menu/controller/search_controller.dart';
import 'package:foodu/features/home_action_menu/screens/search/widget/recent_and_other_options.dart';
import 'package:foodu/features/home_action_menu/screens/search/widget/search_food_list_view.dart';
import 'package:foodu/features/home_action_menu/screens/search/widget/search_not_found.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());
    controller.searchController.addListener(() {
      controller.updateSearchText(controller.searchController.text);
    });
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: TCustomTextField(
          textEditingController: controller.searchController,
          height: 40,
          hintText: 'Search here',
          prefixIcon: Icons.search,
          suffixIcon: Icons.close,
          showBottomSheet: false,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: TSpacingStyles.paddingWithHeightWidth,
          child: controller.searchText.value.isEmpty
              ? const ShowRecentSearchAndOtherOptions()
              : Column(
                  children: [
                    const Gap(10),
                    const TOptionBar(),
                    const Gap(10),
                    Obx(
                      () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.searchFoodItems.isEmpty 
                              ? const SearchNotFound() 
                              : const SizedBox.shrink(),
                    ),
                    // When we have results, let the list view take the remaining space
                    Obx(() {
                      if (controller.isLoading.value || controller.searchFoodItems.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return const Expanded(child: SearchFoodListView());
                    }),
                  ],
                ),
        ),
      ),
    );
  }
}
