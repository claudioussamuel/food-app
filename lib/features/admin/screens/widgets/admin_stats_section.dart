import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';

class AdminStatsSection extends StatelessWidget {
  const AdminStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orders stream drives stats
        StreamBuilder<List<OrderModel>>(
          stream: OrderRepository().orders(limited: false),
          builder: (context, ordersSnap) {
            // Gracefully handle loading/empty/error by rendering zeroed UI instead of nothing
            final orders = ordersSnap.data ?? <OrderModel>[];

            // Current month orders
            final now = DateTime.now();
            final monthOrders = orders
                .where(
                  (o) =>
                      DateTime(o.startTime.year, o.startTime.month) ==
                      DateTime(now.year, now.month),
                )
                .toList();

            // Monthly earnings
            double totalMonthEarning = 0;
            for (final order in monthOrders) {
              for (final p in order.products) {
                totalMonthEarning += (p.price * p.cartQuantity);
              }
            }

            return StreamBuilder<List<FoodModel>>(
              stream: ProductRepository().products(),
              builder: (context, productsSnap) {
                final productsCount = productsSnap.data?.length ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top stats cards (stacked as a column per UI design)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _StatTile(
                          color: TColors.primary,
                          icon: Icons.shopping_bag,
                          title: 'Monthly Earning',
                          value: totalMonthEarning.toStringAsFixed(2),
                          subtitle: 'Local time (in GHS).',
                        ),
                        const SizedBox(height: TSizes.sm),
                        _StatTile(
                          color: TColors.success,
                          icon: Icons.delivery_dining,
                          title: 'Orders',
                          value: monthOrders.length.toString(),
                        ),
                        const SizedBox(height: TSizes.sm),
                        _StatTile(
                          color: TColors.warning,
                          icon: Icons.qr_code,
                          title: 'Products',
                          value: productsCount.toString(),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwSection),
                    // Simple monthly summary card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Summary',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: TSizes.md),
                            Text(
                              'Total Orders: ${monthOrders.length}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: TSizes.sm),
                            Text(
                              'Total Earnings: GHS ${totalMonthEarning.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: TSizes.sm),
                            Text(
                              'Products Available: $productsCount',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSection),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;

  const _StatTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
      tileColor: Theme.of(context).cardColor,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.25),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
