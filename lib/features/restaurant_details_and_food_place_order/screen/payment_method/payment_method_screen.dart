import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../controller/paymeny_method_controller.dart';
import 'widget/payment_method_card.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodController());
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: Text(
          "Payment Method",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: Obx(() => Column(
              children: [
                SizedBox(
                  height: THelperFunctions.screenHeight() / 1.4,
                  child: ListView.builder(
                    itemCount: controller.paymentMethods.length,
                    itemBuilder: (context, index) {
                      var paymentMethod = controller.paymentMethods[index];
                      return PaymentMethodCard(
                        title: paymentMethod['title'],
                        balance: paymentMethod['balance'],
                        icon: paymentMethod['icon'],
                        isSelected: controller.selectedPaymentIndex.value == index,
                        onTap: () => controller.selectPaymentMethod(index),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.addPaymentMethod(
                        'New Card',
                        Icons.credit_card,
                        balance: '**** **** **** 4679',
                      );
                    },
                    child: const Text(
                      'Add new Payment',
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Apply',
          ),
        ),
      ),
    );
  }
}
