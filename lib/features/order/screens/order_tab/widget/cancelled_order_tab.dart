import 'package:flutter/cupertino.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/order/screens/order_tab/widget/cancelled_order_card.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CancelledOrder extends StatelessWidget {
  const CancelledOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Padding(
      padding: TSpacingStyles.paddingWithHeightWidth,
      child: Obx(
        () => ListView.builder(
          itemCount: controller.cancelledOrders.length,
          itemBuilder: (context, index) {
            var order = controller.cancelledOrders[index];
            return CancelledOrderCard(
              restaurantName: order['restaurantName'],
              itemsInfo: order['itemsInfo'],
              price: order['price'],
              isCancelled: true,
              imageUrl: order['imageUrl'],
              cancelledDate: order['cancelledDate'],
            );
          },
        ),
      ),
    );
  }
}
