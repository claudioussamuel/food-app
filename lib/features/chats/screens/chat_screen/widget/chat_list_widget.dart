import 'package:flutter/material.dart';
import 'package:foodu/features/chats/model/chat_item_model.dart';
import 'package:foodu/features/chats/screens/chat_detail_screen/chat_detail_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';

class ChatListWidget extends StatelessWidget {
  final List<ChatItem> chatItems;

  const ChatListWidget({super.key, required this.chatItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatItems.length,
      itemBuilder: (context, index) {
        final chatItem = chatItems[index];
        return InkWell(
          onTap: () => Get.to(const ChatDetailScreen()),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.md),
            child: Row(
              children: [
                CircleAvatar(radius: TSizes.lg, backgroundImage: AssetImage(chatItem.avatarUrl)),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name od the user
                      Text(chatItem.name, style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2)),
                      const SizedBox(height: TSizes.xs),

                      /// Last Message send or received
                      Text(chatItem.lastMessage,
                          style: Theme.of(context).textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (chatItem.unreadCount > 0)

                      /// Unread Messages Count
                      Container(
                        margin: const EdgeInsets.only(top: TSizes.sm),
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: const BoxDecoration(color: TColors.primary, shape: BoxShape.circle),
                        child: Text(chatItem.unreadCount.toString(),
                            style: Theme.of(context).textTheme.labelSmall!.apply(color: Colors.white)),
                      ),

                    /// Time
                    Text(chatItem.time, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
