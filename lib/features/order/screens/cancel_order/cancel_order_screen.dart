import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/dialouge/custom_dialogue.dart';
import 'package:foodu/features/order/screens/cancel_order/widget/cancellation_reason_widget.dart';
import 'package:get/get.dart';
import 'package:foodu/features/order/controller/order_controller.dart';

class CancelOrderScreen extends StatelessWidget {
  final String orderId;

  const CancelOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Cancel Order"),
      ),
      body: const Column(
        children: [
          CancellationReasonWidget(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
            onPressed: () async {
              await OrderController.instance.submitOrderCancellation(orderId);
              // Switch to Cancelled tab to show the cancelled order
              OrderController.instance.switchToCancelledTab();
              Get.to(const TCustomDialog(
                title: "We're so sad about\nyour cancellation",
                subtitle:
                    "We will continue to improve our service & satisfy you on the next order.",
                emoji: Icons.sentiment_dissatisfied,
              ));
            },
            child: const Text("Submit")),
      ),
    );
  }
}
