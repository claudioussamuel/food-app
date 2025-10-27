import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/order/screens/rate_driver/rate_driver_screen.dart';
import 'package:foodu/features/order/screens/whats_your_mind/widget/emoji_list.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class WhatsYourMind extends StatelessWidget {
  const WhatsYourMind({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = OrderController.instance;
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("What's Your Mood!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium!.apply(color: isDark ? TColors.textWhite : TColors.textblack)),
              Text('about this order?',
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.textGrey)),
              EmojiListWidget(
                emojiList: controller.myEmojis,
                emojiSize: 80.0,
                borderRadius: 12.0,
                borderWidth: 2.0,
              ),
            ],
          ),
        ),
      ),
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
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.md)),
                onPressed: () => Get.to(const RateDriverScreen()),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
