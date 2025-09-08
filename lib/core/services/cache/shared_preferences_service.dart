import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _statisticsKey = 'statistics_cache';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  Future<void> cacheStatistics(Map<String, dynamic> data) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(_statisticsKey, jsonEncode(cacheData));
  }

  Map<String, dynamic>? getStatistics() {
    final cachedData = _prefs.getString(_statisticsKey);
    if (cachedData == null) return null;

    final decodedData = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = DateTime.parse(decodedData['timestamp'] as String);

    // التحقق من صلاحية الكاش
    if (DateTime.now().difference(timestamp) > _cacheValidDuration) {
      _prefs.remove(_statisticsKey); // حذف الكاش القديم
      return null;
    }

    return decodedData['data'] as Map<String, dynamic>;
  }

  Future<void> clearCache() async {
    await _prefs.remove(_statisticsKey);
  }
}
