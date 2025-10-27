import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/button/profile_toggle_item.dart';

import '../../../../utils/constants/sizes.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  // State variables for each toggle
  bool _generalNotification = true;
  bool _sound = false;
  bool _vibrate = true;
  bool _specialOffer = true;
  bool _promoAndDiscount = false;
  bool _payments = true;
  bool _cashBack = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: Text(
          "Notification",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: [
            ProfileToggleItem(
              title: "General Notification",
              value: _generalNotification,
              onChanged: (value) {
                setState(() => _generalNotification = value);
              },
            ),
            ProfileToggleItem(
              title: "Sound",
              value: _sound,
              onChanged: (value) {
                setState(() => _sound = value);
              },
            ),
            ProfileToggleItem(
              title: "Vibrate",
              value: _vibrate,
              onChanged: (value) {
                setState(() => _vibrate = value);
              },
            ),
            ProfileToggleItem(
              title: "Special offer",
              value: _specialOffer,
              onChanged: (value) {
                setState(() => _specialOffer = value);
              },
            ),
            ProfileToggleItem(
              title: "Promo and Discount",
              value: _promoAndDiscount,
              onChanged: (value) {
                setState(() => _promoAndDiscount = value);
              },
            ),
            ProfileToggleItem(
              title: "Payments",
              value: _payments,
              onChanged: (value) {
                setState(() => _payments = value);
              },
            ),
            ProfileToggleItem(
              title: "Cash Back",
              value: _cashBack,
              onChanged: (value) {
                setState(() => _cashBack = value);
              },
            ),
            ProfileToggleItem(
              title: "App Updates",
              value: _appUpdates,
              onChanged: (value) {
                setState(() => _appUpdates = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
