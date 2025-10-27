import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/order/screens/rate_driver/widget/driver_rating_widget.dart';
import 'package:foodu/features/order/screens/tip_for_driver/tip_for_driver_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RateDriverScreen extends StatelessWidget {
  const RateDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
        child: DriverRatingWidget(
          driverImage: TImages.pic,
          title: "Let’s rate your driver’s delivery service",
          subtitle: "How was the delivery of your order from Big Garden Salad?",
          onRatingChanged: (rating) {},
          onCallDriverPressed: () {},
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Cancel', style: TextStyle(color: TColors.primary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.to(const TipForDriverScreen()),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
