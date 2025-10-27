import 'package:flutter/material.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:get/get.dart';

class PaymentMethodItem extends StatelessWidget {
  final int index;
  final String label;
  final String image;
  final String? cardNumber;

  const PaymentMethodItem({
    super.key,
    required this.index,
    required this.label,
    required this.image,
    this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WalletController.instance;
    return Obx(() => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            onTap: () => controller.selectMethod(index),
            leading: Image.asset(
              image,
              height: 40,
            ),
            title: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
            ),
            subtitle: cardNumber != null ? Text(cardNumber!) : null,
            trailing: Icon(
              Icons.radio_button_checked,
              color: controller.selectedMethod.value == index ? Colors.green : Colors.grey,
            ),
          ),
        ));
  }
}
