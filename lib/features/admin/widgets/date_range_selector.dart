import 'package:flutter/material.dart';
import 'package:foodu/features/admin/controller/branch_specific_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BranchSpecificController>();

    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                color: TColors.primary,
                size: 20,
              ),
              const SizedBox(width: TSizes.sm),
              Text(
                'Date Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const Spacer(),
              Obx(() => Text(
                controller.dateRangeText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              )),
            ],
          ),
          
          const SizedBox(height: TSizes.md),
          
          // Date Range Options
          Obx(() => Row(
            children: controller.dateRangeOptions.map((option) {
              final isSelected = controller.selectedDateRange.value == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _handleDateRangeSelection(option, controller, context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? TColors.primary : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? TColors.primary : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
          
          // Custom Date Range Display
          Obx(() {
            if (controller.selectedDateRange.value == 'Custom') {
              return Column(
                children: [
                  const SizedBox(height: TSizes.md),
                  Container(
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: TColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: TColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: TSizes.xs),
                        Expanded(
                          child: Text(
                            'Custom range: ${DateFormat('MMM dd').format(controller.customStartDate.value)} - ${DateFormat('MMM dd, yyyy').format(controller.customEndDate.value)}',
                            style: TextStyle(
                              color: TColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showDateRangePicker(controller, context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: TColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _handleDateRangeSelection(String option, BranchSpecificController controller, BuildContext context) {
    if (option == 'Custom') {
      _showDateRangePicker(controller, context);
    } else {
      controller.updateDateRange(option);
    }
  }

  Future<void> _showDateRangePicker(BranchSpecificController controller, BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.customStartDate.value,
        end: controller.customEndDate.value,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateCustomDateRange(picked.start, picked.end);
      controller.updateDateRange('Custom');
    }
  }
}
