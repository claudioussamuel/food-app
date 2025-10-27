import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/controller/filter_controller.dart';
import 'package:foodu/features/home_action_menu/screens/filter/widget/filter_selection.dart';
import 'package:foodu/utils/constants/exports.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());

    return DefaultTabController(
      length: controller.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              isScrollable: true,
              tabs: controller.tabs.map((tabName) {
                return Tab(text: tabName);
              }).toList(),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Obx(() => FilterSection(
                    title: 'Sort by',
                    radioButton: true,
                    options: controller.sortByOptions,
                    selectedOptions: controller.selectedSortByIndex.value,
                    onOptionSelected: (index) {
                      controller.toggleOption(0, index);
                    },
                  )),
              const Gap(TSizes.spaceBtwItems),
              Obx(() => FilterSection(
                    title: 'Restaurant',
                    radioButton: true,
                    options: controller.restaurantOptions,
                    selectedOptions: controller.restaurantSelectedByIndex.value,
                    onOptionSelected: (index) {
                      controller.toggleOption(1, index);
                    },
                  )),
              const Gap(TSizes.spaceBtwItems),
              Obx(() => FilterSection(
                    title: 'Delivery Fee',
                    radioButton: true,
                    options: controller.deliveryFeeOptions,
                    selectedOptions: controller.selectedDeliveryFeeIndex.value,
                    onOptionSelected: (index) {
                      controller.toggleOption(2, index);
                    },
                  )),
              const Gap(TSizes.spaceBtwItems),
              Obx(() => FilterSection(
                    title: 'Mode',
                    radioButton: true,
                    options: controller.modeOptions,
                    selectedOptions: controller.selectedModeIndex.value,
                    onOptionSelected: (index) {
                      controller.toggleOption(3, index);
                    },
                  )),
              const Gap(TSizes.spaceBtwItems),
              FilterSection(
                title: 'Cuisines',
                radioButton: false,
                options: controller.cuisinesOptions,
                selectedOptions: controller.cuisinesSelected,
                onOptionSelected: (index) {
                  controller.toggleOption(4, index);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFE8F7ED),
                      side: const BorderSide(color: Color(0xFFE8F7ED)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      textStyle: const TextStyle(fontSize: 14, color: TColors.primary, fontWeight: FontWeight.w700)),
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: TColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
