import 'package:flutter/material.dart';
import 'package:foodu/features/admin/screens/category_crud_screen.dart';
import 'package:foodu/features/admin/screens/food_crud_screen.dart';
import 'package:foodu/features/admin/screens/orders_management_screen.dart';
import 'package:foodu/features/dispatcher/screens/dispatcher_management_screen.dart';
import 'package:foodu/features/admin/widgets/date_range_selector.dart';
import 'package:foodu/features/admin/controller/branch_specific_controller.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BranchSpecificAdminScreen extends StatelessWidget {
  final BranchModel branch;

  const BranchSpecificAdminScreen({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final branchController = Get.find<BranchController>();
    final branchSpecificController = Get.put(BranchSpecificController());

    // Debug branch information
    print('🏪 DEBUG: Branch passed to screen:');
    print('   - Branch ID: "${branch.id}"');
    print('   - Branch Name: "${branch.name}"');
    print('   - Branch Address: "${branch.address}"');
    print('   - Branch toString: ${branch.toString()}');

    // Ensure branch ID is not empty
    if (branch.id.isEmpty) {
      print('❌ ERROR: Branch ID is empty! Cannot initialize dashboard.');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: TColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Branch ID is missing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Cannot load branch-specific data without a valid branch ID.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Initialize with clicked branch ID and start loading data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('\n🎯 INITIALIZING BRANCH: "${branch.name}" (ID: "${branch.id}")');

      // Use clicked branch ID for everything and start loading data
      branchController.selectBranch(branch);
      branchSpecificController.currentBranchId.value = branch.id;
      branchSpecificController.initializeBranch(branch.id);

      print('🚀 Data loading started automatically for branch: "${branch.id}"');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${branch.name} Dashboard'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // IconButton(
          //   onPressed: () => _showBranchInfo(context),
          //   icon: const Icon(Icons.info_outline),
          //   tooltip: 'Branch Information',
          // ),
          IconButton(
            onPressed: () async {
              final controller = Get.find<BranchSpecificController>();

              print(
                  '\n🔍 DEBUG: Using clicked branch "${branch.name}" (ID: "${branch.id}")');

              // Always use clicked branch ID
              controller.currentBranchId.value = branch.id;
              await controller.refreshData();
              await controller.debugAllProducts();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Branch Header with current branch info
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 24,
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            branch.address,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            branch.isActive ? TColors.success : TColors.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        branch.isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Dashboard Content with Pull-to-Refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await branchSpecificController.refreshData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error Banner (if any)
                    Obx(() => branchSpecificController.hasError.value
                        ? _buildErrorBanner()
                        : const SizedBox.shrink()),

                    // Quick Stats Section
                    _buildQuickStats(),
                    const SizedBox(height: TSizes.spaceBtwSection),

                    // Date Range Selector
                    const DateRangeSelector(),
                    const SizedBox(height: TSizes.md),

                    // Analytics Charts Section
                    _buildAnalyticsCharts(),
                    const SizedBox(height: TSizes.spaceBtwSection),

                    // Quick Actions Section
                    _buildQuickActions(context),
                    const SizedBox(height: TSizes.spaceBtwSection),

                    // Management Tools Section
                    _buildManagementTools(context),
                    const SizedBox(height: TSizes.spaceBtwSection),

                    // Recent Activity Section
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final controller = Get.find<BranchSpecificController>();

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
                  'Branch Overview',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => controller.isLoading.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            onPressed: () {
                              print(
                                  '🔄 REFRESH: Using clicked branch "${branch.name}" (ID: "${branch.id}")');

                              // Always use clicked branch ID
                              controller.currentBranchId.value = branch.id;
                              controller.refreshData();
                            },
                            icon: const Icon(Icons.refresh, size: 20),
                            tooltip: 'Refresh Data',
                          )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(TSizes.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Loading branch data...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Products',
                                '${controller.productsCount.value}',
                                Icons.restaurant_menu,
                                TColors.primary,
                              ),
                            ),
                            const SizedBox(width: TSizes.md),
                            Expanded(
                              child: _buildStatCard(
                                'Categories',
                                '${controller.categoriesCount.value}',
                                Icons.category,
                                TColors.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.md),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Orders Today',
                                '${controller.todaysOrdersCount.value}',
                                Icons.shopping_bag,
                                TColors.success,
                              ),
                            ),
                            const SizedBox(width: TSizes.md),
                            Expanded(
                              child: _buildStatCard(
                                'Revenue',
                                'GHS ${controller.todaysRevenue.value.toStringAsFixed(2)}',
                                Icons.attach_money,
                                TColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    final controller = Get.find<BranchSpecificController>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: TSizes.md),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: TSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error Loading Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              controller.hasError.value = false;
              controller.refreshData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: TSizes.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.md),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Product',
                    Icons.add_shopping_cart,
                    TColors.primary,
                    () => Get.to(() => const FoodCrudScreen()),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: _buildActionButton(
                    'Add Category',
                    Icons.add_circle_outline,
                    TColors.warning,
                    () => Get.to(() => const CategoryCrudScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: TSizes.xs),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCharts() {
    final controller = Get.find<BranchSpecificController>();

    return Obx(() => Column(
          children: [
            // Revenue Trend Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          'Revenue Trend (${controller.dateRangeText})',
                          style: Get.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: TSizes.md),
                    SizedBox(
                      height: 200,
                      child: controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                numberFormat:
                                    NumberFormat.currency(symbol: 'GHS '),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CartesianSeries<_ChartData, String>>[
                                LineSeries<_ChartData, String>(
                                  dataSource: controller
                                      .getRevenueChartData()
                                      .map((data) => _ChartData(data.x, data.y))
                                      .toList(),
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y,
                                  name: 'Revenue',
                                  color: TColors.primary,
                                  width: 3,
                                  markerSettings: const MarkerSettings(
                                    isVisible: true,
                                    color: TColors.primary,
                                    borderColor: Colors.white,
                                    borderWidth: 2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.md),

            // Orders and Categories Charts Row
            Row(
              children: [
                // Orders Chart
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                'Orders (${controller.dateRangeText})',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const SizedBox(height: TSizes.md),
                          SizedBox(
                            height: 150,
                            child: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <CartesianSeries<_ChartData,
                                        String>>[
                                      ColumnSeries<_ChartData, String>(
                                        dataSource: controller
                                            .getOrdersChartData()
                                            .map((data) =>
                                                _ChartData(data.x, data.y))
                                            .toList(),
                                        xValueMapper: (_ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (_ChartData data, _) =>
                                            data.y,
                                        name: 'Orders',
                                        color: TColors.success,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),

                // Category Distribution Chart
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category Distribution',
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: TSizes.md),
                          SizedBox(
                            height: 150,
                            child: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : SfCircularChart(
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom,
                                      textStyle: const TextStyle(fontSize: 10),
                                    ),
                                    series: <CircularSeries<_PieData, String>>[
                                      PieSeries<_PieData, String>(
                                        dataSource: _getCategoryData(),
                                        xValueMapper: (_PieData data, _) =>
                                            data.category,
                                        yValueMapper: (_PieData data, _) =>
                                            data.count,
                                        name: 'Categories',
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                          isVisible: true,
                                          labelPosition:
                                              ChartDataLabelPosition.outside,
                                          textStyle: TextStyle(fontSize: 10),
                                        ),
                                        pointColorMapper: (_PieData data, _) =>
                                            data.color,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  // Real data for category distribution
  List<_PieData> _getCategoryData() {
    final controller = Get.find<BranchSpecificController>();
    final pieData = controller.getCategoryDistributionData();
    return pieData
        .map((data) => _PieData(data.category, data.count, data.color))
        .toList();
  }

  Widget _buildManagementTools(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Management Tools',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.md),
            _buildManagementTile(
              'Manage Products',
              'View, edit, and organize branch products',
              Iconsax.box,
              () => Get.to(() => const FoodCrudScreen()),
            ),
            const Divider(),
            _buildManagementTile(
              'Manage Categories',
              'Organize product categories for this branch',
              Iconsax.category,
              () => Get.to(() => const CategoryCrudScreen()),
            ),
            const Divider(),
            _buildManagementTile(
              'View Orders',
              'Track and manage incoming orders',
              Iconsax.shopping_bag,
              () => Get.to(() => OrdersManagementScreen(branch: branch)),
            ),
            const Divider(),
            _buildManagementTile(
              'Manage Dispatchers',
              'View and manage delivery drivers for this branch',
              Iconsax.truck_fast,
              () => Get.to(() => const DispatcherManagementScreen()),
            ),
            const Divider(),
            _buildManagementTile(
              'Branch Settings',
              'Update branch information and preferences',
              Iconsax.setting,
              () {
                // TODO: Navigate to branch settings
                Get.snackbar(
                  'Coming Soon',
                  'Branch settings will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: TColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: TColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildRecentActivity() {
    final controller = Get.find<BranchSpecificController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.md),
            Obx(() {
              final activities = controller.getRecentActivity();
              if (activities.isEmpty) {
                return const Center(
                  child: Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: activities.take(3).map((activity) {
                  IconData iconData;
                  switch (activity.icon) {
                    case 'shopping_bag':
                      iconData = Icons.shopping_bag;
                      break;
                    case 'edit':
                      iconData = Icons.edit;
                      break;
                    case 'add_circle':
                      iconData = Icons.add_circle;
                      break;
                    default:
                      iconData = Icons.info;
                  }

                  return _buildActivityItem(
                    activity.title,
                    activity.time,
                    iconData,
                    activity.color,
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: TSizes.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to full activity log
                  Get.snackbar(
                    'Coming Soon',
                    'Full activity log will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('View All Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: TSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data classes for charts
class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

class _PieData {
  _PieData(this.category, this.count, this.color);
  final String category;
  final int count;
  final Color color;
}
