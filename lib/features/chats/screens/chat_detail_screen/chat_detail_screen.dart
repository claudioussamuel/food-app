import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/chats/controller/chat_controller.dart';
import 'package:foodu/features/chats/screens/chat_detail_screen/widget/chat_bubble.dart';
import 'package:foodu/features/chats/screens/chat_detail_screen/widget/chat_input_field.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: const Text('Hassan Ali'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return ChatBubble(message: message);
                },
              );
            }),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}
