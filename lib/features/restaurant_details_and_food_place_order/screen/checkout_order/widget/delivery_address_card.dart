import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/container/custom_divider.dart';
import '../../../../../utils/exports.dart';
import '../../../../personalization/screens/location/set_your_location.dart';
import '../../../../personalization/controller/location_controller.dart';

class DeliveryAddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;

  const DeliveryAddressCard({
    super.key,
    required this.title,
    required this.address,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final locationController = Get.put(LocationController());
    return InkWell(
      onTap: () => Get.to(const SetYourLocation()),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.symmetric(
          vertical: TSizes.xm,
        ),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(TSizes.xm),
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
            Text(
              "Deliver to",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const TCustomDivider(),
            Row(
              children: [
                // Icon or Image
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TSizes.xm),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: TColors.primary,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Gap(16),
                // Title and Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            final label =
                                locationController.locationLabel.value;
                            final heading = label.isNotEmpty ? label : title;
                            return Text(heading,
                                style: Theme.of(context).textTheme.bodyLarge);
                          }),
                          const SizedBox(width: TSizes.md),
                          if (isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: TSizes.x),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TSizes.sm),
                              ),
                              child: Text('Default',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ),
                        ],
                      ),
                      const Gap(4),
                      Obx(() {
                        final selected =
                            locationController.locationAddress.value;
                        final display =
                            selected.isNotEmpty ? selected : address;
                        return Text(display,
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis);
                      }),
                    ],
                  ),
                ),
                const Gap(16),
                // Arrow Icon
                const Icon(
                  Icons.arrow_forward_ios,
                  color: TColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
