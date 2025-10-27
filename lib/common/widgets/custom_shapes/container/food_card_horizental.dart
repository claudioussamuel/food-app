import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class TFoodCardHorizontal extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String reviewCount;
  final String price;
  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const TFoodCardHorizontal({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isInCart,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // Border shadow
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Row(
            children: [
              /// Card Image
              ClipRRect(
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                child: _buildImage(imageUrl),
              ),
              const SizedBox(width: TSizes.sm),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Card Title
                    Text(title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: TSizes.sm),

                    /// Ratings
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: TColors.rating, size: 16.0),
                        const SizedBox(width: TSizes.sm),
                        Text('$rating (${reviewCount}k)',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    /// Price
                    Text("GHS $price",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: TColors.primary)),
                  ],
                ),
              ),

              /// Add to Cart Icon
              GestureDetector(
                onTap: onAddToCart,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isInCart ? TColors.primary : TColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.add,
                    color: isInCart ? Colors.white : TColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    // Sanitize possible quoted strings from backend (e.g., "https://...")
    final String cleanPath = path.trim().replaceAll('"', '').replaceAll("'", '');
    final bool isNetwork = cleanPath.startsWith('http');
    if (isNetwork) {
      return Image.network(
        cleanPath,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(width: 90, height: 90);
        },
      );
    }
    return Image.asset(
      cleanPath,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
    );
  }
}
