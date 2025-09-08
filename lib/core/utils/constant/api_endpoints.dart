class ApiEndpoints {
  static String get baseUrl =>
      'https://eramostore.com/eramostore2025_backend/public/api';

  static String get login => '$baseUrl/signin';
  static String get register => '$baseUrl/signup';
  static String get logout => '$baseUrl/logout';
  static String get myAccount => '$baseUrl/my-account';
}
