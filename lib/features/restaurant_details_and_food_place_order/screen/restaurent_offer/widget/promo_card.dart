import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class PromoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const PromoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 14),
      margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 24,
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: THelperFunctions.screenWidth() / 2.2,
                    child: Text(title,
                        style: Theme.of(context).textTheme.labelLarge!.apply(color: isDark ? TColors.textWhite : TColors.textblack)),
                  ),
                  const SizedBox(height: 4.0),
                  SizedBox(
                    width: THelperFunctions.screenWidth() / 2.2,
                    child: Text(description, maxLines: 2, style: Theme.of(context).textTheme.labelSmall),
                  ),
                ],
              ),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              elevation: 0,
              foregroundColor: buttonText == 'Claim' ? TColors.primary : TColors.backgroundLight,
              backgroundColor: buttonText == 'Claim'
                  ? isDark
                      ? TColors.backgroundDark
                      : TColors.backgroundLight
                  : TColors.primary,
              side: const BorderSide(color: TColors.primary),
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            onPressed: onTap,
            child: Text(
              buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
