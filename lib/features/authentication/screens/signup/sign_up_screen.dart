import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../common/widgets/login_signup/footer.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../utils/exports.dart';
import '../login/login_screen.dart';
import 'widget/sign_up_form.dart';
import 'widget/signup_social_buttons.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const TAppBar(showBackButton: true),
        body: SingleChildScrollView(
          padding: TSpacingStyles.paddingWithHeightWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// Header
              Column(
                children: [
                  const Center(child: Image(image: AssetImage(TImages.appLogo), width: 120, height: 120)),
                  const SizedBox(height: TSizes.spaceBtwSection),
                  Text(TTexts.createNewAccount, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                ],
              ),

              /// Form
              const TSignUpForm(),

              /// Divider
              const TFormDivider(text: "or ${TTexts.continueWith}"),

              //Social Button
              const TSignUpSocialRowButton(),

              TFooter(
                buttonText: TTexts.signIN,
                text: TTexts.alreadyHaveAccount,
                onPressed: () => Get.to(const LoginScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
