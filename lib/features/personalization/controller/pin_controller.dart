import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  static PinController get instance => Get.find();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();

  @override
  void onClose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.onClose();
  }

  void moveToNextField(String value, FocusNode currentNode, FocusNode nextNode) {
    if (kDebugMode) print(value.length);
    if (value.length == 1) {
      nextNode.requestFocus();
    }
  }
}
