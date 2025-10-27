import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/login_signup/social_icon.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';

import '../../../../../data/repositories/authentication/authentication_repository.dart';

class TSignUpSocialRowButton extends StatelessWidget {
  const TSignUpSocialRowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = AuthenticationRepository.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //TSocialIcon(
        //   image: TImages.facebook,
        //   onTap: () => TLoaders.warningSnackBar(title: "Not Implemented", message: "Please add Facebook login backend here")),
        const SizedBox(width: TSizes.defaultSpace),
        TSocialIcon(
          image: TImages.google,
          onTap: () {
            controller.signInWithGoogle();
          },
        ),
        //  () => TLoaders.warningSnackBar(
        //     title: "Not Implemented",
        //     message: "Please add Google login backend here")),
        const SizedBox(width: TSizes.defaultSpace),
        //TSocialIcon(
        //    image: isDark ? TImages.lightAppleLogo : TImages.apple,
        //    onTap: () => TLoaders.warningSnackBar(title: "Not Implemented", message: "Please add Apple login backend here")),
      ],
    );
  }
}
