import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:gap/gap.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Gap(50),
        SizedBox(
            width: double.infinity,
            child: Image.asset(
              TImages.searchNotFound, // Using the same image as search not found
              fit: BoxFit.cover,
            )),
        const Gap(20),
        Text('Your Cart is Empty', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const Gap(20),
        Text('Looks like you haven\'t added any items to your cart yet. Start browsing and add your favorite foods!',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
