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

  
  // Location endpoints
  static String get countries => '$baseUrl/countries';
  static String cities(int countryId) => '$baseUrl/cities/$countryId';
  static String regions(int cityId) => '$baseUrl/regions/$cityId';
   
}
