import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../features/home_action_menu/controller/branch_controller.dart';
import '../../../features/home_action_menu/model/order.dart';
import '../../../data/repositories/menu/order_repository.dart';
import '../controller/dispatcher_controller.dart';
import 'ready_orders_screen.dart';

class DispatcherDashboardScreen extends StatelessWidget {
  const DispatcherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatcherController = Get.find<DispatcherController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatcher Dashboard'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => dispatcherController.refreshData(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dispatcherController.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // Branch Selector
              _buildBranchSelector(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // Ready Orders Button
              _buildReadyOrdersButton(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // Quick Stats
              _buildQuickStats(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // Revenue Stats
              _buildRevenueStats(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // Available Orders Section
              _buildAvailableOrdersSection(),
              const SizedBox(height: TSizes.spaceBtwSection),

              // My Deliveries Section
              _buildMyDeliveriesSection(),
              const SizedBox(height: TSizes.spaceBtwSection),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.truck_fast,
                    color: TColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ready for deliveries today?',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Obx(() {
                //   final controller = Get.find<DispatcherController>();
                //   final isOnline = controller.currentBranchId.value.isNotEmpty;

                //   return Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //     decoration: BoxDecoration(
                //       color: isOnline ? TColors.success : Colors.grey,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Text(
                //       isOnline ? 'Online' : 'Offline',
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   );
                // }),
              ],
            ),
            const SizedBox(height: TSizes.md),
            Text(
              DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final dispatcherController = Get.find<DispatcherController>();
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentDispatcherEmail = currentUser?.email ?? '';

    return Obx(() {
      // Get ready orders count from controller
      final availableOrders = dispatcherController.readyOrders.length;

      // Get "My Deliveries" - orders picked up by current dispatcher
      final myDeliveries = dispatcherController.allOrders.where((order) {
        final progress = order['progress']?.toString() ?? '';
        final dispatcherEmail = order['dispatcherEmail']?.toString() ?? '';
        return progress == 'Picked Up' && dispatcherEmail == currentDispatcherEmail;
      }).length;

      // Get completed deliveries by current dispatcher
      final completed = dispatcherController.allOrders.where((order) {
        final progress = order['progress']?.toString().toLowerCase() ?? '';
        final dispatcherEmail = order['dispatcherEmail']?.toString() ?? '';
        return progress == 'delivered' && dispatcherEmail == currentDispatcherEmail;
      }).length;

      return Row(
        children: [
          Expanded(
              child: _buildStatCard('Available Orders', '$availableOrders',
                  Iconsax.shopping_bag, TColors.warning)),
          const SizedBox(width: TSizes.md),
          Expanded(
              child: _buildStatCard('My Deliveries', '$myDeliveries',
                  Iconsax.truck, TColors.primary)),
          const SizedBox(width: TSizes.md),
          Expanded(
              child: _buildStatCard('Completed', '$completed',
                  Icons.check_circle, TColors.success)),
        ],
      );
    });
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: TSizes.sm),
            Text(
              value,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueStats() {
    final dispatcherController = Get.find<DispatcherController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.wallet_money,
                    color: TColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  'My Revenue',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            Obx(() {
              return Column(
                children: [
                  // Today's Revenue
                  Container(
                    padding: const EdgeInsets.all(TSizes.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.success.withOpacity(0.1),
                          TColors.success.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: TColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'GHS ${dispatcherController.todaysRevenue.value.toStringAsFixed(2)}',
                              style: Get.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: TColors.success,
                              ),
                            ),
                            Text(
                              '${dispatcherController.todaysDeliveryCount.value} deliveries',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.money_4,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.md),
                  // Weekly and Monthly Revenue
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(TSizes.md),
                          decoration: BoxDecoration(
                            color: TColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.calendar,
                                    size: 16,
                                    color: TColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'This Week',
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'GHS ${dispatcherController.weeklyRevenue.value.toStringAsFixed(2)}',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.md),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(TSizes.md),
                          decoration: BoxDecoration(
                            color: TColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.calendar_1,
                                    size: 16,
                                    color: TColors.warning,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'This Month',
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'GHS ${dispatcherController.monthlyRevenue.value.toStringAsFixed(2)}',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.md),
                  // Revenue Chart
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(TSizes.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Revenue Trend',
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Last 7 Days',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: TColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.sm),
                        Expanded(
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              labelStyle: Get.textTheme.bodySmall,
                            ),
                            primaryYAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(
                                width: 0.5,
                                color: Colors.grey,
                                dashArray: [5, 5],
                              ),
                              labelFormat: 'GHS {value}',
                              labelStyle: Get.textTheme.bodySmall,
                            ),
                            series: <CartesianSeries>[
                              SplineSeries<ChartData, String>(
                                dataSource: dispatcherController.getRevenueChartData(),
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                color: TColors.success,
                                width: 3,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  height: 6,
                                  width: 6,
                                  color: TColors.success,
                                  borderColor: Colors.white,
                                  borderWidth: 2,
                                ),
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              format: 'point.x: GHS point.y',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyOrdersButton() {
    return Card(
      child: InkWell(
        onTap: () => Get.to(() => const ReadyOrdersScreen()),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.box_tick,
                  color: TColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready Orders',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View all ready orders',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
             const Icon(
                Iconsax.arrow_right_3,
                color: TColors.textGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableOrdersSection() {
    final dispatcherController = Get.find<DispatcherController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Orders',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ReadyOrdersScreen()),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            // Available orders from controller (raw data)
            Obx(() {
              if (dispatcherController.isLoading.value) {
                return Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }

              final readyOrders = dispatcherController.readyOrders;

              if (readyOrders.isEmpty) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.shopping_bag,
                            size: 32, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No available orders',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show first 3 ready orders
              final ordersToShow = readyOrders.take(3).toList();

                return Column(
                  children: [
                    ...ordersToShow.map((order) => Container(
                          margin: const EdgeInsets.only(bottom: TSizes.sm),
                          padding: const EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            color: TColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: TColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: TColors.success,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Iconsax.box_tick,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: TSizes.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${(order['id'] as String).substring(0, 8)}',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${(order['products'] as List?)?.length ?? 0} items • GHS ${_calculateTotal(order).toStringAsFixed(2)}',
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TColors.success,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'READY',
                                  style: Get.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.sm),
                              InkWell(
                                onTap: () {
                                  final controller =
                                      Get.find<DispatcherController>();
                                  controller.pickupOrder(order);
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'PICKUP',
                                    style: Get.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    if (readyOrders.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: TSizes.sm),
                        child: Text(
                          '+${readyOrders.length - 3} more orders available',
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: TColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyDeliveriesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Active Deliveries',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to my deliveries
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            // Display active deliveries via stream
            Obx(() {
              final branchController = Get.find<BranchController>();
              final selectedBranch = branchController.selectedBranch.value;

              if (selectedBranch == null) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.truck, size: 32, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No active deliveries',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final orderRepository = Get.put(OrderRepository());
              return StreamBuilder<List<OrderModel>>(
                stream: orderRepository.ordersByBranch(selectedBranch.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }

                  final allOrders = snapshot.data ?? [];
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final currentDispatcherEmail = currentUser?.email;

                  final activeDeliveries = allOrders
                      .where((o) =>
                          o.progress == 'Picked Up' &&
                          o.dispatcherEmail == currentDispatcherEmail)
                      .toList();

                  if (activeDeliveries.isEmpty) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.truck, size: 32, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No active deliveries',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Show first 3 active deliveries
                  final deliveriesToShow = activeDeliveries.take(3).toList();

                  return Column(
                    children: [
                      ...deliveriesToShow.map((order) => Container(
                            margin: const EdgeInsets.only(bottom: TSizes.sm),
                            padding: const EdgeInsets.all(TSizes.sm),
                            decoration: BoxDecoration(
                              color: TColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: TColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Iconsax.truck,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #${order.id.substring(0, 8)}',
                                        style:
                                            Get.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${order.products.length} items • GHS ${order.totalAmount.toStringAsFixed(2)}',
                                        style:
                                            Get.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (order.dispatcherEmail != null)
                                        Text(
                                          'Picked up by: ${order.dispatcherEmail}',
                                          style:
                                              Get.textTheme.bodySmall?.copyWith(
                                            color: TColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'IN TRANSIT',
                                    style: Get.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TSizes.sm),
                                InkWell(
                                  onTap: () {
                                    final controller =
                                        Get.find<DispatcherController>();
                                    controller.deliverOrder(order);
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TColors.success,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'DELIVER',
                                      style: Get.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      if (activeDeliveries.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: TSizes.sm),
                          child: Text(
                            '+${activeDeliveries.length - 3} more deliveries in progress',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: TColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchSelector() {
    final branchController = Get.find<BranchController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.building,
                  color: TColors.primary,
                  size: 20,
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  'Current Branch',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            Obx(() {
              final selectedBranch = branchController.selectedBranch.value;
              final availableBranches = branchController.availableBranches;

              if (selectedBranch == null) {
                return Container(
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.warning_2, color: Colors.orange),
                      const SizedBox(width: TSizes.sm),
                      const Text('No branch selected'),
                      const Spacer(),
                      if (availableBranches.isNotEmpty)
                        TextButton(
                          onPressed: () => branchController
                              .selectBranch(availableBranches.first),
                          child: const Text('Select Branch'),
                        ),
                    ],
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TSizes.md),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: TColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.building_4,
                            color: TColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedBranch.name,
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  selectedBranch.isActive
                                      ? 'Active'
                                      : 'Inactive',
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color: selectedBranch.isActive
                                        ? TColors.success
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  if (availableBranches.length > 1)
                    IconButton(
                      onPressed: () => branchController.selectNextBranch(),
                      icon: const Icon(Iconsax.arrow_right_3),
                      tooltip: 'Switch Branch',
                      style: IconButton.styleFrom(
                        backgroundColor: TColors.primary.withOpacity(0.1),
                        foregroundColor: TColors.primary,
                      ),
                    ),
                ],
              );
            }),
            if (branchController.availableBranches.length > 1) ...[
              const SizedBox(height: TSizes.sm),
              Text(
                'Tap the arrow to switch between ${branchController.availableBranches.length} available branches',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Calculate total amount from raw order data
  double _calculateTotal(Map<String, dynamic> order) {
    final products = order['products'] as List?;
    if (products == null || products.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var product in products) {
      if (product is Map<String, dynamic>) {
        final price = (product['price'] as num?)?.toDouble() ?? 0.0;
        final quantity = (product['cartQuantity'] as num?)?.toInt() ?? 1;
        total += price * quantity;
      }
    }
    return total;
  }
}
