import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/features/order/screens/cancel_order/cancel_order_screen.dart';
import 'package:foodu/features/order/screens/whats_your_mind/whats_your_mind.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';

class OrderController extends GetxController with GetSingleTickerProviderStateMixin {
  static OrderController get instance => Get.find();

  var tabs = ['Active', 'Completed', 'Cancelled'].obs;
  late TabController tabController;

  final OrderRepository _repository = OrderRepository();

  // Raw orders
  var allOrders = <OrderModel>[].obs;
  // Mapped lists for UI
  var activeOrders = <Map<String, dynamic>>[].obs; // progress == 'pending', 'preparing', or 'ready'
  var completedOrders = <Map<String, dynamic>>[].obs; // progress == 'completed' or 'delivered'
  var cancelledOrders = <Map<String, dynamic>>[].obs; // progress == 'cancelled'

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    _subscribeToOrders();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Switch to Active tab (index 0)
  void switchToActiveTab() {
    tabController.animateTo(0);
  }
  
  /// Switch to Completed tab (index 1)
  void switchToCompletedTab() {
    tabController.animateTo(1);
  }

  /// Switch to Cancelled tab (index 2)
  void switchToCancelledTab() {
    tabController.animateTo(2);
  }

  void _subscribeToOrders() {
    print('🔍 Starting to fetch orders using raw data approach...');
    _fetchOrdersWithRawData();
  }

  /// Fetch orders using raw data approach (like the spanner icon method)
  Future<void> _fetchOrdersWithRawData() async {
    try {
      // Fetch raw data
      final rawOrders = await _repository.getRawOrders();
      print('🔍 Fetched ${rawOrders.length} raw orders');

      // Convert each raw order to model
      final modelOrders = <OrderModel>[];
      for (int i = 0; i < rawOrders.length; i++) {
        final rawOrder = rawOrders[i];
        print('🔍 Converting order $i (ID: ${rawOrder['id']}):');

        try {
          final order = OrderModel.fromRawData(rawOrder);
          modelOrders.add(order);
          print('  ✅ Successfully converted to model');
          print('  Model ID: ${order.id}');
          print('  Model Progress: ${order.progress}');
          print('  Model Products Count: ${order.products.length}');
        } catch (e) {
          print('  ❌ Failed to convert: $e');
        }
      }

      print(
          '🔍 Successfully converted ${modelOrders.length}/${rawOrders.length} orders to models');

      // Update the controller with the converted orders
      allOrders.assignAll(modelOrders);
      _rebuildLists();
    } catch (e) {
      print('❌ Error fetching orders with raw data: $e');
    }
  }

  void _rebuildLists() {
    print(
        '🔍 DEBUG: _rebuildLists() called with ${allOrders.length} total orders');

    // Debug: Print all order statuses
    print('🔍 DEBUG: All order statuses:');
    for (int i = 0; i < allOrders.length; i++) {
      final order = allOrders[i];
      print('  Order $i: ${order.progress} (${order.progress.toLowerCase()})');
    }

    // Filter active orders (pending, preparing, ready, picked up, transit)
    final activeStatuses = ['pending', 'preparing', 'ready', 'picked up', 'transit'];
    final activeFiltered = allOrders
        .where((o) => activeStatuses.contains(o.progress.toLowerCase()))
        .toList();
    print('🔍 DEBUG: Found ${activeFiltered.length} active orders (pending, preparing, ready, picked up, transit)');
    activeOrders.assignAll(activeFiltered.map(_mapToUi).toList());

    // Filter completed orders (completed or delivered)
    final completedStatuses = ['completed', 'delivered'];
    final completedFiltered = allOrders
        .where((o) => completedStatuses.contains(o.progress.toLowerCase()))
        .toList();
    print('🔍 DEBUG: Found ${completedFiltered.length} completed orders (completed, delivered)');
    completedOrders.assignAll(
        completedFiltered.map((o) => _mapToUi(o, isCompleted: true)).toList());

    // Filter cancelled orders
    final cancelledFiltered = allOrders
        .where((o) => o.progress.toLowerCase() == 'cancelled')
        .toList();
    print('🔍 DEBUG: Found ${cancelledFiltered.length} cancelled orders');
    cancelledOrders.assignAll(
        cancelledFiltered.map((o) => _mapToUi(o, isCancelled: true)).toList());

    print(
        '🔍 DEBUG: Final counts - Active: ${activeOrders.length}, Completed: ${completedOrders.length}, Cancelled: ${cancelledOrders.length}');
  }

