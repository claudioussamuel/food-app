import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:gap/gap.dart';

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: TColors.primary,
          ),
          const Gap(16),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodySmall),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: TColors.primary,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}
