import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/footer.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/header.dart';
import '../../../../utils/exports.dart';
import '../login/login_screen.dart';
import '../signup/sign_up_screen.dart';
import 'widget/social_button_with_icon.dart';

class LetYouInScreen extends StatelessWidget {
  const LetYouInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: TSpacingStyles.paddingWithAppbarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Header
                THeader(
                  width: 237,
                  height: 200,
                  text: TTexts.letYouIn,
                  image: isDark ? TImages.darkLetYouIn : TImages.letYouIn,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Social Buttons
                const SocialButtonsWithIcon(),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Divider
                const TFormDivider(text: 'or'),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Login Screen Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      child: const Text(TTexts.signInWithEmail)),
                ),

                /// Signup Screen Button
                TFooter(
                    text: TTexts.alreadyHaveAccount,
                    onPressed: () => Get.to(const SignUpScreen()),
                    buttonText: TTexts.signUp)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
