import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_divider.dart';
import 'package:foodu/common/widgets/texts/expandable_text.dart';
import 'package:foodu/common/widgets/texts/title_text.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

import 'widget/rating_and_bar_graph.dart';

class RestaurantAboutScreen extends StatelessWidget {
  const RestaurantAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppBar(showBackButton: true),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Big Gardan Salad",
                style: Theme.of(context).textTheme.headlineSmall),
            const TCustomDivider(),
            const RatingAndBarGraph(),
            const TCustomDivider(),
            const TTitleText(
              title: 'Overview',
            ),
            const Gap(TSizes.sm),
            const Flexible(
                child: SingleChildScrollView(
              child: TExpandableText(
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad dskfjkshfkjskfsdlkjflskjfsldkjfldsjflksjflksjlfksjlkjdslkfjlskjflksjflkjldskjflsjslfkjfdsl',
              ),
            )),
            // const Gap(TSizes.spaceBtwItems),
            // const DayAndTime(
            //   dayStart: 'Monday',
            //   dayEnd: 'Friday',
            //   hourStart: '10:00',
            //   hourEnd: '22:00',
            // ),
            // const Gap(10),
            // const DayAndTime(
            //   dayStart: 'Saturday',
            //   dayEnd: 'Sunday',
            //   hourStart: '12:00',
            //   hourEnd: '20:00',
            // ),
            const TCustomDivider(),
            const Gap(TSizes.spaceBtwItems),
            const TTitleText(title: "Address"),
            const Gap(TSizes.spaceBtwItems),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: TColors.primary),
                const Gap(10),
                Text('Grand City St. 100, New York, United States',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2)
              ],
            ),
            const Gap(TSizes.spaceBtwItems),
            Image.asset(isDark ? TImages.foodMap : TImages.lightFoodMap)
          ],
        ),
      ),
    );
  }
}
