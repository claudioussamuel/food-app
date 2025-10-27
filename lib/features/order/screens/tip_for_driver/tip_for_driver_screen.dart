import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/order/screens/rate_the%20restaurent/rate_the_restaurent.dart';
import 'package:foodu/features/order/screens/tip_for_driver/widget/tip_selection_widget.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

class TipForDriverScreen extends StatelessWidget {
  const TipForDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace, horizontal: TSizes.defaultSpace),
        child: TipSelectionWidget(
          driverImage: TImages.pic,
          title: "Wow 5 Star! 🤩",
          subtitle: "Do you want to add an additional tip to make your driver's day?",
          onCustomTipSelected: () {
            if (kDebugMode) print("Custom tip selected");
          },
        ),
      ),
      //make this widget resuable
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFE8F7ED),
                    side: const BorderSide(color: Color(0xFFE8F7ED)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    textStyle: const TextStyle(fontSize: 14, color: TColors.primary, fontWeight: FontWeight.w700)),
                child: const Text(
                  'No Thanks',
                  style: TextStyle(color: TColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.to(const RateTheRestaurentScreen()),
                child: const Text('Pay Tip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
