import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  static OfferController get instance => Get.find();
  var promoList = [
    {
      'icon': Icons.person,
      'title': 'Promo New User',
      'description': 'Valid for new users',
      'buttonText': 'Claim',
    },
    {
      'icon': Icons.local_offer,
      'title': 'Promo Special Offer',
      'description': 'Save 20% on your next purchase',
      'buttonText': 'Claimed',
    },
  ].obs;
}
