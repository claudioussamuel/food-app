import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/help_center_controller.dart';
import 'widget/contect_option_widget.dart';
import 'widget/faq_widget.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpCenterController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help Center'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              isScrollable: true,
              tabs: controller.tabs.map((tabName) => Tab(text: tabName)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //Faq
            FaqWidget(controller: controller),
            const ContactOptionsWidget(),
          ],
        ),
      ),
    );
  }
}
