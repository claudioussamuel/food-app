import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class ActionIcon extends StatelessWidget {
  const ActionIcon({
    super.key,
    required this.iconData,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData iconData;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: TColors.borderGrey),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Stack(
        children: [
          IconButton(onPressed: onTap, icon: Icon(iconData)),
          if (badgeCount > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
