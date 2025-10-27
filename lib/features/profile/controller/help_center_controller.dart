import 'package:get/get.dart';

import '../model/faq.dart';

class HelpCenterController extends GetxController {
  var selectedCategory = 'General'.obs;
  var faqs = <FAQ>[].obs;

  List tabs = ['Faq', 'Contact us'];

  @override
  void onInit() {
    super.onInit();
    loadFAQs();
  }

  void loadFAQs() {
    faqs.addAll([
      FAQ(
          question: 'What is Foodu?',
          answer:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      FAQ(
          question: 'How can I make a payment?',
          answer:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      FAQ(
          question: 'How do I cancel orders?',
          answer:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      FAQ(
          question: 'How do I delete my account?',
          answer:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
      FAQ(
          question: 'How do I exit the app?',
          answer:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
    ]);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    // Optionally filter FAQs based on the selected category
  }
}
