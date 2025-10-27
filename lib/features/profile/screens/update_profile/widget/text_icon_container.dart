import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class TextIconContainer extends StatelessWidget {
  const TextIconContainer({
    super.key,
    required this.text,
    required this.iconData,
    required this.onTap,
  });

  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: TSizes.homeAppBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: TSizes.appBarHeight),
        decoration: ShapeDecoration(
          color: isDark ? TColors.darkCard : TColors.textFieldFillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.md),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            Icon(
              iconData,
              color: TColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}
