import 'package:flutter/material.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:foodu/features/wallet/screens/top_up/top_up_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalletController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.userName.value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(controller.cardNumber.value, style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.backgroundLight)),
              const Spacer(),
              Row(
                children: [
                  Image.asset(TImages.visa, width: 50),
                  Image.asset(TImages.masterCard, width: 50),
                ],
              )
            ],
          ),
          const SizedBox(height: 14),
          Text("Your balance", style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.backgroundLight)),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              children: [
                Text("\$${controller.balance.value.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.headlineLarge!.apply(color: TColors.backgroundLight)),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.white),
                  onPressed: () => Get.to(const TopUpScreen()),
                  child: Text("Top Up", style: Theme.of(context).textTheme.bodySmall?.apply(color: isDark ? Colors.black : Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
