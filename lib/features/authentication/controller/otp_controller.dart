import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();

  /// Timer
  var secondsRemaining = 60.obs;
  var isButtonEnabled = false.obs;
  Timer? _timer;

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

  void startTimer() {
    try {
      if (_timer != null) {
        _timer?.cancel();
      }

      secondsRemaining.value = 60;
      isButtonEnabled.value = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          isButtonEnabled.value = true;
          _timer!.cancel();
        }
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap", message: e.toString());
    }
  }
}
