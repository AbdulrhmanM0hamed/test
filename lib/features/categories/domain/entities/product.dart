class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final double realPrice;
  final double? fakePrice;
  final int discount;
  final double star;
  final int numOfUserReview;
  final int stock;
  final bool isFav;
  final bool isBest;
  final String brandName;
  final String brandLogo;
  final int limitation;
  final int countOfAvailable;
  final int countOfReviews;
  final String currency;
  final int? quantityInCart;
  final int? productSizeColorId;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.realPrice,
    this.fakePrice,
    required this.discount,
    required this.star,
    required this.numOfUserReview,
    required this.stock,
    required this.isFav,
    required this.isBest,
    required this.brandName,
    required this.brandLogo,
    required this.limitation,
    required this.countOfAvailable,
    required this.countOfReviews,
    this.currency = 'ج.م',
    this.quantityInCart,
    this.productSizeColorId,
  });

  /// السعر النهائي (هو realPrice)
  double get finalPrice => realPrice;

  /// السعر الأصلي (قبل الخصم)
  double get originalPrice => fakePrice ?? realPrice;

  /// هل يوجد خصم على المنتج
  bool get hasDiscount => discount > 0 && fakePrice != null && fakePrice! > realPrice;

  /// نسبة الخصم
  double get discountPercentage => discount.toDouble();

  /// هل المنتج متوفر
  bool get isAvailable => stock > 0;

  /// هل المنتج في المفضلة
  bool get isFavorite => isFav;

  /// تقييم المنتج
  double get rating => star;

  /// عدد المراجعات
  int get reviewsCount => countOfReviews;
}

class ProductsResponse {
  final List<Product> data;
  final ProductsPagination pagination;

  const ProductsResponse({
    required this.data,
    required this.pagination,
  });
}

class ProductsPagination {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const ProductsPagination({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
}
