import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class OrderSummaryDetail extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;

  const OrderSummaryDetail({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    double total = subtotal + deliveryFee;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.sm),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryRow('Subtotal', subtotal),
          const SizedBox(height: TSizes.sm),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          const Divider(thickness: 1.0),
          _buildSummaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16.0, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
