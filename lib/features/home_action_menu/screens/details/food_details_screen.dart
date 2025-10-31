import 'package:flutter/material.dart';
import 'package:foodu/features/home_action_menu/model/search_food_item_model.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FoodDetailsScreen extends StatelessWidget {
  final SearchFoodItemModel item;
  const FoodDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(item.image),
            ),
            const SizedBox(height: TSizes.md),
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: TSizes.xs),
            Text('GHS ${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.md),
            Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    final isNetwork = path.startsWith('http');
    if (isNetwork) {
      return Image.network(
        path,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 220,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),
      );
    }
    return Image.asset(
      path,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
