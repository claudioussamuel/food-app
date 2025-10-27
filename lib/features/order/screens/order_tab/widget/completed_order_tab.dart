import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/order/screens/order_tab/widget/completd_order_card.dart';
import 'package:foodu/features/order/widgets/order_expense_chart.dart';
import 'package:foodu/features/order/screens/order_detail/order_detail_modal.dart';
import 'package:get/get.dart';

class CompletedOrderTab extends StatelessWidget {
  const CompletedOrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;

    return Obx(
      () => Column(
        children: [
          // Expense Chart
          OrderExpenseChart(
            orders: controller.completedOrders,
            title: 'Completed Orders Flow',
            subtitle: 'Last twenty completed orders',
          ),
          
          // Orders List
          Expanded(
            child: Padding(
              padding: TSpacingStyles.paddingWithHeightWidth,
              child: ListView.builder(
                itemCount: controller.completedOrders.length,
                itemBuilder: (context, index) {
                  var order = controller.completedOrders[index];
                  return GestureDetector(
                    onTap: () => _showOrderDetail(context, order),
                    child: CompletedOrderCard(
                      restaurantName: order['restaurantName'],
                      itemsInfo: order['itemsInfo'],
                      price: order['price'],
                      isCompleted: true,
                      imageUrl: order['imageUrl'],
                      completedDate: order['completedDate'],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailModal(order: order),
    );
  }
}
