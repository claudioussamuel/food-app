import 'package:get/get.dart';

class FAQ {
  final String question;
  final String answer;
  var isExpanded = false.obs;

  FAQ({required this.question, required this.answer});
}
