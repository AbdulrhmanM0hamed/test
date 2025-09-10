class ApiEndpoints {
  static String get baseUrl =>
      'https://eramostore.com/eramostore2025_backend/public/api';

  static String get login => '$baseUrl/signin';
  static String get register => '$baseUrl/signup';
  static String get logout => '$baseUrl/logout';
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

  // Location endpoints
  static String get countries => '$baseUrl/countries';
  static String cities(int countryId) => '$baseUrl/cities/$countryId';
  static String regions(int cityId) => '$baseUrl/regions/$cityId';
   
}
