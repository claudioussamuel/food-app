import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_chip.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../controller/restaurant_controller.dart';

class RatingAndReviewChipListRow extends StatelessWidget {
  const RatingAndReviewChipListRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = RestaurantController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xm),
      child: SizedBox(
        height: 30,
        width: double.infinity,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.chipList.length,
          itemBuilder: (context, index) {
            return Obx(() {
              bool isSelected = index == controller.selectedChipIndex.value;
              return TCustomChip(
                label: controller.chipList[index],
                labelColor: isSelected ? Colors.white : TColors.primary,
                imagePath: controller.chipList[index] == 'Sort By' ? TImages.sort : TImages.rating,
                onTap: () {
                  controller.selectChip(index);
                },
                backgroundColor: isSelected ? TColors.primary : Colors.white,
              );
            });
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: TSizes.sm,
            );
          },
        ),
      ),
    );
  }
}
