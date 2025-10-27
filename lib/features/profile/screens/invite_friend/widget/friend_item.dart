import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controller/invite_friend_controller.dart';
import '../../../model/invite_friend.dart';

class FriendItem extends StatelessWidget {
  final Friend friend;

  const FriendItem({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend.imageUrl),
          ),
          title: Text(friend.name, style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2)),
          subtitle: Text(friend.phoneNumber, style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.grey)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              foregroundColor: friend.isInvited.value ? Colors.green : Colors.white,
              backgroundColor: friend.isInvited.value ? Colors.white : Colors.green,
            ),
            child: Text(friend.isInvited.value ? 'Invited' : 'Invite'),
            onPressed: () {
              Get.find<InviteFriendsController>().toggleInvite(friend);
            },
          ),
        ));
  }
}
