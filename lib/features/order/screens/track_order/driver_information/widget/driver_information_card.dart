import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

class DriverInformationCard extends StatelessWidget {
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;
  final double rating;
  final int orders;
  final int years;
  final String memberSince;
  final String vehicleModel;
  final String plateNumber;

  const DriverInformationCard({
    super.key,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverImageUrl,
    required this.rating,
    required this.orders,
    required this.years,
    required this.memberSince,
    required this.vehicleModel,
    required this.plateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Profile picture and name
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(driverImageUrl),
        ),
        const SizedBox(height: 16),
        Text(driverName, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(driverPhoneNumber, style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.textGrey)),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: TColors.primary, size: 16),
          ],
        ),
        const SizedBox(height: 24),
        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(Icons.star, rating.toString(), 'Ratings'),
                  _buildStatColumn(Icons.shopping_bag, orders.toString(), 'Orders'),
                  _buildStatColumn(Icons.access_time, years.toString(), 'Years'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Additional Information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Member Since', memberSince),
                  const SizedBox(height: 8),
                  _buildInfoRow('Motorcycle Model', vehicleModel),
                  const SizedBox(height: 8),
                  _buildInfoRow('Plate Number', plateNumber),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: TColors.primary, size: 32),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(Get.context!).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(Get.context!).textTheme.titleSmall),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(Get.context!).textTheme.titleSmall),
        Text(value, style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(fontWeightDelta: 2)),
      ],
    );
  }
}
