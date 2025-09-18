class HomeProduct {
  final int id;
  final String name;
  final String image;
  final String price;
  final String? originalPrice;
  final int? discount;
  final double star;
  final int reviewCount;
  final String brandName;
  final String? brandLogo;
  final int countOfAvailable;
  final bool isBest;
  final bool isFeatured;
  final bool isLatest;
  final bool isSpecialOffer;
  final bool isFavorite;
  final int? productSizeColorId;
  final int quantityInCart;
  final int limitation;

  const HomeProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discount,
    required this.star,
    required this.reviewCount,
    required this.brandName,
    this.brandLogo,
    required this.countOfAvailable,
    required this.isBest,
    required this.isFeatured,
    required this.isLatest,
    required this.isSpecialOffer,
    required this.isFavorite,
    this.productSizeColorId,
    required this.quantityInCart,
    required this.limitation,
  });

  bool get hasDiscount => discount != null && discount! > 0;

  bool get isAvailable => countOfAvailable > 0;

  String get availabilityText {
    if (countOfAvailable > 10) return 'متوفر';
    if (countOfAvailable > 0) return 'قطع قليلة متبقية';
    return 'غير متوفر';
  }

  String get discountText => hasDiscount ? '${discount!}%' : '';
}
