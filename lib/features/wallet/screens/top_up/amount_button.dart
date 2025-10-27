import 'package:flutter/material.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

import '../../../../utils/constants/sizes.dart';

class AmountButton extends StatelessWidget {
  const AmountButton({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = WalletController.instance;

    return SizedBox(
      height: 50, // Controls vertical height
      child: OutlinedButton(
        onPressed: () => controller.updateAmount(amount),
        style: OutlinedButton.styleFrom(
            backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
            side: const BorderSide(color: TColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
            padding: const EdgeInsets.symmetric(vertical: 0)),
        child: Text(
          'GHS $amount',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
