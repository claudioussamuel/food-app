import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class RatingAndBarGraph extends StatelessWidget {
  const RatingAndBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: THelperFunctions.screenWidth() / 3,
          height: THelperFunctions.screenHeight() / 6.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("4.8", style: Theme.of(context).textTheme.headlineMedium!.apply(color: isDark ? TColors.textWhite : TColors.textblack)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.star_rate_rounded, color: TColors.rating),
                  Icon(Icons.star_rate_rounded, color: TColors.rating),
                  Icon(Icons.star_rate_rounded, color: TColors.rating),
                  Icon(Icons.star_half_rounded, color: TColors.rating),
                  Icon(Icons.star_border_outlined, color: TColors.rating),
                ],
              ),
              Text("(4.8k reviews)", style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
        ),
        const Gap(10),
        SizedBox(
          width: THelperFunctions.screenWidth() / 2.0,
          height: THelperFunctions.screenHeight() / 6.2,
          child: Column(
            children: [
              chartRow(context, '5', 85),
              chartRow(context, '4', 65),
              chartRow(context, '3', 30),
              chartRow(context, '2', 45),
              chartRow(context, '1', 20),
            ],
          ),
        )
      ],
    );
  }

  Widget chartRow(BuildContext context, String label, int pct) {
    return Row(
      children: [
        SizedBox(width: 5, child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Stack(children: [
            Container(
              height: 4,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(color: TColors.textGrey, borderRadius: BorderRadius.circular(20)),
              child: const Text(''),
            ),
            Container(
              height: 4,
              width: MediaQuery.of(context).size.width * (pct / 100) * 0.45,
              decoration: BoxDecoration(color: TColors.primary, borderRadius: BorderRadius.circular(20)),
              child: const Text(''),
            ),
          ]),
        ),
      ],
    );
  }
}
