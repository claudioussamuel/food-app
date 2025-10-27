import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserBranchSelectionScreen extends StatelessWidget {
  const UserBranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final branchController = Get.find<BranchController>();
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Branch',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(TSizes.borderRadiusLg),
                bottomRight: Radius.circular(TSizes.borderRadiusLg),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Iconsax.location,
                  size: 48,
                  color: TColors.primary,
                ),
                const SizedBox(height: TSizes.sm),
                Text(
                  'Select Your Preferred Branch',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  'Choose the branch you want to order from',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Branch List
          Expanded(
            child: Obx(() {
              if (branchController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final activeBranches = branchController.branches
                  .where((branch) => branch.isActive)
                  .toList();

              if (activeBranches.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.location_slash,
                        size: 64,
                        color: TColors.darkGrey,
                      ),
                      const SizedBox(height: TSizes.md),
                      Text(
                        'No Branches Available',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TSizes.sm),
                      Text(
                        'There are currently no active branches.\nPlease try again later.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                itemCount: activeBranches.length,
                itemBuilder: (context, index) {
                  final branch = activeBranches[index];
                  
                  return Obx(() {
                    final isSelected = branchController.selectedBranch.value?.id == branch.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectBranch(context, branch, branchController),
                        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                        child: Container(
                          padding: const EdgeInsets.all(TSizes.md),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? TColors.primary.withOpacity(0.1)
                              : isDark ? TColors.darkCard : TColors.lightGrey,
                            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                            border: Border.all(
                              color: isSelected 
                                ? TColors.primary 
                                : isDark ? TColors.darkGrey : TColors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Branch Icon
                              Container(
                                padding: const EdgeInsets.all(TSizes.sm),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? TColors.primary 
                                    : TColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                                ),
                                child: Icon(
                                  Iconsax.building,
                                  color: isSelected ? Colors.white : TColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: TSizes.md),

                              // Branch Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      branch.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? TColors.primary : null,
                                      ),
                                    ),
                                    const SizedBox(height: TSizes.xs),
                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.location,
                                          size: 16,
                                          color: TColors.darkGrey,
                                        ),
                                        const SizedBox(width: TSizes.xs),
                                        Expanded(
                                          child: Text(
                                            branch.address,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: TColors.darkGrey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (branch.phone.isNotEmpty) ...[
                                      const SizedBox(height: TSizes.xs),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.call,
                                            size: 16,
                                            color: TColors.darkGrey,
                                          ),
                                          const SizedBox(width: TSizes.xs),
                                          Text(
                                            branch.phone,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: TColors.darkGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Selection Indicator
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(TSizes.xs),
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  });
                },
              );
            }),
          ),

          // Current Selection Info (if any)
          Obx(() {
            final selectedBranch = branchController.selectedBranch.value;
            if (selectedBranch == null) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: TColors.success.withOpacity(0.1),
                border: Border(
                  top: BorderSide(
                    color: TColors.success.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    color: TColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Text(
                      'Selected: ${selectedBranch.name}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: TColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _selectBranch(BuildContext context, BranchModel branch, BranchController branchController) {
    branchController.selectBranch(branch);
    
    // Show success feedback
    Get.snackbar(
      'Branch Selected',
      'You have selected ${branch.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: TColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(TSizes.defaultSpace),
      icon: const Icon(
        Iconsax.tick_circle,
        color: Colors.white,
      ),
    );
  }
}
