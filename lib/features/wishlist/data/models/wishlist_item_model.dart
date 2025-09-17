import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.id,
    required super.wishlistProduct,
    required super.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing WishlistItem: $json');
    
    // Handle different possible structures
    Map<String, dynamic> wishlistProductData = {};
    Map<String, dynamic> productData = {};
    
    if (json.containsKey('wishlist_product')) {
      wishlistProductData = json['wishlist_product'] ?? {};
    } else if (json.containsKey('product')) {
      // Sometimes the main product data is directly in 'product'
      wishlistProductData = json['product'] ?? {};
      productData = json['product'] ?? {};
    }
    
    if (json.containsKey('product') && json['product'] is Map) {
      productData = json['product'] ?? {};
    } else {
      // If no separate product summary, use the main product data
      productData = wishlistProductData;
    }
    
    return WishlistItemModel(
      id: json['id'] ?? 0,
      wishlistProduct: WishlistProductModel.fromJson(wishlistProductData),
      product: WishlistProductSummaryModel.fromJson(productData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wishlist_product': (wishlistProduct as WishlistProductModel).toJson(),
      'product': (product as WishlistProductSummaryModel).toJson(),
    };
  }
}

class WishlistProductModel extends WishlistProduct {
  const WishlistProductModel({
    required super.id,
    required super.image,
    required super.name,
    required super.slug,
    required super.details,
    required super.summary,
    required super.star,
    required super.numOfUserReview,
    required super.numberOfSale,
    required super.stock,
    required super.countOfAvailable,
    required super.status,
    required super.department,
    required super.mainCategory,
    required super.subCategory,
    required super.brandId,
    required super.brandName,
    required super.brandSlug,
    required super.brandLogo,
    required super.productSizeColor,
    required super.tags,
  });

  factory WishlistProductModel.fromJson(Map<String, dynamic> json) {
    return WishlistProductModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      details: json['details'] ?? '',
      summary: json['summary'] ?? '',
      star: (json['star'] ?? 0).toDouble(),
      numOfUserReview: json['num_of_user_review'] ?? 0,
      numberOfSale: json['number_of_sale'] ?? 0,
      stock: json['stock'] ?? 0,
      countOfAvailable: json['countOfAvailable'] ?? 0,
      status: json['status'] ?? '',
      department: json['department'] ?? '',
      mainCategory: json['main_category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      brandId: json['brand_id'] ?? 0,
      brandName: json['brand_name'] ?? '',
      brandSlug: json['brand_slug'] ?? '',
      brandLogo: json['brand_logo'] ?? '',
      productSizeColor: (json['product_size_color'] as List<dynamic>?)
          ?.map((item) => ProductSizeColorModel.fromJson(item))
          .toList() ?? [],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => tag.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'slug': slug,
      'details': details,
      'summary': summary,
      'star': star,
      'num_of_user_review': numOfUserReview,
      'number_of_sale': numberOfSale,
      'stock': stock,
      'countOfAvailable': countOfAvailable,
      'status': status,
      'department': department,
      'main_category': mainCategory,
      'sub_category': subCategory,
      'brand_id': brandId,
      'brand_name': brandName,
      'brand_slug': brandSlug,
      'brand_logo': brandLogo,
      'product_size_color': productSizeColor
          .map((item) => (item as ProductSizeColorModel).toJson())
          .toList(),
      'tags': tags,
    };
  }
}

class ProductSizeColorModel extends ProductSizeColor {
  const ProductSizeColorModel({
    required super.id,
    super.colorId,
    super.color,
    super.colorCode,
    super.sizeId,
    super.size,
    required super.stock,
    required super.realPrice,
    super.fakePrice,
    super.discount,
    required super.isFav,
    required super.isBest,
  });

  factory ProductSizeColorModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeColorModel(
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
      isFav: json['is_fav'] == '1' || json['is_fav'] == true,
      isBest: json['isBest'] ?? false,
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
      'is_fav': isFav ? '1' : '0',
      'isBest': isBest,
    };
  }
}

class WishlistProductSummaryModel extends WishlistProductSummary {
  const WishlistProductSummaryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.star,
    required super.numOfUserReview,
    required super.realPrice,
    required super.fakePrice,
    required super.discount,
    required super.status,
    required super.productSizeColorId,
    super.colorId,
    super.colorCode,
    super.sizeId,
    super.sizeName,
    required super.stock,
  });

  factory WishlistProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return WishlistProductSummaryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      star: (json['star'] ?? 0).toDouble(),
      numOfUserReview: json['num_of_user_review'] ?? 0,
      realPrice: json['real_price']?.toString() ?? '0',
      fakePrice: (json['fake_price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      status: json['status'] ?? '',
      productSizeColorId: json['product_size_color_id'] ?? 0,
      colorId: json['color_id'],
      colorCode: json['color_code'],
      sizeId: json['size_id'],
      sizeName: json['size_name'],
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'star': star,
      'num_of_user_review': numOfUserReview,
      'real_price': realPrice,
      'fake_price': fakePrice,
      'discount': discount,
      'status': status,
      'product_size_color_id': productSizeColorId,
      'color_id': colorId,
      'color_code': colorCode,
      'size_id': sizeId,
      'size_name': sizeName,
      'stock': stock,
    };
  }
}

class WishlistResponseModel extends WishlistResponse {
  const WishlistResponseModel({
    required super.count,
    required super.wishlist,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing WishlistResponse JSON: $json');
    
    // Handle different response structures
    Map<String, dynamic> data;
    if (json.containsKey('data')) {
      data = json['data'] ?? {};
    } else {
      data = json;
    }
    
    print('🔍 Data section: $data');
    
    // Try different possible keys for wishlist items
    List<dynamic> wishlistData = [];
    if (data.containsKey('wishlist')) {
      wishlistData = data['wishlist'] as List<dynamic>? ?? [];
    } else if (data.containsKey('items')) {
      wishlistData = data['items'] as List<dynamic>? ?? [];
    } else if (json.containsKey('wishlist')) {
      wishlistData = json['wishlist'] as List<dynamic>? ?? [];
    } else if (json is List) {
      wishlistData = json as List<dynamic>;
    }
    
    print('🔍 Wishlist items count: ${wishlistData.length}');
    
    final wishlistItems = wishlistData
        .map((item) {
          try {
            return WishlistItemModel.fromJson(item);
          } catch (e) {
            print('⚠️ Error parsing wishlist item: $e');
            print('⚠️ Item data: $item');
            return null;
          }
        })
        .where((item) => item != null)
        .cast<WishlistItemModel>()
        .toList();
    
    return WishlistResponseModel(
      count: data['count'] ?? wishlistItems.length,
      wishlist: wishlistItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'count': count,
        'wishlist': wishlist
            .map((item) => (item as WishlistItemModel).toJson())
            .toList(),
      },
    };
  }
}
