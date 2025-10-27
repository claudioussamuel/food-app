import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/image_provider.dart' as timg;
import 'package:get/get.dart';
import 'package:foodu/features/home_action_menu/controller/product_controller.dart';
import 'package:foodu/data/repositories/menu/category_repository.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:iconsax/iconsax.dart';

class FoodCrudScreen extends StatelessWidget {
  const FoodCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ProductRepository();
    Get.put(ProductController(), permanent: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Meals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFoodDialog(context, repo, null),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<FoodModel>>(
        stream: repo.products(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No meals yet.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.sm,
                ),
                child: _MealCard(
                  name: p.name,
                  price: p.price,
                  imageUrl: p.image,
                  categoriesCount: p.categoryName.length,
                  onEdit: () => _openFoodDialog(context, repo, p),
                  onDelete: () async {
                    await repo.deleteItem(p);
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Deleted')));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openFoodDialog(
    BuildContext context,
    ProductRepository repo,
    FoodModel? product,
  ) async {
    final name = TextEditingController(text: product?.name ?? '');
    final description = TextEditingController(text: product?.description ?? '');
    final price = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );
    final image = TextEditingController(text: product?.image ?? '');
    // Selected categories list (IDs)
    final List<String> selectedCategoryIds = List<String>.from(
      product?.categoryName ?? const <String>[],
    );
    // Selected branches list (IDs)
    final List<String> selectedBranchIds = List<String>.from(
      product?.availableBranches ?? const <String>[],
    );
    final categoryRepo = CategoryRepository();
    final branchController = Get.find<BranchController>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            top: TSizes.defaultSpace,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + TSizes.defaultSpace,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final productController = ProductController.instance;

              Future<void> pickFromGallery() async {
                final url = await productController.pickImageAndUpload(
                  suggestedName: name.text,
                );
                if (url != null) {
                  setState(() {
                    image.text = url;
                  });
                }
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product == null ? 'Add Meal' : 'Edit Meal',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                              ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.md),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: image.text.isEmpty
                              ? null
                              : timg.imageProviderFromString(image.text),
                          backgroundColor: TColors.primary.withOpacity(0.2),
                          child: image.text.isEmpty
                              ? const Icon(Icons.image, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: TSizes.md),
                        Expanded(
                          child: TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              labelText: 'Meal name',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.md),
                    TextFormField(
                      controller: description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: TSizes.md),
                    TextFormField(
                      controller: price,

                      decoration: const InputDecoration(
                        labelText: 'Price (GHS)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: TSizes.md),
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.borderLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: StreamBuilder<List<CategoryModel>>(
                        stream: categoryRepo.categories(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(TSizes.md),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final cats = snapshot.data!;
                          if (cats.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(TSizes.md),
                                child: Text('No categories found'),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: cats.length,
                            itemBuilder: (context, index) {
                              final c = cats[index];
                              final checked = selectedCategoryIds.contains(
                                c.id,
                              );
                              return CheckboxListTile(
                                value: checked,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      if (!selectedCategoryIds.contains(c.id)) {
                                        selectedCategoryIds.add(c.id);
                                      }
                                    } else {
                                      selectedCategoryIds.remove(c.id);
                                    }
                                  });
                                },
                                title: Text(c.name),
                                secondary: CircleAvatar(
                                  backgroundImage: timg.imageProviderFromString(
                                    c.image,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: TSizes.md),
                    
                    // Branch Selection Section
                    Container(
                      padding: const EdgeInsets.all(TSizes.md),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                        border: Border.all(
                          color: TColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.building,
                                color: TColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: TSizes.sm),
                              Text(
                                'Available Branches',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.sm),
                          Text(
                            'Select which branches this product will be available at',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TColors.darkGrey,
                            ),
                          ),
                          const SizedBox(height: TSizes.md),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                              border: Border.all(color: TColors.grey),
                            ),
                            child: Obx(() {
                              final branches = branchController.branches
                                  .where((branch) => branch.isActive)
                                  .toList();
                              
                              if (branches.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(TSizes.md),
                                    child: Text('No active branches found'),
                                  ),
                                );
                              }
                              
                              return ListView.builder(
                                itemCount: branches.length,
                                itemBuilder: (context, index) {
                                  final branch = branches[index];
                                  final checked = selectedBranchIds.contains(branch.id);
                                  
                                  return CheckboxListTile(
                                    value: checked,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          if (!selectedBranchIds.contains(branch.id)) {
                                            selectedBranchIds.add(branch.id);
                                          }
                                        } else {
                                          selectedBranchIds.remove(branch.id);
                                        }
                                      });
                                    },
                                    title: Text(branch.name),
                                    subtitle: Text(
                                      branch.address,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: TColors.darkGrey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    secondary: Container(
                                      padding: const EdgeInsets.all(TSizes.xs),
                                      decoration: BoxDecoration(
                                        color: TColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                                      ),
                                      child: Icon(
                                        Iconsax.building,
                                        color: TColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    dense: true,
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.md),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => OutlinedButton.icon(
                              onPressed: productController.isUploading.value
                                  ? null
                                  : pickFromGallery,
                              icon: const Icon(Icons.photo_library),
                              label: Text(
                                productController.isUploading.value
                                    ? 'Uploading...'
                                    : 'Pick from gallery',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.lg),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: TSizes.md),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (productController.isUploading.value) return;
                              final parsedPrice =
                                  double.tryParse(price.text.trim()) ?? 0;
                              // Validation: At least one branch must be selected
                              if (selectedBranchIds.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select at least one branch'),
                                      backgroundColor: TColors.error,
                                    ),
                                  );
                                }
                                return;
                              }
                              
                              final model = FoodModel(
                                id: product?.id ?? name.text.trim(),
                                name: name.text.trim(),
                                description: description.text.trim(),
                                categoryName: selectedCategoryIds,
                                price: parsedPrice,
                                image: image.text.trim(),
                                cartQuantity: product?.cartQuantity ?? 0,
                                availableBranches: selectedBranchIds,
                              );
                              if (product == null) {
                                await productController.addProduct(model);
                              } else {
                                await productController.updateProduct(model);
                              }
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Text(product == null ? 'Add' : 'Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.categoriesCount,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final double price;
  final String imageUrl;
  final int categoriesCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: timg.imageProviderFromString(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: TSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: TSizes.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.buttonSecondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'GHS ${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: TColors.primary),
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Flexible(
                      child: Text(
                        categoriesCount == 1
                            ? '1 category'
                            : '$categoriesCount categories',
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: TColors.primary),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
