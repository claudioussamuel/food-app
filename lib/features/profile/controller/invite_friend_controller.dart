import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

import '../model/invite_friend.dart';

class InviteFriendsController extends GetxController {
  var friendsList = <Friend>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  void loadFriends() {
    friendsList.addAll([
      Friend(name: 'Lauralee Quintero', phoneNumber: '+1-300-555-0135', imageUrl: TImages.pic),
      Friend(name: 'Annabel Rohan', phoneNumber: '+1-202-555-0136', imageUrl: TImages.pic),
      Friend(name: 'Alfonzo Schuessler', phoneNumber: '+1-300-555-0119', imageUrl: TImages.pic),
      // Add more friends as per your data
    ]);
  }

  void toggleInvite(Friend friend) {
    friend.isInvited.value = !friend.isInvited.value;
  }
}
