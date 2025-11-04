import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controller/profile_form_controller.dart';

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
            onTap: () => controller.selectImage(),
            child: Obx(() {
              return Container(
                width: TSizes.imageThumbSize,
                height: TSizes.imageThumbSize,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide.none,
                  ),
                ),
                child: Stack(
                  children: [
                    controller.imagePath.value.isEmpty
                        ? const CircleAvatar(
                            backgroundImage: AssetImage(TImages.user))
                        : CircleAvatar(
                            backgroundImage:
                                FileImage(File(controller.imagePath.value))),
                    // Show circular progress indicator when uploading
                    if (controller.isUploadingImage.value)
                      Container(
                        width: TSizes.imageThumbSize,
                        height: TSizes.imageThumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: controller.uploadProgress.value > 0
                                ? controller.uploadProgress.value
                                : null,
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          // Pencil Icon to upload image
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image(
                      image: AssetImage(TImages.picImage), fit: BoxFit.fill),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
