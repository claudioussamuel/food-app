import 'package:get/get.dart';

class Friend {
  final String name;
  final String phoneNumber;
  final String imageUrl;
  var isInvited = false.obs;

  Friend({required this.name, required this.phoneNumber, required this.imageUrl});
}
