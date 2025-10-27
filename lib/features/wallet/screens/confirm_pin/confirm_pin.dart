import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/custom_shapes/container/pin_field.dart';
import 'package:foodu/common/widgets/dialouge/custom_dialogue.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:get/get.dart';

import '../../../personalization/controller/pin_controller.dart';

class ConfirmPin extends StatelessWidget {
  const ConfirmPin({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PinController());
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text(TTexts.createNewPin),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: TSizes.imageThumbSize, left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: Column(children: [
          Text(
            textAlign: TextAlign.center,
            TTexts.confirmPinText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSection,
          ),
          const TPinField(),
          const SizedBox(
            height: TSizes.spaceBtwSection,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => Get.to(const TCustomDialog(
                      title: "Top Up Successful", subtitle: "You have successfully top up e-wallet for \$50", emoji: Icons.wallet)),
                  child: const Text(TTexts.continueB)))
        ]),
      ),
    );
  }
}
