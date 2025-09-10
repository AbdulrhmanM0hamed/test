import '../../domain/entities/product_details.dart';

class ProductDetailsModel extends ProductDetails {
  const ProductDetailsModel({
    required super.id,
    required super.image,
    required super.name,
    required super.slug,
    required super.metaDescription,
    required super.metaKeywords,
    required super.details,
    required super.summary,
    required super.instructions,
    required super.features,
    required super.extras,
    required super.star,
    required super.numOfUserReview,
    required super.numberOfSale,
    super.videoLink,
    required super.stock,
    required super.countOfAvailable,
    required super.material,
    required super.shipping,
    required super.status,
    required super.limitation,
    required super.views,
    required super.sizeColorType,
    required super.departmentId,
    required super.department,
    required super.mainCategoryId,
    required super.mainCategory,
    required super.subCategoryId,
    required super.subCategory,
    required super.cityId,
    required super.cityName,
    required super.productImages,
    required super.brandId,
    required super.brandName,
    required super.brandSlug,
    required super.brandDescription,
    required super.brandLogo,
    required super.inputs,
    required super.productSizeColor,
    required super.userReviews,
    required super.productTaxes,
    required super.promoCodes,
    required super.tags,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] ?? 0,
      image: json['image']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      metaDescription: json['meta_description']?.toString() ?? '',
      metaKeywords:
          (json['meta_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      details: json['details']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
      features: json['features']?.toString() ?? '',
      extras: json['extras']?.toString() ?? '',
      star: (json['star'] ?? 0).toDouble(),
      numOfUserReview: json['num_of_user_review'] ?? 0,
      numberOfSale: json['number_of_sale'] ?? 0,
      videoLink: json['video_link']?.toString(),
      stock: json['stock'] ?? 0,
      countOfAvailable: json['countOfAvailable'] ?? 0,
      material: json['matrial']?.toString() ?? '',
      shipping: json['shipping']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      limitation: json['limitation'] ?? 0,
      views: json['views'] ?? 0,
      sizeColorType: json['size_color_type']?.toString() ?? '',
      departmentId: json['department_id'] ?? 0,
      department: json['department']?.toString() ?? '',
      mainCategoryId: json['main_category_id'] ?? 0,
      mainCategory: json['main_category']?.toString() ?? '',
      subCategoryId: json['sub_category_id'] ?? 0,
      subCategory: json['sub_category']?.toString() ?? '',
      cityId: json['city_id'] ?? 0,
      cityName: json['city_name']?.toString() ?? '',
      productImages:
          (json['product_images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e))
              .toList() ??
          [],
      brandId: json['brand_id'] ?? 0,
      brandName: json['brand_name']?.toString() ?? '',
      brandSlug: json['brand_slug']?.toString() ?? '',
      brandDescription: json['brand_describtion']?.toString() ?? '',
      brandLogo: json['brand_logo']?.toString() ?? '',
      inputs:
          (json['inputs'] as List<dynamic>?)
              ?.map((e) => ProductInputModel.fromJson(e))
              .toList() ??
          [],
      productSizeColor:
          (json['product_size_color'] as List<dynamic>?)
              ?.map((e) => ProductSizeColorModel.fromJson(e))
              .toList() ??
          [],
      userReviews:
          (json['user_reviews'] as List<dynamic>?)
              ?.map((e) => UserReviewModel.fromJson(e))
              .toList() ??
          [],
      productTaxes:
          (json['product_taxes'] as List<dynamic>?)
              ?.map((e) => ProductTaxModel.fromJson(e))
              .toList() ??
          [],
      promoCodes:
          (json['promo-codes'] as List<dynamic>?)
              ?.map((e) => PromoCodeModel.fromJson(e))
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'slug': slug,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
      'details': details,
      'summary': summary,
      'instructions': instructions,
      'features': features,
      'extras': extras,
      'star': star,
      'num_of_user_review': numOfUserReview,
      'number_of_sale': numberOfSale,
      'video_link': videoLink,
      'stock': stock,
      'countOfAvailable': countOfAvailable,
      'matrial': material,
      'shipping': shipping,
      'status': status,
      'limitation': limitation,
      'views': views,
      'size_color_type': sizeColorType,
      'department_id': departmentId,
      'department': department,
      'main_category_id': mainCategoryId,
      'main_category': mainCategory,
      'sub_category_id': subCategoryId,
      'sub_category': subCategory,
      'city_id': cityId,
      'city_name': cityName,
      'product_images': productImages
          .map((e) => (e as ProductImageModel).toJson())
          .toList(),
      'brand_id': brandId,
      'brand_name': brandName,
      'brand_slug': brandSlug,
      'brand_describtion': brandDescription,
      'brand_logo': brandLogo,
      'inputs': inputs.map((e) => (e as ProductInputModel).toJson()).toList(),
      'product_size_color': productSizeColor
          .map((e) => (e as ProductSizeColorModel).toJson())
          .toList(),
      'user_reviews': userReviews
          .map((e) => (e as UserReviewModel).toJson())
          .toList(),
      'product_taxes': productTaxes
          .map((e) => (e as ProductTaxModel).toJson())
          .toList(),
      'promo-codes': promoCodes
          .map((e) => (e as PromoCodeModel).toJson())
          .toList(),
      'tags': tags,
    };
  }
}

class ProductImageModel extends ProductImage {
  const ProductImageModel({required super.image});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(image: json['image'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'image': image};
  }
}

class ProductInputModel extends ProductInput {
  const ProductInputModel();

  factory ProductInputModel.fromJson(Map<String, dynamic> json) {
    return const ProductInputModel();
  }

  Map<String, dynamic> toJson() {
    return {};
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
    required super.quantityInCart,
    super.cartId,
    required super.isFav,
    required super.countDeliveredProduct,
    required super.countOfAvailable,
    required super.isBest,
    super.endAt,
    required super.countDown,
  });

  factory ProductSizeColorModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeColorModel(
      id: json['id'] ?? 0,
      colorId: json['color_id'],
      color: json['color']?.toString(),
      colorCode: json['color_code']?.toString(),
      sizeId: json['size_id'],
      size: json['size']?.toString(),
      stock: json['stock'] ?? 0,
      realPrice: (json['real_price'] ?? 0).toString(),
      fakePrice: json['fake_price']?.toString(),
      discount: json['discount']?.toString(),
      quantityInCart: json['quantity_in_cart'] ?? 0,
      cartId: json['cart_id'],
      isFav: json['is_fav']?.toString() ?? '0',
      countDeliveredProduct: json['countDeliveredProduct'] ?? 0,
      countOfAvailable: json['countOfAvailable'] ?? 0,
      isBest: json['isBest'] ?? false,
      endAt: json['end_at']?.toString(),
      countDown: CountDownModel.fromJson(json['countDown'] ?? {}),
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
      'isBest': isBest,
      'end_at': endAt,
      'countDown': (countDown as CountDownModel).toJson(),
    };
  }
}

class CountDownModel extends CountDown {
  const CountDownModel({
    required super.productId,
    required super.days,
    required super.hours,
    required super.minutes,
    required super.seconds,
  });

  factory CountDownModel.fromJson(Map<String, dynamic> json) {
    return CountDownModel(
      productId: json['product_id'] ?? 0,
      days: json['days'] ?? 0,
      hours: json['hours'] ?? 0,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }
}

class UserReviewModel extends UserReview {
  const UserReviewModel({
    required super.review,
    required super.star,
    required super.userName,
    required super.userImage,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      review: json['review'] ?? '',
      star: json['star'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'star': star,
      'user_name': userName,
      'user_image': userImage,
    };
  }
}

class ProductTaxModel extends ProductTax {
  const ProductTaxModel({
    required super.id,
    required super.name,
    required super.percentage,
    required super.status,
  });

  factory ProductTaxModel.fromJson(Map<String, dynamic> json) {
    return ProductTaxModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      percentage: json['precentage'] ?? 0, // Note: API uses 'precentage' (typo)
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'precentage': percentage, // Keep API typo for consistency
      'status': status,
    };
  }
}

class PromoCodeModel extends PromoCode {
  const PromoCodeModel();

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return const PromoCodeModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
