import 'package:flutter/material.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:get/get.dart';

class CancellationReasonWidget extends StatelessWidget {
  const CancellationReasonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Please select the reason for cancellation:",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          // List of reasons
          Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.reasons.length,
                itemBuilder: (context, index) {
                  final reason = controller.reasons[index];
                  return ListTile(
                    title: Text(reason,
                        style: Theme.of(context).textTheme.bodySmall),
                    leading: Radio<String>(
                      value: reason,
                      groupValue: controller.selectedReason.value,
                      onChanged: (value) {
                        controller.selectReason(value!);
                      },
                      activeColor: Colors.green,
                    ),
                  );
                },
              )),

          if (controller.selectedReason.value == "Others")
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Others reason...",
                ),
                onChanged: (value) {
                  // Handle the input for the "Others" reason
                  controller.setCustomReason(value);
                },
              ),
            ),
        ],
      ),
    );
  }
}
