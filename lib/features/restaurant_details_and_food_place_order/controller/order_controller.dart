import 'package:get/get.dart';

import '../model/order_item_model.dart';

class RestaurantOrderController extends GetxController {
  var orderItems = <OrderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Start with empty cart - items will be synced from CartController on Checkout page
  }

  void addItem(OrderItem item) {
    orderItems.add(item);
  }

  void editItem(int index, OrderItem updatedItem) {
    orderItems[index] = updatedItem;
  }

  void removeItem(int index) {
    orderItems.removeAt(index);
  }

  // Replace the entire list (used to sync from CartController)
  void setItems(List<OrderItem> items) {
    orderItems.assignAll(items);
  }

  // Clear all items
  void clearItems() {
    orderItems.clear();
  }
}
