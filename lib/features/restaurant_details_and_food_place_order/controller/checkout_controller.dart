import 'package:get/get.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/restaurant_details_and_food_place_order/controller/order_controller.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final RxInt productQuantity = 1.obs;
  final Rx<FoodModel?> currentProduct = Rx<FoodModel?>(null);
  final RxBool isDelivery = false.obs; // Default to delivery
  late RestaurantOrderController orderController;

  @override
  void onInit() {
    super.onInit();
    orderController = Get.find<RestaurantOrderController>();
  }

  void setProduct(FoodModel? product) {
    currentProduct.value = product;
    productQuantity.value = 1; // Reset quantity when product changes
  }

  void increaseQuantity() {
    productQuantity.value++;
  }

  void decreaseQuantity() {
    if (productQuantity.value > 1) {
      productQuantity.value--;
    }
  }

  void setDeliveryOption(bool delivery) {
    isDelivery.value = delivery;
  }

  double get subtotal {
    // If we have a current product (single product checkout)
    if (currentProduct.value != null) {
      return (currentProduct.value?.price ?? 0.0) * productQuantity.value;
    }
    // Otherwise, calculate from order items (cart checkout)
    return orderController.orderItems
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee => isDelivery.value ? 0.0 : 0.0;
  double get total => subtotal + deliveryFee;
}
