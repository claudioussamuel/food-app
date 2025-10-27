import 'package:get/get.dart';

class AddressController extends GetxController {
  var addresses = <Map<String, dynamic>>[].obs;
  var selectedAddressIndex = 0.obs;

  void addAddress(String title, String address, {bool isDefault = false}) {
    addresses.add({
      'title': title,
      'address': address,
      'isDefault': isDefault,
    });
  }

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
  }
}
