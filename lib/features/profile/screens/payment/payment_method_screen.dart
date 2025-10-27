import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../wallet/screens/payment_method/widget/payment_method_item.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Payment Method"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: TSizes.spaceBtwItems,
            children: [
              const PaymentMethodItem(
                index: 0,
                label: 'PayPal',
                image: TImages.paypal,
              ),
              const PaymentMethodItem(
                index: 1,
                label: 'Google Pay',
                image: TImages.google,
              ),
              PaymentMethodItem(
                index: 2,
                label: 'Apple Pay',
                image: isDark ? TImages.lightAppleLogo : TImages.apple,
              ),
              const PaymentMethodItem(
                index: 3,
                label: 'Mastercard',
                image: TImages.masterCard,
                cardNumber: '**** **** **** 4679',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: ElevatedButton(onPressed: () {}, child: const Text("Add new card")),
      // ),
    );
  }
}
