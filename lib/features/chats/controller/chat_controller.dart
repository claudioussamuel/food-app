import 'package:foodu/features/chats/model/chat_message_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  var tabs = ['Chats', 'Calls'].obs;

  var messages = <ChatMessage>[].obs;

  void sendMessage(String text, {bool isImage = false, bool isAudio = false}) {
    final newMessage = ChatMessage(
      content: text,
      isSender: true,
      isImage: isImage,
      isAudio: isAudio,
    );
    messages.add(newMessage);
  }

  void receiveMessage(String text, {bool isImage = false, bool isAudio = false}) {
    final newMessage = ChatMessage(
      content: text,
      isSender: false,
      isImage: isImage,
      isAudio: isAudio,
    );
    messages.add(newMessage);
  }

  var showAttachmentOptions = false.obs;

  void toggleAttachmentOptions() {
    showAttachmentOptions.value = !showAttachmentOptions.value;
  }

  void handleOptionSelected(String option) {
    showAttachmentOptions.value = false;
    Get.snackbar('Option Selected', 'You selected: $option');
  }
}
