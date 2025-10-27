import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../personalization/controller/profile_form_controller.dart';

class ProfilePicSelection extends StatelessWidget {
  const ProfilePicSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ProfileFormController.instance;
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              controller.selectImage();
            },
            child: Obx(() {
              return Container(
                width: TSizes.imageThumbSize,
                height: TSizes.imageThumbSize,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide.none,
                  ),
                ),
                child: _buildProfileImage(controller),
              );
            }),
          ),
          Positioned(
            bottom: -5,
            right: 0,
            child: Container(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image(
                    image: AssetImage(TImages.picImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile image widget based on image source
  Widget _buildProfileImage(ProfileFormController controller) {
    // No image selected - show default profile image
    if (controller.imagePath.value.isEmpty && controller.imageUrl.value.isEmpty) {
      return const CircleAvatar(
        backgroundImage: AssetImage(TImages.profile),
      );
    }

    // Check if we have a network URL (from Firebase Storage or existing profile)
    final String imageSource = controller.imageUrl.value.isNotEmpty 
        ? controller.imageUrl.value 
        : controller.imagePath.value;

    // If it's a network URL (starts with http)
    if (imageSource.startsWith('http')) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageSource),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default image on error
          print('Error loading network image: $exception');
        },
      );
    }

    // If it's a local file path
    if (File(imageSource).existsSync()) {
      return CircleAvatar(
        backgroundImage: FileImage(File(imageSource)),
      );
    }

    // Fallback to default image
    return const CircleAvatar(
      backgroundImage: AssetImage(TImages.profile),
    );
  }
}
