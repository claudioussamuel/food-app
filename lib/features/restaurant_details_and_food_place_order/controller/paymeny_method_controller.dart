import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  var paymentMethods = <Map<String, dynamic>>[].obs;
  var selectedPaymentIndex = 0.obs;

  void addPaymentMethod(String title, IconData icon, {String? balance}) {
    paymentMethods.add({
      'title': title,
      'icon': icon,
      'balance': balance,
    });
  }

  void selectPaymentMethod(int index) {
    selectedPaymentIndex.value = index;
  }
}
