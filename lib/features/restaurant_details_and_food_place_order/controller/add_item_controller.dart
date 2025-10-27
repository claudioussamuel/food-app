import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddItemController extends GetxController {
  static AddItemController get instance => Get.find();
  TextEditingController textEditingController = TextEditingController();
  RxInt itemCount = 0.obs;
}
