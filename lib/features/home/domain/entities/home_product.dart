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
  final int stock;
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
    required this.stock,
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

  HomeProduct copyWith({
    int? id,
    String? name,
    String? image,
    String? price,
    String? originalPrice,
    int? discount,
    double? star,
    int? reviewCount,
    String? brandName,
    String? brandLogo,
    int? countOfAvailable,
    int? stock,
    bool? isBest,
    bool? isFeatured,
    bool? isLatest,
    bool? isSpecialOffer,
    bool? isFavorite,
    int? productSizeColorId,
    int? quantityInCart,
    int? limitation,
  }) {
    return HomeProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      star: star ?? this.star,
      reviewCount: reviewCount ?? this.reviewCount,
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
      countOfAvailable: countOfAvailable ?? this.countOfAvailable,
      stock: stock ?? this.stock,
      isBest: isBest ?? this.isBest,
      isFeatured: isFeatured ?? this.isFeatured,
      isLatest: isLatest ?? this.isLatest,
      isSpecialOffer: isSpecialOffer ?? this.isSpecialOffer,
      isFavorite: isFavorite ?? this.isFavorite,
      productSizeColorId: productSizeColorId ?? this.productSizeColorId,
      quantityInCart: quantityInCart ?? this.quantityInCart,
      limitation: limitation ?? this.limitation,
    );
  }
}
