import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_divider.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class ActiveOrderCard extends StatelessWidget {
  final String restaurantName;
  final String itemsInfo;
  final double price;
  final bool isCompleted;
  final String imageUrl;
  final String location;
  final VoidCallback onCancelOrder;
  final VoidCallback onTrackOrder;

  const ActiveOrderCard({
    super.key,
    required this.restaurantName,
    required this.itemsInfo,
    required this.price,
    required this.isCompleted,
    required this.imageUrl,
    required this.location,
    required this.onCancelOrder,
    required this.onTrackOrder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.xm),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(TSizes.xm),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood, size: 40),
                  ),
                ),
              ),
              const Gap(TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurantName,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.xs),
                    Text(itemsInfo,
                        style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: isDark ? TColors.primary : TColors.primary,
                        ),
                        const SizedBox(width: TSizes.xs),
                        Expanded(
                          child: Text(
                            location,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: isDark
                                      ? TColors.primary
                                      : TColors.primary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      children: [
                        Text('GHS $price',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: TSizes.sm),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.md, vertical: TSizes.xs),
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(TSizes.xm),
                            ),
                            child: Text(
                              'Paid',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: TColors.backgroundLight),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const TCustomDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onCancelOrder,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.sm, horizontal: TSizes.md)),
                child: const Text('Cancel Order'),
              ),
              ElevatedButton(
                onPressed: onTrackOrder,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.sm, horizontal: TSizes.md)),
                child: const Text('Track Order'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
