import 'package:flutter/material.dart';
import 'package:foodu/features/admin/screens/branch_management_screen.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/features/navigation_menu/navigation_menu.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

class BranchSelectionScreen extends StatelessWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BranchController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Branch'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const BranchManagementScreen()),
            icon: const Icon(Icons.settings),
            tooltip: 'Manage Branches',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColors.primary, TColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              children: [
                const Icon(
                  Icons.store,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: TSizes.sm),
                const Text(
                  'Choose Your Branch',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: TSizes.xs),
                const Text(
                  'Select a branch to manage its products, categories, and orders',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Branch List
          Expanded(
            child: StreamBuilder<List<BranchModel>>(
              stream: controller.getBranchesStream(activeOnly: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: TSizes.md),
                        Text('Loading branches...'),
                      ],
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: TSizes.md),
                        Text(
                          'No Active Branches',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          'Create your first branch to get started',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: TSizes.lg),
                        ElevatedButton.icon(
                          onPressed: () => Get.to(() => const BranchManagementScreen()),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Create Branch',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.lg,
                              vertical: TSizes.md,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final branches = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return _BranchSelectionCard(
                      branch: branch,
                      onTap: () => _selectBranch(branch),
                    );
                  },
                );
              },
            ),
          ),

          // Footer Actions
          Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(() => const BranchManagementScreen()),
                    icon: const Icon(Icons.settings),
                    label: const Text('Manage Branches'),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(() => const BranchManagementScreen()),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Branch',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Select branch and navigate to main admin interface
  void _selectBranch(BranchModel branch) {
    final controller = Get.find<BranchController>();
    controller.selectBranch(branch);
    
    Get.snackbar(
      'Branch Selected',
      'Now managing ${branch.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: TColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Navigate to main admin interface
    Get.offAll(() => const NavigationMenu());
  }
}

class _BranchSelectionCard extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;

  const _BranchSelectionCard({
    required this.branch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Row(
            children: [
              // Branch Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.store,
                  color: TColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: TSizes.md),
              
              // Branch Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            branch.address,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          branch.phone,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (branch.description != null) ...[
                      const SizedBox(height: TSizes.xs),
                      Text(
                        branch.description!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Selection Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: TColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
