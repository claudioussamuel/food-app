import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/menu/category_repository.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/utils/helpers/image_provider.dart' as timg;
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:foodu/features/home_action_menu/controller/category_controller.dart';
import 'package:iconsax/iconsax.dart';

class CategoryCrudScreen extends StatelessWidget {
  const CategoryCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CategoryRepository();
    Get.put(CategoryController(), permanent: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCategoryDialog(context, repo, null),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: repo.categories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No categories yet.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final c = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.sm,
                ),
                child: _CategoryCard(
                  name: c.name,
                  imageUrl: c.image,
                  onEdit: () => _openCategoryDialog(context, repo, c),
                  onDelete: () async {
                    await repo.deleteItem(c);
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

  Future<void> _openCategoryDialog(
    BuildContext context,
    CategoryRepository repo,
    CategoryModel? cat,
  ) async {
    final name = TextEditingController(text: cat?.name ?? '');
    final image = TextEditingController(text: cat?.image ?? '');
    // Selected branches list (IDs)
    final List<String> selectedBranchIds = List<String>.from(
      cat?.availableBranches ?? const <String>[],
    );
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
              final categoryController = CategoryController.instance;

              Future<void> pickFromGallery() async {
                final url = await categoryController.pickImageAndUpload(
                  suggestedName: name.text,
                );
                if (url != null) {
                  setState(() {
                    image.text = url;
                  });
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat == null ? 'Add Category' : 'Edit Category',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        child: image.text.isEmpty
                            ? const Icon(Icons.image, color: Colors.white)
                            : null,
                        backgroundColor: TColors.primary.withOpacity(0.2),
                      ),
                      const SizedBox(width: TSizes.md),
                      Expanded(
                        child: TextFormField(
                          controller: name,

                          decoration: const InputDecoration(
                            labelText: 'Category name',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.md),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => OutlinedButton.icon(
                            onPressed: categoryController.isUploading.value
                                ? null
                                : pickFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: Text(
                              categoryController.isUploading.value
                                  ? 'Uploading...'
                                  : 'Pick from gallery',
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          'Select which branches this category will be available at',
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
                            if (categoryController.isUploading.value) return;
                            if (name.text.trim().isEmpty ||
                                image.text.trim().isEmpty) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Name and image are required',
                                    ),
                                  ),
                                );
                              }
                              return;
                            }

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

                            if (cat == null) {
                              await categoryController.addCategoryWithBranches(
                                name: name.text,
                                imageUrl: image.text,
                                availableBranches: selectedBranchIds,
                              );
                            } else {
                              await categoryController.updateCategoryWithBranches(
                                id: cat.id,
                                name: name.text,
                                imageUrl: image.text,
                                availableBranches: selectedBranchIds,
                              );
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Text(cat == null ? 'Add' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.name,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final String imageUrl;
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: timg.imageProviderFromString(imageUrl),
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: TSizes.md),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
