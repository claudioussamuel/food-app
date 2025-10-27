import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/sizes.dart';

class TFooter extends StatelessWidget {
  const TFooter({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonText,
  });

  final String text;
  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(width: TSizes.sm),
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText, style: Theme.of(context).textTheme.labelLarge),
          )
        ],
      ),
    );
  }
}
