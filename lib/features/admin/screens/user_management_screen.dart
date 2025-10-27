import 'package:flutter/material.dart';
import 'package:foodu/data/repositories/personalization/profile_repository.dart';
import 'package:foodu/features/personalization/models/profile_model.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:get/get.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ProfileRepository();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<ProfileModel>>(
        stream: _getAllProfilesStream(repo),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: TSizes.md),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.isAdmin ? TColors.primary : TColors.grey,
                    child: Icon(
                      user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(user.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: user.isAdmin ? TColors.primary : TColors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleUserAction(context, repo, user, value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: user.isAdmin ? 'make_user' : 'make_admin',
                        child: Text(user.isAdmin ? 'Make User' : 'Make Admin'),
                      ),
                      const PopupMenuItem(
                        value: 'view_details',
                        child: Text('View Details'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Create a stream of all profiles (simplified for demo)
  Stream<List<ProfileModel>> _getAllProfilesStream(ProfileRepository repo) async* {
    try {
      final profiles = await repo.fetchAllItems();
      yield profiles;
    } catch (e) {
      yield [];
    }
  }

  /// Handle user management actions
  void _handleUserAction(BuildContext context, ProfileRepository repo, ProfileModel user, String action) async {
    switch (action) {
      case 'make_admin':
        await _toggleUserRole(repo, user, 'admin');
        break;
      case 'make_user':
        await _toggleUserRole(repo, user, 'user');
        break;
      case 'view_details':
        _showUserDetails(context, user);
        break;
    }
  }

  /// Toggle user role between admin and user
  Future<void> _toggleUserRole(ProfileRepository repo, ProfileModel user, String newRole) async {
    try {
      final updatedUser = user.copyWith(role: newRole);
      await repo.updateItem(updatedUser);
      
      Get.snackbar(
        'Success',
        'User role updated to ${newRole.toUpperCase()}',
        backgroundColor: TColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user role: $e',
        backgroundColor: TColors.error,
        colorText: Colors.white,
      );
    }
  }

  /// Show user details dialog
  void _showUserDetails(BuildContext context, ProfileModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', user.email),
            _buildDetailRow('Phone', user.phoneNumber),
            _buildDetailRow('Role', user.role.toUpperCase()),
            if (user.gender != null) _buildDetailRow('Gender', user.gender!),
            if (user.dateOfBirth != null)
              _buildDetailRow('Date of Birth', user.dateOfBirth.toString().split(' ')[0]),
            if (user.createdAt != null)
              _buildDetailRow('Joined', user.createdAt.toString().split(' ')[0]),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
