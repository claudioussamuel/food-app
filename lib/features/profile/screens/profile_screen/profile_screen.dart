import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/button/profile_toggle_item.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:foodu/data/repositories/authentication/authentication_repository.dart';

import '../../../personalization/controller/profile_form_controller.dart'
    show ProfileFormController;
import '../../../../utils/theme/theme_controller.dart';
import '../../../admin/screens/manage_admins_screen.dart';
import '../../../dispatcher/screens/dispatcher_management_screen.dart';
import '../../../navigation_menu/controller.dart';
import '../help_center/help_center_screen.dart';
import '../update_profile/update_profile_screen.dart';
import 'widget/admin_role_switcher.dart';
import 'widget/admin_dispatcher_switcher.dart';
import 'widget/dispatcher_view_switcher_widget.dart';
import 'widget/log_out_button.dart';
import 'widget/profile_header.dart';
import 'widget/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final navigationController = Get.find<NavigationController>();
    // Initialize ProfileFormController to access user profile data
    final profileController = Get.put(ProfileFormController(), permanent: true);

    // Load user profile data when home screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadCurrentUserProfile();
    });
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: TSizes.defaultSpace),
          child: Image.asset(TImages.appLogo),
        ),
        title: Text("Profile", style: Theme.of(context).textTheme.titleLarge),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: TSizes.defaultSpace),
        //     child: ImageIcon(AssetImage(TImages.more)),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            // spacing: TSizes.sm,
            children: [
              ProfileHeader(
                name: profileController.currentProfile.value?.firstName ?? '',
                phoneNumber:
                    profileController.currentProfile.value?.phoneNumber ?? '',
                imageUrl:
                    profileController.currentProfile.value?.profileImagePath ??
                        '',
                onEdit: () => Get.to(const UpdateProfileScreen()),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Admin Role Switcher - Switch between Admin and User (only visible for admins)
              const AdminRoleSwitcher(),
              
              /// Admin-Dispatcher Switcher - Switch between Admin and Dispatcher (only visible for admins)
              const AdminDispatcherSwitcher(),
              
              /// Dispatcher View Switcher (only visible for dispatchers)
              const DispatcherViewSwitcherWidget(),
              
              /// Admin Management Section (only visible for admins)
              if (navigationController.isOriginallyAdmin) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Text(
                    'Admin Management',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ProfileListItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Manage Admins',
                  onTap: () => Get.to(() => const ManageAdminsScreen()),
                ),
                ProfileListItem(
                  icon: Icons.delivery_dining,
                  title: 'Manage Dispatchers',
                  onTap: () => Get.to(() => const DispatcherManagementScreen()),
                ),
              ],
              
              // const Divider(),
              // ProfileListItem(
              //   icon: Iconsax.heart,
              //   title: 'My Favorite Restaurants',
              //   onTap: () => Get.to(const FavouriteScreen()),
              // ),
              // ProfileListItem(
              //   icon: Iconsax.tag,
              //   title: 'Special Offers & Promo',
              //   onTap: () {
              //     Get.to(DiscountScreen());
              //   },
              // ),
              // ProfileListItem(
              //   icon: Icons.payment,
              //   title: 'Payment Methods',
              //   onTap: () => Get.to(const PaymentMethodScreen()),
              // ),
              const Divider(),
              ProfileListItem(
                icon: Iconsax.user,
                title: 'Profile',
                onTap: () => Get.to(const UpdateProfileScreen()),
              ),
              // ProfileListItem(
              //   icon: Iconsax.location,
              //   title: 'Address',
              //   onTap: () => Get.to(const AddressScreen()),
              // ),
              // ProfileListItem(
              //   icon: Iconsax.notification,
              //   title: 'Notification',
              //   onTap: () => Get.to(const NotificationSetting()),
              // ),
              // ProfileListItem(
              //   icon: Iconsax.shield,
              //   title: 'Security',
              //   onTap: () => Get.to(const SecuritySetting()),
              // ),
              // ProfileListItem(
              //   icon: Iconsax.global,
              //   title: 'Language',
              //   trailingText: 'English (US)',
              //   onTap: () => Get.to(const LanguageSetting()),
              // ),
              Obx(
                () => ProfileToggleItem(
                  icon: themeController.themeModeIcon,
                  title: 'Dark Mode',
                  value: themeController.isDarkMode,
                  onChanged: (newValue) {
                    themeController.toggleTheme();
                  },
                ),
              ),
              ProfileListItem(
                icon: Iconsax.message_question,
                title: 'Help Center',
                onTap: () => Get.to(const HelpCenterScreen()),
              ),
              // ProfileListItem(
              //   icon: Iconsax.people,
              //   title: 'Invite Friends',
              //   onTap: () => Get.to(const InviteFriendsScreen()),
              // ),
              const Divider(),
              LogoutButton(onTap: () => showLogoutConfirmation(context)),
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _performLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Perform logout
      await AuthenticationRepository.instance.logout();

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Close loading dialog if it's open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
