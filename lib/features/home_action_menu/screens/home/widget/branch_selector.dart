import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/screens/branch_selection/user_branch_selection_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BranchSelector extends StatelessWidget {
  const BranchSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final branchController = Get.find<BranchController>();
    final isDark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final selectedBranch = branchController.selectedBranch.value;
      
      return Container(
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.to(() => const UserBranchSelectionScreen()),
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            child: Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: selectedBranch != null 
                  ? TColors.primary.withOpacity(0.1)
                  : isDark ? TColors.darkCard : TColors.lightGrey,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: selectedBranch != null 
                    ? TColors.primary.withOpacity(0.3)
                    : isDark ? TColors.darkGrey : TColors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Branch Icon
                  Container(
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: selectedBranch != null 
                        ? TColors.primary 
                        : TColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Icon(
                      selectedBranch != null ? Iconsax.building : Iconsax.location,
                      color: selectedBranch != null ? Colors.white : TColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: TSizes.md),

                  // Branch Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedBranch != null 
                            ? selectedBranch.name
                            : 'Select Branch',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: selectedBranch != null ? TColors.primary : null,
                          ),
                        ),
                        const SizedBox(height: TSizes.xs),
                        Text(
                          selectedBranch != null 
                            ? selectedBranch.address
                            : 'Choose your preferred branch location',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Iconsax.arrow_right_3,
                    color: selectedBranch != null ? TColors.primary : TColors.darkGrey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
