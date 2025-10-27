import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/let_you_in/let_you_in.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      currentPageIndex.value = 0;
      // Remove all the previous Screens and Launch Login
      Get.offAll(() => const LetYouInScreen());
    } else {
      currentPageIndex.value++;
      pageController.jumpToPage(currentPageIndex.value);
    }
  }
}
