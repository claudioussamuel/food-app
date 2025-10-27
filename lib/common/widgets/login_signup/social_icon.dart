import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';

class TSocialIcon extends StatelessWidget {
  const TSocialIcon({
    super.key,
    required this.image,
    required this.onTap,
  });

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(side: const BorderSide(width: 1, color: TColors.borderGrey), borderRadius: BorderRadius.circular(10)),
      ),
      child: IconButton(onPressed: onTap, icon: Image(image: AssetImage(image), height: TSizes.lg, width: TSizes.lg)),
    );
  }
}
