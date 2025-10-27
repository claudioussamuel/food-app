import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:foodu/features/wallet/screens/payment_method/payment_method_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

import 'amount_button.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalletController.instance;

    return Scaffold(
      appBar: const TAppBar(showBackButton: true, title: Text("Top Up E-Wallet")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the amount to top up',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            /// Selected Amount
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColors.backgroundLight,
                border: Border.all(color: TColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Text(
                  'GHS ${controller.selectedAmount}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: TColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                // Three buttons in each row
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                // Controls the button's width-to-height ratio
                children: const [
                  AmountButton(amount: 10),
                  AmountButton(amount: 20),
                  AmountButton(amount: 50),
                  AmountButton(amount: 100),
                  AmountButton(amount: 200),
                  AmountButton(amount: 250),
                  AmountButton(amount: 500),
                  AmountButton(amount: 750),
                  AmountButton(amount: 1000),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Get.to(PaymentMethodScreen()), child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
