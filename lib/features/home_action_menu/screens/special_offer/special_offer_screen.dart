import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/custom_shapes/container/discount_container.dart';
import 'package:foodu/features/home_action_menu/controller/special_offer_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SpecialOfferScreen extends StatelessWidget {
  const SpecialOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialOfferController());
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Special Offer',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        showBackButton: true,
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: ListView.separated(
          itemCount: controller.specialOffers.length,
          itemBuilder: (BuildContext context, int index) {
            var offer = controller.specialOffers[index];
            return DiscountImage(
              imagePath: offer['imageUrl']!,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(1);
          },
        ),
      ),
    );
  }
}
