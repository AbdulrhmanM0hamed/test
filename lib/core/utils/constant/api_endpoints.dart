class ApiEndpoints {
  static String get baseUrl => 'https://sobiehcoffee.com/sobieh/public/api';

  static String get login => '$baseUrl/signin';
  static String get register => '$baseUrl/signup';
  static String get logout => '$baseUrl/logout';
  static String get refreshToken => '$baseUrl/refresh-token';
  static String get resendVerifyEmail => '$baseUrl/resend-verify-email';
  static String get forgetPassword => '$baseUrl/forget-password';
  static String get checkOtp => '$baseUrl/forget-password/check-otp';
  static String get changePassword =>
      '$baseUrl/forget-password/change-password';
  static String get myAccount => '$baseUrl/my-account';
  static String get updateProfile => '$baseUrl/update-profile';
  static String get categories => '$baseUrl/departments';
  static String get mainCategories => '$baseUrl/main-categories';
  static String productsByDepartment(String departmentName) =>
      '$baseUrl/products-by-department/$departmentName';

  // Home page products endpoints
  static const String featuredProducts = '/featured-products';
  static const String bestSellerProducts = '/best-seller-products';
  static const String latestProducts = '/latest-products';
  static const String specialOfferProducts = '/special-offer-products';
  static String get addToWishlist => '$baseUrl/wishlist/add';
  static String removeFromWishlist(int productId) =>
      '$baseUrl/wishlist/remove/$productId';
  static String get getWishlist => '$baseUrl/my-wishlist';
  static String get removeAllFromWishlist => '$baseUrl/wishlist/remove-all';

  // Cart endpoints
  static String get addToCart => '$baseUrl/cart/add';
  static String get getCart => '$baseUrl/my-cart';
  static String removeFromCart(int cartItemId) =>
      '$baseUrl/cart/remove/$cartItemId';
  static String get removeAllFromCart => '$baseUrl/cart/remove-all';

  static String featuredProductsUrl({int? regionId}) =>
      '$baseUrl$featuredProducts${regionId != null ? '?region_id=$regionId' : ''}';
  static String bestSellerProductsUrl({int? regionId}) =>
      '$baseUrl$bestSellerProducts${regionId != null ? '?region_id=$regionId' : ''}';
  static String latestProductsUrl({int? regionId}) =>
      '$baseUrl$latestProducts${regionId != null ? '?region_id=$regionId' : ''}';
  static String specialOfferProductsUrl({int? regionId}) =>
      '$baseUrl$specialOfferProducts${regionId != null ? '?region_id=$regionId' : ''}';

  // Product details endpoint
  static String productDetails(int productId) =>
      '$baseUrl/spacific-product/$productId';

  // Products filtering endpoint
  static String getAllProducts({
    int? mainCategoryId,
    int? subCategoryId,
    double? minPrice,
    double? maxPrice,
    int? rate,
    String? departmentId,
    int? brandId,
    String? platform,
    int? colorId,
    int? sizeId,
    String? keyword,
    int? regionId,
    String? tags,
    int? page,
  }) {
    final params = <String, dynamic>{};

    if (mainCategoryId != null) params['main_category_id'] = mainCategoryId;
    if (subCategoryId != null) params['sub_category_id'] = subCategoryId;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (rate != null) params['rate'] = rate;
    if (departmentId != null) params['department_id'] = departmentId;
    if (brandId != null) params['brand_id'] = brandId;
    if (platform != null) params['platform'] = platform;
    if (colorId != null) params['color_id'] = colorId;
    if (sizeId != null) params['size_id'] = sizeId;
    if (keyword != null) params['keyword'] = keyword;
    if (regionId != null) params['region_id'] = regionId;
    if (tags != null) params['tags'] = tags;
    if (page != null) params['page'] = page;

    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return '$baseUrl/get-all-products${queryString.isNotEmpty ? '?$queryString' : ''}';
  }

  // Location endpoints
  static String get countries => '$baseUrl/countries';
  static String get cities => '$baseUrl/cities';
  static String citiesByCountry(int countryId) => '$baseUrl/cities/$countryId';
  static String regions(int cityId) => '$baseUrl/regions/$cityId';

  // Orders endpoints
  static String get addresses => '$baseUrl/addresses';
  static String addressById(int addressId) => '$baseUrl/addresses/$addressId';
  static String get checkPromo => '$baseUrl/check-promo';
  static String get checkout => '$baseUrl/order/checkout';
}
