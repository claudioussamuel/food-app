import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/personalization/profile_repository.dart';
import 'package:foodu/features/personalization/models/profile_model.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';

/// Admin Management Screen with Full CRUD Operations
class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  final _profileRepo = ProfileRepository.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showStatistics,
            icon: const Icon(Icons.analytics),
            tooltip: 'Statistics',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAdminDialog,
        backgroundColor: TColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Admin', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search admins by name, email, or phone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Admins List
          Expanded(
            child: StreamBuilder<List<ProfileModel>>(
              stream: _getAdminsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.admin_panel_settings, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: TSizes.md),
                        Text(
                          'No admins found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          'Tap the + button to add an admin',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                var admins = snapshot.data!;
                
                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  admins = admins.where((admin) {
                    return admin.fullName.toLowerCase().contains(_searchQuery) ||
                        admin.email.toLowerCase().contains(_searchQuery) ||
                        admin.phoneNumber.contains(_searchQuery);
                  }).toList();
                }
                
                if (admins.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: TSizes.md),
                        const Text('No admins match your search'),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                  itemCount: admins.length,
                  itemBuilder: (context, index) {
                    final admin = admins[index];
                    return _AdminCard(
                      admin: admin,
                      onEdit: () => _showEditAdminDialog(admin),
                      onDelete: () => _confirmDelete(admin),
                      onDemote: () => _confirmDemote(admin),
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

  /// Get admins stream from Firestore
  Stream<List<ProfileModel>> _getAdminsStream() {
    return _profileRepo.db
        .collection('profiles')
        .where('role', isEqualTo: 'admin')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProfileModel.fromMap(doc.data()))
            .toList());
  }

  /// Show add admin dialog - Promote user to admin
  void _showAddAdminDialog() async {
    // Get all users who are not admins
    final allProfiles = await _profileRepo.fetchAllItems();
    final availableUsers = allProfiles
        .where((profile) => profile.role == 'user' || profile.role == 'dispatcher')
        .toList();

    if (availableUsers.isEmpty) {
      Get.snackbar(
        'No Users Available',
        'All users are already admins',
        backgroundColor: TColors.warning,
        colorText: Colors.white,
        icon: const Icon(Icons.info, color: Colors.white),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddAdminSheet(users: availableUsers),
    );
  }

  /// Show edit admin dialog
  void _showEditAdminDialog(ProfileModel admin) {
    final firstNameController = TextEditingController(text: admin.firstName);
    final lastNameController = TextEditingController(text: admin.lastName);
    final phoneController = TextEditingController(text: admin.phoneNumber);

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
                      'Edit Admin',
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
                
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: TSizes.md),
                
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: TSizes.md),
                
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
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
                          if (firstNameController.text.trim().isEmpty ||
                              lastNameController.text.trim().isEmpty ||
                              phoneController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Error',
                              'All fields are required',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          try {
                            final updatedAdmin = admin.copyWith(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              phoneNumber: phoneController.text.trim(),
                            );

                            await _profileRepo.updateItem(updatedAdmin);

                            Get.snackbar(
                              'Success',
                              'Admin updated successfully',
                              backgroundColor: TColors.success,
                              colorText: Colors.white,
                              icon: const Icon(Icons.check_circle, color: Colors.white),
                            );
                            
                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to update admin: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save'),
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

  /// Confirm delete admin
  void _confirmDelete(ProfileModel admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Admin'),
        content: Text(
          'Are you sure you want to delete "${admin.fullName}"? This will permanently remove them from the system.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _profileRepo.deleteItem(admin);

                Get.snackbar(
                  'Success',
                  'Admin deleted successfully',
                  backgroundColor: TColors.success,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                );
                
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete admin: $e',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Confirm demote admin to user
  void _confirmDemote(ProfileModel admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demote Admin'),
        content: Text(
          'Are you sure you want to demote "${admin.fullName}" to a regular user? They will lose admin privileges.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedProfile = admin.copyWith(role: 'user');
                await _profileRepo.updateItem(updatedProfile);

                Get.snackbar(
                  'Success',
                  'Admin demoted to user',
                  backgroundColor: TColors.success,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                );
                
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to demote admin: $e',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.warning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Demote'),
          ),
        ],
      ),
    );
  }

  /// Show statistics
  void _showStatistics() async {
    final allProfiles = await _profileRepo.fetchAllItems();
    final admins = allProfiles.where((p) => p.role == 'admin').length;
    final dispatchers = allProfiles.where((p) => p.role == 'dispatcher').length;
    final users = allProfiles.where((p) => p.role == 'user').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: TColors.primary),
            const SizedBox(width: TSizes.sm),
            const Text('User Statistics'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatRow('Total Admins', admins.toString(), Icons.admin_panel_settings),
            _StatRow('Total Dispatchers', dispatchers.toString(), Icons.delivery_dining),
            _StatRow('Total Users', users.toString(), Icons.people),
            const Divider(),
            _StatRow('Total Profiles', allProfiles.length.toString(), Icons.group),
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

/// Add Admin Sheet - Promote User to Admin
class _AddAdminSheet extends StatefulWidget {
  final List<ProfileModel> users;

  const _AddAdminSheet({required this.users});

  @override
  State<_AddAdminSheet> createState() => _AddAdminSheetState();
}

class _AddAdminSheetState extends State<_AddAdminSheet> {
  String _searchQuery = '';
  final _profileRepo = ProfileRepository.instance;

  @override
  Widget build(BuildContext context) {
    var filteredUsers = widget.users;
    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.fullName.toLowerCase().contains(_searchQuery) ||
            user.email.toLowerCase().contains(_searchQuery) ||
            user.phoneNumber.contains(_searchQuery);
      }).toList();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        top: TSizes.defaultSpace,
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.defaultSpace,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promote User to Admin',
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
          const SizedBox(height: TSizes.sm),
          Text(
            'Select a user to promote to admin role',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: TSizes.md),
          
          TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: TSizes.md),
          
          SizedBox(
            height: 400,
            child: filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: TSizes.sm),
                        const Text('No users found'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: TSizes.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: TColors.primary,
                            child: Text(
                              user.firstName.isNotEmpty 
                                  ? user.firstName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(user.email, style: const TextStyle(fontSize: 12))),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(user.phoneNumber, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: user.role == 'dispatcher' ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Current: ${user.role}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: user.role == 'dispatcher' ? Colors.blue : Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              try {
                                final updatedProfile = user.copyWith(role: 'admin');
                                await _profileRepo.updateItem(updatedProfile);

                                Get.snackbar(
                                  'Success',
                                  '${user.fullName} is now an admin',
                                  backgroundColor: TColors.success,
                                  colorText: Colors.white,
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                );
                                
                                if (context.mounted) Navigator.pop(context);
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to promote user: $e',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Promote'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Admin Card Widget
class _AdminCard extends StatelessWidget {
  final ProfileModel admin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDemote;

  const _AdminCard({
    required this.admin,
    required this.onEdit,
    required this.onDelete,
    required this.onDemote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TSizes.md),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: TColors.primary,
                  child: Text(
                    admin.firstName.isNotEmpty 
                        ? admin.firstName[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        admin.fullName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              admin.email,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            admin.phoneNumber,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onDemote,
                  icon: const Icon(Icons.arrow_downward, size: 16),
                  label: const Text('Demote'),
                  style: TextButton.styleFrom(foregroundColor: TColors.warning),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(foregroundColor: TColors.primary),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat Row Widget
class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TColors.primary),
          const SizedBox(width: TSizes.sm),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
