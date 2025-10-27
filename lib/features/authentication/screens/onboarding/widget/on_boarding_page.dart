import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Image
          Image(image: AssetImage(image), height: THelperFunctions.screenHeight() * 0.5),

          /// Title
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          const Gap(TSizes.spaceBtwItems),

          /// SubTitle
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: isDark ? TColors.textWhite : TColors.textblack),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
