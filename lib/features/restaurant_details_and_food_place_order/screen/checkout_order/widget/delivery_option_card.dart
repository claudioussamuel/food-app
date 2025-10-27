import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controller/checkout_controller.dart';

class DeliveryOptionCard extends StatelessWidget {
  const DeliveryOptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final checkoutController = CheckoutController.instance;

    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.sm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Delivery Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Pickup Option
          Obx(() => _buildOptionTile(
                context: context,
                icon: Iconsax.bag_2,
                title: 'Pickup',
                subtitle: 'Pick up from restaurant',
                price: 'Free',
                isSelected: !checkoutController.isDelivery.value,
                onTap: () => checkoutController.setDeliveryOption(false),
                isDark: isDark,
              )),

          const SizedBox(height: TSizes.xs),

          // Delivery Option
          Obx(() => _buildOptionTile(
                context: context,
                icon: Iconsax.truck_fast,
                title: 'Delivery',
                subtitle: 'Delivered to your address',
                price: '',
                isSelected: checkoutController.isDelivery.value,
                onTap: () => checkoutController.setDeliveryOption(true),
                isDark: isDark,
              )),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? TColors.primary.withValues(alpha: 0.1)
              : (isDark ? TColors.darkCard : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(TSizes.xs),
          border: Border.all(
            color: isSelected ? TColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(TSizes.xs),
              decoration: BoxDecoration(
                color: isSelected ? TColors.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(TSizes.xs),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: TSizes.sm),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? TColors.primary : null,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              price,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? TColors.primary : Colors.grey.shade700,
                  ),
            ),

            const SizedBox(width: TSizes.xs),

            // Selection Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? TColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? TColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
