import 'package:flutter/material.dart';
import 'package:foodu/features/order/controller/order_controller.dart';
import 'package:foodu/features/order/screens/order_tab/widget/active_order_tab.dart';
import 'package:foodu/features/order/screens/order_tab/widget/cancelled_order_tab.dart';
import 'package:foodu/features/order/screens/order_tab/widget/completed_order_tab.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Scaffold(
      appBar: AppBar(
        /// Appbar Title
        title: Text('Orders', style: Theme.of(context).textTheme.titleLarge),
        leading: Padding(
          padding: const EdgeInsets.only(left: TSizes.defaultSpace),
          child: Image.asset(TImages.appLogo),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: TabBar(
            controller: controller.tabController,
            tabAlignment: TabAlignment.fill,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            isScrollable: false,
            labelStyle: const TextStyle(fontSize: 17),
            tabs: controller.tabs.map((tabName) {
              return Tab(text: tabName);
            }).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          ActiveOrderTab(),
          CompletedOrderTab(),
          CancelledOrder(),
        ],
      ),
    );
  }
}
