import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../home_action_menu/screens/home/widget/horizental_food_list.dart';
import '../../../home_action_menu/screens/home/widget/verical_food_list.dart';
import '../../../home_action_menu/model/food_model.dart';
import '../../controller/restaurant_controller.dart';
import '../checkout_order/checkout_order_screen.dart';
import '../restaurent_about/restaurent_about_screen.dart';
import '../restaurent_rating_and_reviews/rating_and_reviews.dart';
import 'widget/info_row.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final FoodModel? product;

  const RestaurantDetailScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    Get.put(RestaurantController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                /// Background Image
                Container(
                  width: double.infinity,
                  height: THelperFunctions.screenHeight(context: context) / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: product?.image.isNotEmpty == true
                          ? (product!.image.startsWith('http')
                              ? NetworkImage(product!.image)
                              : AssetImage(product!.image) as ImageProvider)
                          : const AssetImage(TImages.restaurent),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// Appbar with Icons
                Positioned(
                  top: TSizes.appBarHeight + 8,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.defaultSpace),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Iconsax.arrow_left,
                                color: Colors.white)),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Iconsax.heart,
                                      color: Colors.white)),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.paperplane,
                                      color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Heading
                  InfoRow(
                    title: product?.name ?? 'Restaurant',
                    onTap: () => Get.to(const RestaurantAboutScreen()),
                  ),
                  InfoRow(
                    text: product?.rating.toStringAsFixed(1) ?? '0.0',
                    secondaryText:
                        '(${_formatReviewCount(product?.reviewCount ?? 0)} reviews)',
                    onTap: () => Get.to(const RatingAndReviews()),
                    leadingIcon: const Icon(CupertinoIcons.star_fill,
                        color: TColors.rating),
                  ),

                  /// Product Description
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    product?.description ??
                        'No description available for this product.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // InfoRow(
                  //     text: 'Offers are available',
                  //     leadingIcon: const Icon(Iconsax.tag5, color: TColors.primary),
                  //     onTap: () => Get.to(const OfferScreen())),
                ],
              ),
            ),

            /// FOR YOU LIST
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child:
                  Text("For You", style: Theme.of(context).textTheme.bodyLarge),
            ),
            const HorizontalFoodList(),
            const Gap(TSizes.spaceBtwSection),

            /// MENU LIST
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Text("Menu", style: Theme.of(context).textTheme.bodyLarge),
            ),
            const VerticalFoodList(),
            const Gap(TSizes.spaceBtwSection),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(() => CheckoutOrderScreen(product: product)),
          child: Text(
            'Add to Basket - GHS ${product?.price.toStringAsFixed(2) ?? '0.00'}',
          ),
        ),
      ),
    );
  }

  /// Helper method to format review count (e.g., 1200 -> "1.2k", 1000 -> "1000", 500 -> "500")
  String _formatReviewCount(int count) {
    if (count > 1000) {
      double formatted = count / 1000.0;
      return '${formatted.toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
