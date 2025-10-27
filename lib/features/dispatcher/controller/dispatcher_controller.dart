import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

/// Dispatcher Controller - Works with Orders based on progress field
class DispatcherController extends GetxController {
  static DispatcherController get instance => Get.find();

  final OrderRepository _orderRepository = OrderRepository();
  final BranchController _branchController = Get.find<BranchController>();

  // Observable variables - Working with raw order data
  final RxList<Map<String, dynamic>> readyOrders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> activeDeliveries = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> deliveredOrders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allOrders = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentBranchId = ''.obs;

  // Statistics - Based on order progress
  final RxInt availableDispatchersCount = 0.obs; // Ready orders count
  final RxInt totalDispatchersCount = 0.obs; // Active deliveries count
  final RxInt activeDispatchersCount = 0.obs; // Delivered today count
  
  // Revenue statistics
  final RxDouble todaysRevenue = 0.0.obs; // Today's delivery revenue
  final RxDouble weeklyRevenue = 0.0.obs; // This week's delivery revenue
  final RxDouble monthlyRevenue = 0.0.obs; // This month's delivery revenue
  final RxInt todaysDeliveryCount = 0.obs; // Deliveries completed today
  final RxList<OrderModel> deliveredOrdersList = <OrderModel>[].obs; // For chart data

