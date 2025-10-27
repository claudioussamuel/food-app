import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/dispatcher/controller/dispatcher_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ReadyOrdersScreen extends StatelessWidget {
  const ReadyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DispatcherController>();

    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text('Ready Orders'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: TSizes.spaceBtwItems),
                Text('Loading ready orders...'),
              ],
            ),
          );
        }

        if (controller.readyOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Icon(
                  Iconsax.box_tick,
                  size: 80,
                  color: TColors.textGrey,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'No Ready Orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Text(
                  'All orders have been picked up or are still being prepared.',
                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                        color: TColors.textGrey,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwSection),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshData(),
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: Column(
            children: [
              // Header with count
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: TColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                   const Icon(
                      Iconsax.box_tick,
                      color: TColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems / 2),
                    Text(
                      '${controller.readyOrders.length} Orders Ready',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: TColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              // Orders list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  itemCount: controller.readyOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.readyOrders[index];
                    return _buildOrderCard(context, order, controller);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order,
      DispatcherController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${(order['id'] as String).substring(0, 8)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customer: ${order['customerEmail'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                            color: TColors.textGrey,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm,
                    vertical: TSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    border: Border.all(
                      color: TColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'READY',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: TColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Order details
            Row(
              children: [
                const Icon(
                  Iconsax.clock,
                  size: 16,
                  color: TColors.textGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ordered: ${_formatTime(_parseTimestamp(order['startTime']))}',
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                        color: TColors.textGrey,
                      ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
              const Icon(
                  Iconsax.call,
                  size: 16,
                  color: TColors.textGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  order['customerNumber'] ?? 'N/A',
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                        color: TColors.textGrey,
                      ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            // Location (clickable)
            InkWell(
              onTap: () => _openMapWithDirections(order['location']),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.xs,
                  vertical: TSizes.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: TColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.location,
                      size: 16,
                      color: TColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order['location'] ?? 'No location specified',
                        style: Theme.of(context).textTheme.bodySmall?.apply(
                              color: TColors.primary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Iconsax.arrow_right_3,
                      size: 14,
                      color: TColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            // Products count and total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(order['products'] as List?)?.length ?? 0} items',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'GHS ${_calculateTotal(order).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Pickup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.pickupOrder(order),
                icon: const Icon(Iconsax.box_tick),
                label: const Text('Pick Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Parse timestamp from raw data
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now();
    }

    if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp is Map && timestamp.containsKey('_seconds')) {
      final seconds = timestamp['_seconds'] as int;
      final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + (nanoseconds ~/ 1000000));
    }
    return DateTime.now();
  }

  /// Calculate total amount from raw order data
  double _calculateTotal(Map<String, dynamic> order) {
    final products = order['products'] as List?;
    if (products == null || products.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var product in products) {
      if (product is Map<String, dynamic>) {
        final price = (product['price'] as num?)?.toDouble() ?? 0.0;
        final quantity = (product['cartQuantity'] as num?)?.toInt() ?? 1;
        total += price * quantity;
      }
    }
    return total;
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Open map with directions from current location to destination
  Future<void> _openMapWithDirections(String? destination) async {
    if (destination == null || destination.isEmpty || destination == 'Pickup') {
      Get.snackbar(
        'No Location',
        'This order has no delivery location specified',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.warning,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Opening map...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.back(); // Close loading
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to get directions',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.back(); // Close loading
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to get directions',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: TColors.error,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.back(); // Close loading
        Get.snackbar(
          'Permission Denied',
          'Please enable location permission in app settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Get.back(); // Close loading

      // Encode destination for URL
      final encodedDestination = Uri.encodeComponent(destination);
      
      // Try Google Maps first (works on both Android and iOS)
      final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$encodedDestination&travelmode=driving',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to platform-specific maps
        final Uri fallbackUrl;
        if (GetPlatform.isIOS) {
          // Apple Maps
          fallbackUrl = Uri.parse(
            'http://maps.apple.com/?saddr=${position.latitude},${position.longitude}&daddr=$encodedDestination',
          );
        } else {
          // Generic geo intent for Android
          fallbackUrl = Uri.parse(
            'geo:${position.latitude},${position.longitude}?q=$encodedDestination',
          );
        }

        if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(
            fallbackUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          Get.snackbar(
            'Error',
            'Could not open maps application',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: TColors.error,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      // Close loading if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      print('Error opening map: $e');
      Get.snackbar(
        'Error',
        'Failed to open map: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
