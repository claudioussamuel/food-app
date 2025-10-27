import 'package:flutter/material.dart';

/// Helper function to create ImageProvider from string URL or asset path
ImageProvider imageProviderFromString(String imageString) {
  if (imageString.isEmpty) {
    // Return a default placeholder image
    return const AssetImage('assets/images/food/placeholder.png');
  }
  
  // Check if it's a network URL
  if (imageString.startsWith('http://') || imageString.startsWith('https://')) {
    return NetworkImage(imageString);
  }
  
  // Check if it's a Firebase Storage URL
  if (imageString.contains('firebasestorage.googleapis.com')) {
    return NetworkImage(imageString);
  }
  
  // Otherwise, treat it as an asset path
  return AssetImage(imageString);
}
