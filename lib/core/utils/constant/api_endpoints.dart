class ApiEndpoints {
  static String get baseUrl =>
      'https://eramostore.com/eramostore2025_backend/public/api';

  static String get login => '$baseUrl/signin';
  static String get register => '$baseUrl/signup';
  static String get logout => '$baseUrl/logout';
  static String get refreshToken => '$baseUrl/refresh-token';
  static String get myAccount => '$baseUrl/my-account';
  static String get categories => '$baseUrl/departments';
  static String productsByDepartment(String departmentName) =>
      '$baseUrl/products-by-department/$departmentName';

  // Home page products endpoints
  static const String featuredProducts = '/featured-products';
  static const String bestSellerProducts = '/best-seller-products';
  static const String latestProducts = '/latest-products';
  static const String specialOfferProducts = '/special-offer-products';

  static String featuredProductsUrl({int? countryId}) => 
      '$baseUrl$featuredProducts${countryId != null ? '?country_id=$countryId' : ''}';
  static String bestSellerProductsUrl({int? countryId}) => 
      '$baseUrl$bestSellerProducts${countryId != null ? '?country_id=$countryId' : ''}';
  static String latestProductsUrl({int? countryId}) => 
      '$baseUrl$latestProducts${countryId != null ? '?country_id=$countryId' : ''}';
  static String specialOfferProductsUrl({int? countryId}) => 
      '$baseUrl$specialOfferProducts${countryId != null ? '?country_id=$countryId' : ''}';

  // Product details endpoint
  static String productDetails(int productId) => '$baseUrl/spacific-product/$productId';

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
    int? countryId,
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
    if (countryId != null) params['country_id'] = countryId;
    if (tags != null) params['tags'] = tags;
    if (page != null) params['page'] = page;
    
    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$baseUrl/get-all-products${queryString.isNotEmpty ? '?$queryString' : ''}';
  }

  // Location endpoints
  static String get countries => '$baseUrl/countries';
  static String cities(int countryId) => '$baseUrl/cities/$countryId';
  static String regions(int cityId) => '$baseUrl/regions/$cityId';
   
}
