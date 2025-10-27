import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String? branchId; // Branch association
  List<String>? availableBranches; // Multiple branch availability

  CategoryModel({
    required this.id, 
    required this.name, 
    required this.image,
    this.branchId,
    this.availableBranches,
  });

  factory CategoryModel.fromJson(DocumentSnapshot data) {
    return CategoryModel(
      id: data.id, 
      name: data['name'], 
      image: data['image'],
      branchId: data['branchId'],
      availableBranches: data['availableBranches'] != null 
          ? List<String>.from(data['availableBranches']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name, 
    'image': image,
    'branchId': branchId,
    'availableBranches': availableBranches,
  };
}
