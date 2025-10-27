import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:foodu/data/repositories/menu/product_repository.dart';
import 'package:foodu/data/repositories/menu/category_repository.dart';
import 'package:foodu/data/repositories/menu/order_repository.dart';
import 'package:foodu/features/home_action_menu/model/food_model.dart';
import 'package:foodu/features/home_action_menu/model/category_model.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';

class BranchSpecificController extends GetxController {
  static BranchSpecificController get instance => Get.find();

  // Repositories
  final ProductRepository _productRepository = ProductRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final OrderRepository _orderRepository = OrderRepository();

  // Observable data
  var isLoading = false.obs;
  var currentBranchId = ''.obs;
  
  // Statistics
  var productsCount = 0.obs;
  var categoriesCount = 0.obs;
  var todaysOrdersCount = 0.obs;
  var todaysRevenue = 0.0.obs;
  
  // Data streams
  var branchProducts = <FoodModel>[].obs;
  var branchCategories = <CategoryModel>[].obs;
  var todaysOrders = <OrderModel>[].obs;
  var filteredOrders = <OrderModel>[].obs;
  
  // Date range filtering
  var selectedDateRange = 'Monthly'.obs; // Weekly, Monthly, Custom
  var customStartDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var customEndDate = DateTime.now().obs;
  
  // Stream subscriptions for real-time updates
  StreamSubscription<List<FoodModel>>? _productsSubscription;
  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;
  StreamSubscription<List<OrderModel>>? _todaysOrdersSubscription;
  StreamSubscription<List<OrderModel>>? _filteredOrdersSubscription;
  
  // Error handling
  var hasError = false.obs;
  var errorMessage = ''.obs;

  /// Initialize with clicked branch ID - simple and direct
  void initializeBranch(String clickedBranchId) {
    print('🎯 Using clicked branch ID: "$clickedBranchId"');
    
    if (clickedBranchId.isEmpty) {
      print('❌ ERROR: Clicked branch ID is empty!');
      return;
    }
    
    // Use clicked branch ID for everything
    _cancelSubscriptions();
    currentBranchId.value = clickedBranchId;
    
    // Immediately start loading data
    print('🚀 Starting data load for branch: "$clickedBranchId"');
    
    // Test: Load all products first to see what's in the database
    _testLoadAllProducts();
    
    _setupRealTimeStreams();
  }
  
  /// Test method to see all products in database
  Future<void> _testLoadAllProducts() async {
    try {
      print('\n🧪 TESTING: Loading ALL products to check database...');
      final allProducts = await _productRepository.fetchAllItems();
      print('🧪 Found ${allProducts.length} total products in database');
      
      for (int i = 0; i < allProducts.length && i < 5; i++) {
        final product = allProducts[i];
        print('🧪 Product ${i + 1}: ${product.name}');
        print('   - branchId: ${product.branchId}');
        print('   - availableBranches: ${product.availableBranches}');
      }
      
      // Test the specific query
      final branchId = currentBranchId.value;
      print('\n🧪 TESTING: Query for branch "$branchId"...');
      final branchProducts = await _productRepository.productsForBranchOnce(branchId);
      print('🧪 Found ${branchProducts.length} products for branch "$branchId"');
      
      if (branchProducts.isEmpty) {
        print('⚠️ WARNING: No products found for branch "$branchId"!');
        print('   This might be why you need to refresh manually.');
      }
    } catch (e) {
      print('❌ Error testing products: $e');
    }
  }

