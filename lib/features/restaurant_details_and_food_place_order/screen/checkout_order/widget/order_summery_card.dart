import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../controller/order_controller.dart';
import '../../../controller/checkout_controller.dart';
import '../../../model/order_item_model.dart';

class OrderSummaryCard extends StatelessWidget {
  OrderSummaryCard({super.key, required this.title, this.product});

  final String title;
  final FoodModel? product;
  final RestaurantOrderController orderController =
      Get.put(RestaurantOrderController());

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.symmetric(vertical: TSizes.xm),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.xm),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Add Items Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              // TextButton(
              //   onPressed: () {
              //     orderController.addItem(
              //       OrderItem(name: 'Mixid Salad', imageUrl: TImages.mixedSalad, price: 10.0, quantity: 1),
              //     );
              //   },
              //   child: Text('Add Items', style: Theme.of(context).textTheme.labelLarge),
              // ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Order Items List
          product != null
              ? _buildProductItem(product!, context)
              : Obx(() {
                  if (orderController.orderItems.isEmpty) {
                    // return _buildEmptyCartState(context);
                  }
                  return Column(
                    spacing: TSizes.sm,
                    children: orderController.orderItems
                        .asMap()
                        .entries
                        .map((entry) =>
                            _buildOrderItem(entry.key, entry.value, context))
                        .toList(),
                  );
                }),
        ],
      ),
    );
  }

  Widget _buildOrderItem(int index, OrderItem item, BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        // Item Image
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.sm),
          child: Image.network(
            item.imageUrl,
            height: 70.0,
            width: 70.0,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(16),
        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.textWhite : Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'GHS ${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Quantity Controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrease or Remove Button
            item.quantity > 1
                ? IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: TColors.primary,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      orderController.editItem(
                        index,
                        OrderItem(
                          name: item.name,
                          imageUrl: item.imageUrl,
                          price: item.price,
                          quantity: item.quantity - 1,
                        ),
                      );
                    },
                  )
                : IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      orderController.removeItem(index);
                    },
                  ),

            // Quantity Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${item.quantity}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? TColors.textWhite : Colors.black87,
                    ),
              ),
            ),

            // Increase Button
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: TColors.primary,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                orderController.editItem(
                  index,
                  OrderItem(
                    name: item.name,
                    imageUrl: item.imageUrl,
                    price: item.price,
                    quantity: item.quantity + 1,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductItem(FoodModel product, BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.sm),
          child: _buildImage(product.image, height: 70.0, width: 70.0),
        ),
        const Gap(16),
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.textWhite : Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'GHS ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Quantity Controls
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              // Quantity Display
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.primary),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                        '${CheckoutController.instance.productQuantity.value}x',
                        style: Theme.of(context).textTheme.labelLarge),
                  )),
              // Quantity Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decrease Button
                  IconButton(
                    icon: const Icon(Icons.remove,
                        color: TColors.primary, size: 20),
                    onPressed: () {
                      CheckoutController.instance.decreaseQuantity();
                    },
                  ),
                  // Increase Button
                  IconButton(
                    icon:
                        const Icon(Icons.add, color: TColors.primary, size: 20),
                    onPressed: () {
                      CheckoutController.instance.increaseQuantity();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String path, {double? height, double? width}) {
    final isNetwork = path.startsWith('http');
    if (isNetwork) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }
}
