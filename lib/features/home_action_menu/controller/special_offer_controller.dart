import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class SpecialOfferController extends GetxController {
  static SpecialOfferController get instance => Get.find();

  var specialOffers = <Map<String, String>>[
    {
      "discount": "30%",
      "description": "Discount only valid for today!",
      "imageUrl": TImages.banner1,
    },
    {
      "discount": "15%",
      "description": "Discount only valid for today!",
      "imageUrl": TImages.banner2,
    },
    {
      "discount": "20%",
      "description": "Discount only valid for today!",
      "imageUrl": TImages.banner3,
    },
    {
      "discount": "25%",
      "description": "Discount only valid for today!",
      "imageUrl": TImages.banner4,
    },
  ].obs;

  final List<Gradient> colors = [
    TColors.greenGradient,
    TColors.orangeGradient,
    TColors.redGradient,
    TColors.blueGradient,
  ];
}
