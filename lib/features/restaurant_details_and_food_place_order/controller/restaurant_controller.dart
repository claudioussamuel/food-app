import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class RestaurantController extends GetxController {
  static RestaurantController get instance => Get.find();

  final List<Map<String, dynamic>> foodItems = [
    {'imageUrl': TImages.mixedSalad, 'title': 'Mixed Vegetable Salad', 'price': '6.0', 'badgeText': 'Best Seller'},
    {'imageUrl': TImages.mixedSalad, 'title': 'Mixed Vegetable Salad', 'price': '6.0', 'badgeText': null},
  ];

  var selectedChipIndex = 0.obs;

  void selectChip(int index) {
    selectedChipIndex.value = index;
  }

  final List<String> chipList = ['Sort By', '5', '4', '3', '2', '1'];
}
