import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/device/device_utility.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.leadingImage,
    this.actions,
    this.bottomBar,
    this.height,
    this.leadingOnPressed,
    this.increaseAppbarSpace = 0.0,
  });

  final Widget? title;
  final double? height;
  final bool showBackButton;
  final String? leadingImage;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final PreferredSizeWidget? bottomBar;
  final double increaseAppbarSpace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: title,
        leadingWidth: showBackButton ? 25 : null,
        centerTitle: false,
        actions: actions,
        bottom: bottomBar,
        leading: showBackButton
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Iconsax.arrow_left))
            : leadingImage != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(leadingImage!),
                  )
                : null,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + increaseAppbarSpace);
}
