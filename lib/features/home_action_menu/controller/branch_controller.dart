import 'package:foodu/features/home_action_menu/model/branch_model.dart';
import 'package:foodu/data/repositories/menu/branch_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BranchController extends GetxController {
  static BranchController get instance => Get.find();

  // Observable list of branches
  var branches = <BranchModel>[].obs;
  var isLoading = false.obs;
  var selectedBranch = Rxn<BranchModel>();

  final BranchRepository _branchRepository = BranchRepository();

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
    loadSelectedBranch();
  }

  /// Fetch all branches from Firestore
  Future<void> fetchBranches() async {
    try {
      isLoading.value = true;
      final fetchedBranches = await _branchRepository.getAllItems();
      branches.value = fetchedBranches;

      // Set default branch if none is selected
      if (selectedBranch.value == null && fetchedBranches.isNotEmpty) {
        final activeBranches =
            fetchedBranches.where((branch) => branch.isActive).toList();
        if (activeBranches.isNotEmpty) {
          selectedBranch.value = activeBranches.first;
          // Save this as the selected branch
          Get.find<GetStorage>()
              .write('selected_branch_id', activeBranches.first.id);
        }
      }
    } catch (e) {
      print('Error fetching branches: $e');
      // Get.snackbar('Error', 'Failed to load branches');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get branches as stream for real-time updates
  Stream<List<BranchModel>> getBranchesStream({bool activeOnly = false}) {
    return _branchRepository.branches(activeOnly: activeOnly);
  }

  /// Get only active branches
  Future<List<BranchModel>> getActiveBranches() async {
    try {
      return await _branchRepository.getActiveBranches();
    } catch (e) {
      print('Error fetching active branches: $e');
      return [];
    }
  }

  /// Add new branch
  Future<void> addBranch(BranchModel branch) async {
    try {
      await _branchRepository.addItem(branch);
      await fetchBranches(); // Refresh the list
      Get.snackbar('Success', 'Branch added successfully');
    } catch (e) {
      print('Error adding branch: $e');
      Get.snackbar('Error', 'Failed to add branch');
    }
  }

  /// Update existing branch
  Future<void> updateBranch(BranchModel branch) async {
    try {
      final updatedBranch = branch.copyWith(updatedAt: DateTime.now());
      await _branchRepository.updateItem(updatedBranch);
      await fetchBranches(); // Refresh the list
      Get.snackbar('Success', 'Branch updated successfully');
    } catch (e) {
      print('Error updating branch: $e');
      Get.snackbar('Error', 'Failed to update branch');
    }
  }

  /// Delete branch
  Future<void> deleteBranch(BranchModel branch) async {
    try {
      await _branchRepository.deleteItem(branch);
      await fetchBranches(); // Refresh the list
      Get.snackbar('Success', 'Branch deleted successfully');
    } catch (e) {
      print('Error deleting branch: $e');
      Get.snackbar('Error', 'Failed to delete branch');
    }
  }

  /// Toggle branch active status
  Future<void> toggleBranchStatus(String branchId) async {
    try {
      await _branchRepository.toggleBranchStatus(branchId);
      await fetchBranches(); // Refresh the list
      Get.snackbar('Success', 'Branch status updated');
    } catch (e) {
      print('Error toggling branch status: $e');
      Get.snackbar('Error', 'Failed to update branch status');
    }
  }

  /// Search branches
  Future<List<BranchModel>> searchBranches(String searchTerm) async {
    try {
      return await _branchRepository.searchBranches(searchTerm);
    } catch (e) {
      print('Error searching branches: $e');
      Get.snackbar('Error', 'Failed to search branches');
      return [];
    }
  }

  /// Get branches near location
  Future<List<BranchModel>> getBranchesNearLocation(
      double latitude, double longitude,
      {double radiusKm = 10.0}) async {
    try {
      return await _branchRepository
          .getBranchesNearLocation(latitude, longitude, radiusKm: radiusKm);
    } catch (e) {
      print('Error getting nearby branches: $e');
      Get.snackbar('Error', 'Failed to get nearby branches');
      return [];
    }
  }

  /// Get branch statistics
  Future<Map<String, int>> getBranchStats() async {
    try {
      return await _branchRepository.getBranchStats();
    } catch (e) {
      print('Error getting branch stats: $e');
      return {'total': 0, 'active': 0, 'inactive': 0};
    }
  }

  /// Set selected branch
  void selectBranch(BranchModel? branch) {
    selectedBranch.value = branch;
    // Save selected branch to local storage for persistence
    if (branch != null) {
      Get.find<GetStorage>().write('selected_branch_id', branch.id);
    } else {
      Get.find<GetStorage>().remove('selected_branch_id');
    }
  }

  /// Select next available active branch
  void selectNextBranch() {
    final activeBranches = branches.where((branch) => branch.isActive).toList();
    if (activeBranches.isEmpty) return;

    final currentIndex = selectedBranch.value != null
        ? activeBranches
            .indexWhere((branch) => branch.id == selectedBranch.value!.id)
        : -1;

    final nextIndex = (currentIndex + 1) % activeBranches.length;
    selectBranch(activeBranches[nextIndex]);
  }

  /// Get list of available branches for selection
  List<BranchModel> get availableBranches {
    return branches.where((branch) => branch.isActive).toList();
  }

  /// Load previously selected branch or set default
  void loadSelectedBranch() async {
    try {
      final storage = Get.find<GetStorage>();
      final savedBranchId = storage.read<String>('selected_branch_id');

      if (savedBranchId != null) {
        final branch = getBranchById(savedBranchId);
        if (branch != null && branch.isActive) {
          selectedBranch.value = branch;
          return;
        }
      }

      // If no saved branch or saved branch is not active, set first active branch as default
      if (branches.isNotEmpty) {
        final activeBranches =
            branches.where((branch) => branch.isActive).toList();
        if (activeBranches.isNotEmpty) {
          selectedBranch.value = activeBranches.first;
          // Save this as the selected branch
          storage.write('selected_branch_id', activeBranches.first.id);
        }
      }
    } catch (e) {
      print('Error loading selected branch: $e');
    }
  }

  /// Get active branch names for dropdowns
  List<String> get activeBranchNames {
    return branches
        .where((branch) => branch.isActive)
        .map((branch) => branch.name)
        .toList();
  }

  /// Get branch by name
  BranchModel? getBranchByName(String name) {
    try {
      return branches.firstWhere((branch) => branch.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get branch by ID
  BranchModel? getBranchById(String id) {
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get branch-specific statistics for dashboard
  Future<Map<String, dynamic>> getBranchDashboardStats(String branchId) async {
    try {
      // TODO: Implement actual branch-specific stats from Firestore
      // This is a placeholder implementation
      return {
        'products': 24,
        'categories': 8,
        'ordersToday': 12,
        'revenue': 'GHS 450',
        'activeOrders': 3,
        'completedOrders': 9,
        'recentActivity': [
          {
            'type': 'order',
            'message': 'New order received',
            'time': '2 minutes ago',
            'icon': 'shopping_bag',
          },
          {
            'type': 'product',
            'message': 'Product "Jollof Rice" updated',
            'time': '1 hour ago',
            'icon': 'edit',
          },
          {
            'type': 'category',
            'message': 'New category "Beverages" added',
            'time': '3 hours ago',
            'icon': 'add_circle',
          },
        ],
      };
    } catch (e) {
      print('Error getting branch dashboard stats: $e');
      return {
        'products': 0,
        'categories': 0,
        'ordersToday': 0,
        'revenue': 'GHS 0',
        'activeOrders': 0,
        'completedOrders': 0,
        'recentActivity': [],
      };
    }
  }

  /// Get branch chart data for analytics
  Future<Map<String, dynamic>> getBranchChartData(String branchId) async {
    try {
      // TODO: Implement actual chart data from Firestore
      // This is a placeholder implementation with realistic sample data
      return {
        'revenueData': [
          {'day': 'Mon', 'amount': 320.0},
          {'day': 'Tue', 'amount': 450.0},
          {'day': 'Wed', 'amount': 380.0},
          {'day': 'Thu', 'amount': 520.0},
          {'day': 'Fri', 'amount': 680.0},
          {'day': 'Sat', 'amount': 750.0},
          {'day': 'Sun', 'amount': 620.0},
        ],
        'ordersData': [
          {'day': 'Mon', 'orders': 12},
          {'day': 'Tue', 'orders': 18},
          {'day': 'Wed', 'orders': 15},
          {'day': 'Thu', 'orders': 22},
          {'day': 'Fri', 'orders': 28},
          {'day': 'Sat', 'orders': 35},
          {'day': 'Sun', 'orders': 25},
        ],
        'categoryData': [
          {'category': 'Main Dishes', 'count': 8, 'percentage': 40.0},
          {'category': 'Beverages', 'count': 5, 'percentage': 25.0},
          {'category': 'Desserts', 'count': 3, 'percentage': 15.0},
          {'category': 'Appetizers', 'count': 4, 'percentage': 20.0},
        ],
        'performanceMetrics': {
          'totalRevenue': 3720.0,
          'averageOrderValue': 22.4,
          'totalOrders': 155,
          'growthRate': 12.5,
        }
      };
    } catch (e) {
      print('Error getting branch chart data: $e');
      return {
        'revenueData': [],
        'ordersData': [],
        'categoryData': [],
        'performanceMetrics': {
          'totalRevenue': 0.0,
          'averageOrderValue': 0.0,
          'totalOrders': 0,
          'growthRate': 0.0,
        }
      };
    }
  }

  /// Check if a branch is currently selected
  bool get hasBranchSelected => selectedBranch.value != null;

  /// Get current selected branch name
  String get selectedBranchName =>
      selectedBranch.value?.name ?? 'No Branch Selected';

  /// Navigate to branch dashboard (helper method)
  void navigateToBranchDashboard(BranchModel branch) {
    selectBranch(branch);
    // Navigation will be handled by the calling screen
  }
}
