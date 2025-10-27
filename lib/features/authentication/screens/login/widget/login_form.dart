import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../utils/exports.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = AuthenticationRepository.instance;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isDark = THelperFunctions.isDarkMode(context);
    // Reactive boolean for "Remember me"
    final rememberMe = true.obs;
    final showPassword = true.obs;
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSection),
        child: Column(
          children: [
            /// OTP Field
            // const TPhoneNumberField(),
            // const SizedBox(height: TSizes.sm),

            const SizedBox(height: TSizes.sm),

            /// Email
            SizedBox(
              height: TSizes.textFieldHeight,
              child: TextFormField(
                controller: emailController,
                cursorHeight: TSizes.lg,
                cursorColor: TColors.primary,
                textAlignVertical: TextAlignVertical.bottom,
                style: Theme.of(context).textTheme.bodySmall,
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

            /// Remember Me + Forgot Password Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me Checkbox + Label
                Obx(() {
                  return Row(
                    children: [
                      Checkbox(
                        value: rememberMe.value,
                        onChanged: (val) {
                          // Toggle the reactive boolean
                          rememberMe.value = val ?? false;
                        },
                      ),
                      Text(
                        TTexts.rememberMe,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }),

                /// Forgot Password Button
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to “Forgot Password” screen or show a dialog
                  },
                  child: Text(
                    TTexts.forgotPassword,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                        color: TColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),

            /// Sign in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    TLoaders.customToast(message: TTexts.loggingIn);
                    controller.loginWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                  // () => Get.to(const OtpScreen()),
                  child: const Text(TTexts.signIN)),
            ),
          ],
        ),
      ),
    );
  }
}
