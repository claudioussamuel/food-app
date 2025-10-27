import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../../personalization/screens/profile_form/profile_form_screen.dart';
import '../../controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OtpController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startTimer();
    });
    return SafeArea(
      child: Scaffold(
        appBar: const TAppBar(showBackButton: true),
        body: Padding(
          padding: TSpacingStyles.paddingWithHeightWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Title
                Text(TTexts.enter4digitOTPCode.tr, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),

                const SizedBox(height: TSizes.spaceBtwItems),

                /// Subtitle123456
                Text(
                  TTexts.codeSendTo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: TSizes.spaceBtwSection * 2),

                /// OTP Text Field
                OTPTextField(
                  length: 4,
                  fieldWidth: 70,
                  outlineBorderRadius: TSizes.borderRadiusLg,
                  onCompleted: (String verificationCode) {},
                  onChanged: (String code) {},
                  fieldStyle: FieldStyle.box,
                  width: MediaQuery.of(context).size.width,
                  style: Theme.of(context).textTheme.headlineMedium!.apply(fontSizeDelta: 12),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  otpFieldStyle: OtpFieldStyle(
                    borderColor: TColors.primary,
                    focusBorderColor: dark ? TColors.darkCard : TColors.primary,
                    backgroundColor: dark ? TColors.darkCard : TColors.otpTextFieldFillColor,
                    enabledBorderColor: dark ? TColors.darkCard : TColors.otpTextFieldFillColor,
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSection * 2),

                /// Otp text box and time
                // const TextFieldAndTime(),

                /// Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => Get.to(const ProfileFormScreen()), child: const Text(TTexts.verify)),
                ),

                const SizedBox(height: TSizes.spaceBtwSection * 2),

                /// Footer Text
                Center(child: Text(TTexts.otpFooter.tr, style: Theme.of(context).textTheme.titleSmall)),

                /// Footer text with Button
                Center(
                  child: Obx(
                    () => RichText(
                      text: TextSpan(
                        text: TTexts.thenLets.tr,
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(
                            text: TTexts.resendOTP.tr,
                            recognizer: (controller.secondsRemaining.value > 0) ? null : TapGestureRecognizer()
                              ?..onTap = () {},
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: (controller.secondsRemaining.value > 0) ? TColors.darkGrey : TColors.primary),
                          ),
                          if (controller.secondsRemaining.value > 0)
                            TextSpan(
                              text: " in ${controller.secondsRemaining.value}",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: TColors.darkGrey),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
