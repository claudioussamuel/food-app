import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';


class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final OrderRepository _orderRepository = OrderRepository();
  
  // Observable variables
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final RxString currentBranchId = ''.obs;
  
  // Stream subscription
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  @override
  void onClose() {
    _ordersSubscription?.cancel();
    super.onClose();
  }

  /// Initialize controller with branch ID
  void initializeWithBranch(String branchId) {
    print('🎯 OrdersController: Initializing with branch ID: $branchId');
    
    if (branchId.isEmpty) {
      print('❌ OrdersController: Branch ID is empty!');
      return;
    }
    
    currentBranchId.value = branchId;
    _loadOrdersForBranch(branchId);
  }

  /// Load orders for specific branch
  void _loadOrdersForBranch(String branchId) {
    print('📦 OrdersController: Loading orders for branch: $branchId');
    
    isLoading.value = true;
    
    // Cancel existing subscription
    _ordersSubscription?.cancel();
    
    // Subscribe to orders stream for this branch
    _ordersSubscription = _orderRepository.ordersByBranch(branchId).listen(
      (ordersList) {
        print('📦 OrdersController: Received ${ordersList.length} orders for branch $branchId');
        
        orders.value = ordersList;
        _applyFilters();
        isLoading.value = false;
      },
      onError: (error) {
        print('❌ OrdersController: Error loading orders: $error');
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Failed to load orders: $error',
          backgroundColor: TColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Refresh orders data
  Future<void> refreshOrders() async {
    if (currentBranchId.value.isNotEmpty) {
      _loadOrdersForBranch(currentBranchId.value);
    }
  }

  /// Filter orders by status
  void filterByStatus(String status) {
    print('🔍 OrdersController: Filtering by status: $status');
    selectedStatus.value = status;
    _applyFilters();
  }

  /// Search orders by customer email or order ID
  void searchOrders(String query) {
    print('🔍 OrdersController: Searching orders with query: $query');
    searchQuery.value = query.toLowerCase();
    _applyFilters();
  }

  /// Apply current filters to orders list
  void _applyFilters() {
    List<OrderModel> filtered = List.from(orders);

    // Apply status filter
    if (selectedStatus.value != 'all') {
      filtered = filtered.where((order) => 
        order.progress.toLowerCase() == selectedStatus.value.toLowerCase()
      ).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((order) =>
        order.customerEmail.toLowerCase().contains(searchQuery.value) ||
        order.id.toLowerCase().contains(searchQuery.value) ||
        order.customerNumber.toLowerCase().contains(searchQuery.value)
      ).toList();
    }

    filteredOrders.value = filtered;
    print('📊 OrdersController: Applied filters - ${filtered.length} orders shown');
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      print('🔄 OrdersController: Updating order $orderId to status: $newStatus');
      
      isLoading.value = true;
      
      await _orderRepository.updateOrderProgress(
        orderId: orderId,
        progress: newStatus,
      );
      
      // Show success message
      Get.snackbar(
        'Success',
        'Order status updated to ${newStatus.toUpperCase()}',
        backgroundColor: TColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      print('✅ OrdersController: Order status updated successfully');
      
    } catch (error) {
      print('❌ OrdersController: Error updating order status: $error');
      
      Get.snackbar(
        'Error',
        'Failed to update order status: $error',
        backgroundColor: TColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel order with optional reason
  Future<void> cancelOrder(String orderId, [String? reason]) async {
    try {
      print('❌ OrdersController: Cancelling order $orderId with reason: $reason');
      
      isLoading.value = true;
      
      await _orderRepository.updateOrderProgress(
        orderId: orderId,
        progress: 'cancelled',
        cancellationReason: reason,
      );
      
      // Show success message
      Get.snackbar(
        'Order Cancelled',
        'Order has been cancelled successfully',
        backgroundColor: TColors.warning,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      print('✅ OrdersController: Order cancelled successfully');
      
    } catch (error) {
      print('❌ OrdersController: Error cancelling order: $error');
      
      Get.snackbar(
        'Error',
        'Failed to cancel order: $error',
        backgroundColor: TColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get orders count by status for current branch
  int getOrdersCountByStatus(String status) {
    if (status == 'all') {
      return orders.length;
    }
    return orders.where((order) => 
      order.progress.toLowerCase() == status.toLowerCase()
    ).length;
  }

  /// Get today's orders count for current branch
  int getTodaysOrdersCount() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return orders.where((order) =>
      order.startTime.isAfter(startOfDay) && 
      order.startTime.isBefore(endOfDay)
    ).length;
  }

  /// Get today's revenue for current branch
  double getTodaysRevenue() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final todaysOrders = orders.where((order) =>
      order.startTime.isAfter(startOfDay) && 
      order.startTime.isBefore(endOfDay) &&
      order.progress.toLowerCase() != 'cancelled'
    );

    double totalRevenue = 0.0;
    for (final order in todaysOrders) {
      for (final product in order.products) {
        totalRevenue += product.price * product.cartQuantity;
      }
    }

    return totalRevenue;
  }

  /// Get average order value for current branch
  double getAverageOrderValue() {
    if (orders.isEmpty) return 0.0;

    double totalValue = 0.0;
    int validOrders = 0;

    for (final order in orders) {
      if (order.progress.toLowerCase() != 'cancelled') {
        for (final product in order.products) {
          totalValue += product.price * product.cartQuantity;
        }
        validOrders++;
      }
    }

    return validOrders > 0 ? totalValue / validOrders : 0.0;
  }

  /// Get orders by time period (today, week, month)
  List<OrderModel> getOrdersByPeriod(String period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period.toLowerCase()) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      default:
        return orders;
    }

    return orders.where((order) => order.startTime.isAfter(startDate)).toList();
  }

  /// Get most popular products from orders
  Map<String, int> getMostPopularProducts() {
    final Map<String, int> productCounts = {};

    for (final order in orders) {
      if (order.progress.toLowerCase() != 'cancelled') {
        for (final product in order.products) {
          productCounts[product.name] = 
            (productCounts[product.name] ?? 0) + product.cartQuantity;
        }
      }
    }

    // Sort by count and return top products
    final sortedEntries = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(5));
  }

  /// Get order completion rate (delivered orders / total orders)
  double getOrderCompletionRate() {
    if (orders.isEmpty) return 0.0;

    final completedOrders = orders.where((order) => 
      order.progress.toLowerCase() == 'delivered'
    ).length;

    return (completedOrders / orders.length) * 100;
  }

  /// Get peak hours analysis
  Map<int, int> getPeakHoursAnalysis() {
    final Map<int, int> hourCounts = {};

    for (final order in orders) {
      final hour = order.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    return hourCounts;
  }

  /// Clear all filters and search
  void clearFilters() {
    selectedStatus.value = 'all';
    searchQuery.value = '';
    _applyFilters();
  }

  /// Get order statistics summary
  Map<String, dynamic> getOrderStatistics() {
    return {
      'total_orders': orders.length,
      'pending_orders': getOrdersCountByStatus('pending'),
      'preparing_orders': getOrdersCountByStatus('preparing'),
      'ready_orders': getOrdersCountByStatus('ready'),
      'delivered_orders': getOrdersCountByStatus('delivered'),
      'cancelled_orders': getOrdersCountByStatus('cancelled'),
      'todays_orders': getTodaysOrdersCount(),
      'todays_revenue': getTodaysRevenue(),
      'average_order_value': getAverageOrderValue(),
      'completion_rate': getOrderCompletionRate(),
    };
  }
}
