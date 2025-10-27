import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// Dispatcher Management Screen - Placeholder
/// Note: This feature is deprecated. The system now works with orders and their progress status.
class DispatcherManagementScreen extends StatelessWidget {
  const DispatcherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatcher Management'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.info_circle,
                size: 80,
                color: TColors.primary.withOpacity(0.5),
              ),
              const SizedBox(height: TSizes.spaceBtwSection),
              Text(
                'Feature Under Redesign',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.md),
              Text(
                'Dispatcher management is being redesigned.\n\nThe system now works with orders and their progress status. Use the Dispatcher Dashboard to view and manage order deliveries.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSection),
              ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.lg,
                    vertical: TSizes.md,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
