import 'package:cloud_firestore/cloud_firestore.dart';

class DispatcherModel {
  String id;
  String email;
  String name;
  String phone;
  String? profileImage;
  bool isActive;
  bool isAvailable;
  GeoPoint? currentLocation;
  String? vehicleType;
  String? vehicleNumber;
  String? licenseNumber;
  double rating;
  int totalDeliveries;
  int completedDeliveries;
  DateTime createdAt;
  DateTime? lastActiveAt;
  List<String>? assignedBranches; // Branches this dispatcher can serve

  DispatcherModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImage,
    this.isActive = true,
    this.isAvailable = true,
    this.currentLocation,
    this.vehicleType,
    this.vehicleNumber,
    this.licenseNumber,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.completedDeliveries = 0,
    required this.createdAt,
    this.lastActiveAt,
    this.assignedBranches,
  });

  factory DispatcherModel.fromJson(DocumentSnapshot data) {
    final docData = data.data() as Map<String, dynamic>;
    return DispatcherModel(
      id: data.id,
      email: docData['email'] ?? '',
      name: docData['name'] ?? '',
      phone: docData['phone'] ?? '',
      profileImage: docData['profileImage'],
      isActive: docData['isActive'] ?? true,
      isAvailable: docData['isAvailable'] ?? true,
      currentLocation: docData['currentLocation'] as GeoPoint?,
      vehicleType: docData['vehicleType'],
      vehicleNumber: docData['vehicleNumber'],
      licenseNumber: docData['licenseNumber'],
      rating: (docData['rating'] as num?)?.toDouble() ?? 5.0,
      totalDeliveries: docData['totalDeliveries'] ?? 0,
      completedDeliveries: docData['completedDeliveries'] ?? 0,
      createdAt: (docData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveAt: (docData['lastActiveAt'] as Timestamp?)?.toDate(),
      assignedBranches: docData['assignedBranches'] != null
          ? List<String>.from(docData['assignedBranches'])
          : null,
    );
  }

  factory DispatcherModel.fromMap(Map<String, dynamic> data) {
    return DispatcherModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      profileImage: data['profileImage'],
      isActive: data['isActive'] ?? true,
      isAvailable: data['isAvailable'] ?? true,
      currentLocation: data['currentLocation'] as GeoPoint?,
      vehicleType: data['vehicleType'],
      vehicleNumber: data['vehicleNumber'],
      licenseNumber: data['licenseNumber'],
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      totalDeliveries: data['totalDeliveries'] ?? 0,
      completedDeliveries: data['completedDeliveries'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate(),
      assignedBranches: data['assignedBranches'] != null
          ? List<String>.from(data['assignedBranches'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'phone': phone,
        'profileImage': profileImage,
        'isActive': isActive,
        'isAvailable': isAvailable,
        'currentLocation': currentLocation,
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber,
        'licenseNumber': licenseNumber,
        'rating': rating,
        'totalDeliveries': totalDeliveries,
        'completedDeliveries': completedDeliveries,
        'createdAt': createdAt,
        'lastActiveAt': lastActiveAt,
        'assignedBranches': assignedBranches,
      };

  // Helper methods
  double get completionRate {
    if (totalDeliveries == 0) return 0.0;
    return (completedDeliveries / totalDeliveries) * 100;
  }

  bool get isOnline {
    if (lastActiveAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastActiveAt!);
    return difference.inMinutes <= 5; // Consider online if active within 5 minutes
  }

  String get statusText {
    if (!isActive) return 'Inactive';
    if (!isAvailable) return 'Busy';
    if (isOnline) return 'Online';
    return 'Offline';
  }

  String get vehicleInfo {
    if (vehicleType == null && vehicleNumber == null) return 'No vehicle info';
    return '${vehicleType ?? 'Vehicle'} - ${vehicleNumber ?? 'No number'}';
  }

  // Check if dispatcher can serve a specific branch
  bool canServeBranch(String branchId) {
    if (assignedBranches == null || assignedBranches!.isEmpty) return true;
    return assignedBranches!.contains(branchId);
  }

  // Copy with method for updates
  DispatcherModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    bool? isActive,
    bool? isAvailable,
    GeoPoint? currentLocation,
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
    double? rating,
    int? totalDeliveries,
    int? completedDeliveries,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    List<String>? assignedBranches,
  }) {
    return DispatcherModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      completedDeliveries: completedDeliveries ?? this.completedDeliveries,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      assignedBranches: assignedBranches ?? this.assignedBranches,
    );
  }

  @override
  String toString() {
    return 'DispatcherModel(id: $id, name: $name, email: $email, isActive: $isActive, isAvailable: $isAvailable, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DispatcherModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
