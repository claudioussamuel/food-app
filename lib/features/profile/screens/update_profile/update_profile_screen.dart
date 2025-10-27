import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../personalization/screens/profile_form/widget/profile_form.dart';
import '../../../personalization/controller/profile_form_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileFormController(), permanent: true);

    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Update Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
          child: Column(
            children: [
              const ProfileForm(),
              const SizedBox(
                height: TSizes.defaultSpace,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                      onPressed: profileController.isLoading.value
                          ? null
                          : () async {
                              // Update profile with Firestore
                              final success =
                                  await profileController.updateProfile();
                              if (success) {
                                // Navigate back to profile screen on success
                                Get.back();
                              }
                            },
                      child: profileController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Update'))))
            ],
          ),
        ),
      ),
    );
  }
}
