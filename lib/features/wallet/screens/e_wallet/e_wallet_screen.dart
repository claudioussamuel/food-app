import 'package:flutter/material.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:foodu/features/wallet/screens/e_wallet/widget/balance_card.dart';
import 'package:foodu/features/wallet/screens/e_wallet/widget/transection_history_widget.dart';
import 'package:foodu/features/wallet/screens/transaction_history/transaction_history_screen.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

class EWalletScreen extends StatelessWidget {
  const EWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    Get.put(WalletController());
    return SafeArea(
      child: Scaffold(
        /// App Bar
        appBar: AppBar(
          title: Text('E-Wallet', style: Theme.of(context).textTheme.titleLarge),
          leading: Padding(
            padding: const EdgeInsets.only(left: TSizes.defaultSpace),
            child: Image.asset(TImages.appLogo),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TSizes.defaultSpace),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: TSizes.x),
                  ImageIcon(const AssetImage(TImages.more), color: isDark ? TColors.backgroundLight : TColors.backgroundDark),
                ],
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Add Card Image here or set the values
              const BalanceCard(),
              const SizedBox(height: TSizes.spaceBtwSection),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transaction History', style: Theme.of(context).textTheme.bodyLarge),
                  GestureDetector(
                    onTap: () => Get.to(const TransactionHistoryScreen()),
                    child: Text('See All', style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary)),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TransactionHistoryWidget()
            ],
          ),
        ),
      ),
    );
  }
}
