import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controller/dispatcher_controller.dart';

/// Dispatcher View Switcher - Placeholder
/// Note: View switching is deprecated. The system now focuses on order delivery workflow.
class DispatcherViewSwitcher extends StatelessWidget {
  const DispatcherViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatcherController = Get.find<DispatcherController>();

    return Obx(() {
      final isOnline = dispatcherController.currentBranchId.value.isNotEmpty;
      
      return Container(
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isOnline ? TColors.success.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: isOnline ? TColors.success : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isOnline ? Iconsax.truck_fast : Iconsax.truck,
              color: isOnline ? TColors.success : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: TSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dispatcher Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    isOnline 
                      ? '🟢 Online - Ready for deliveries'
                      : '⚪ Offline - Select a branch to go online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOnline ? TColors.success : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              decoration: BoxDecoration(
                color: isOnline ? TColors.success : Colors.grey,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: Text(
                isOnline ? 'ONLINE' : 'OFFLINE',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
