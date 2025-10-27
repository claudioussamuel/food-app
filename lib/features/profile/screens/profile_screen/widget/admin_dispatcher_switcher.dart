import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../navigation_menu/controller.dart';

class AdminDispatcherSwitcher extends StatelessWidget {
  const AdminDispatcherSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();
    
    // Only show for original admins
    if (!navigationController.isOriginallyAdmin) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isInDispatcherMode = navigationController.isTemporaryDispatcherMode.value;
      
      return Container(
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isInDispatcherMode 
              ? TColors.warning.withOpacity(0.1) 
              : TColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: isInDispatcherMode ? TColors.warning : TColors.success,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isInDispatcherMode ? Iconsax.truck_fast : Iconsax.crown,
                  color: isInDispatcherMode ? TColors.warning : TColors.success,
                  size: 20,
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  'Admin Role Switcher',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isInDispatcherMode ? TColors.warning : TColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: isInDispatcherMode, // Switch shows dispatcher mode as "on"
                  onChanged: (value) {
                    navigationController.toggleDispatcherMode();
                    
                    // Show feedback
                    Get.snackbar(
                      value ? 'Dispatcher Mode' : 'Admin Mode',
                      value 
                        ? 'Switched to Dispatcher view' 
                        : 'Switched back to Admin view',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: value ? TColors.warning : TColors.success,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(TSizes.defaultSpace),
                    );
                  },
                  activeColor: TColors.warning,
                  inactiveThumbColor: TColors.success,
                  inactiveTrackColor: TColors.success.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              isInDispatcherMode 
                ? '🚚 Currently viewing as: Dispatcher\nAccess delivery and order pickup features'
                : '👑 Currently viewing as: Administrator\nFull admin access and management controls',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isInDispatcherMode ? TColors.warning : TColors.success,
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
                color: (isInDispatcherMode ? TColors.warning : TColors.success).withOpacity(0.1),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 14,
                    color: isInDispatcherMode ? TColors.warning : TColors.success,
                  ),
                  const SizedBox(width: TSizes.xs),
                  Expanded(
                    child: Text(
                      isInDispatcherMode 
                        ? 'Switch back to Admin mode to access management features'
                        : 'Switch to Dispatcher mode to test delivery features',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isInDispatcherMode ? TColors.warning : TColors.success,
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
