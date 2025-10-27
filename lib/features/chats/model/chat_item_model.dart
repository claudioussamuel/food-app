class ChatItem {
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  ChatItem({
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });
}