  Map<String, dynamic> _mapToUi(OrderModel order,
      {bool isCompleted = false, bool isCancelled = false}) {
    final productCount = order.products.length;
    final firstImage =
        productCount > 0 ? order.products.first.image : TImages.mixedSalad;
    final firstName = productCount > 0 ? order.products.first.name : 'Order';
    final total = order.products
        .fold<double>(0.0, (sum, p) => sum + (p.price * (p.cartQuantity)));
    return {
      'id': order.id,
      'orderNumber': order.orderNumber,
      'formattedOrderNumber': order.formattedOrderNumber,
      'status': order.progress,
      'restaurantName': firstName,
      'itemsInfo': '$productCount items',
      'price': total,
      'isCompleted': isCompleted,
      'isCancelled': isCancelled,
      'imageUrl': firstImage,
      'location': order.location ?? 'Location not specified',
      'cancelledDate':
          isCancelled ? _formatDate(order.endTime ?? order.startTime) : null,
      'completedDate':
          isCompleted ? _formatDateTime(order.endTime ?? order.startTime) : null,
    };
  }

  void leaveReview(int index) {
    Get.to(const WhatsYourMind());
  }

  void orderAgain(int index) {
    if (kDebugMode) print('Ordering again for order at index: $index');
  }

  void cancelOrder(int index) {
    final orderId = activeOrders[index]['id'] as String;
    Get.to(CancelOrderScreen(orderId: orderId));
  }

  // void trackOrder(int index) {
  //   Get.to(const TrackOrderScreen());
  // }

  var reasons = [
    "Waiting for long time",
    "Unable to contact driver",
    "Driver denied to go to destination",
    "Driver denied to come to pickup",
    "Wrong address shown",
    "The price is not reasonable",
    "I want to order another restaurant",
    "I just want to cancel",
    "Others"
  ].obs;

  var selectedReason = ''.obs;
  var customReason = ''.obs;

  void selectReason(String reason) {
    selectedReason.value = reason;
  }

  void setCustomReason(String reason) {
    customReason.value = reason;
  }

  String getCancellationReason() {
    if (selectedReason.value == "Others" && customReason.value.isNotEmpty) {
      return customReason.value;
    }
    return selectedReason.value;
  }

  final List<String> myEmojis = [
    "😊",
    "😍",
    "😎",
    "🤩",
    "😂",
    "🤔",
    "😐",
    "😕",
    "😞",
    "😡",
    "👍",
    "👎",
    "🙌",
    "🎉",
    "💡",
    "🙏"
  ];

  var emojiBorderStates = <bool>[].obs;

  void initializeEmojiList(List<String> emojis) {
    emojiBorderStates.value = List<bool>.filled(emojis.length, false);
  }

  void toggleBorder(int index) {
    emojiBorderStates[index] = !emojiBorderStates[index];
  }

  final List<int> tips = [1, 2, 4, 6, 8, 10, 12, 14];

  var selectedTip = 0.obs;

  void updateSelectedTip(int tip) {
    selectedTip.value = tip;
  }

  Future<void> submitOrderCancellation(String orderId) async {
    final reason = getCancellationReason();
    await _repository.updateOrderProgress(
        orderId: orderId, progress: 'cancelled', cancellationReason: reason);
    
    // Refresh orders to immediately reflect the cancellation
    await _fetchOrdersWithRawData();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Manually refresh orders (useful after creating new orders)
  Future<void> refreshOrders() async {
    print('🔍 Manually refreshing orders...');
    await _fetchOrdersWithRawData();
  }

  /// Debug method to print all order details
  void debugPrintAllOrders() {
    print('🔍 DEBUG: === ALL ORDERS DETAILS ===');
    print('Total orders: ${allOrders.length}');
    for (int i = 0; i < allOrders.length; i++) {
      final order = allOrders[i];
      print('Order $i:');
      print('  ID: ${order.id}');
      print('  Customer Email: ${order.customerEmail}');
      print('  Progress: ${order.progress}');
      print('  Start Time: ${order.startTime}');
      print('  End Time: ${order.endTime}');
      print('  Products Count: ${order.products.length}');
      print('  Total Amount: ${order.totalAmount}');
      print('  Location: ${order.location}');
      print('  Branch ID: ${order.branchId}');
      print('  ---');
    }
    print('🔍 DEBUG: === END ORDERS DETAILS ===');
  }
}
