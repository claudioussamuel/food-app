import 'package:get/get.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DispatcherReadyController extends GetxController {
  static DispatcherReadyController get instance => Get.find();

  final OrderRepository _orderRepository = Get.put(OrderRepository());

  // Observable variables
  final RxList<OrderModel> readyOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  // Using global stream like dashboard/debug; no branch scoping

  @override
  void onInit() {
    super.onInit();
    loadReadyOrders();
  }

  /// Load ready orders globally (matches dashboard/debug filtering)
  void loadReadyOrders() {
    try {
      isLoading.value = true;

      // Listen to global orders stream and filter Ready
      _orderRepository.getAllOrdersStream().listen(
        (orders) {
          final filtered = orders
              .where((o) => (o.progress).toLowerCase() == 'ready')
              .toList();
          readyOrders.value = filtered;
          isLoading.value = false;
        },
        onError: (error) {
          print('❌ Error loading ready orders: $error');
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Failed to load ready orders: $error',
            backgroundColor: TColors.error,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (error) {
      print('❌ Error in loadReadyOrders: $error');
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load ready orders: $error',
        backgroundColor: TColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Mark order as picked up by dispatcher
  Future<void> pickupOrder(OrderModel order) async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Confirm Pickup'),
              content: Text('Mark order ${order.id} as picked up?'),
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

      // Mark as picked up
      await _orderRepository.markOrderAsPickedUp(order.id);

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Order ${order.id} marked as picked up',
        backgroundColor: TColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('❌ Error picking up order: $error');
      Get.snackbar(
        'Error',
        'Failed to pickup order: $error',
        backgroundColor: TColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Get order count for ready orders
  int get readyOrdersCount => readyOrders.length;

  /// Check if there are ready orders available
  bool get hasReadyOrders => readyOrders.isNotEmpty;

  /// Refresh ready orders
  void refreshOrders() {
    loadReadyOrders();
  }
}
