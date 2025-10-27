import 'package:flutter/cupertino.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_chip.dart';
import 'package:foodu/features/home_action_menu/controller/search_controller.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TOptionBar extends StatelessWidget {
  const TOptionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = SearchPageController.instance;

    return SizedBox(
      height: 30,
      child: Obx(() {
        if (searchController.isCategoriesLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              // onTap: () => Get.to(() => const FilterScreen()),
              child:
                  const TCustomChip(label: 'Filter', imagePath: TImages.filter),
            ),
            const Gap(5),
            TCustomChip(
              label: 'All',
              onTap: () => searchController.searchByCategory('All'),
            ),
            const Gap(5),
            // Dynamic categories from Firestore
            ...searchController.categories
                .map((category) => [
                      TCustomChip(
                        label: category.name,
                        onTap: () =>
                            searchController.searchByCategory(category.id),
                      ),
                      const Gap(5),
                    ])
                .expand((element) => element),
          ],
        );
      }),
    );
  }
}
