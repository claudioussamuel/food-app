import 'package:flutter/material.dart';
import 'package:foodu/features/chats/model/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;
    // final alignment = isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final backgroundColor = isSender ? Colors.green : Colors.grey.shade200;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: message.isImage ? Colors.white : backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: message.isImage
            ? Image.asset(message.content)
            : message.isAudio
                ? const Row(
                    children: [
                      Icon(Icons.play_arrow),
                      Text("Voice Message"),
                    ],
                  )
                : Text(
                    message.content,
                    style: TextStyle(color: isSender ? Colors.white : Colors.black),
                  ),
      ),
    );
  }
}
