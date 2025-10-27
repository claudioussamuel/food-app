import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/images/t_circular_image.dart';
import 'package:foodu/features/order/screens/track_order/common/action_button.dart';
import 'package:foodu/utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';

class DriverInfoCard extends StatelessWidget {
  final String driverName;
  final String vehicleName;
  final String vehiclePlate;
  final double rating;
  final String driverImageUrl;
  final VoidCallback onCancel;
  final VoidCallback onMessage;
  final VoidCallback onCall;

  const DriverInfoCard({
    super.key,
    required this.driverName,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.rating,
    required this.driverImageUrl,
    required this.onCancel,
    required this.onMessage,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Text('Driver is heading to the restaurant...', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwSection),
            Row(
              children: [
                // Driver Image
                TCircularImage(
                  padding: 0,
                  image: driverImageUrl,
                ),
                const SizedBox(width: TSizes.spaceBtwItems),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driverName, style: Theme.of(context).textTheme.bodyLarge),
                      Text(vehicleName, style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: TColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Text(rating.toString(), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Text(vehiclePlate, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSection),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  onTap: onCancel,
                  iconData: Icons.close,
                  backgroundColor: TColors.error,
                ),
                ActionButton(
                  onTap: onMessage,
                  iconData: Icons.message,
                  backgroundColor: TColors.primary,
                ),
                ActionButton(
                  onTap: onCall,
                  iconData: Icons.call,
                  backgroundColor: TColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
