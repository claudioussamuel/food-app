import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class VerticalFoodCardRestaurant extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? badgeText;

  const VerticalFoodCardRestaurant({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.badgeText,
  });

  @override
  VerticalFoodCardRestaurantState createState() => VerticalFoodCardRestaurantState();
}

class VerticalFoodCardRestaurantState extends State<VerticalFoodCardRestaurant> {
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
        width: 150,
        // margin: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.xm),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 5))],
          border: Border.all(color: isTapped ? TColors.primary : Colors.transparent, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(widget.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
                  ),
                  if (widget.badgeText != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm + 2, vertical: TSizes.xs),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(TSizes.xm)),
                        child: Text(widget.badgeText!, style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.backgroundLight)),
                      ),
                    ),
                ],
              ),
              const Gap(TSizes.spaceBtwItems / 2),
              Text(widget.title, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const Gap(TSizes.spaceBtwItems / 2),
              Text("\$ ${widget.price}", style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
