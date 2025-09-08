class Product {
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final int discount;
  final double rating;
  final int ratingCount;
  final bool isBestSeller;

  const Product({
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.ratingCount,
    this.isBestSeller = false,
  });
}

