import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/container/custom_divider.dart';
import '../../../../../utils/exports.dart';
import '../../../../profile/screens/payment/payment_method_screen.dart';
import '../../discount/discount_screen.dart';
import 'option_tile.dart';

class PaymentsAndDiscounts extends StatelessWidget {
  const PaymentsAndDiscounts({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: TSizes.xm,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: ShapeDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        shadows: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.lg)),
      ),
      child: Column(
        children: [
          OptionTile(icon: Icons.account_balance_wallet_outlined, title: 'Payment Methods', onTap: () => Get.to(const PaymentMethodScreen())),
          const TCustomDivider(),
          OptionTile(icon: Icons.local_offer_outlined, title: 'Get Discounts', onTap: () => Get.to(DiscountScreen())),
        ],
      ),
    );
  }
}
