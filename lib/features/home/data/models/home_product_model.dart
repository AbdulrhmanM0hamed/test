import '../../domain/entities/home_product.dart';

class HomeProductModel extends HomeProduct {
  const HomeProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    super.originalPrice,
    super.discount,
    required super.star,
    required super.reviewCount,
    required super.brandName,
    super.brandLogo,
    required super.stock,
    required super.isBest,
    required super.isFeatured,
    required super.isLatest,
    required super.isSpecialOffer,
    required super.isFavorite,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    final fakePriceValue = json['fake_price'];
    String? originalPrice;

    if (fakePriceValue != null &&
        fakePriceValue != 0 &&
        fakePriceValue.toString() != '0') {
      originalPrice = fakePriceValue.toString();
    }

    return HomeProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['real_price']?.toString() ?? '0',
      originalPrice: originalPrice,
      discount: json['discount'] ?? 0,
      star: (json['star'] ?? 0).toDouble(),
      reviewCount: json['num_of_user_review'] ?? 0,
      brandName: json['brand_name'] ?? '',
      brandLogo: json['brand_logo'],
      stock: json['stock'] ?? 0,
      isBest: json['isBest'] ?? false,
      isFeatured: true, // من API featured products
      isLatest: true, // من API latest products
      isSpecialOffer: json['discount'] != null && json['discount'] > 0,
      isFavorite: json['is_fav'] == "1",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'original_price': originalPrice,
      'discount': discount,
      'star': star,
      'review_count': reviewCount,
      'brand_name': brandName,
      'brand_logo': brandLogo,
      'stock': stock,
      'is_best': isBest,
      'is_featured': isFeatured,
      'is_latest': isLatest,
      'is_special_offer': isSpecialOffer,
    };
  }

  HomeProduct toEntity() {
    return HomeProduct(
      id: id,
      name: name,
      image: image,
      price: price,
      originalPrice: originalPrice,
      discount: discount,
      star: star,
      reviewCount: reviewCount,
      brandName: brandName,
      brandLogo: brandLogo,
      stock: stock,
      isBest: isBest,
      isFeatured: isFeatured,
      isLatest: isLatest,
      isSpecialOffer: isSpecialOffer,
      isFavorite: isFavorite,
    );
  }
}
