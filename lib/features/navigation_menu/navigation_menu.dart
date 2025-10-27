import 'package:flutter/material.dart';
import 'package:foodu/features/navigation_menu/controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(() {
        List<BottomNavigationBarItem> navigationItems;

        if (controller.isAdmin.value) {
          navigationItems = _adminNavigationItems();
        } else if (controller.isDispatcher.value) {
          navigationItems = _dispatcherNavigationItems();
        } else {
          navigationItems = _userNavigationItems();
        }

        // Hide navigation bar if only one item (branch selection mode)
        if (navigationItems.length < 2) {
          return const SizedBox.shrink();
        }

        return BottomNavigationBar(
          elevation: 20,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          selectedItemColor: TColors.primary,
          unselectedItemColor: TColors.textGrey,
          showUnselectedLabels: true,
          backgroundColor:
              isDark ? const Color(0xD8181A20) : TColors.backgroundLight,
          type: BottomNavigationBarType.fixed,
          items: navigationItems,
        );
      }),
      body: Obx(() {
        final screens = controller.screens;
        final currentIndex = controller.selectedIndex.value;

        // Ensure index is within bounds
        if (currentIndex >= screens.length) {
          controller.selectedIndex.value = 0;
          return screens[0];
        }

        return screens[currentIndex];
      }),
    );
  }

  /// Navigation items for regular users
  List<BottomNavigationBarItem> _userNavigationItems() {
    return const [
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(TImages.home)),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(TImages.order)),
        label: 'Order',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(TImages.profile)),
        label: 'Profile',
      ),
    ];
  }

  /// Navigation items for dispatcher users
  List<BottomNavigationBarItem> _dispatcherNavigationItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.local_shipping),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(TImages.profile)),
        label: 'Profile',
      ),
    ];
  }

  /// Navigation items for admin users
  List<BottomNavigationBarItem> _adminNavigationItems() {
    final controller = Get.find<NavigationController>();

    // Check if showing branch selection screen
    if (controller.screens.length == 1) {
      // Reset selected index to 0 for single screen
      if (controller.selectedIndex.value != 0) {
        controller.selectedIndex.value = 0;
      }
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Select Branch',
        ),
      ];
    }

    // Normal admin navigation when branch is selected (2 screens)
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.store),
        label: 'Branches',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(TImages.profile)),
        label: 'Profile',
      ),
    ];
  }
}
