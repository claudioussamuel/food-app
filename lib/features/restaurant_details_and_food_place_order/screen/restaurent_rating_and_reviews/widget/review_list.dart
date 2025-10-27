import 'package:flutter/material.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controller/review_and_rating_controller.dart';
import 'review_card.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ReviewAndRatingController.instance;

    return Obx(() {
      return SizedBox(
        height: THelperFunctions.screenHeight() / 1.75,
        child: ListView.separated(
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(
              reviewData: controller.reviews[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Column(
              children: [
                Divider(),
                SizedBox(height: TSizes.spaceBtwItems),
              ],
            );
          },
        ),
      );
    });
  }
}
