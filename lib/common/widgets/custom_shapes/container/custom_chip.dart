import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class TCustomChip extends StatelessWidget {
  final String label;
  final String? imagePath;
  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;
  final VoidCallback? onTap;

  const TCustomChip({
    super.key,
    required this.label,
    this.imagePath,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.green,
    this.labelColor = Colors.green,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md, vertical: TSizes.xs),
        decoration: BoxDecoration(
            color: backgroundColor == TColors.primary
                ? TColors.primary
                : isDark
                    ? TColors.backgroundDark
                    : TColors.backgroundLight,
            borderRadius: BorderRadius.circular(TSizes.buttonRadius),
            border: Border.all(color: borderColor)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null && imagePath!.isNotEmpty) ...[
              _buildImage(imagePath!),
              const SizedBox(width: TSizes.xs),
            ],
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: labelColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    final bool isNetwork = path.startsWith('http');
    if (isNetwork) {
      return Image.network(
        path,
        height: 20,
        width: 20,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(height: 20, width: 20);
        },
      );
    }
    return Image.asset(
      path,
      height: 20,
      width: 20,
      fit: BoxFit.cover,
    );
  }
}
