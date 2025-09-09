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
  final int stock;
  final bool isBest;
  final bool isFeatured;
  final bool isLatest;
  final bool isSpecialOffer;

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
    required this.stock,
    required this.isBest,
    required this.isFeatured,
    required this.isLatest,
    required this.isSpecialOffer,
  });

  bool get hasDiscount => discount != null && discount! > 0;
  
  bool get isAvailable => stock > 0;
  
  String get availabilityText {
    if (stock > 10) return 'متوفر';
    if (stock > 0) return 'قطع قليلة متبقية';
    return 'غير متوفر';
  }
  
  String get discountText => hasDiscount ? '${discount!}%' : '';
}
