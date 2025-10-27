import 'package:flutter/material.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

class EmojiListWidget extends StatelessWidget {
  final List<String> emojiList;
  final double emojiSize;
  final double borderRadius;
  final double borderWidth;
  final controller = OrderController.instance;

  EmojiListWidget({
    super.key,
    required this.emojiList,
    this.emojiSize = 50.0,
    this.borderRadius = 16.0,
    this.borderWidth = 2.0,
  }) {
    // Initialize the controller with the emoji list
    controller.initializeEmojiList(emojiList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 45.0,
        runSpacing: 20.0,
        children: List.generate(emojiList.length, (index) {
          return Obx(() => GestureDetector(
                onTap: () => controller.toggleBorder(index),
                child: Container(
                  width: emojiSize,
                  height: emojiSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: controller.emojiBorderStates[index] ? Border.all(color: TColors.primary, width: borderWidth) : null,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Center(
                    child: Text(
                      emojiList[index],
                      style: TextStyle(
                        fontSize: emojiSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
