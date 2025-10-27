import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:get/get.dart';

import '../../controller/discount_controller.dart';
import 'widget/discount_card.dart';

class DiscountScreen extends StatelessWidget {
  DiscountScreen({super.key});

  // Put or find the controller here
  final controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Get Discount"),
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        // Remove Obx from around ListView; we’ll put one inside itemBuilder instead
        child: ListView.builder(
          itemCount: controller.discounts.length,
          itemBuilder: (context, index) {
            final discount = controller.discounts[index];
            // Wrap each DiscountCard in its own Obx, so it rebuilds when
            // selectedDiscountIndex changes.
            return Obx(() {
              // isSelected is true iff this index matches the controller’s value:
              final isSelected = controller.selectedDiscountIndex.value == index;
              return DiscountCard(
                title: discount['title'] as String,
                description: discount['description'] as String,
                icon: discount['icon'] as IconData,
                isSelected: isSelected,
                onTap: () => controller.selectDiscount(index),
              );
            });
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("Apply"),
          ),
        ),
      ),
    );
  }
}
