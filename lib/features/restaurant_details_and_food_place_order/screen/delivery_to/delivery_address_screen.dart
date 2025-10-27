import 'package:flutter/material.dart';
import 'package:foodu/features/restaurant_details_and_food_place_order/screen/delivery_to/widget/address_card.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../controller/address_controller.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: Text(
          "Deliver to",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: Obx(() => Column(
              children: [
                SizedBox(
                  height: THelperFunctions.screenHeight() / 1.4,
                  child: ListView.builder(
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) {
                      var address = controller.addresses[index];
                      return AddressCard(
                        title: address['title'],
                        address: address['address'],
                        isDefault: address['isDefault'],
                        isSelected: controller.selectedAddressIndex.value == index,
                        onTap: () => controller.selectAddress(index),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.addAddress('New Address', '123 New Street, NY', isDefault: false);
                    },
                    child: const Text(
                      'Add new Address',
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Apply',
          ),
        ),
      ),
    );
  }
}
