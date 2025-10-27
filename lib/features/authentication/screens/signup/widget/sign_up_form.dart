import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../utils/popups/loaders.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    // Reactive boolean for "showPassword"
    final showPassword = true.obs;

    final controller = AuthenticationRepository.instance;

    /// Form
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(top: TSizes.spaceBtwSection),
        child: Column(
          children: [
            /// Phone Number
            // const TPhoneNumberField(),
            //    const SizedBox(height: TSizes.sm),

            /// Email
            SizedBox(
              height: TSizes.textFieldHeight,
              child: TextFormField(
                cursorHeight: TSizes.lg,
                cursorColor: TColors.primary,
                textAlignVertical: TextAlignVertical.bottom,
                style: Theme.of(context).textTheme.bodySmall,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: TTexts.email,
                  prefixIcon: const Icon(Icons.email),
                  hintStyle: Theme.of(context).textTheme.titleSmall,
                  fillColor:
                      isDark ? TColors.darkCard : TColors.textFieldFillColor,
                ),
              ),
            ),
            const SizedBox(height: TSizes.sm),

            /// Full Name
            Obx(() {
              return SizedBox(
                height: TSizes.textFieldHeight,
                child: TextFormField(
                  controller: passwordController,
                  cursorHeight: TSizes.lg,
                  cursorColor: TColors.primary,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: Theme.of(context).textTheme.bodySmall,
                  obscureText: showPassword.value,
                  decoration: InputDecoration(
                    hintText: TTexts.password,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: TColors.primary,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => showPassword.value = !showPassword.value,
                      icon: Icon(
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: TColors.primary,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.titleSmall,
                    fillColor:
                        isDark ? TColors.darkCard : TColors.textFieldFillColor,
                  ),
                ),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSection),

            /// Sign up button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    TLoaders.customToast(message: TTexts.signingUp);
                    controller.registerWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  // () => Get.to(const OtpScreen()),
                  child: const Text(TTexts.signUp)),
            ),
          ],
        ),
      ),
    );
  }
}
