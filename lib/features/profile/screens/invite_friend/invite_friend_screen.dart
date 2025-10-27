import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:get/get.dart';

import '../../controller/invite_friend_controller.dart';
import 'widget/friend_item.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InviteFriendsController controller = Get.put(InviteFriendsController());

    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("Invite Friend"),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.friendsList.length,
          itemBuilder: (context, index) {
            return FriendItem(friend: controller.friendsList[index]);
          },
        ),
      ),
    );
  }
}
