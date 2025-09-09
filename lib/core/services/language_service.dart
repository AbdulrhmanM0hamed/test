import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('ar');
  bool _isChanging = false;

  Locale get currentLocale => _currentLocale;
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isChanging => _isChanging;

  LanguageService() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'ar';
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      // Fallback to Arabic if loading fails
      _currentLocale = const Locale('ar');
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_isChanging || _currentLocale.languageCode == languageCode) {
      return; // Prevent concurrent changes or unnecessary changes
    }

    try {
      _isChanging = true;
      notifyListeners();

      // Update locale immediately for UI
      _currentLocale = Locale(languageCode);
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      // Add small delay to ensure persistence
      await Future.delayed(const Duration(milliseconds: 100));

      _isChanging = false;
      notifyListeners();
      
      // Additional notification after delay to ensure all listeners respond
      await Future.delayed(const Duration(milliseconds: 200));
      notifyListeners();
    } catch (e) {
      _isChanging = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleLanguage() async {
    if (_isChanging) return;
    
    final newLanguageCode = _currentLocale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(newLanguageCode);
  }

  /// Force refresh all listeners
  void forceRefresh() {
    notifyListeners();
  }
}
