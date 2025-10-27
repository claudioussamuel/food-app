import 'package:flutter/cupertino.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controller/help_center_controller.dart';
import 'faq_item.dart';

class FaqWidget extends StatelessWidget {
  const FaqWidget({
    super.key,
    required this.controller,
  });

  final HelpCenterController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TSpacingStyles.paddingWithHeightWidth,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.faqs.length,
                itemBuilder: (context, index) {
                  return FAQItem(faq: controller.faqs[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: TSizes.md);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
