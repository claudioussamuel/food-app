import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> reviewData;

  const ReviewCard({
    super.key,
    required this.reviewData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: isDark ? TColors.backgroundDark : Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 20.0, backgroundImage: AssetImage(reviewData['userImage'])),
              const SizedBox(width: TSizes.sm),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(reviewData['userName'], style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.textblack)),
                    const SizedBox(width: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(5, (index) {
                        return Icon(index < reviewData['rating'] ? Icons.star : Icons.star_border, color: Colors.amber, size: 16.0);
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TSizes.xs),
              ImageIcon(const AssetImage(TImages.more), color: isDark ? Colors.white : Colors.black)
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Text(reviewData['reviewText'], style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: TSizes.sm),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink),
                  const SizedBox(width: TSizes.xs),
                  Text(reviewData['likes'].toString(),
                      style: Theme.of(context).textTheme.titleSmall!.apply(color: isDark ? TColors.textWhite : TColors.textblack)),
                ],
              ),
              const SizedBox(width: TSizes.md),
              Text(reviewData['daysAgo'], style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
