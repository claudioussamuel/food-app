import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.isDefault = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(TSizes.xm),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const CircleAvatar(
                backgroundColor: TColors.primary,
                child: Icon(Icons.location_on, color: Colors.white),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(width: TSizes.sm),
                      if (isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.x),
                          decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(TSizes.xm)),
                          child: Text('Default', style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.primary)),
                        ),
                    ],
                  ),
                  Text(address, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            const Icon(Icons.edit, color: TColors.primary)
          ],
        ),
      ),
    );
  }
}
