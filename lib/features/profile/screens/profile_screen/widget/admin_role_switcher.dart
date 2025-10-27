import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../navigation_menu/controller.dart';

class AdminRoleSwitcher extends StatelessWidget {
  const AdminRoleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();
    
    // Only show for original admins
    if (!navigationController.isOriginallyAdmin) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isInUserMode = navigationController.isTemporaryUserMode.value;
      
      return Container(
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isInUserMode ? TColors.primary.withOpacity(0.1) : TColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: isInUserMode ? TColors.primary : TColors.success,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isInUserMode ? Iconsax.user : Iconsax.crown,
                  color: isInUserMode ? TColors.primary : TColors.success,
                  size: 20,
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  'Admin Testing Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isInUserMode ? TColors.primary : TColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: !isInUserMode, // Switch shows admin mode as "on"
                  onChanged: (value) {
                    navigationController.toggleUserMode();
                    
                    // Show feedback
                    Get.snackbar(
                      value ? 'Admin Mode' : 'User Mode',
                      value 
                        ? 'Switched to Admin view' 
                        : 'Switched to User view for testing',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: value ? TColors.success : TColors.primary,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(TSizes.defaultSpace),
                    );
                  },
                  activeColor: TColors.success,
                  inactiveThumbColor: TColors.primary,
                  inactiveTrackColor: TColors.primary.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              isInUserMode 
                ? '👤 Currently viewing as: Regular User\nTesting the customer experience'
                : '👑 Currently viewing as: Administrator\nFull admin access and controls',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isInUserMode ? TColors.primary : TColors.success,
                height: 1.3,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              decoration: BoxDecoration(
                color: (isInUserMode ? TColors.primary : TColors.success).withOpacity(0.1),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 14,
                    color: isInUserMode ? TColors.primary : TColors.success,
                  ),
                  const SizedBox(width: TSizes.xs),
                  Expanded(
                    child: Text(
                      isInUserMode 
                        ? 'Switch back to Admin mode to access management features'
                        : 'Switch to User mode to test the customer experience',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isInUserMode ? TColors.primary : TColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