  // Stream subscriptions
  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeDispatcher();
  }

  @override
  void onClose() {
    _ordersSubscription?.cancel();
    super.onClose();
  }

  /// Initialize dispatcher data
  void _initializeDispatcher() {
    print('🚚 DispatcherController: Initializing...');

    // Listen to branch changes
    ever(_branchController.selectedBranch, (_) {
      if (_branchController.selectedBranch.value != null) {
        currentBranchId.value = _branchController.selectedBranch.value!.id;
        _loadOrderData();
      }
    });

    // Load initial data if branch is already selected
    if (_branchController.selectedBranch.value != null) {
      currentBranchId.value = _branchController.selectedBranch.value!.id;
      _loadOrderData();
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    print('🔄 DispatcherController: Refreshing data...');
    isLoading.value = true;
    try {
      _loadOrderData();
      await _loadStatistics();
    } catch (e) {
      print('❌ Error refreshing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load order data using raw data approach (no OrderModel)
  void _loadOrderData() {
    if (currentBranchId.value.isEmpty) {
      print('⚠️ DispatcherController: No branch selected');
      return;
    }

    isLoading.value = true;
    print(
        '📦 DispatcherController: Loading orders for branch: ${currentBranchId.value}');

    // Cancel existing subscription
    _ordersSubscription?.cancel();

    // Subscribe to raw Firestore data for the branch
    _ordersSubscription = _orderRepository.db
        .collection('orders')
        .where('branchId', isEqualTo: currentBranchId.value)
        .snapshots()
        .listen(
      (snapshot) {
        print('🔍 Received ${snapshot.docs.length} raw orders from Firestore');

        // Convert to raw maps
        final rawOrders = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Add document ID
          return data;
        }).toList();

        allOrders.value = rawOrders;
        _filterOrders();
        isLoading.value = false;
      },
      onError: (error) {
        print('❌ Error loading orders: $error');
        isLoading.value = false;
      },
    );
  }

  /// Filter orders by progress status (using raw data)
  void _filterOrders() {
    print('🔍 Filtering ${allOrders.length} orders...');

    // Filter ready orders (case-insensitive)
    final ready = allOrders.where((order) {
      final progress = order['progress']?.toString().toLowerCase() ?? '';
      final location = order['location']?.toString() ?? '';
      return (progress == 'ready' || progress == 'pending') && location != 'Pickup';
    }).toList();

    // Filter active deliveries (picked up by dispatcher)
    final active = allOrders.where((order) {
      final progress = order['progress']?.toString() ?? '';
      return progress == 'Picked Up';
    }).toList();

    // Filter delivered orders
    final delivered = allOrders.where((order) {
      final progress = order['progress']?.toString().toLowerCase() ?? '';
      return progress == 'delivered';
    }).toList();

    readyOrders.value = ready;
    activeDeliveries.value = active;
    deliveredOrders.value = delivered;

    availableDispatchersCount.value = ready.length;
    totalDispatchersCount.value = active.length;
    activeDispatchersCount.value = delivered.length;

    print('✅ Filtered - Ready: ${ready.length}, Active: ${active.length}, Delivered: ${delivered.length}');
  }

  /// Load statistics
  Future<void> _loadStatistics() async {
    if (currentBranchId.value.isEmpty) return;

    try {
      // Get ready orders count
      final readyQuery = await _orderRepository.db
          .collection('orders')
          .where('branchId', isEqualTo: currentBranchId.value)
          .where('progress', isEqualTo: 'Ready')
          .get();

      // Get in delivery orders count
      final inDeliveryQuery = await _orderRepository.db
          .collection('orders')
          .where('branchId', isEqualTo: currentBranchId.value)
          .where('progress', isEqualTo: 'Picked Up')
          .get();

      // Get delivered orders count
      final deliveredQuery = await _orderRepository.db
          .collection('orders')
          .where('branchId', isEqualTo: currentBranchId.value)
          .where('progress', isEqualTo: 'Delivered')
          .get();

      availableDispatchersCount.value = readyQuery.docs.length;
      totalDispatchersCount.value = inDeliveryQuery.docs.length;
      activeDispatchersCount.value = deliveredQuery.docs.length;

      print(
          '📊 Statistics loaded - Ready: ${readyQuery.docs.length}, In Delivery: ${inDeliveryQuery.docs.length}, Delivered: ${deliveredQuery.docs.length}');
      
      // Calculate revenue statistics
      await _calculateRevenueStatistics();
    } catch (error) {
      print('❌ Error loading statistics: $error');
    }
  }

  /// Calculate revenue statistics for the current dispatcher
  Future<void> _calculateRevenueStatistics() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      
      final dispatcherEmail = currentUser.email;
      if (dispatcherEmail == null) return;

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
      final monthStart = DateTime(now.year, now.month, 1);

      // Get all delivered orders by this dispatcher
      final deliveredQuery = await _orderRepository.db
          .collection('orders')
          .where('dispatcherEmail', isEqualTo: dispatcherEmail)
          .where('progress', isEqualTo: 'Delivered')
          .get();

      double todayRev = 0.0;
      double weekRev = 0.0;
      double monthRev = 0.0;
      int todayCount = 0;
      List<OrderModel> deliveredList = [];

      for (var doc in deliveredQuery.docs) {
        final orderModel = OrderModel.fromJson(doc);
        final orderTotal = orderModel.totalAmount;
        final orderDate = orderModel.endTime ?? orderModel.startTime;

        deliveredList.add(orderModel);

        // Today's revenue
        if (orderDate.isAfter(todayStart)) {
          todayRev += orderTotal;
          todayCount++;
        }

        // Weekly revenue
        if (orderDate.isAfter(weekStartDate)) {
          weekRev += orderTotal;
        }

        // Monthly revenue
        if (orderDate.isAfter(monthStart)) {
          monthRev += orderTotal;
        }
      }

      todaysRevenue.value = todayRev;
      weeklyRevenue.value = weekRev;
      monthlyRevenue.value = monthRev;
      todaysDeliveryCount.value = todayCount;
      deliveredOrdersList.value = deliveredList;

      print('💰 Revenue calculated - Today: GHS ${todayRev.toStringAsFixed(2)}, Week: GHS ${weekRev.toStringAsFixed(2)}, Month: GHS ${monthRev.toStringAsFixed(2)}');
    } catch (e) {
      print('❌ Error calculating revenue: $e');
    }
  }

  /// Mark order as picked up (using raw order data)
  Future<void> pickupOrder(Map<String, dynamic> order) async {
    try {
      final orderId = order['id'] as String;
      final orderIdShort = orderId.length > 8 ? orderId.substring(0, 8) : orderId;
      
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Confirm Pickup'),
              content:
                  Text('Mark order $orderIdShort as picked up?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      // Show loading
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Marking order as picked up...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Mark as picked up with dispatcher email
      final currentUser = FirebaseAuth.instance.currentUser;
      final dispatcherEmail = currentUser?.email;
      await _orderRepository.markOrderAsPickedUp(orderId,
          dispatcherEmail: dispatcherEmail);

      // Close loading
      Get.back();

      // Show success
      Get.snackbar(
        'Success',
        'Order picked up successfully',
        backgroundColor: TColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      // Close loading if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('❌ Error picking up order: $error');
      _showError('Failed to pickup order');
    }
  }

  /// Mark order as delivered
  Future<void> deliverOrder(OrderModel order) async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Confirm Delivery'),
              content:
                  Text('Mark order ${order.id.substring(0, 8)} as delivered?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.success,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      // Show loading
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Marking order as delivered...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      await _orderRepository.updateOrderProgress(
        orderId: order.id,
        progress: 'Delivered',
      );

      // Close loading
      Get.back();

      // Show success
      Get.snackbar(
        'Success',
        'Order delivered successfully',
        backgroundColor: TColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      // Close loading if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('❌ Error delivering order: $error');
      _showError('Failed to mark order as delivered');
    }
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: TColors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Get ready orders count
  int get readyOrdersCount => readyOrders.length;

  /// Get active deliveries count
  int get activeDeliveriesCount => activeDeliveries.length;

  /// Get delivered orders count
  int get deliveredOrdersCount => deliveredOrders.length;

  /// Check if there are ready orders
  bool get hasReadyOrders => readyOrders.isNotEmpty;

  /// Check if there are active deliveries
  bool get hasActiveDeliveries => activeDeliveries.isNotEmpty;

  /// Get revenue chart data for last 7 days
  List<ChartData> getRevenueChartData() {
    final Map<String, double> revenueData = {};
    final now = DateTime.now();
    
    // Initialize last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayLabel = _getDayName(date.weekday);
      revenueData[dayLabel] = 0.0;
    }
    
    // Calculate revenue for each day
    for (final order in deliveredOrdersList) {
      final orderDate = order.endTime ?? order.startTime;
      final daysDiff = now.difference(orderDate).inDays;
      
      if (daysDiff < 7) {
        final dayLabel = _getDayName(orderDate.weekday);
        revenueData[dayLabel] = (revenueData[dayLabel] ?? 0.0) + order.totalAmount;
      }
    }
    
    return revenueData.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  /// Get deliveries count chart data for last 7 days
  List<ChartData> getDeliveriesChartData() {
    final Map<String, double> deliveriesData = {};
    final now = DateTime.now();
    
    // Initialize last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayLabel = _getDayName(date.weekday);
      deliveriesData[dayLabel] = 0.0;
    }
    
    // Count deliveries for each day
    for (final order in deliveredOrdersList) {
      final orderDate = order.endTime ?? order.startTime;
      final daysDiff = now.difference(orderDate).inDays;
      
      if (daysDiff < 7) {
        final dayLabel = _getDayName(orderDate.weekday);
        deliveriesData[dayLabel] = (deliveriesData[dayLabel] ?? 0.0) + 1;
      }
    }
    
    return deliveriesData.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

/// Chart data model for revenue/deliveries charts
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
