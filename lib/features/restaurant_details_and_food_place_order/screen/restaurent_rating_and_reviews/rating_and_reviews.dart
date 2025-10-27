import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_divider.dart';
import 'package:get/get.dart';

import '../../controller/review_and_rating_controller.dart';
import '../restaurent_about/widget/rating_and_bar_graph.dart';
import 'widget/rating_and_review_chip_list_row.dart';
import 'widget/review_list.dart';

class RatingAndReviews extends StatefulWidget {
  const RatingAndReviews({super.key});

  @override
  State<RatingAndReviews> createState() => _RatingAndReviewsState();
}

class _RatingAndReviewsState extends State<RatingAndReviews> {
  @override
  Widget build(BuildContext context) {
    Get.put(ReviewAndRatingController());
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Rating & Reviews"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithHeightWidth,
          child: const Column(
            children: [
              TCustomDivider(),
              RatingAndBarGraph(),
              TCustomDivider(),
              RatingAndReviewChipListRow(),
              TCustomDivider(),
              ReviewList(),
            ],
          ),
        ),
      ),
    );
  }
}
