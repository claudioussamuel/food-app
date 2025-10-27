import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class HorizontalFoodCardRestaurant extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? badgeText;

  const HorizontalFoodCardRestaurant({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.badgeText,
  });

  @override
  HorizontalFoodCardRestaurantState createState() => HorizontalFoodCardRestaurantState();
}

class HorizontalFoodCardRestaurantState extends State<HorizontalFoodCardRestaurant> {
  bool isTapped = false;

  void _toggleBorderColor() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: _toggleBorderColor,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.xs),
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          color: isDark ? TColors.darkCard : Colors.white,
          border: Border.all(color: isTapped ? Colors.green : Colors.transparent, width: 2.0),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 0, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              child: Image.asset(widget.imageUrl, height: 80, width: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: TSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.badgeText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm + 2, vertical: TSizes.xs),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(TSizes.xm)),
                      child: Text(widget.badgeText!, style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.backgroundLight)),
                    ),
                  Text(widget.title, style: Theme.of(context).textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: TSizes.xs),
                  Text("\$ ${widget.price}", style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
