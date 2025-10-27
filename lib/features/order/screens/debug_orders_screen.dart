import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/utils/constants/sizes.dart';

class DebugOrdersScreen extends StatelessWidget {
  const DebugOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;

    // Automatically fetch orders when debug screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Orders'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Summary',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  controller.refreshOrders();
                                },
                                tooltip: 'Refresh Orders',
                              ),
                              IconButton(
                                icon: const Icon(Icons.print),
                                onPressed: () {
                                  controller.debugPrintAllOrders();
                                },
                                tooltip: 'Print to Console',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Total Orders: ${controller.allOrders.length}'),
                      Text('Active Orders: ${controller.activeOrders.length}'),
                      Text(
                          'Completed Orders: ${controller.completedOrders.length}'),
                      Text(
                          'Cancelled Orders: ${controller.cancelledOrders.length}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // All Orders Section
              Text(
                'All Orders (${controller.allOrders.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              if (controller.allOrders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No orders found'),
                  ),
                )
              else
                ...controller.allOrders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return _buildOrderCard(context, 'All Orders', index, order);
                }),

              const SizedBox(height: 24),

              // Active Orders Section
              Text(
                'Active Orders (${controller.activeOrders.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
              ),
              const SizedBox(height: 8),

              if (controller.activeOrders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No active orders'),
                  ),
                )
              else
                ...controller.activeOrders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return _buildOrderCard(context, 'Active', index, order,
                      isActive: true);
                }),

              const SizedBox(height: 24),

              // Completed Orders Section
              Text(
                'Completed Orders (${controller.completedOrders.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
              ),
              const SizedBox(height: 8),

              if (controller.completedOrders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No completed orders'),
                  ),
                )
              else
                ...controller.completedOrders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return _buildOrderCard(context, 'Completed', index, order,
                      isCompleted: true);
                }),

              const SizedBox(height: 24),

              // Cancelled Orders Section
              Text(
                'Cancelled Orders (${controller.cancelledOrders.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
              ),
              const SizedBox(height: 8),

              if (controller.cancelledOrders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No cancelled orders'),
                  ),
                )
              else
                ...controller.cancelledOrders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return _buildOrderCard(context, 'Cancelled', index, order,
                      isCancelled: true);
                }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    String section,
    int index,
    dynamic order, {
    bool isActive = false,
    bool isCompleted = false,
    bool isCancelled = false,
  }) {
    Color cardColor = Colors.grey.shade100;
    if (isActive) cardColor = Colors.orange.shade50;
    if (isCompleted) cardColor = Colors.green.shade50;
    if (isCancelled) cardColor = Colors.red.shade50;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$section Order #$index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.orange
                        : isCompleted
                            ? Colors.green
                            : isCancelled
                                ? Colors.red
                                : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive
                        ? 'ACTIVE'
                        : isCompleted
                            ? 'COMPLETED'
                            : isCancelled
                                ? 'CANCELLED'
                                : 'UNKNOWN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (order is OrderModel) ...[
              Text('ID: ${order.id}'),
              Text('Customer Email: ${order.customerEmail}'),
              Text('Progress: ${order.progress}'),
              Text('Start Time: ${order.startTime}'),
              if (order.endTime != null) Text('End Time: ${order.endTime}'),
              Text('Products: ${order.products.length}'),
              Text('Total Amount: GHS ${order.totalAmount.toStringAsFixed(2)}'),
              if (order.location != null) Text('Location: ${order.location}'),
              if (order.branchId.isNotEmpty)
                Text('Branch ID: ${order.branchId}'),
            ] else if (order is Map<String, dynamic>) ...[
              Text('Restaurant: ${order['restaurantName'] ?? 'N/A'}'),
              Text('Items: ${order['itemsInfo'] ?? 'N/A'}'),
              Text('Price: GHS ${order['price']?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Location: ${order['location'] ?? 'N/A'}'),
              if (order['cancelledDate'] != null)
                Text('Cancelled Date: ${order['cancelledDate']}'),
            ],
          ],
        ),
      ),
    );
  }
}
