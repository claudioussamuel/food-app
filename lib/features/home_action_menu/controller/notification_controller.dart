import 'package:foodu/features/home_action_menu/model/notifcation_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  var notificationList = <NotificationModel>[
    NotificationModel(
      title: 'Orders Successful!',
      date: '19 Dec, 2022',
      time: '20:49 PM',
      description: 'You have placed an order at Burger Hut and paid \$24. Your food will arrive soon. Enjoy our services 😊',
      status: 'New',
    ),
    NotificationModel(
      title: 'Orders Cancelled!',
      date: '19 Dec, 2022',
      time: '20:49 PM',
      description:
          'You have canceled an order at Burger Hut. We apologize for your inconvenience. We will try to improve our service next time 🥲',
      status: 'New',
    ),
    NotificationModel(
      title: 'New Services Available!',
      date: '19 Dec, 2022',
      time: '20:49 PM',
      description: 'You can now make multiple food orders at one time. You can also cancel your orders.',
      status: 'New',
    ),
    NotificationModel(
      title: 'Credit Card Connected!',
      date: '19 Dec, 2022',
      time: '20:49 PM',
      description: 'Your credit card has been successfully linked with Foodu. Enjoy our services.',
      status: 'New',
    ),
    NotificationModel(
      title: 'Account Setup Successful!',
      date: '19 Dec, 2022',
      time: '20:49 PM',
      description: 'Your account creation is successful, you can now experience our services.',
      status: 'New',
    ),
  ].obs;
}