  /// Setup real-time streams for clicked branch
  void _setupRealTimeStreams() {
    final branchId = currentBranchId.value;
    if (branchId.isEmpty) {
      print('❌ ERROR: Branch ID is empty!');
      return;
    }
    
    try {
      print('🔄 Setting up streams for branch: "$branchId"');
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      // Reset counts to show loading state
      productsCount.value = 0;
      categoriesCount.value = 0;
      todaysOrdersCount.value = 0;
      
      // Setup product stream - try multiple approaches
      print('📦 Loading products for branch: "$branchId"');
      
      // First try the availableBranches query
      _productsSubscription = _productRepository
          .productsForBranch(branchId)
          .listen(
            (products) {
              print('✅ Loaded ${products.length} products using availableBranches for branch "$branchId"');
              
              // If no products found with availableBranches, try branchId field
              if (products.isEmpty) {
                print('🔄 No products found with availableBranches, trying branchId field...');
                _tryBranchIdQuery(branchId);
              } else {
                branchProducts.value = products;
                productsCount.value = products.length;
                _calculateStatistics();
                
                // Set loading to false when first data arrives
                if (isLoading.value) {
                  isLoading.value = false;
                  print('🏁 Data loading completed for branch "$branchId"');
                }
              }
            },
            onError: (error) {
              print('❌ Error loading products with availableBranches: $error');
              print('🔄 Trying branchId field instead...');
              _tryBranchIdQuery(branchId);
            },
          );
      
      // Setup categories stream
      print('📦 Loading categories for branch: "$branchId"');
      _categoriesSubscription = _categoryRepository
          .categoriesForBranch(branchId)
          .listen(
            (categories) {
              print('✅ Loaded ${categories.length} categories for branch "$branchId"');
              branchCategories.value = categories;
              categoriesCount.value = categories.length;
            },
            onError: (error) {
              print('❌ Error loading categories: $error');
              _handleError('Failed to load categories: $error');
            },
          );
      
      // Setup today's orders stream
      print('📦 Loading today\'s orders for branch: "$branchId"');
      _todaysOrdersSubscription = _orderRepository
          .todaysOrdersByBranch(branchId)
          .listen(
            (orders) {
              print('✅ Loaded ${orders.length} orders today for branch "$branchId"');
              todaysOrders.value = orders;
              todaysOrdersCount.value = orders.length;
              _calculateStatistics();
            },
            onError: (error) {
              print('❌ Error loading today\'s orders: $error');
              _handleError('Failed to load today\'s orders: $error');
            },
          );
      
      // Setup filtered orders stream based on selected date range
      _setupFilteredOrdersStream(branchId);
      
      print('📊 All streams initialized for branch: "$branchId"');
      
    } catch (e) {
      print('❌ Error setting up streams: $e');
      isLoading.value = false;
      _handleError('Failed to initialize branch data: $e');
    }
  }
  
