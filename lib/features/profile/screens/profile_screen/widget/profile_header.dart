import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
        const SizedBox(width: TSizes.spaceBtwItems),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: TSizes.xs),
            Text(
              phoneNumber,
              style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: TColors.textGrey,
                  ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Iconsax.edit,
            color: Colors.green,
          ),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
