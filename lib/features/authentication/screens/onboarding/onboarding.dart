import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/exports.dart';
import '../../controller/onboarding_controller.dart';
import 'widget/on_boarding_page.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          /// Pages to scroll with Image, Title and Subtitle
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(title: TTexts.onBoardingTitle1, image: TImages.onBoardingImage1, subTitle: TTexts.onBoardingSubTitle1),
              OnBoardingPage(title: TTexts.onBoardingTitle2, image: TImages.onBoardingImage2, subTitle: TTexts.onBoardingSubTitle2),
              OnBoardingPage(title: TTexts.onBoardingTitle3, image: TImages.onBoardingImage3, subTitle: TTexts.onBoardingSubTitle3),
            ],
          ),

          /// Button and Slider remained fixed and at the bottom
          Positioned(
            bottom: TSizes.defaultSpace,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Slider Indicator
                SmoothPageIndicator(
                  count: 3,
                  controller: controller.pageController,
                  onDotClicked: controller.dotNavigationClick,
                  effect: const ExpandingDotsEffect(activeDotColor: TColors.primary, dotHeight: 6),
                ),
                const Gap(TSizes.defaultSpace),

                /// Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.nextPage(),
                    child: Obx(() => Text(controller.currentPageIndex < 2 ? 'Next' : 'Get Started')),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
