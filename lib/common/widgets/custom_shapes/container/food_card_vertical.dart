import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class TFoodCardVertical extends StatelessWidget {
  final String imageUrl;
  final String title;

  final String price;

  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const TFoodCardVertical({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.isInCart,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(TSizes.sm + 2),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          boxShadow: [
            // Shadow of the Card
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 0.3,
                blurRadius: 6,
                offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                /// Image of the product
                ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _buildImage(imageUrl),
                  ),
                ),

                /// Promo Text
                Positioned(
                  top: TSizes.md,
                  left: TSizes.sm,
                  child: Container(
                    width: 55,
                    height: 25,
                    padding: const EdgeInsets.all(TSizes.xs),
                    decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'FAST',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .apply(color: TColors.backgroundLight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),

            /// Title of the product
            Text(title,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: TSizes.sm),

            /// Product price and Delivery Fee
            Row(
              children: [
                // Product Price
                Text("GHS $price",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: TColors.primary)),

                // Space between add Icon and the price
                const Spacer(),

                /// Add to Cart Icon
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isInCart ? TColors.primary : TColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Iconsax.add,
                      color: isInCart ? Colors.white : TColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    // Sanitize possible quoted strings from backend (e.g., "https://...")
    final String cleanPath =
        path.trim().replaceAll('"', '').replaceAll("'", '');
    final bool isNetwork = cleanPath.startsWith('http');
    if (isNetwork) {
      return Image.network(
        cleanPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.grey),
          );
        },
      );
    }
    return Image.asset(
      cleanPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
    );
  }
}
