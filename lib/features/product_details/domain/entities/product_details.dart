import 'package:equatable/equatable.dart';

class ProductDetails extends Equatable {
  final int id;
  final String image;
  final String name;
  final String slug;
  final String metaDescription;
  final List<String> metaKeywords;
  final String details;
  final String summary;
  final String instructions;
  final String features;
  final String extras;
  final double star;
  final int numOfUserReview;
  final int numberOfSale;
  final String? videoLink;
  final int stock;
  final int countOfAvailable;
  final String material;
  final String shipping;
  final String status;
  final int limitation;
  final int views;
  final String sizeColorType;
  final int departmentId;
  final String department;
  final int mainCategoryId;
  final String mainCategory;
  final int subCategoryId;
  final String subCategory;
  final int cityId;
  final String cityName;
  final List<ProductImage> productImages;
  final int brandId;
  final String brandName;
  final String brandSlug;
  final String brandDescription;
  final String brandLogo;
  final List<ProductInput> inputs;
  final List<ProductSizeColor> productSizeColor;
  final List<UserReview> userReviews;
  final List<ProductTax> productTaxes;
  final List<PromoCode> promoCodes;
  final List<String> tags;

  const ProductDetails({
    required this.id,
    required this.image,
    required this.name,
    required this.slug,
    required this.metaDescription,
    required this.metaKeywords,
    required this.details,
    required this.summary,
    required this.instructions,
    required this.features,
    required this.extras,
    required this.star,
    required this.numOfUserReview,
    required this.numberOfSale,
    this.videoLink,
    required this.stock,
    required this.countOfAvailable,
    required this.material,
    required this.shipping,
    required this.status,
    required this.limitation,
    required this.views,
    required this.sizeColorType,
    required this.departmentId,
    required this.department,
    required this.mainCategoryId,
    required this.mainCategory,
    required this.subCategoryId,
    required this.subCategory,
    required this.cityId,
    required this.cityName,
    required this.productImages,
    required this.brandId,
    required this.brandName,
    required this.brandSlug,
    required this.brandDescription,
    required this.brandLogo,
    required this.inputs,
    required this.productSizeColor,
    required this.userReviews,
    required this.productTaxes,
    required this.promoCodes,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        image,
        name,
        slug,
        metaDescription,
        metaKeywords,
        details,
        summary,
        instructions,
        features,
        extras,
        star,
        numOfUserReview,
        numberOfSale,
        videoLink,
        stock,
        countOfAvailable,
        material,
        shipping,
        status,
        limitation,
        views,
        sizeColorType,
        departmentId,
        department,
        mainCategoryId,
        mainCategory,
        subCategoryId,
        subCategory,
        cityId,
        cityName,
        productImages,
        brandId,
        brandName,
        brandSlug,
        brandDescription,
        brandLogo,
        inputs,
        productSizeColor,
        userReviews,
        productTaxes,
        promoCodes,
        tags,
      ];
}

class ProductImage extends Equatable {
  final String image;

  const ProductImage({
    required this.image,
  });

  @override
  List<Object> get props => [image];
}

class ProductInput extends Equatable {
  // Add fields as needed based on actual API response
  const ProductInput();

  @override
  List<Object> get props => [];
}

class ProductSizeColor extends Equatable {
  final int id;
  final int? colorId;
  final String? color;
  final String? colorCode;
  final int? sizeId;
  final String? size;
  final int stock;
  final String realPrice;
  final String? fakePrice;
  final String? discount;
  final int quantityInCart;
  final int? cartId;
  final String isFav;
  final int countDeliveredProduct;
  final int countOfAvailable;
  final bool isBest;
  final String? endAt;
  final CountDown countDown;

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
    required this.isBest,
    this.endAt,
    required this.countDown,
  });

  @override
  List<Object?> get props => [
        id,
        colorId,
        color,
        colorCode,
        sizeId,
        size,
        stock,
        realPrice,
        fakePrice,
        discount,
        quantityInCart,
        cartId,
        isFav,
        countDeliveredProduct,
        countOfAvailable,
        isBest,
        endAt,
        countDown,
      ];
}

class CountDown extends Equatable {
  final int productId;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const CountDown({
    required this.productId,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object> get props => [productId, days, hours, minutes, seconds];
}

class UserReview extends Equatable {
  final String review;
  final int star;
  final String userName;
  final String userImage;

  const UserReview({
    required this.review,
    required this.star,
    required this.userName,
    required this.userImage,
  });

  @override
  List<Object> get props => [review, star, userName, userImage];
}

class ProductTax extends Equatable {
  final int id;
  final String name;
  final int percentage;
  final String status;

  const ProductTax({
    required this.id,
    required this.name,
    required this.percentage,
    required this.status,
  });

  @override
  List<Object> get props => [id, name, percentage, status];
}

class PromoCode extends Equatable {
  // Add fields as needed based on actual API response
  const PromoCode();

  @override
  List<Object> get props => [];
}
