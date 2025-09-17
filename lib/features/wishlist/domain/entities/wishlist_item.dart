class WishlistItem {
  final int id;
  final WishlistProduct wishlistProduct;
  final WishlistProductSummary product;

  const WishlistItem({
    required this.id,
    required this.wishlistProduct,
    required this.product,
  });
}

class WishlistProduct {
  final int id;
  final String image;
  final String name;
  final String slug;
  final String details;
  final String summary;
  final double star;
  final int numOfUserReview;
  final int numberOfSale;
  final int stock;
  final int countOfAvailable;
  final String status;
  final String department;
  final String mainCategory;
  final String subCategory;
  final int brandId;
  final String brandName;
  final String brandSlug;
  final String brandLogo;
  final List<ProductSizeColor> productSizeColor;
  final List<String> tags;

  const WishlistProduct({
    required this.id,
    required this.image,
    required this.name,
    required this.slug,
    required this.details,
    required this.summary,
    required this.star,
    required this.numOfUserReview,
    required this.numberOfSale,
    required this.stock,
    required this.countOfAvailable,
    required this.status,
    required this.department,
    required this.mainCategory,
    required this.subCategory,
    required this.brandId,
    required this.brandName,
    required this.brandSlug,
    required this.brandLogo,
    required this.productSizeColor,
    required this.tags,
  });

  bool get isAvailable => stock > 0;
  bool get isBest => status.toLowerCase() == 'best';
  String get availabilityText {
    if (stock > 10) return 'متوفر';
    if (stock > 0) return 'قطع قليلة متبقية';
    return 'غير متوفر';
  }
}

class ProductSizeColor {
  final int id;
  final int? colorId;
  final String? color;
  final String? colorCode;
  final int? sizeId;
  final String? size;
  final int stock;
  final String realPrice;
  final String? fakePrice;
  final int? discount;
  final bool isFav;
  final bool isBest;

  const ProductSizeColor({
    required this.id,
    this.colorId,
    this.color,
    this.colorCode,
    this.sizeId,
    this.size,
    required this.stock,
    required this.realPrice,
    this.fakePrice,
    this.discount,
    required this.isFav,
    required this.isBest,
  });

  bool get hasDiscount => discount != null && discount! > 0;
  
  String get formattedPrice {
    if (realPrice.endsWith('.00')) {
      return realPrice.substring(0, realPrice.length - 3);
    }
    return realPrice;
  }
}

class WishlistProductSummary {
  final int id;
  final String name;
  final String image;
  final double star;
  final int numOfUserReview;
  final String realPrice;
  final double fakePrice;
  final int discount;
  final String status;
  final int productSizeColorId;
  final int? colorId;
  final String? colorCode;
  final int? sizeId;
  final String? sizeName;
  final int stock;

  const WishlistProductSummary({
    required this.id,
    required this.name,
    required this.image,
    required this.star,
    required this.numOfUserReview,
    required this.realPrice,
    required this.fakePrice,
    required this.discount,
    required this.status,
    required this.productSizeColorId,
    this.colorId,
    this.colorCode,
    this.sizeId,
    this.sizeName,
    required this.stock,
  });

  bool get hasDiscount => discount > 0;
  bool get isAvailable => stock > 0;
  bool get isBest => status.toLowerCase() == 'best';
  
  String get formattedPrice {
    if (realPrice.endsWith('.00')) {
      return realPrice.substring(0, realPrice.length - 3);
    }
    return realPrice;
  }
  
  String get availabilityText {
    if (stock > 10) return 'متوفر';
    if (stock > 0) return 'قطع قليلة متبقية';
    return 'غير متوفر';
  }
}

class WishlistResponse {
  final int count;
  final List<WishlistItem> wishlist;

  const WishlistResponse({
    required this.count,
    required this.wishlist,
  });
}
