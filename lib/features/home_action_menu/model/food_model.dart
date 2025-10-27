import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String id, name, description, image;
  List<String> categoryName;
  double price, rating;
  int cartQuantity, reviewCount;
  String? branchId; // Branch association
  List<String>? availableBranches; // Multiple branch availability

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.price,
    required this.image,
    this.cartQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.branchId,
    this.availableBranches,
  });

  factory FoodModel.fromJson(DocumentSnapshot data) {
    final docData = data.data() as Map<String, dynamic>?;
    return FoodModel(
      id: data.id,
      name: data['name'],
      description: data['description'],
      categoryName: List.generate(
        data['categoryName'].length,
        (index) => data['categoryName'][index].toString(),
      ),
      price: data['price'],
      image: data['image'],
      cartQuantity: data['cartQuantity'] ?? 0,
      rating: docData != null && docData.containsKey('rating')
          ? (docData['rating'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      reviewCount: docData != null && docData.containsKey('reviewCount')
          ? docData['reviewCount'] as int? ?? 0
          : 0,
      branchId: data['branchId'],
      availableBranches: data['availableBranches'] != null
          ? List<String>.from(data['availableBranches'])
          : null,
    );
  }

  factory FoodModel.fromMap(Map data) => FoodModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        categoryName: data['categoryName'] is List
            ? List.generate(
                data['categoryName'].length,
                (index) => data['categoryName'][index].toString(),
              )
            : [],
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        image: data['image'] ?? '',
        cartQuantity: data['cartQuantity'] ?? 0,
        rating: data.containsKey('rating')
            ? (data['rating'] as num?)?.toDouble() ?? 0.0
            : 0.0,
        reviewCount: data.containsKey('reviewCount')
            ? data['reviewCount'] as int? ?? 0
            : 0,
        branchId: data['branchId'],
        availableBranches: data['availableBranches'] != null
            ? List<String>.from(data['availableBranches'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categoryName': categoryName,
        'price': price,
        'image': image,
        'cartQuantity': cartQuantity,
        'rating': rating,
        'reviewCount': reviewCount,
        'branchId': branchId,
        'availableBranches': availableBranches,
      };
}
