import 'package:flutter/cupertino.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/order/screens/order_tab/widget/active_order_card.dart';
import 'package:foodu/features/order/screens/order_status/order_status_screen.dart';
import 'package:get/get.dart';

class ActiveOrderTab extends StatelessWidget {
  const ActiveOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Padding(
      padding: TSpacingStyles.paddingWithHeightWidth,
      child: Obx(() => ListView.builder(
            itemCount: controller.activeOrders.length,
            itemBuilder: (context, index) {
              var order = controller.activeOrders[index];
              return GestureDetector(
                onTap: () => Get.to(() => OrderStatusScreen(order: order)),
                child: ActiveOrderCard(
                  restaurantName: order['restaurantName'],
                  itemsInfo: order['itemsInfo'],
                  price: order['price'],
                  isCompleted: false,
                  imageUrl: order['imageUrl'],
                  location: order['location'],
                  onCancelOrder: () => controller.cancelOrder(index),
                  onTrackOrder: () => Get.to(() => OrderStatusScreen(order: order)),
                ),
              );
            },
          )),
    );
  }
}
