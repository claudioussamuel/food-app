import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:get/get.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';
import 'package:foodu/features/personalization/controller/location_controller.dart';
import 'package:foodu/features/personalization/controller/profile_form_controller.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/services/paystack_payment_service.dart';
import 'package:foodu/features/navigation_menu/controller.dart';
import 'package:foodu/data/services/order_number_service.dart';

import '../../../wallet/controller/wallet_controller.dart';
import '../../controller/checkout_controller.dart';
import '../../controller/order_controller.dart';
import '../../model/order_item_model.dart';
import '../../../home_action_menu/controller/cart_controller.dart';
import '../../../order/controller/order_controller.dart' as orders;
import '../finding_nearby_driver/finding_driver.dart';
import 'widget/delivery_address_card.dart';
import 'widget/delivery_option_card.dart';
import 'widget/order_summery_card.dart';

class CheckoutOrderScreen extends StatelessWidget {
  final FoodModel? product;

  const CheckoutOrderScreen({super.key, this.product});

  /// Process order with Paystack payment
  Future<void> _processOrderWithPayment({
    required BuildContext context,
    required CheckoutController checkoutController,
    required RestaurantOrderController orderController,
    required CartController cartController,
    required LocationController locationController,
    required ProfileFormController profileController,
    required PaystackPaymentService paymentService,
    required BranchController branchController,
  }) async {
    try {
      // Build products list for the order
      final List<FoodModel> products = [];

      if (checkoutController.currentProduct.value != null) {
        final p = checkoutController.currentProduct.value!;
        products.add(
          FoodModel(
            id: p.id,
            name: p.name,
            description: p.description,
            categoryName: p.categoryName,
            price: p.price,
            image: p.image,
            cartQuantity: checkoutController.productQuantity.value,
          ),
        );
      } else {
        // Map from the orderController items (synced from cart)
        for (final item in orderController.orderItems) {
          products.add(
            FoodModel(
              id: '',
              name: item.name,
              description: '',
              categoryName: const [],
              price: item.price,
              image: item.imageUrl,
              cartQuantity: item.quantity,
            ),
          );
        }
      }

      if (products.isEmpty) {
        Get.snackbar('No items', 'Your cart is empty.');
        return;
      }

      // Get customer information
      final email = profileController.currentProfile.value?.email ?? '';
      final phone = profileController.currentProfile.value?.phoneNumber ?? '';
      final firstName = profileController.currentProfile.value?.firstName ?? '';
      final lastName = profileController.currentProfile.value?.lastName ?? '';
      final selectedAddress = locationController.locationAddress.value;

      if (email.isEmpty) {
        Get.snackbar('Error', 'Please complete your profile first.');
        return;
      }

      // Validate branch selection
      if (!branchController.hasBranchSelected) {
        Get.snackbar('Error', 'Please select a branch before placing your order.');
        return;
      }

      // Generate payment reference
      final paymentReference = paymentService.generateReference();
      final totalAmount = checkoutController.total;

      // Process payment with Paystack
      final paymentResult = await paymentService.initializePayment(
        email: email,
        amount: totalAmount,
        reference: paymentReference,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone,
      );

      if (paymentResult.isSuccess) {
        // Generate order number based on branch name
        final orderNumberService = OrderNumberService();
        final branchName = branchController.selectedBranch.value!.name;
        final orderNumber = await orderNumberService.generateOrderNumberForBranch(branchName);
        
        // Payment successful - create order
        final order = OrderModel(
          id: '',
          customerEmail: email,
          customerNumber: phone,
          startTime: DateTime.now(),
          products: products,
          progress: 'pending',
          location: checkoutController.isDelivery.value
              ? (selectedAddress.isNotEmpty
                  ? selectedAddress
                  : 'Delivery Address')
              : 'Pickup',
          branchId: branchController.selectedBranch.value!.id,
          orderNumber: orderNumber,
        );

        // Save to Firestore
        final repo = OrderRepository();
        await repo.createOrder(order);

        // Clear UI state after success
        orderController.clearItems();
        cartController.foodCards.clear();

        Get.snackbar(
          'Order Placed Successfully',
          'Order $orderNumber has been created and payment processed',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Navigate back to home and switch to Orders page (Active tab)
        Navigator.of(context).pop();
        
        // Switch to Orders tab in navigation
        final navigationController = Get.find<NavigationController>();
        navigationController.selectedIndex.value = 1; // Orders page is at index 1
        
        // Refresh orders and switch to Active tab in OrderScreen
        final ordersCtrl = Get.find<orders.OrderController>();
        await ordersCtrl.refreshOrders(); // Refresh to show new order
        ordersCtrl.switchToActiveTab();
      } else {
        // Payment failed
        Get.snackbar(
          'Payment Failed',
          paymentResult.message,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(WalletController());
    final orderController = Get.put(RestaurantOrderController());
    final checkoutController = Get.put(CheckoutController());
    final cartController = Get.put(CartController());
    final locationController = Get.put(LocationController());
    final profileController = Get.put(ProfileFormController());
    final paymentService = Get.put(PaystackPaymentService());
    final branchController = Get.put(BranchController());

    // If a single product is provided, use product-quantity flow; otherwise sync cart items
    if (product != null) {
      checkoutController.setProduct(product);
    } else {
      // Map CartController items to OrderItem list for the checkout summary
      final mapped = cartController.foodCards
          .map((c) => OrderItem(
                name: c.title,
                imageUrl: c.imageUrls.isNotEmpty ? c.imageUrls.first : '',
                price: c.price,
                quantity: 1,
              ))
          .toList();
      orderController.setItems(mapped);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Order')),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithHeightWidth,
          child: Column(
            children: [
              const DeliveryOptionCard(),
              // Only show delivery address when delivery is selected
              Obx(() => checkoutController.isDelivery.value
                  ? const DeliveryAddressCard(
                      title: 'Home',
                      address: 'Accra, Ghana',
                      isDefault: true)
                  : const SizedBox.shrink()),
              OrderSummaryCard(title: "Order Summery", product: product),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  await _processOrderWithPayment(
                    context: context,
                    checkoutController: checkoutController,
                    orderController: orderController,
                    cartController: cartController,
                    locationController: locationController,
                    profileController: profileController,
                    paymentService: paymentService,
                    branchController: branchController,
                  );
                },
                child: Obx(() => Text(
                    "Place Order - GHS ${checkoutController.total.toStringAsFixed(2)}")))),
      ),
    );
  }
}
