import 'package:flutter/material.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class ProfileListItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final String? trailingText;

  const ProfileListItem({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: icon != null ? Icon(icon, color: isDark ? Colors.white : Colors.black) : null,
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: trailingText != null
          ? Text(trailingText!, style: Theme.of(context).textTheme.bodySmall)
          : Icon(Icons.chevron_right, color: isDark ? Colors.white : Colors.black),
      onTap: onTap,
    );
  }
}
