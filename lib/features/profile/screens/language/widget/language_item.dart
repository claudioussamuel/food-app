import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

import '../../../controller/profile_controller.dart';

class LanguageItem extends StatelessWidget {
  final String language;

  const LanguageItem({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.instance;

    return Obx(() => ListTile(
          title: Text(language, style: Theme.of(context).textTheme.labelLarge),
          trailing: controller.selectedLanguage.value == language
              ? const Icon(Icons.check_circle, color: TColors.primary)
              : Icon(
                  Icons.circle,
                  color: Colors.blueGrey[100],
                ),
          onTap: () {
            controller.changeLanguage(language);
          },
        ));
  }
}
