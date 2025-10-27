import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailModal extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailModal({super.key, required this.order});

  @override
  State<OrderDetailModal> createState() => _OrderDetailModalState();
}

class _OrderDetailModalState extends State<OrderDetailModal> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final BranchController _branchController = BranchController.instance;
  final OrderController _orderController = OrderController.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TSizes.cardRadiusLg),
              topRight: Radius.circular(TSizes.cardRadiusLg),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Tracking order.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the close button
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? TColors.backgroundDark : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(TSizes.cardRadiusLg),
                      topRight: Radius.circular(TSizes.cardRadiusLg),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Order Number
                      Container(
                        margin: const EdgeInsets.all(TSizes.defaultSpace),
                        padding: const EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Number:',
                              style: TextStyle(
                                color: TColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.order['orderNumber'] ?? widget.order['formattedOrderNumber'] ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Swipeable Content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            // Details Page
                            _buildDetailsPage(isDark),
                            // Progress Page
                            _buildProgressPage(isDark),
                          ],
                        ),
                      ),

                      // Page Indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPageIndicator(0),
                            const SizedBox(width: TSizes.xs),
                            _buildPageIndicator(1),
                          ],
                        ),
                      ),

                      // Swipe Hint
                      Padding(
                        padding: const EdgeInsets.only(bottom: TSizes.sm),
                        child: Text(
                          _currentPage == 0
                              ? 'Swipe right for Progress'
                              : 'Swipe left for Details',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      // Bottom Message and Button
                      Container(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          children: [
                            Text(
                              'We wish that all pick ups are done timely\nto prevent meals from running cold.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: TSizes.md),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _openBranchLocation(),
                                icon: const Icon(Icons.location_on, color: Colors.white),
                                label: const Text(
                                  'Branch Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.black : Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDetailsPage(bool isDark) {
    // Get actual order data
    final orderId = widget.order['id'] as String?;
    final actualOrder = _orderController.allOrders.firstWhereOrNull(
      (o) => o.id == orderId,
    );

    // Get branch info
    final branchId = actualOrder?.branchId ?? widget.order['branchId'] as String?;
    final branch = branchId != null
        ? _branchController.branches.firstWhereOrNull((b) => b.id == branchId)
        : null;

    // Calculate totals
    final total = actualOrder?.totalAmount ?? (widget.order['price'] as num?)?.toDouble() ?? 0.0;

    // Get order status
    final status = actualOrder?.progress.toUpperCase() ?? 'PENDING';
    final statusColor = _getStatusColor(status);

    // Format date
    final orderDate = actualOrder?.startTime ?? DateTime.now();
    final formattedDate = '${_getMonthName(orderDate.month)} ${orderDate.day}, ${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.grey[100],
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),

            // Order Items
            if (actualOrder != null && actualOrder.products.isNotEmpty)
              ...actualOrder.products.map((product) => _buildOrderItem(
                    '${product.cartQuantity} x ${product.name}',
                    'GHS ${(product.price * product.cartQuantity).toStringAsFixed(2)}',
                  ))
            else
              _buildOrderItem(widget.order['itemsInfo'] ?? '0 items', 'GHS ${total.toStringAsFixed(2)}'),
            const Divider(height: TSizes.spaceBtwItems),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'GHS ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),

            // Pick Up Branch
            const Text(
              'Pick Up Branch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              branch?.name.toUpperCase() ?? 'BRANCH NOT FOUND',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (branch != null) ...[
              const SizedBox(height: TSizes.xs),
              Text(
                branch.address,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: TSizes.xs),
            Text(
              'Paid: Mobile/Card Payment',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressPage(bool isDark) {
    // Get actual order data
    final orderId = widget.order['id'] as String?;
    final actualOrder = _orderController.allOrders.firstWhereOrNull(
      (o) => o.id == orderId,
    );

    final currentStatus = actualOrder?.progress.toLowerCase() ?? 'pending';

    // Determine which steps are completed
    final isPending = true; // Order always starts as pending
    final isPreparing = ['preparing', 'ready', 'completed', 'delivered'].contains(currentStatus);
    final isReady = ['ready', 'completed', 'delivered'].contains(currentStatus);
    final isCompleted = ['completed', 'delivered'].contains(currentStatus);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkCard : Colors.grey[100],
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        ),
        child: Column(
          children: [
            _buildProgressStep(
              'Placing Order',
              'Your order has been placed',
              isPending,
              true,
            ),
            _buildProgressStep(
              'Order Accepted',
              isPreparing ? 'Your order is being prepared' : 'Waiting for restaurant to accept',
              isPreparing,
              true,
            ),
            _buildProgressStep(
              'Order Ready',
              isReady ? 'Your order is ready for pickup' : 'Order is being prepared',
              isReady,
              true,
            ),
            _buildProgressStep(
              'Order Picked Up',
              isCompleted ? 'Enjoy your meal!' : 'Waiting for pickup',
              isCompleted,
              false,
            ),
          ],
        ),
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
        const SizedBox(width: TSizes.md),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (showLine) const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper method to open branch location in Google Maps
  Future<void> _openBranchLocation() async {
    final orderId = widget.order['id'] as String?;
    final actualOrder = _orderController.allOrders.firstWhereOrNull(
      (o) => o.id == orderId,
    );

    final branchId = actualOrder?.branchId ?? widget.order['branchId'] as String?;
    final branch = branchId != null
        ? _branchController.branches.firstWhereOrNull((b) => b.id == branchId)
        : null;

    if (branch == null) {
      Get.snackbar(
        'Error',
        'Branch location not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create Google Maps URL
    final lat = branch.latitude;
    final lng = branch.longitude;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open maps',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Colors.green[700]!;
      case 'ready':
        return Colors.blue[700]!;
      case 'preparing':
        return Colors.orange[700]!;
      case 'pending':
        return Colors.grey[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
