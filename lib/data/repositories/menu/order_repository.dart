import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodu/features/home_action_menu/model/order.dart';

class OrderRepository {
  final db = FirebaseFirestore.instance;
  final String _collection = 'orders';

  Stream<List<OrderModel>> orders({bool limited = false}) {
    Query query =
        db.collection(_collection).orderBy('startTime', descending: true);
    if (limited) query = query.limit(5);
    return query.snapshots().map(
          (q) => q.docs.map((d) => OrderModel.fromJson(d)).toList(),
        );
  }

  Future<String> createOrder(OrderModel order) async {
    final data = order.toJson();
    final doc = await db.collection(_collection).add(data);
    return doc.id;
  }

  Future<void> updateOrderProgress(
      {required String orderId,
      required String progress,
      String? cancellationReason}) async {
    final updateData = {'progress': progress};
    if (cancellationReason != null && cancellationReason.isNotEmpty) {
      updateData['cancellationReason'] = cancellationReason;
    }
    await db.collection(_collection).doc(orderId).update(updateData);
  }

  /// Get orders for a specific branch
  Stream<List<OrderModel>> ordersByBranch(String branchId,
      {bool limited = false}) {
    Query query = db
        .collection(_collection)
        .where('branchId', isEqualTo: branchId)
        .orderBy('startTime', descending: true);
    if (limited) query = query.limit(5);
    return query.snapshots().map(
          (q) => q.docs.map((d) => OrderModel.fromJson(d)).toList(),
        );
  }

  /// Get orders count for a specific branch
  Future<int> getOrdersCountByBranch(String branchId) async {
    final snapshot = await db
        .collection(_collection)
        .where('branchId', isEqualTo: branchId)
        .get();
    return snapshot.docs.length;
  }

  /// Get today's orders for a specific branch
  Stream<List<OrderModel>> todaysOrdersByBranch(String branchId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return db
        .collection(_collection)
        .where('branchId', isEqualTo: branchId)
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThanOrEqualTo: endOfDay)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => OrderModel.fromJson(d)).toList());
  }

  /// Get orders for a specific branch within a date range
  Stream<List<OrderModel>> ordersByBranchAndDateRange(
      String branchId, DateTime startDate, DateTime endDate) {
    return db
        .collection(_collection)
        .where('branchId', isEqualTo: branchId)
        .where('startTime', isGreaterThanOrEqualTo: startDate)
        .where('startTime', isLessThanOrEqualTo: endDate)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => OrderModel.fromJson(d)).toList());
  }

  /// Get weekly orders for a specific branch (last 7 days)
  Stream<List<OrderModel>> weeklyOrdersByBranch(String branchId) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return ordersByBranchAndDateRange(branchId, weekAgo, now);
  }

  /// Get monthly orders for a specific branch (last 30 days)
  Stream<List<OrderModel>> monthlyOrdersByBranch(String branchId) {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));

    return ordersByBranchAndDateRange(branchId, monthAgo, now);
  }

  /// Get ready orders available for dispatcher pickup
  Stream<List<OrderModel>> getReadyOrdersForPickup(String branchId) {
    return db
        .collection(_collection)
        .where('branchId', isEqualTo: branchId)
        .where('progress', isEqualTo: 'Ready')
        .orderBy('startTime', descending: false)
        .snapshots()
        .map((q) => q.docs.map((d) => OrderModel.fromJson(d)).toList());
  }

  /// Mark order as picked up by dispatcher
  Future<void> markOrderAsPickedUp(String orderId,
      {String? dispatcherEmail}) async {
    await db.collection(_collection).doc(orderId).update({
      'progress': 'Picked Up',
      'endTime': DateTime.now(),
      'dispatcherEmail': dispatcherEmail,
    });
  }

  /// Get all orders stream (for debugging)
  Stream<List<OrderModel>> getAllOrdersStream() {
    return db
        .collection(_collection)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => OrderModel.fromJson(d)).toList());
  }

  /// Get database instance for raw queries (debug purposes)
  FirebaseFirestore get database => db;

  /// Fetch raw orders data for debugging (without model conversion)
  Future<List<Map<String, dynamic>>> getRawOrders() async {
    final snapshot = await db.collection(_collection).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add document ID

      // Add product IDs if missing
      if (data['products'] is List) {
        final products = data['products'] as List;
        for (int i = 0; i < products.length; i++) {
          if (products[i] is Map && !products[i].containsKey('id')) {
            products[i]['id'] = 'product_${doc.id}_$i';
          }
        }
      }

      return data;
    }).toList();
  }
}
