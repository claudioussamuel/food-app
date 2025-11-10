import 'package:flutter/material.dart';
import 'package:foodu/features/admin/screens/branch_location_picker_screen.dart';
import 'package:foodu/features/admin/screens/branch_specific_admin_screen.dart';
import 'package:foodu/features/admin/screens/manage_admins_screen.dart';
import 'package:foodu/features/dispatcher/screens/dispatcher_management_screen.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchManagementScreen extends StatelessWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BranchController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Management'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showBranchStats(context, controller),
            icon: const Icon(Icons.analytics),
            tooltip: 'Branch Statistics',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Management Options',
            onSelected: (value) {
              if (value == 'admins') {
                Get.to(() => const ManageAdminsScreen());
              } else if (value == 'dispatchers') {
                Get.to(() => const DispatcherManagementScreen());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'admins',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, size: 20),
                    SizedBox(width: 12),
                    Text('Manage Admins'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'dispatchers',
                child: Row(
                  children: [
                    Icon(Icons.delivery_dining, size: 20),
                    SizedBox(width: 12),
                    Text('Manage Dispatchers'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBranchDialog(context, controller, null),
        backgroundColor: TColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search branches...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          
          // Branches List
          Expanded(
            child: StreamBuilder<List<BranchModel>>(
              stream: controller.getBranchesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store, size: 64, color: Colors.grey),
                        SizedBox(height: TSizes.md),
                        Text('No branches found'),
                        SizedBox(height: TSizes.sm),
                        Text('Tap + to add your first branch'),
                      ],
                    ),
                  );
                }
                
                final branches = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return _BranchCard(
                      branch: branch,
                      onTap: () => _navigateToBranchDashboard(branch),
                      onEdit: () => _openBranchDialog(context, controller, branch),
                      onDelete: () => _confirmDelete(context, controller, branch),
                      onToggleStatus: () => controller.toggleBranchStatus(branch.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to branch-specific dashboard
  void _navigateToBranchDashboard(BranchModel branch) {
    Get.to(() => BranchSpecificAdminScreen(branch: branch));
  }

  /// Show branch statistics dialog
  void _showBranchStats(BuildContext context, BranchController controller) async {
    final stats = await controller.getBranchStats();
    
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Branch Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatRow('Total Branches', stats['total'].toString()),
              _StatRow('Active Branches', stats['active'].toString()),
              _StatRow('Inactive Branches', stats['inactive'].toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  /// Open branch add/edit dialog
  void _openBranchDialog(BuildContext context, BranchController controller, BranchModel? branch) {
    final nameController = TextEditingController(text: branch?.name ?? '');
    final phoneController = TextEditingController(text: branch?.phone ?? '');
    final descriptionController = TextEditingController(text: branch?.description ?? '');
    
    // Location variables
    LatLng? selectedLocation = branch != null 
        ? LatLng(branch.latitude, branch.longitude) 
        : null;
    String selectedAddress = branch?.address ?? '';

    showModalBottomSheet(
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
            bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.defaultSpace,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      branch == null ? 'Add Branch' : 'Edit Branch',
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
                
                // Branch Name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Branch Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.store),
                  ),
                ),
                const SizedBox(height: TSizes.md),
                
                
                // Location Picker
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Location Picker Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => BranchLocationPickerScreen(
                              initialLocation: selectedLocation,
                              initialAddress: selectedAddress,
                              onLocationSelected: (location, address) {
                                setState(() {
                                  selectedLocation = location;
                                  selectedAddress = address;
                                });
                              },
                            ));
                          },
                          icon: const Icon(Icons.location_on),
                          label: Text(selectedLocation != null 
                              ? 'Update Location' 
                              : 'Select Location from Map'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedLocation != null 
                                ? TColors.success 
                                : TColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        
                        // Selected Location Display
                        if (selectedLocation != null) ...[
                          const SizedBox(height: TSizes.sm),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: TColors.success.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, 
                                        color: TColors.success, size: 16),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Location Selected',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: TColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Coordinates: ${selectedLocation!.latitude.toStringAsFixed(6)}, ${selectedLocation!.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (selectedAddress.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Address: $selectedAddress',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: TSizes.md),
                
                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: TSizes.md),
                
                // Description
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: TSizes.lg),
                
                // Action Buttons
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
                          if (_validateBranchForm(
                            nameController.text,
                            phoneController.text,
                            selectedLocation,
                          )) {
                            final branchData = BranchModel(
                              id: branch?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text.trim(),
                              address: selectedAddress,
                              latitude: selectedLocation!.latitude,
                              longitude: selectedLocation!.longitude,
                              phone: phoneController.text.trim(),
                              description: descriptionController.text.trim().isEmpty 
                                  ? null 
                                  : descriptionController.text.trim(),
                              createdAt: branch?.createdAt ?? DateTime.now(),
                              updatedAt: branch != null ? DateTime.now() : null,
                            );

                            if (branch == null) {
                              await controller.addBranch(branchData);
                            } else {
                              await controller.updateBranch(branchData);
                            }
                            
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: Text(branch == null ? 'Add' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Validate branch form
  bool _validateBranchForm(String name, String phone, LatLng? location) {
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Branch name is required');
      return false;
    }
    if (phone.trim().isEmpty) {
      Get.snackbar('Error', 'Phone number is required');
      return false;
    }
    if (location == null) {
      Get.snackbar('Error', 'Please select a location from the map');
      return false;
    }
    return true;
  }

  /// Confirm delete dialog
  void _confirmDelete(BuildContext context, BranchController controller, BranchModel branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Branch'),
        content: Text('Are you sure you want to delete "${branch.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.deleteBranch(branch);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _BranchCard({
    required this.branch,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    branch.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: branch.isActive ? TColors.success : TColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    branch.isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branch.address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.xs),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  branch.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (branch.description != null) ...[
              const SizedBox(height: TSizes.xs),
              Text(
                branch.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: TSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onToggleStatus,
                  icon: Icon(
                    branch.isActive ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                  ),
                  label: Text(branch.isActive ? 'Deactivate' : 'Activate'),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
