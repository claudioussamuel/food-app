import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/help_center_controller.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;

  const CategorySelector({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpCenterController>();

    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.map((category) {
            return GestureDetector(
              onTap: () {
                controller.changeCategory(category);
              },
              child: Column(
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: controller.selectedCategory.value == category ? Colors.green : Colors.grey,
                    ),
                  ),
                  if (controller.selectedCategory.value == category)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 2,
                      width: 50,
                      color: Colors.green,
                    ),
                ],
              ),
            );
          }).toList(),
        ));
  }
}
