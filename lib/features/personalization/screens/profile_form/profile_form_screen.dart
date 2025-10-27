import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import '../../../navigation_menu/navigation_menu.dart';
import '../../../profile/screens/update_profile/widget/profile_form.dart';
import '../../controller/profile_form_controller.dart';

class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(ProfileFormController(), permanent: true);
    return Scaffold(
      // Appbar
      appBar: const TAppBar(
          showBackButton: true, title: Text(TTexts.fillYourProfile)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
          child: Column(
            children: [
              const ProfileForm(),
              const SizedBox(height: TSizes.defaultSpace),

              // Continue Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ProfileFormController.instance.isLoading.value
                          ? null
                          : () async {
                              final success = await ProfileFormController
                                  .instance
                                  .saveProfile();
                              if (success) {
                                Get.offAll(const NavigationMenu());
                              }
                            },
                      child: ProfileFormController.instance.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(TTexts.continueB),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
