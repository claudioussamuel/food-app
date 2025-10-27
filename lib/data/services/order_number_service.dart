import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to generate unique order numbers in format: PREFIX-XXX (e.g., A-001, M-183)
/// Supports prefixes A-Z with numbers 000-999
class OrderNumberService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _counterCollection = 'orderCounters';

  /// Generate next order number for a given prefix
  /// Returns formatted order number like "A-001", "M-183", etc.
  Future<String> generateOrderNumber(String prefix) async {
    try {
      prefix = prefix.toUpperCase();
      
      // Validate prefix is a single letter
      if (prefix.length != 1 || !RegExp(r'[A-Z]').hasMatch(prefix)) {
        prefix = 'A'; // Default to 'A' if invalid
      }

      final counterDoc = _db.collection(_counterCollection).doc(prefix);
      
      // Use transaction to ensure atomic increment
      final orderNumber = await _db.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(counterDoc);
        
        int currentCount = 0;
        if (snapshot.exists) {
          currentCount = snapshot.data()?['count'] ?? 0;
        }
        
        // Increment counter (reset to 0 if it reaches 1000)
        int nextCount = (currentCount + 1) % 1000;
        
        // Update counter in Firestore
        transaction.set(counterDoc, {
          'count': nextCount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        // Format as XXX (3 digits with leading zeros)
        final formattedNumber = nextCount.toString().padLeft(3, '0');
        return '$prefix-$formattedNumber';
      });
      
      return orderNumber;
    } catch (e) {
      print('Error generating order number: $e');
      // Fallback to timestamp-based number if transaction fails
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final number = (timestamp % 1000).toString().padLeft(3, '0');
      return '$prefix-$number';
    }
  }

  /// Generate order number based on branch name
  /// Uses first letter of branch name as prefix
  Future<String> generateOrderNumberForBranch(String branchName) async {
    final prefix = branchName.isNotEmpty ? branchName[0].toUpperCase() : 'A';
    return generateOrderNumber(prefix);
  }

  /// Reset counter for a specific prefix (admin use only)
  Future<void> resetCounter(String prefix) async {
    try {
      prefix = prefix.toUpperCase();
      await _db.collection(_counterCollection).doc(prefix).set({
        'count': 0,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error resetting counter: $e');
    }
  }

  /// Get current count for a prefix
  Future<int> getCurrentCount(String prefix) async {
    try {
      prefix = prefix.toUpperCase();
      final snapshot = await _db.collection(_counterCollection).doc(prefix).get();
      return snapshot.data()?['count'] ?? 0;
    } catch (e) {
      print('Error getting current count: $e');
      return 0;
    }
  }
}
