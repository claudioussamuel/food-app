import 'package:flutter/material.dart';
import 'package:foodu/features/chats/controller/chat_controller.dart';
import 'package:foodu/features/chats/model/chat_item_model.dart';
import 'package:foodu/features/chats/screens/chat_screen/widget/chat_list_widget.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          /// Appbar Title
          title: Text('Messages', style: Theme.of(context).textTheme.titleLarge),
          leading: Padding(
            padding: const EdgeInsets.only(left: TSizes.defaultSpace),
            child: Image.asset(TImages.appLogo),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),

              /// Tab Bar
              child: TabBar(
                tabAlignment: TabAlignment.fill,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                isScrollable: false,
                labelStyle: const TextStyle(fontSize: 17),
                tabs: controller.tabs.map((tabName) {
                  return Tab(text: tabName);
                }).toList(),
              ),
            ),
          ),
        ),
        body: ChatListWidget(
          /// Send List of models to Chat Widget
          chatItems: [
            ChatItem(
              avatarUrl: TImages.pic,
              name: 'Rayford Chenail',
              lastMessage: 'Great! I will arrive soon...',
              time: '16:01',
              unreadCount: 2,
            ),
            ChatItem(
              avatarUrl: TImages.pic,
              name: 'Natasya Wilodra',
              lastMessage: 'My order hasn\'t arrived yet 😟',
              time: '14:45',
              unreadCount: 3,
            ),
          ],
        ),
      ),
    );
  }
}
