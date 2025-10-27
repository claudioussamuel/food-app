import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_text_field.dart';
import 'package:foodu/features/chats/controller/chat_controller.dart';
import 'package:foodu/features/chats/screens/chat_detail_screen/widget/attachment_option_widget.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class ChatInputField extends StatelessWidget {
  final chatController = ChatController.instance;

  final TextEditingController _controller = TextEditingController();

  ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TCustomTextField(
                  height: 40,
                  textEditingController: _controller,
                  prefixIcon: Icons.sentiment_satisfied,
                  prefixOnTap: () => _showAttachmentOptions(context),
                  hintText: "Type a message here",
                )),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    chatController.sendMessage(TImages.mixedSalad, isImage: true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      chatController.sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(13),
                  decoration: ShapeDecoration(
                    gradient: TColors.greenGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F1BAC4B),
                        blurRadius: 24,
                        offset: Offset(4, 8),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic,
                              size: 24,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (chatController.showAttachmentOptions.value)
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: AttachmentOptionsWidget(
                onOptionSelected: chatController.handleOptionSelected,
              ),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: AttachmentOptionsWidget(
            onOptionSelected: (String option) {
              chatController.handleOptionSelected(option);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
