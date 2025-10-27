class ChatMessage {
  final String content;
  final bool isSender;
  final bool isImage;
  final bool isAudio;

  ChatMessage({
    required this.content,
    this.isSender = false,
    this.isImage = false,
    this.isAudio = false,
  });
}