  /// Handle errors with user feedback
  void _handleError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Cancel all active subscriptions
  void _cancelSubscriptions() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    _todaysOrdersSubscription?.cancel();
    _filteredOrdersSubscription?.cancel();
  }

  /// Refresh data for clicked branch
  Future<void> refreshData() async {
    final branchId = currentBranchId.value;
    if (branchId.isNotEmpty) {
      print('🔄 Refreshing data for branch: "$branchId"');
      _cancelSubscriptions();
      _setupRealTimeStreams();
    } else {
      print('❌ ERROR: Branch ID is empty!');
    }
  }
  
  /// Get branch statistics summary
  Map<String, dynamic> getBranchStats() {
    return {
      'productsCount': productsCount.value,
      'categoriesCount': categoriesCount.value,
      'todaysOrdersCount': todaysOrdersCount.value,
      'todaysRevenue': todaysRevenue.value,
      'isLoading': isLoading.value,
      'hasError': hasError.value,
    };
  }
  
  /// Try loading products using branchId field instead of availableBranches
  void _tryBranchIdQuery(String branchId) {
    print('🔄 Trying branchId query for branch: "$branchId"');
    
    _productsSubscription?.cancel();
    _productsSubscription = _productRepository
        .productsByBranch(branchId)
        .listen(
          (products) {
            print('✅ Loaded ${products.length} products using branchId for branch "$branchId"');
            
            if (products.isEmpty) {
              print('⚠️ WARNING: No products found with either method for branch "$branchId"!');
              print('   Check if products exist and have proper branch association.');
            }
            
            branchProducts.value = products;
            productsCount.value = products.length;
            _calculateStatistics();
            
            // Set loading to false
            if (isLoading.value) {
              isLoading.value = false;
              print('🏁 Data loading completed for branch "$branchId"');
            }
          },
          onError: (error) {
            print('❌ Error loading products with branchId: $error');
            isLoading.value = false;
            _handleError('Failed to load products: $error');
          },
        );
  }
  
  /// Debug products for clicked branch
  Future<void> debugAllProducts() async {
    try {
      final branchId = currentBranchId.value;
      print('\n🔍 Checking products for branch: "$branchId"');
      
      final allProducts = await _productRepository.fetchAllItems();
      print('Total products in database: ${allProducts.length}');
      
      int matchingAvailableBranches = 0;
      int matchingBranchId = 0;
      
      for (final product in allProducts) {
        final hasThisBranchInArray = product.availableBranches?.contains(branchId) ?? false;
        final hasThisBranchId = product.branchId == branchId;
        
        if (hasThisBranchInArray) {
          matchingAvailableBranches++;
          print('✅ ${product.name} - in availableBranches');
        }
        
        if (hasThisBranchId) {
          matchingBranchId++;
          print('✅ ${product.name} - has branchId');
        }
      }
      
      print('\n📊 SUMMARY:');
      print('   Branch: "$branchId"');
      print('   Products with availableBranches: $matchingAvailableBranches');
      print('   Products with branchId: $matchingBranchId');
      print('   Products currently loaded: ${branchProducts.length}');
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  /// Calculate statistics from loaded data (branch-specific)
  void _calculateStatistics() {
    // Calculate today's revenue (only from orders for this branch)
    double revenue = 0.0;
    for (final order in todaysOrders) {
      // Ensure order is for current branch
      if (order.branchId == currentBranchId.value) {
        for (final product in order.products) {
          revenue += product.price * product.cartQuantity;
        }
      }
    }
    todaysRevenue.value = revenue;
  }

  /// Get revenue data for chart based on selected date range
  List<ChartData> getRevenueChartData() {
    final Map<String, double> revenueData = {};
    final now = DateTime.now();
    
    // Initialize based on selected date range
    if (selectedDateRange.value == 'Weekly') {
      // Last 7 days
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayLabel = _getDayName(date.weekday);
        revenueData[dayLabel] = 0.0;
      }
    } else {
      // Monthly or Custom - show weekly aggregates
      for (int i = 3; i >= 0; i--) {
        final weekLabel = 'Week ${4 - i}';
        revenueData[weekLabel] = 0.0;
      }
    }
    
    // Calculate revenue based on filtered orders
    for (final order in filteredOrders) {
      if (order.branchId == currentBranchId.value) {
        double orderTotal = 0.0;
        for (final product in order.products) {
          orderTotal += product.price * product.cartQuantity;
        }
        
        if (selectedDateRange.value == 'Weekly') {
          final dayLabel = _getDayName(order.startTime.weekday);
          revenueData[dayLabel] = (revenueData[dayLabel] ?? 0.0) + orderTotal;
        } else {
          final daysSinceOrder = now.difference(order.startTime).inDays;
          final weekIndex = (daysSinceOrder / 7).floor();
          if (weekIndex < 4) {
            final weekLabel = 'Week ${4 - weekIndex}';
            revenueData[weekLabel] = (revenueData[weekLabel] ?? 0.0) + orderTotal;
          }
        }
      }
    }
    
    return revenueData.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  /// Get orders data for chart based on selected date range
  List<ChartData> getOrdersChartData() {
    final Map<String, double> ordersData = {};
    final now = DateTime.now();
    
    // Initialize based on selected date range
    if (selectedDateRange.value == 'Weekly') {
      // Last 7 days
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayLabel = _getDayName(date.weekday);
        ordersData[dayLabel] = 0.0;
      }
    } else {
      // Monthly or Custom - show weekly aggregates
      for (int i = 3; i >= 0; i--) {
        final weekLabel = 'Week ${4 - i}';
        ordersData[weekLabel] = 0.0;
      }
    }
    
    // Count orders based on filtered orders
    for (final order in filteredOrders) {
      if (order.branchId == currentBranchId.value) {
        if (selectedDateRange.value == 'Weekly') {
          final dayLabel = _getDayName(order.startTime.weekday);
          ordersData[dayLabel] = (ordersData[dayLabel] ?? 0.0) + 1;
        } else {
          final daysSinceOrder = now.difference(order.startTime).inDays;
          final weekIndex = (daysSinceOrder / 7).floor();
          if (weekIndex < 4) {
            final weekLabel = 'Week ${4 - weekIndex}';
            ordersData[weekLabel] = (ordersData[weekLabel] ?? 0.0) + 1;
          }
        }
      }
    }
    
    return ordersData.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  }

  /// Get category distribution data for pie chart (branch-specific)
  List<PieData> getCategoryDistributionData() {
    final Map<String, int> categoryCount = {};
    
    // Count products by category (only products available at current branch)
    for (final product in branchProducts) {
      // Ensure product is available at current branch
      if (product.availableBranches != null && 
          product.availableBranches!.contains(currentBranchId.value)) {
        for (final category in product.categoryName) {
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }
    }
    
    // Convert to pie data with colors
    final colors = [
      const Color(0xFF6366F1), // Primary
      const Color(0xFF10B981), // Success
      const Color(0xFFF59E0B), // Warning
      const Color(0xFF3B82F6), // Info
      const Color(0xFFEF4444), // Error
    ];
    
    int colorIndex = 0;
    return categoryCount.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieData(entry.key, entry.value, color);
    }).toList();
  }

  /// Get recent activity for the branch (branch-specific)
  List<ActivityItem> getRecentActivity() {
    final List<ActivityItem> activities = [];
    
    // Add recent orders (only for current branch)
    final branchSpecificOrders = todaysOrders
        .where((order) => order.branchId == currentBranchId.value)
        .take(3);
    
    for (final order in branchSpecificOrders) {
      final timeAgo = _getTimeAgo(order.startTime);
      activities.add(ActivityItem(
        title: 'New order received',
        subtitle: 'Order from ${order.customerEmail}',
        time: timeAgo,
        icon: 'shopping_bag',
        color: const Color(0xFF10B981),
      ));
    }
    
    // Add recent products (only products available at current branch)
    final branchSpecificProducts = branchProducts
        .where((product) => product.availableBranches != null && 
                           product.availableBranches!.contains(currentBranchId.value))
        .take(1);
    
    for (final product in branchSpecificProducts) {
      activities.add(ActivityItem(
        title: 'Product "${product.name}" available',
        subtitle: 'Product is active for this branch',
        time: '2 hours ago',
        icon: 'edit',
        color: const Color(0xFF6366F1),
      ));
    }
    
    // Add recent categories (only categories available at current branch)
    final branchSpecificCategories = branchCategories
        .where((category) => category.availableBranches != null && 
                            category.availableBranches!.contains(currentBranchId.value))
        .take(1);
    
    for (final category in branchSpecificCategories) {
      activities.add(ActivityItem(
        title: 'Category "${category.name}" active',
        subtitle: 'Category is available for this branch',
        time: '4 hours ago',
        icon: 'add_circle',
        color: const Color(0xFF3B82F6),
      ));
    }
    
    return activities;
  }

  @override
  void onClose() {
    _cancelSubscriptions();
    super.onClose();
  }

  /// Helper method to get day name from weekday number
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  /// Helper method to get time ago string
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  /// Setup filtered orders stream based on selected date range
  void _setupFilteredOrdersStream(String branchId) {
    print('📦 Loading filtered orders for branch: "$branchId" with range: ${selectedDateRange.value}');
    
    _filteredOrdersSubscription?.cancel();
    
    // Determine date range based on selection
    DateTime startDate, endDate;
    final now = DateTime.now();
    
    switch (selectedDateRange.value) {
      case 'Weekly':
        startDate = now.subtract(const Duration(days: 7));
        endDate = now;
        break;
      case 'Monthly':
        startDate = now.subtract(const Duration(days: 30));
        endDate = now;
        break;
      case 'Custom':
        startDate = customStartDate.value;
        endDate = customEndDate.value;
        break;
      default:
        startDate = now.subtract(const Duration(days: 30));
        endDate = now;
    }
    
    // Use the flexible date range query
    _filteredOrdersSubscription = _orderRepository
        .ordersByBranchAndDateRange(branchId, startDate, endDate)
        .listen(
          (orders) {
            print('✅ Loaded ${orders.length} filtered orders for branch "$branchId"');
            filteredOrders.value = orders;
          },
          onError: (error) {
            print('❌ Error loading filtered orders: $error');
            // Fallback to client-side filtering if server-side fails
            _setupClientSideFiltering(branchId, startDate, endDate);
          },
        );
  }

  /// Fallback to client-side filtering if server-side query fails
  void _setupClientSideFiltering(String branchId, DateTime startDate, DateTime endDate) {
    print('🔄 Using client-side filtering as fallback');
    
    _filteredOrdersSubscription = _orderRepository
        .orders(limited: false)
        .listen(
          (allOrders) {
            final filtered = allOrders.where((order) {
              return order.branchId == branchId &&
                     order.startTime.isAfter(startDate) &&
                     order.startTime.isBefore(endDate);
            }).toList();
            
            print('✅ Client-side filtered ${filtered.length} orders for branch "$branchId"');
            filteredOrders.value = filtered;
          },
          onError: (error) {
            print('❌ Error with client-side filtering: $error');
            _handleError('Failed to load filtered orders: $error');
          },
        );
  }

  /// Update date range selection
  void updateDateRange(String range) {
    selectedDateRange.value = range;
    final branchId = currentBranchId.value;
    if (branchId.isNotEmpty) {
      _setupFilteredOrdersStream(branchId);
    }
  }

  /// Update custom date range
  void updateCustomDateRange(DateTime startDate, DateTime endDate) {
    customStartDate.value = startDate;
    customEndDate.value = endDate;
    if (selectedDateRange.value == 'Custom') {
      final branchId = currentBranchId.value;
      if (branchId.isNotEmpty) {
        _setupFilteredOrdersStream(branchId);
      }
    }
  }

  /// Get available date range options
  List<String> get dateRangeOptions => ['Weekly', 'Monthly', 'Custom'];

  /// Get formatted date range text for display
  String get dateRangeText {
    switch (selectedDateRange.value) {
      case 'Weekly':
        return 'Last 7 days';
      case 'Monthly':
        return 'Last 30 days';
      case 'Custom':
        final formatter = DateFormat('MMM dd, yyyy');
        return '${formatter.format(customStartDate.value)} - ${formatter.format(customEndDate.value)}';
      default:
        return 'Last 30 days';
    }
  }
}

// Data classes for charts and activities
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class PieData {
  PieData(this.category, this.count, this.color);
  final String category;
  final int count;
  final Color color;
}

class ActivityItem {
  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
  
  final String title;
  final String subtitle;
  final String time;
  final String icon;
  final Color color;
}
