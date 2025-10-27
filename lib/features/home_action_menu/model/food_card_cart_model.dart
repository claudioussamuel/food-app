class FoodCardCartModel {
  final List<String> imageUrls; // A list of image URLs
  final String title;
  final String description;
  final double price;
  final String? productId; // Optional link to a product for favorites/cart sync

  FoodCardCartModel({
    required this.imageUrls,
    required this.title,
    required this.description,
    required this.price,
    this.productId,
  });
}
