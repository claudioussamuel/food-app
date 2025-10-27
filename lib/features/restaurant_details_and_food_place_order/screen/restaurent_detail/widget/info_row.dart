import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';

class InfoRow extends StatelessWidget {
  final Icon? leadingIcon;
  final String? title;
  final String? text;
  final String? secondaryText; // Optional secondary text
  final VoidCallback? onTap;
  final bool showBottomRow; // Whether to show the bottom row or not
  final String? deliveryText; // Text in the bottom row
  final String? priceText; // Price text in the bottom row
  final Widget? bottomRowIcon; // Icon in the bottom row

  const InfoRow({
    super.key,
    this.leadingIcon,
    this.text,
    this.title,
    this.secondaryText,
    this.onTap,
    this.showBottomRow = false,
    this.deliveryText,
    this.priceText,
    this.bottomRowIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /// Leading Icon
                if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: TSizes.sm)],

                /// Main Text
                Expanded(
                  child: Row(
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall!.apply(fontSizeDelta: 3),
                        ),

                      if (text != null) Text(text!, style: Theme.of(context).textTheme.bodySmall), // Customize main text style

                      if (secondaryText != null) ...[
                        const SizedBox(width: 8), // Space between main text and secondary text
                        Text(secondaryText!, style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Iconsax.arrow_right_1,
                  color: Colors.grey,
                ), // Trailing arrow
              ],
            ),
            if (showBottomRow) ...[
              const SizedBox(height: 8), // Space between rows
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Delivery Now', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  const Text('|', textAlign: TextAlign.center),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  const Icon(Icons.delivery_dining, color: Colors.green, size: 20.0),
                  const SizedBox(width: TSizes.sm),
                  Text(priceText ?? '', style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
            Divider(color: TColors.grey.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}
