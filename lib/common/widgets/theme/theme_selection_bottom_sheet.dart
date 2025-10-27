import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/theme/theme_controller.dart';

/// Bottom sheet for theme selection with multiple options
class ThemeSelectionBottomSheet extends StatelessWidget {
  const ThemeSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose Theme',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Light Theme Option
          Obx(() => _ThemeOptionTile(
                icon: Icons.light_mode,
                title: 'Light',
                subtitle: 'Light theme for daytime use',
                isSelected: themeController.themeMode == ThemeMode.light,
                onTap: () {
                  themeController.setLightTheme();
                  Get.back();
                },
              )),

          // Dark Theme Option
          Obx(() => _ThemeOptionTile(
                icon: Icons.dark_mode,
                title: 'Dark',
                subtitle: 'Dark theme for nighttime use',
                isSelected: themeController.themeMode == ThemeMode.dark,
                onTap: () {
                  themeController.setDarkTheme();
                  Get.back();
                },
              )),

          // System Theme Option
          Obx(() => _ThemeOptionTile(
                icon: Icons.brightness_auto,
                title: 'System',
                subtitle: 'Follow system theme settings',
                isSelected: themeController.themeMode == ThemeMode.system,
                onTap: () {
                  themeController.setSystemTheme();
                  Get.back();
                },
              )),

          const SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }

  /// Show theme selection bottom sheet
  static void show() {
    Get.bottomSheet(
      const ThemeSelectionBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

/// Individual theme option tile
class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Iconsax.tick_circle,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: onTap,
    );
  }
}
