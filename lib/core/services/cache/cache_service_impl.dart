import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_service.dart';

class CacheServiceImpl implements CacheService {
  static const String _guestModeKey = 'guest_mode';
  final SharedPreferences _prefs;
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _sessionCookieKey = 'session_cookie';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _emailKey = 'saved_email';
  static const String _passwordKey = 'saved_password';
  static const String _userIdKey = 'user_id';
  static const String _lastNotificationKey = 'last_notification_timestamp';
  static const String _darkModeKey = 'dark_mode';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _isGuestKey = 'is_guest_mode';

  CacheServiceImpl(this._prefs);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      await _prefs.setString(_userKey, jsonEncode(user));
    } catch (e) {
      //  print('❌ Error saving user: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    final token = _prefs.getString(_tokenKey);
    return token;
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_sessionCookieKey);
    await _prefs.remove(_userKey);
    await _prefs.remove(_lastNotificationKey);

    if (!(await getRememberMe())) {
      await clearLoginCredentials();
    }
  }

  @override
  Future<String?> getSessionCookie() async {
    return _prefs.getString(_sessionCookieKey);
  }

  @override
  Future<void> saveSessionCookie(String cookie) async {
    await _prefs.setString(_sessionCookieKey, cookie);
  }

  @override
  int? getUserId() {
    try {
      final userStr = _prefs.getString(_userKey);
      if (userStr == null) {
        //print('🔍 No user data found in cache');
        return null;
      }

      final userData = jsonDecode(userStr) as Map<String, dynamic>;
      final userId = userData['id'] as int?;

      //print('📱 Retrieved user ID from cache: $userId');
      return userId;
    } catch (e) {
      //print('❌ Error getting user ID: $e');
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  @override
  Future<Map<String, String>?> getLoginCredentials() async {
    final email = _prefs.getString(_emailKey);
    final password = _prefs.getString(_passwordKey);

    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }

  @override
  Future<void> saveLoginCredentials(String email, String password) async {
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
  }

  @override
  Future<void> clearLoginCredentials() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
    await _prefs.remove(_rememberMeKey);
  }

  @override
  Future<String?> getFCMToken() async {
    return _prefs.getString('fcm_token');
  }

  @override
  Future<void> saveFCMToken(String token) async {
    await _prefs.setString('fcm_token', token);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  @override
  Future<String?> getLastNotificationTimestamp() async {
    return _prefs.getString(_lastNotificationKey);
  }

  @override
  Future<void> saveLastNotificationTimestamp(String timestamp) async {
    await _prefs.setString(_lastNotificationKey, timestamp);
  }

  @override
  Future<bool> getDarkMode() async {
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_darkModeKey, isDark);
  }

  @override
  Future<bool> getIsFirstTime() async {
    return _prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setIsFirstTime(bool isFirstTime) async {
    await _prefs.setBool(_isFirstTimeKey, isFirstTime);
  }

  @override
  Future<bool> isGuestMode() async {
    return _prefs.getBool(_isGuestKey) ?? false;
  }

  @override
  Future<void> setGuestMode(bool isGuest) async {
    await _prefs.setBool(_isGuestKey, isGuest);
  }
}

