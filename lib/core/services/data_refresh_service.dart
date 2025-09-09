import 'package:flutter/foundation.dart';
import 'package:test/core/services/language_service.dart';

/// Service to manage data refresh when language changes
class DataRefreshService extends ChangeNotifier {
  final LanguageService _languageService;
  final List<VoidCallback> _refreshCallbacks = [];
  String? _lastLanguage;

  DataRefreshService(this._languageService) {
    _lastLanguage = _languageService.currentLocale.languageCode;
    _languageService.addListener(_onLanguageChanged);
  }

  /// Register a callback to be called when language changes
  void registerRefreshCallback(VoidCallback callback) {
    _refreshCallbacks.add(callback);
  }

  /// Unregister a callback
  void unregisterRefreshCallback(VoidCallback callback) {
    _refreshCallbacks.remove(callback);
  }

  /// Called when language changes
  void _onLanguageChanged() {
    final currentLanguage = _languageService.currentLocale.languageCode;

    if (_lastLanguage != null && _lastLanguage != currentLanguage) {
      // Language has changed, trigger all refresh callbacks
      for (final callback in _refreshCallbacks) {
        try {
          callback();
        } catch (e) {
          if (kDebugMode) {
            print('Error in refresh callback: $e');
          }
        }
      }
    }

    _lastLanguage = currentLanguage;
  }

  /// Manually trigger refresh for all registered callbacks
  void refreshAll() {
    for (final callback in _refreshCallbacks) {
      try {
        callback();
      } catch (e) {
        if (kDebugMode) {
          print('Error in manual refresh callback: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _refreshCallbacks.clear();
    super.dispose();
  }
}
