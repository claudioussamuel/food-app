import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

class DayAndTime extends StatelessWidget {
  const DayAndTime({
    super.key,
    required this.dayStart,
    required this.dayEnd,
    required this.hourStart,
    required this.hourEnd,
  });

  final String dayStart;
  final String dayEnd;
  final String hourStart;
  final String hourEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: Get.width / 2, child: Text("$dayStart - $dayEnd", maxLines: 1, style: Theme.of(context).textTheme.bodySmall)),
        Text('$hourStart - $hourEnd', style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary)),
      ],
    );
  }
}
