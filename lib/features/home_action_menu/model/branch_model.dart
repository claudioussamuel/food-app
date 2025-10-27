import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.description,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Empty helper function
  static BranchModel empty() => BranchModel(
        id: '',
        name: '',
        address: '',
        latitude: 0.0,
        longitude: 0.0,
        phone: '',
        createdAt: DateTime.now(),
      );

  /// Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Store ID in document data
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Factory method to create a BranchModel from a Firebase document snapshot
  /// This is the preferred method when working with Firestore documents
  factory BranchModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      final documentId = document.id;
      
      // Use ID from data, fallback to document ID
      final id = data['id'] ?? documentId;
      
      print('📄 DEBUG: Creating BranchModel from snapshot:');
      print('   - Document ID: "$documentId"');
      print('   - Data ID: "${data['id'] ?? 'null'}"');
      print('   - Final ID: "$id"');
      print('   - Name: "${data['name'] ?? 'null'}"');
      
      return BranchModel(
        id: id, // Use ID from data, fallback to document ID
        name: data['name'] ?? '',
        address: data['address'] ?? '',
        latitude: (data['latitude'] ?? 0.0).toDouble(),
        longitude: (data['longitude'] ?? 0.0).toDouble(),
        phone: data['phone'] ?? '',
        description: data['description'],
        isActive: data['isActive'] ?? true,
        createdAt: data['createdAt'] != null 
            ? DateTime.parse(data['createdAt']) 
            : DateTime.now(),
        updatedAt: data['updatedAt'] != null 
            ? DateTime.parse(data['updatedAt']) 
            : null,
      );
    } else {
      print('❌ ERROR: Document snapshot has no data!');
      return BranchModel.empty();
    }
  }

  /// Factory method to create a BranchModel from a JSON Map
  /// Note: This method should only be used when document ID is not available
  /// Prefer using fromSnapshot when working with Firestore documents
  factory BranchModel.fromJson(Map<String, dynamic> data) {
    final id = data['id'] ?? '';
    
    if (id.isEmpty) {
      print('⚠️ WARNING: BranchModel.fromJson called with empty ID!');
      print('   Data: $data');
      print('   Consider using BranchModel.fromSnapshot instead');
    }
    
    print('📄 DEBUG: Creating BranchModel from JSON:');
    print('   - Data ID: "${data['id'] ?? 'null'}"');
    print('   - Final ID: "$id"');
    
    return BranchModel(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      phone: data['phone'] ?? '',
      description: data['description'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? DateTime.parse(data['updatedAt']) 
          : null,
    );
  }

  /// Create a copy of BranchModel with updated fields
  BranchModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get full address with coordinates
  String get fullAddress => '$address (${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)})';

  /// Get distance from a point (simple calculation)
  double distanceFrom(double lat, double lng) {
    // Simple distance calculation (not accurate for large distances)
    final double deltaLat = latitude - lat;
    final double deltaLng = longitude - lng;
    return (deltaLat * deltaLat + deltaLng * deltaLng);
  }

  @override
  String toString() {
    return 'BranchModel(id: $id, name: $name, address: $address, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BranchModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
