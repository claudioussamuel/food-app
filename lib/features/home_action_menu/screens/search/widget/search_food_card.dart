import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/model/search_food_item_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:foodu/features/home_action_menu/controller/search_controller.dart';
import 'package:foodu/features/home_action_menu/screens/details/food_details_screen.dart';

class SearchFoodCard extends StatelessWidget {
  final SearchFoodItemModel foodItem;

  const SearchFoodCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: () => Get.to(() => FoodDetailsScreen(item: foodItem)),
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(foodItem.image, height: 80, width: 80),
                ),
                const SizedBox(width: TSizes.xm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              foodItem.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        '⭐ ${foodItem.rating} (${foodItem.reviews})',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: TSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'GHS ${foodItem.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          GetBuilder<SearchPageController>(
                            builder: (c) {
                              final isFav = c.isFavorite(foodItem.id);
                              return IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  if (!isFav) {
                                    // Add to cart and mark as favorite
                                    c.addToCart(foodItem);
                                  } else {
                                    // Just toggle favorite (remove from favorites)
                                    c.toggleFavorite(foodItem.id);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            Divider(color: TColors.textGrey.withValues(alpha: 0.3)),
            const SizedBox(height: TSizes.sm),
            Column(
              children: foodItem.recommendedItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(item.image, height: 50, width: 50),
                      ),
                      const SizedBox(width: TSizes.xm),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            THelperFunctions.truncateText(item.name, 25),
                            style: Theme.of(context).textTheme.labelLarge!.apply(color: isDark ? TColors.textWhite : TColors.textblack),
                          ),
                          Text('GHS ${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ))
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildImage(String path, {double? height, double? width}) {
    final isNetwork = path.startsWith('http');
    if (isNetwork) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
        ),
      );
    }
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
