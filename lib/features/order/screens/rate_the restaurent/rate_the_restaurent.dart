import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/order/screens/rate_the%20restaurent/widget/order_feedback_widget.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';

class RateTheRestaurentScreen extends StatelessWidget {
  const RateTheRestaurentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
          child: OrderFeedbackWidget(
            imageUrl: TImages.mixedSalad,
            title: 'How was the delivery of your order from Big Garden Salad?',
            subtitle: 'Enjoyed your food? Rate the restaurant, your feedback is matters.',
            onRatingChanged: (rating) {},
          )),
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
                  'Cancel',
                  style: TextStyle(color: TColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
