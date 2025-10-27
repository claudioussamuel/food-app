import 'package:flutter/material.dart';

import '../../../../../utils/exports.dart';
import '../../../controller/otp_controller.dart';

class TextFieldAndTime extends StatelessWidget {
  const TextFieldAndTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = OtpController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.textFieldHeight),
      child: Column(
        children: [
          Text(
            TTexts.codeSendTo,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: TSizes.textFieldHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: TSizes.textFieldHeight,
                width: TSizes.textFieldHeight,
                child: Center(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: TColors.primary,
                    focusNode: controller.focusNode1,
                    cursorHeight: TSizes.lg,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
                    ),
                    onChanged: (value) {
                      controller.moveToNextField(value, controller.focusNode1, controller.focusNode2);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: TSizes.textFieldHeight,
                width: TSizes.textFieldHeight,
                child: Center(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: TColors.primary,
                    cursorHeight: TSizes.lg,
                    focusNode: controller.focusNode2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
                    ),
                    onChanged: (value) {
                      controller.moveToNextField(value, controller.focusNode2, controller.focusNode3);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: TSizes.textFieldHeight,
                width: TSizes.textFieldHeight,
                child: Center(
                  child: TextFormField(
                    cursorColor: TColors.primary,
                    cursorHeight: TSizes.lg,
                    focusNode: controller.focusNode3,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
                    ),
                    onChanged: (value) {
                      controller.moveToNextField(value, controller.focusNode3, controller.focusNode4);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: TSizes.textFieldHeight,
                width: TSizes.textFieldHeight,
                child: Center(
                  child: TextFormField(
                    cursorColor: TColors.primary,
                    cursorHeight: TSizes.lg,
                    focusNode: controller.focusNode4,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
                    ),
                    onChanged: (value) {
                      controller.focusNode4.unfocus();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.textFieldHeight,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Resend code in ', style: Theme.of(context).textTheme.titleSmall),
                TextSpan(text: '55', style: Theme.of(context).textTheme.bodySmall),
                TextSpan(text: ' s', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
