import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_chip.dart';
import 'package:foodu/features/home_action_menu/controller/home_controller.dart';
import 'package:foodu/features/home_action_menu/controller/category_controller.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ChipListRow extends StatelessWidget {
  const ChipListRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = THelperFunctions.isDarkMode(context);
    final homeController = HomeController.instance;
    final categoryController = Get.find<CategoryController>();
    final branchController = Get.find<BranchController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
      child: SizedBox(
        height: 35,
        width: double.infinity,
        child: Obx(() {
          // Listen to branch changes to update categories
          // This variable triggers reactivity when branch selection changes
          final selectedBranch = branchController.selectedBranch.value;
          
          // Show loading indicator if categories are being fetched or no branch selected
          if (categoryController.isLoading.value || selectedBranch == null) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          // Show chips if categories are loaded
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.chipListName.length,
            itemBuilder: (context, index) {
              return Obx(() {
                bool isSelected =
                    index == homeController.selectedChipIndex.value;
                return TCustomChip(
                  label: homeController.chipListName[index],
                  labelColor: isSelected ? Colors.white : TColors.primary,
                  imagePath: homeController.chipListImage[index],
                  onTap: () => homeController.selectChip(index),
                  backgroundColor: isSelected ? TColors.primary : Colors.white,
                );
              });
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: TSizes.sm),
          );
        }),
      ),
    );
  }
}
