import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controller/profile_form_controller.dart';

class GenderSelectionButton extends StatelessWidget {
  const GenderSelectionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = ProfileFormController.instance;
    return Container(
      width: double.infinity,
      height: TSizes.textFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: TSizes.appBarHeight),
      decoration: ShapeDecoration(
        color: isDark ? TColors.darkCard : TColors.textFieldFillColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.md),
        ),
      ),
      child: Obx(
        () => DropdownButton(
          padding: const EdgeInsets.symmetric(vertical: 10),
          value: controller.dropDownValue.value,
          style: Theme.of(context).textTheme.bodySmall,
          elevation: 0,
          borderRadius: BorderRadius.circular(TSizes.md),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.keyboard_arrow_down),

          // Getting data from ProfileFormController
          items: controller.items.map((String item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),

          onChanged: (String? newValue) {
            controller.dropDownValue.value = newValue!;
          },
        ),
      ),
    );
  }
}
