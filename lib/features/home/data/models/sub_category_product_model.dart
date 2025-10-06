import '../../domain/entities/home_product.dart';

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
  final int quantityInCart;
  final int? cartId;
  final String isFav;
  final int countDeliveredProduct;
  final int countOfAvailable;
  final String? endAt;

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
    required this.quantityInCart,
    this.cartId,
    required this.isFav,
    required this.countDeliveredProduct,
    required this.countOfAvailable,
    this.endAt,
  });

  factory ProductSizeColor.fromJson(Map<String, dynamic> json) {
    return ProductSizeColor(
      id: json['id'] ?? 0,
      colorId: json['color_id'],
      color: json['color'],
      colorCode: json['color_code'],
      sizeId: json['size_id'],
      size: json['size'],
      stock: json['stock'] ?? 0,
      realPrice: json['real_price']?.toString() ?? '0',
      fakePrice: json['fake_price']?.toString(),
      discount: json['discount'],
      quantityInCart: json['quantity_in_cart'] ?? 0,
      cartId: json['cart_id'],
      isFav: json['is_fav']?.toString() ?? '0',
      countDeliveredProduct: json['countDeliveredProduct'] ?? 0,
      countOfAvailable: json['countOfAvailable'] ?? 0,
      endAt: json['end_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color_id': colorId,
      'color': color,
      'color_code': colorCode,
      'size_id': sizeId,
      'size': size,
      'stock': stock,
      'real_price': realPrice,
      'fake_price': fakePrice,
      'discount': discount,
      'quantity_in_cart': quantityInCart,
      'cart_id': cartId,
      'is_fav': isFav,
      'countDeliveredProduct': countDeliveredProduct,
      'countOfAvailable': countOfAvailable,
      'end_at': endAt,
    };
  }
}

class SubCategoryProductModel extends HomeProduct {
  final List<ProductSizeColor> productSizeColor;
  final List<String> tags;
  final List<String> metaKeywords;

  const SubCategoryProductModel({
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
    required super.countOfAvailable,
    required super.stock,
    required super.isBest,
    required super.isFeatured,
    required super.isLatest,
    required super.isSpecialOffer,
    required super.isFavorite,
    super.productSizeColorId,
    required super.quantityInCart,
    required super.limitation,
    required this.productSizeColor,
    required this.tags,
    required this.metaKeywords,
  });

  factory SubCategoryProductModel.fromJson(Map<String, dynamic> json) {
    // Handle product_size_color array
    final productSizeColorList = json['product_size_color'] != null
        ? (json['product_size_color'] as List)
            .map((item) => ProductSizeColor.fromJson(item))
            .toList()
        : <ProductSizeColor>[];

    // Get the first product_size_color for main product data
    final firstSizeColor = productSizeColorList.isNotEmpty 
        ? productSizeColorList.first 
        : null;

    // Handle fake_price from first size color or main product
    final fakePriceValue = firstSizeColor?.fakePrice ?? json['fake_price'];
    String? originalPrice;
    if (fakePriceValue != null &&
        fakePriceValue != 0 &&
        fakePriceValue.toString() != '0') {
      originalPrice = fakePriceValue.toString();
    }

    // Handle is_fav from first size color or main product
    final isFav = firstSizeColor?.isFav == "1" || 
                  firstSizeColor?.isFav == "1" ||
                  json['is_fav'] == "1" || 
                  json['is_fav'] == 1;

    // Determine product status flags
    final status = json['status']?.toString().toLowerCase();
    final isBest = status == 'الأفضل' || status == 'best';
    final isFeatured = status == 'مميز' || status == 'featured';
    final isSpecialOffer = (firstSizeColor?.discount ?? json['discount']) != null && 
                          (firstSizeColor?.discount ?? json['discount']) > 0;

    return SubCategoryProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: firstSizeColor?.realPrice ?? json['real_price']?.toString() ?? '0',
      originalPrice: originalPrice,
      discount: firstSizeColor?.discount ?? json['discount'],
      star: (json['star'] ?? 0).toDouble(),
      reviewCount: json['num_of_user_review'] ?? 0,
      brandName: json['brand_name'] ?? '',
      brandLogo: json['brand_logo'],
      countOfAvailable: firstSizeColor?.countOfAvailable ?? json['countOfAvailable'] ?? 0,
      stock: firstSizeColor?.stock ?? json['stock'] ?? 0,
      isBest: isBest,
      isFeatured: isFeatured,
      isLatest: false, // Not specified in this JSON structure
      isSpecialOffer: isSpecialOffer,
      isFavorite: isFav,
      productSizeColorId: firstSizeColor?.id ?? json['product_size_color_id'],
      quantityInCart: firstSizeColor?.quantityInCart ?? json['quantity_in_cart'] ?? 0,
      limitation: json['limitation'] ?? 10,
      productSizeColor: productSizeColorList,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      metaKeywords: json['meta_keywords'] != null ? List<String>.from(json['meta_keywords']) : [],
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
      'countOfAvailable': countOfAvailable,
      'stock': stock,
      'is_best': isBest,
      'is_featured': isFeatured,
      'is_latest': isLatest,
      'is_special_offer': isSpecialOffer,
      'is_favorite': isFavorite,
      'product_size_color_id': productSizeColorId,
      'quantity_in_cart': quantityInCart,
      'limitation': limitation,
      'product_size_color': productSizeColor.map((item) => item.toJson()).toList(),
      'tags': tags,
      'meta_keywords': metaKeywords,
    };
  }

  // Convert to regular HomeProduct for compatibility
  HomeProduct toHomeProduct() {
    // Use the first productSizeColorId from the array if available
    final firstSizeColorId = productSizeColor.isNotEmpty 
        ? productSizeColor.first.id 
        : productSizeColorId;

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
      countOfAvailable: countOfAvailable,
      stock: stock,
      isBest: isBest,
      isFeatured: isFeatured,
      isLatest: isLatest,
      isSpecialOffer: isSpecialOffer,
      isFavorite: isFavorite,
      productSizeColorId: firstSizeColorId,
      quantityInCart: quantityInCart,
      limitation: limitation,
    );
  }
}
