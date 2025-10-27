import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/button/profile_toggle_item.dart';

import '../../../../utils/constants/sizes.dart';
import '../profile_screen/widget/profile_list_item.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: Text("Security", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            ProfileToggleItem(title: "Remember me", value: true, onChanged: (value) {}),
            ProfileToggleItem(title: "Face Id", value: true, onChanged: (value) {}),
            ProfileToggleItem(title: "Biometric", value: true, onChanged: (value) {}),
            ProfileListItem(title: 'Google Authenticator', onTap: () {}),
            const SizedBox(height: TSizes.spaceBtwSection),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: const Text("Change Pin"))),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: const Text("Change Password"))),
          ],
        ),
      ),
    );
  }
}
