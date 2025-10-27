import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  static WalletController get instance => Get.find();
  var userName = "Andrew Ainsley".obs;
  var cardNumber = "**** **** **** 3629".obs;
  var balance = 9379.0.obs;

  var selectedAmount = 50.obs;

  void updateAmount(int amount) {
    selectedAmount.value = amount;
  }

  var transactions = [
    {
      "title": "Big Garden Salad",
      "amount": 21.20,
      "date": "Dec 15, 2024 | 16:00 PM",
      "type": "Orders",
      "isCredit": false,
      "image": TImages.mixedSalad
    },
    {
      "title": "Top Up E-Wallet",
      "amount": 40.00,
      "date": "Dec 14, 2024 | 16:42 PM",
      "type": "Top up",
      "isCredit": true,
      "image": TImages.wallet
    },
    {
      "title": "Vegetable Salad",
      "amount": 24.00,
      "date": "Dec 14, 2024 | 11:39 AM",
      "type": "Orders",
      "isCredit": false,
      "image": TImages.sandwich
    },
    {
      "title": "Mixed Salad Bonbon",
      "amount": 28.50,
      "date": "Dec 13, 2024 | 14:46 PM",
      "type": "Orders",
      "isCredit": false,
      "image": TImages.mixedSalad
    },
    {
      "title": "Top Up E-Wallet",
      "amount": 50.00,
      "date": "Dec 12, 2024 | 09:27 AM",
      "type": "Top up",
      "isCredit": true,
      "image": TImages.wallet
    },
  ].obs;

  var selectedMethod = 0.obs;

  void selectMethod(int index) {
    selectedMethod.value = index;
  }
}
