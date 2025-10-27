import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscountImage extends StatelessWidget {
  final String imagePath;

  const DiscountImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Banner Image
    return Image(image: AssetImage(imagePath),width: double.infinity, fit: BoxFit.contain,);
  }
}
