import 'package:flutter/material.dart';
import 'package:foodu/features/admin/controller/orders_controller.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class OrdersManagementScreen extends StatelessWidget {
  final BranchModel branch;

  const OrdersManagementScreen({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    
    // Initialize with branch data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeWithBranch(branch.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders - ${branch.name}'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.refreshOrders(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: Column(
        children: [
          // Branch Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColors.primary, TColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        branch.address,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.orders.length} Orders',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ],
            ),
          ),

          // Filter and Search Section
          Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => controller.searchOrders(value),
                  decoration: InputDecoration(
                    hintText: 'Search by customer email or order ID...',
                    prefixIcon: const Icon(Iconsax.search_normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TSizes.md,
                      vertical: TSizes.sm,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.md),
                
                // Status Filter Chips
                Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'All',
                        controller.selectedStatus.value == 'all',
                        () => controller.filterByStatus('all'),
                      ),
                      const SizedBox(width: TSizes.sm),
                      _buildFilterChip(
                        'Pending',
                        controller.selectedStatus.value == 'pending',
                        () => controller.filterByStatus('pending'),
                      ),
                      const SizedBox(width: TSizes.sm),
                      _buildFilterChip(
                        'Preparing',
                        controller.selectedStatus.value == 'preparing',
                        () => controller.filterByStatus('preparing'),
                      ),
                      const SizedBox(width: TSizes.sm),
                      _buildFilterChip(
                        'Ready',
                        controller.selectedStatus.value == 'ready',
                        () => controller.filterByStatus('ready'),
                      ),
                      const SizedBox(width: TSizes.sm),
                      _buildFilterChip(
                        'Delivered',
                        controller.selectedStatus.value == 'delivered',
                        () => controller.filterByStatus('delivered'),
                      ),
                      const SizedBox(width: TSizes.sm),
                      _buildFilterChip(
                        'Cancelled',
                        controller.selectedStatus.value == 'cancelled',
                        () => controller.filterByStatus('cancelled'),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: TSizes.md),
                      Text('Loading orders...'),
                    ],
                  ),
                );
              }

              if (controller.filteredOrders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.shopping_bag,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: TSizes.md),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'No orders found for "${controller.searchQuery.value}"'
                            : controller.selectedStatus.value == 'all'
                                ? 'No orders yet for this branch'
                                : 'No ${controller.selectedStatus.value} orders',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TSizes.sm),
                      Text(
                        'Orders will appear here when customers place them',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshOrders(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return _buildOrderCard(order, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: TColors.primary.withOpacity(0.2),
      checkmarkColor: TColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? TColors.primary : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? TColors.primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, OrdersController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order, controller),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.customerEmail,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(order.progress),
                ],
              ),
              const SizedBox(height: TSizes.md),

              // Order Info
              Row(
                children: [
                  Icon(
                    Iconsax.clock,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(order.startTime),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: TSizes.md),
                  Icon(
                    Iconsax.shopping_bag,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${order.products.length} items',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.sm),

              // Customer Info
              if (order.customerNumber.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Iconsax.call,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.customerNumber,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

              // Location if available
              if (order.location != null && order.location!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.location!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: TSizes.md),

              // Order Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: GHS ${_calculateOrderTotal(order).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: TColors.primary,
                    ),
                  ),
                  if (order.progress != 'delivered' && order.progress != 'cancelled')
                    _buildQuickActionButton(order, controller),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String displayText;
    
    switch (status.toLowerCase()) {
      case 'pending':
        color = TColors.warning;
        displayText = 'Pending';
        break;
      case 'preparing':
        color = Colors.orange;
        displayText = 'Preparing';
        break;
      case 'ready':
        color = Colors.blue;
        displayText = 'Ready';
        break;
      case 'delivered':
        color = TColors.success;
        displayText = 'Delivered';
        break;
      case 'cancelled':
        color = TColors.error;
        displayText = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(OrderModel order, OrdersController controller) {
    String nextStatus;
    String buttonText;
    IconData icon;

    switch (order.progress.toLowerCase()) {
      case 'pending':
        nextStatus = 'preparing';
        buttonText = 'Start Preparing';
        icon = Iconsax.play;
        break;
      case 'preparing':
        nextStatus = 'ready';
        buttonText = 'Mark Ready';
        icon = Iconsax.tick_circle;
        break;
      case 'ready':
        nextStatus = 'delivered';
        buttonText = 'Mark Delivered';
        icon = Iconsax.truck;
        break;
      default:
        return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: () => controller.updateOrderStatus(order.id, nextStatus),
      icon: Icon(icon, size: 16),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  double _calculateOrderTotal(OrderModel order) {
    return order.products.fold(0.0, (total, product) {
      return total + (product.price * product.cartQuantity);
    });
  }

  void _showOrderDetails(OrderModel order, OrdersController controller) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Details',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id.substring(0, 8).toUpperCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                _buildStatusChip(order.progress),
                              ],
                            ),
                            const SizedBox(height: TSizes.md),
                            _buildDetailRow('Customer', order.customerEmail),
                            if (order.customerNumber.isNotEmpty)
                              _buildDetailRow('Phone', order.customerNumber),
                            _buildDetailRow(
                              'Order Time',
                              DateFormat('MMM dd, yyyy - HH:mm a').format(order.startTime),
                            ),
                            if (order.endTime != null)
                              _buildDetailRow(
                                'Completed Time',
                                DateFormat('MMM dd, yyyy - HH:mm a').format(order.endTime!),
                              ),
                            if (order.location != null && order.location!.isNotEmpty)
                              _buildDetailRow('Delivery Address', order.location!),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: TSizes.md),
                    
                    // Products List
                    Text(
                      'Order Items',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    
                    ...order.products.map((product) => Card(
                      margin: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: TSizes.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Qty: ${product.cartQuantity}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'GHS ${(product.price * product.cartQuantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                    
                    const SizedBox(height: TSizes.md),
                    
                    // Total
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'GHS ${_calculateOrderTotal(order).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: TSizes.md),
                    
                    // Action Buttons
                    if (order.progress != 'delivered' && order.progress != 'cancelled')
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                _showStatusUpdateDialog(order, controller);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Update Status'),
                            ),
                          ),
                          const SizedBox(height: TSizes.sm),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                                _showCancelOrderDialog(order, controller);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TColors.error,
                                side: const BorderSide(color: TColors.error),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Cancel Order'),
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: TSizes.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(OrderModel order, OrdersController controller) {
    final statuses = ['pending', 'preparing', 'ready', 'delivered'];
    String selectedStatus = order.progress;

    Get.dialog(
      AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order #${order.id.substring(0, 8).toUpperCase()}'),
            const SizedBox(height: TSizes.md),
            ...statuses.map((status) => RadioListTile<String>(
              title: Text(status.toUpperCase()),
              value: status,
              groupValue: selectedStatus,
              onChanged: (value) {
                selectedStatus = value!;
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: const Text('Update Order Status'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Order #${order.id.substring(0, 8).toUpperCase()}'),
                        const SizedBox(height: TSizes.md),
                        ...statuses.map((status) => RadioListTile<String>(
                          title: Text(status.toUpperCase()),
                          value: status,
                          groupValue: selectedStatus,
                          onChanged: (value) => selectedStatus = value!,
                        )).toList(),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.updateOrderStatus(order.id, selectedStatus);
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                );
              },
            )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateOrderStatus(order.id, selectedStatus);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(OrderModel order, OrdersController controller) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to cancel order #${order.id.substring(0, 8).toUpperCase()}?'),
            const SizedBox(height: TSizes.md),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelOrder(order.id, reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}
