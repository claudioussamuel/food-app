import 'dart:async';
import 'package:foodu/features/home_action_menu/screens/home/home_screen.dart';
import 'package:foodu/features/order/screens/order_tab/order_screen.dart';
import 'package:foodu/features/profile/screens/profile_screen/profile_screen.dart';
import 'package:foodu/features/admin/screens/branch_management_screen.dart';
import 'package:foodu/features/dispatcher/screens/dispatcher_dashboard_screen.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/personalization/controller/profile_form_controller.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxBool isAdmin = false.obs;
  final RxBool isDispatcher = false.obs;
  final RxBool isTemporaryUserMode =
      false.obs; // For admin testing user experience
  final RxBool isTemporaryDispatcherMode =
      false.obs; // For admin testing dispatcher experience

  // Store the original role status
  bool _originalAdminStatus = false;
  bool _originalDispatcherStatus = false;

  // Get profile controller to check user role
  ProfileFormController? _profileController;

  // Get branch controller to check selected branch
  BranchController? _branchController;

  // Timer for retrying profile controller connection
  Timer? _retryTimer;

  @override
  void onInit() {
    super.onInit();
    _checkUserRole();

    // Listen to temporary user mode changes to reset navigation
    ever(isTemporaryUserMode, (isUserMode) {
      selectedIndex.value = 0; // Reset to first tab when switching modes
    });

    // Listen to temporary dispatcher mode changes to reset navigation
    ever(isTemporaryDispatcherMode, (isDispatcherMode) {
      selectedIndex.value = 0; // Reset to first tab when switching modes
    });

    // Retry role checking periodically if ProfileFormController is not available
    _retryRoleCheckingIfNeeded();
  }

  /// Check if current user is admin
  void _checkUserRole() {
    try {
      // Try to get the profile controller
      _profileController = Get.find<ProfileFormController>();
      _setupProfileListener();
      print(
          'NavigationController: Successfully found ProfileFormController on first try');
    } catch (e) {
      // ProfileFormController not available yet, try to initialize it
      print(
          'ProfileFormController not available, attempting to initialize: $e');
      try {
        _profileController = Get.put(ProfileFormController(), permanent: true);
        _setupProfileListener();
        print(
            'NavigationController: Successfully initialized ProfileFormController');
      } catch (e2) {
        // Still failed, default to regular user and retry later
        _originalAdminStatus = false;
        isAdmin.value = false;
        print('Failed to initialize ProfileFormController: $e2');
      }
    }
  }

  /// Set up profile listener and check current profile
  void _setupProfileListener() {
    if (_profileController != null) {
      // Listen to profile changes
      ever(_profileController!.currentProfile, (profile) {
        if (profile != null) {
          _originalAdminStatus = profile.isAdmin;
          _originalDispatcherStatus = profile.isDispatcher;
          _updateRoleStatus();
          print(
              'NavigationController: Profile updated - isAdmin: ${profile.isAdmin}, isDispatcher: ${profile.isDispatcher}');
        }
      });

      // Check current profile immediately
      if (_profileController!.currentProfile.value != null) {
        _originalAdminStatus =
            _profileController!.currentProfile.value!.isAdmin;
        _originalDispatcherStatus =
            _profileController!.currentProfile.value!.isDispatcher;
        _updateRoleStatus();
        print(
            'NavigationController: Initial profile check - isAdmin: $_originalAdminStatus, isDispatcher: $_originalDispatcherStatus');
      } else {
        // Load profile if not loaded yet
        _profileController!.loadCurrentUserProfile();
        print('NavigationController: Loading user profile...');
      }
    }
  }

  /// Update role status based on original status and temporary mode
  void _updateRoleStatus() {
    if (_originalAdminStatus && isTemporaryUserMode.value) {
      // Admin is in temporary user mode
      isAdmin.value = false;
      isDispatcher.value = false;
    } else if (_originalAdminStatus && isTemporaryDispatcherMode.value) {
      // Admin is in temporary dispatcher mode
      isAdmin.value = false;
      isDispatcher.value = true;
    } else {
      // Use original admin status
      isAdmin.value = _originalAdminStatus;
      isDispatcher.value = false;
    }

    // Set dispatcher status for original dispatchers (also affected by temporary user mode)
    if (_originalDispatcherStatus && isTemporaryUserMode.value) {
      // Dispatcher is in temporary user mode
      isDispatcher.value = false;
    } else if (_originalDispatcherStatus && !_originalAdminStatus) {
      // Original dispatcher (not admin)
      isDispatcher.value = true;
    }
  }

  /// Check if current user is originally an admin (regardless of temporary mode)
  bool get isOriginallyAdmin => _originalAdminStatus;

  /// Check if current user is originally a dispatcher (regardless of temporary mode)
  bool get isOriginallyDispatcher => _originalDispatcherStatus;

  /// Switch to user mode (for admin/dispatcher testing)
  void switchToUserMode() {
    if (_originalAdminStatus || _originalDispatcherStatus) {
      isTemporaryUserMode.value = true;
      _updateRoleStatus();
      if (_originalAdminStatus) {
        print('Admin switched to temporary user mode for testing');
      } else if (_originalDispatcherStatus) {
        print('Dispatcher switched to temporary user mode for testing');
      }
    }
  }

  /// Switch back to admin/dispatcher mode
  void switchToAdminMode() {
    if (_originalAdminStatus || _originalDispatcherStatus) {
      isTemporaryUserMode.value = false;
      _updateRoleStatus();
      if (_originalAdminStatus) {
        print('Admin switched back to admin mode');
      } else if (_originalDispatcherStatus) {
        print('Dispatcher switched back to dispatcher mode');
      }
    }
  }

  /// Toggle between admin/dispatcher and user modes (for testing)
  void toggleUserMode() {
    if (_originalAdminStatus || _originalDispatcherStatus) {
      if (isTemporaryUserMode.value) {
        switchToAdminMode();
      } else {
        switchToUserMode();
      }
    }
  }

  /// Switch to dispatcher mode (for admin testing)
  void switchToDispatcherMode() {
    if (_originalAdminStatus) {
      isTemporaryUserMode.value = false;
      isTemporaryDispatcherMode.value = true;
      _updateRoleStatus();
      print('Admin switched to temporary dispatcher mode for testing');
    }
  }

  /// Switch back to admin mode from dispatcher mode
  void switchBackToAdminFromDispatcher() {
    if (_originalAdminStatus) {
      isTemporaryDispatcherMode.value = false;
      _updateRoleStatus();
      print('Admin switched back to admin mode from dispatcher mode');
    }
  }

  /// Toggle between admin and dispatcher modes (for admin testing)
  void toggleDispatcherMode() {
    if (_originalAdminStatus) {
      if (isTemporaryDispatcherMode.value) {
        switchBackToAdminFromDispatcher();
      } else {
        switchToDispatcherMode();
      }
    }
  }

  /// Retry role checking if ProfileFormController is not available
  void _retryRoleCheckingIfNeeded() {
    // If ProfileFormController is still not available, retry periodically (max 10 attempts)
    if (_profileController == null) {
      int attempts = 0;
      _retryTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        attempts++;
        try {
          _profileController = Get.find<ProfileFormController>();
          _setupProfileListener();

          // Stop the timer once we successfully connect
          timer.cancel();
          _retryTimer = null;
          print(
              'NavigationController: Successfully connected to ProfileFormController on retry $attempts');
        } catch (e) {
          // Still not available, continue retrying up to 10 times
          if (attempts >= 10) {
            timer.cancel();
            _retryTimer = null;
            print(
                'NavigationController: Failed to connect to ProfileFormController after $attempts attempts');
          } else {
            print(
                'NavigationController: Retrying ProfileFormController connection... (attempt $attempts)');
          }
        }
      });
    }
  }

  @override
  void onClose() {
    // Clean up the retry timer
    _retryTimer?.cancel();
    super.onClose();
  }

  /// Get screens based on user role
  List get screens {
    if (isAdmin.value) {
      // Admin role screens
      try {
        _branchController = Get.find<BranchController>();
        if (_branchController?.selectedBranch.value == null) {
          // No branch selected, show branch selection screen
          if (selectedIndex.value != 0) {
            selectedIndex.value = 0;
          }
          return [const BranchManagementScreen()];
        }
      } catch (e) {
        // BranchController not found, show branch selection
        if (selectedIndex.value != 0) {
          selectedIndex.value = 0;
        }
        return [const BranchManagementScreen()];
      }

      // Admin screens with branch selected (2 screens)
      if (selectedIndex.value >= 2) {
        selectedIndex.value = 0;
      }
      return [
        const BranchManagementScreen(),
        const ProfileScreen(),
      ];
    } else if (isDispatcher.value) {
      // Dispatcher role screens (2 screens)
      if (selectedIndex.value >= 2) {
        selectedIndex.value = 0;
      }

      return [
        const DispatcherDashboardScreen(),
        const ProfileScreen(),
      ];
    } else {
      // Regular user screens (3 screens)
      if (selectedIndex.value >= 3) {
        selectedIndex.value = 0;
      }
      return [
        const HomeScreen(),
        const OrderScreen(),
        const ProfileScreen(),
      ];
    }
  }
}
