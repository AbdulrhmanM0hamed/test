import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Boolean operations
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Integer operations
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Object operations
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, json.encode(value));
  }

  static Map<String, dynamic>? getObject(String key) {
    String? jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  // List operations
  static Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove and clear operations
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Storage Keys
  static const String keyToken = 'token';
  static const String keyUser = 'user';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyOnboarding = 'onboarding';
  static const String keyFavorites = 'favorites';
  static const String keyRecentSearches = 'recentSearches';
}
