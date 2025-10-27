import 'package:flutter/material.dart';

import 'contect_option.dart';

class ContactOptionsWidget extends StatelessWidget {
  const ContactOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ContactOption(
            icon: Icons.headset_mic,
            title: 'Customer Service',
            onTap: () {},
          ),
          ContactOption(
            icon: Icons.whatshot,
            title: 'WhatsApp',
            onTap: () {},
          ),
          ContactOption(
            icon: Icons.language,
            title: 'Website',
            onTap: () {},
          ),
          ContactOption(
            icon: Icons.facebook,
            title: 'Facebook',
            onTap: () {},
          ),
          ContactOption(
            icon: Icons.telegram,
            title: 'Twitter',
            onTap: () {},
          ),
          ContactOption(
            icon: Icons.camera_alt,
            title: 'Instagram',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
