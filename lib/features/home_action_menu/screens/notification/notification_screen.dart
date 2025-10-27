import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/home_action_menu/controller/notification_controller.dart';
import 'package:foodu/features/home_action_menu/screens/notification/widget/notification_card.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text('Notifications', style: Theme.of(context).textTheme.headlineSmall),
          showBackButton: true,
        ),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ListView.separated(
              itemCount: controller.notificationList.length,
              itemBuilder: (context, index) {
                final notification = controller.notificationList[index];
                return NotificationCard(
                  title: notification.title,
                  date: notification.date,
                  time: notification.time,
                  description: notification.description,
                  status: notification.status,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: TSizes.spaceBtwItems);
              },
            ),
          ),
        ),
      ),
    );
  }
}
