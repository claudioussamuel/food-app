import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

import '../../../../../utils/constants/sizes.dart';

class FoodCardHorizontalCart extends StatelessWidget {
  final List<String> imageUrl;
  final String title;
  final String description;
  final double price;

  const FoodCardHorizontalCart({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Stack Images
          SizedBox(
            width: 80,
            height: 60,
            child: Stack(
              children: List.generate(imageUrl.length, (index) {
                return Positioned(
                  left: index * 10.0, // 10 pixels right offset for each image
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: _imageProvider(imageUrl[index]),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          /// Title, Description, Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: TSizes.sm),
                Text(description, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: TSizes.sm),
                Text('GHS $price', style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _imageProvider(String path) {
    final String cleanPath = path.trim().replaceAll('"', '').replaceAll("'", '');
    if (cleanPath.startsWith('http')) {
      return NetworkImage(cleanPath);
    }
    return AssetImage(cleanPath);
  }
}
