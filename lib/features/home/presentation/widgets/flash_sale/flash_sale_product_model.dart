
/// نموذج بيانات منتج فلاش سيل
class FlashSaleProduct {
  final String id;
  final String title;
  final String image;
  final dynamic discountPercentage;
  final double originalPrice;
  final double discountedPrice;
  final bool isFavorite;

  FlashSaleProduct({
    required this.id,
    required this.title,
    required this.image,
    required this.discountPercentage,
    required this.originalPrice,
    required this.discountedPrice,
    this.isFavorite = false,
  });
} 