import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';

class OrderStatusScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderStatusScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final orderNumber = order['orderNumber'] ?? order['formattedOrderNumber'] ?? 'N/A';
    final status = _getOrderStatus();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order $orderNumber'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Number Card
              _buildOrderNumberCard(context, isDark, orderNumber),
              
              const Gap(TSizes.spaceBtwSection),
              
              // Status Progress
              Text(
                'Order Status',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(TSizes.spaceBtwItems),
              
              _buildStatusTimeline(context, isDark, status),
              
              const Gap(TSizes.spaceBtwSection),
              
              // Order Details
              Text(
                'Order Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(TSizes.spaceBtwItems),
              
              _buildOrderDetailsCard(context, isDark),
              
              const Gap(TSizes.spaceBtwSection),
              
              // Delivery Information
              if (order['location'] != null && order['location'] != 'Pickup')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(TSizes.spaceBtwItems),
                    _buildDeliveryCard(context, isDark),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderNumberCard(BuildContext context, bool isDark, String orderNumber) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Number',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const Gap(4),
              Text(
                orderNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, bool isDark, String currentStatus) {
    // Determine which steps are completed based on current status
    final isPending = true; // Order always starts as pending
    final isPreparing = ['preparing', 'ready', 'picked up', 'transit', 'completed', 'delivered'].contains(currentStatus);
    final isReady = ['ready', 'picked up', 'transit', 'completed', 'delivered'].contains(currentStatus);
    final isPickedUp = ['picked up', 'transit', 'completed', 'delivered'].contains(currentStatus);
    final isTransit = ['transit', 'completed', 'delivered'].contains(currentStatus);
    final isDelivered = ['completed', 'delivered'].contains(currentStatus);
    
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.grey[100],
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Column(
        children: [
          _buildProgressStep(
            'Order Placed',
            'Your order has been placed',
            isPending,
            true,
          ),
          _buildProgressStep(
            'Preparing',
            isPreparing ? 'Your order is being prepared' : 'Waiting for restaurant to accept',
            isPreparing,
            true,
          ),
          _buildProgressStep(
            'Ready for Pickup',
            isReady ? 'Your order is ready' : 'Order is being prepared',
            isReady,
            true,
          ),
          _buildProgressStep(
            'Picked Up',
            isPickedUp ? 'Dispatcher has collected your order' : 'Waiting for pickup',
            isPickedUp,
            true,
          ),
          _buildProgressStep(
            'In Transit',
            isTransit ? 'Your order is on the way' : 'Waiting for dispatch',
            isTransit,
            true,
          ),
          _buildProgressStep(
            'Delivered',
            isDelivered ? 'Enjoy your meal!' : 'Waiting for delivery',
            isDelivered,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(
    String title,
    String subtitle,
    bool isCompleted,
    bool showLine,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 60,
                color: Colors.orange,
              ),
          ],
        ),
        const Gap(TSizes.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (showLine) const Gap(20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(context, 'Items', order['itemsInfo'] ?? 'N/A', Icons.shopping_bag),
          const Divider(height: TSizes.spaceBtwItems),
          _buildDetailRow(context, 'Total Amount', 'GHS ${order['price'] ?? 0}', Icons.payments),
          const Divider(height: TSizes.spaceBtwItems),
          _buildDetailRow(context, 'Restaurant', order['restaurantName'] ?? 'N/A', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(TSizes.sm),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          ),
          child: Icon(icon, color: TColors.primary, size: 20),
        ),
        const Gap(TSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(color: TColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Icon(
              Icons.location_on,
              color: TColors.primary,
              size: 32,
            ),
          ),
          const Gap(TSizes.md),
          Expanded(
            child: Text(
              order['location'] ?? 'No address provided',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getOrderStatus() {
    // Get the actual status from the order data
    final status = order['status'];
    if (status != null && status is String) {
      return status.toLowerCase();
    }
    return 'pending';
  }
}
