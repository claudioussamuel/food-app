import 'package:cloud_firestore/cloud_firestore.dart';

import 'food_model.dart';

class OrderModel {
  String id;
  String customerEmail;
  DateTime startTime;
  List<FoodModel> products;
  DateTime? endTime;
  String progress;
  String customerNumber;
  String? location;
  String branchId; // Branch ID for order association
  String? dispatcherEmail; // Email of dispatcher who picked up the order
  String? orderNumber; // Formatted order number (e.g., A-001, M-183)

  OrderModel({
    required this.id,
    required this.customerEmail,
    required this.startTime,
    required this.products,
    this.endTime,
    required this.progress,
    required this.customerNumber,
    this.location,
    required this.branchId,
    this.dispatcherEmail,
    this.orderNumber,
  });

  factory OrderModel.fromJson(DocumentSnapshot data) {
    final docData = data.data() as Map<String, dynamic>?;
    return OrderModel(
      id: data.id,
      customerEmail: data['customerEmail'] ?? '',
      startTime: _parseTimestamp(data['startTime']),
      customerNumber: data['customerNumber'] ?? '',
      location: data['location'],
      branchId: data['branchId'] ?? '',
      dispatcherEmail: docData?.containsKey('dispatcherEmail') == true
          ? data['dispatcherEmail']
          : null,
      orderNumber: docData?.containsKey('orderNumber') == true
          ? data['orderNumber']
          : null,
      products: _parseProducts(data['products'], data.id),
      endTime:
          data['endTime'] != null ? _parseTimestamp(data['endTime']) : null,
      progress: data['progress'] ?? 'pending',
    );
  }

  /// Helper method to parse timestamp from various formats
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      throw Exception('Timestamp is null');
    }

    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp is String) {
      // Try to parse ISO string
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        throw Exception('Cannot parse timestamp string: $timestamp');
      }
    } else if (timestamp is Map && timestamp.containsKey('_seconds')) {
      // Handle Firestore timestamp in map format
      final seconds = timestamp['_seconds'] as int;
      final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + (nanoseconds ~/ 1000000));
    } else {
      throw Exception(
          'Unknown timestamp format: ${timestamp.runtimeType} - $timestamp');
    }
  }

  /// Helper method to parse products with proper ID handling
  static List<FoodModel> _parseProducts(dynamic products, String orderId) {
    if (products == null || products is! List) {
      return [];
    }

    return List.generate(products.length, (index) {
      final productData = products[index];
      if (productData is Map) {
        // Add ID if missing
        final productMap = Map<String, dynamic>.from(productData);
        if (!productMap.containsKey('id') || productMap['id'] == null) {
          productMap['id'] = 'product_${orderId}_$index';
        }
        return FoodModel.fromMap(productMap);
      }
      throw Exception('Product data is not a Map: ${productData.runtimeType}');
    });
  }

  /// Factory method to create OrderModel from raw Map data (for debugging)
  factory OrderModel.fromRawData(Map<String, dynamic> data,
      {String? documentId}) {
    final id = documentId ?? data['id'] ?? '';
    return OrderModel(
      id: id,
      customerEmail: data['customerEmail'] ?? '',
      startTime: _parseTimestamp(data['startTime']),
      customerNumber: data['customerNumber'] ?? '',
      location: data['location'],
      branchId: data['branchId'] ?? '',
      dispatcherEmail: data.containsKey('dispatcherEmail')
          ? data['dispatcherEmail']
          : null,
      orderNumber: data.containsKey('orderNumber')
          ? data['orderNumber']
          : null,
      products: _parseProducts(data['products'], id),
      endTime:
          data['endTime'] != null ? _parseTimestamp(data['endTime']) : null,
      progress: data['progress'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'customerEmail': customerEmail,
        'startTime': startTime,
        'products': List.generate(
          products.length,
          (index) => products[index].toJson(),
        ),
        'endTime': endTime,
        'progress': progress,
        "customerNumber": customerNumber,
        "location": location,
        "branchId": branchId,
        "dispatcherEmail": dispatcherEmail,
        "orderNumber": orderNumber,
      };

  // Helper methods for order functionality
  bool get isReadyForPickup => progress.toLowerCase() == 'ready';

  bool get isCompleted =>
      progress.toLowerCase() == 'completed' ||
      progress.toLowerCase() == 'delivered';

  String get orderStatus {
    switch (progress.toLowerCase()) {
      case 'pending':
        return 'Order Placed';
      case 'preparing':
        return 'Being Prepared';
      case 'ready':
        return 'Ready for Pickup';
      case 'picked up':
        return 'Picked Up by Dispatcher';
      case 'completed':
      case 'delivered':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return progress;
    }
  }

  Duration? get totalOrderTime {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  double get totalAmount {
    double productTotal = products.fold(
        0.0, (sum, product) => sum + (product.price * product.cartQuantity));
    return productTotal;
  }

  /// Get formatted order number (e.g., A-001, M-183)
  /// If orderNumber is not set, generates one from the order ID
  String get formattedOrderNumber {
    if (orderNumber != null && orderNumber!.isNotEmpty) {
      return orderNumber!;
    }
    // Fallback: Generate from ID if orderNumber is not set
    final prefix = id.isNotEmpty ? id[0].toUpperCase() : 'A';
    final number = id.length >= 3 ? id.substring(id.length - 3) : '000';
    return '$prefix-$number';
  }

  // Copy with method for updates
  OrderModel copyWith({
    String? id,
    String? customerEmail,
    DateTime? startTime,
    List<FoodModel>? products,
    DateTime? endTime,
    String? progress,
    String? customerNumber,
    String? location,
    String? branchId,
    String? dispatcherEmail,
    String? orderNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerEmail: customerEmail ?? this.customerEmail,
      startTime: startTime ?? this.startTime,
      products: products ?? this.products,
      endTime: endTime ?? this.endTime,
      progress: progress ?? this.progress,
      customerNumber: customerNumber ?? this.customerNumber,
      location: location ?? this.location,
      branchId: branchId ?? this.branchId,
      dispatcherEmail: dispatcherEmail ?? this.dispatcherEmail,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }
}
