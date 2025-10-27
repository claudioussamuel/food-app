import 'package:flutter/material.dart';
import 'package:foodu/features/navigation_menu/navigation_menu.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_function.dart';

class CreateNewPin extends StatelessWidget {
  const CreateNewPin({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppBar(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Column(
          children: [
            /// Title
            Text(TTexts.enter4digitPINCode.tr,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
                textAlign: TextAlign.center,
                TTexts.pinText,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: TSizes.spaceBtwSection),
            // const TPinField(),
            /// Pin Text Field
            OTPTextField(
              length: 4,
              fieldWidth: 70,
              outlineBorderRadius: TSizes.borderRadiusLg,
              onCompleted: (String verificationCode) {},
              onChanged: (String code) {},
              fieldStyle: FieldStyle.box,
              width: MediaQuery.of(context).size.width,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(fontSizeDelta: 12),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              otpFieldStyle: OtpFieldStyle(
                borderColor: TColors.primary,
                focusBorderColor: dark ? TColors.darkCard : TColors.primary,
                backgroundColor:
                    dark ? TColors.darkCard : TColors.otpTextFieldFillColor,
                enabledBorderColor:
                    dark ? TColors.darkCard : TColors.otpTextFieldFillColor,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSection),

            // Continue Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(const NavigationMenu()),
                    child: const Text(TTexts.continueB)))
          ],
        ),
      ),
    );
  }
}
