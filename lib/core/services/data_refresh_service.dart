import 'package:flutter/foundation.dart';
import 'package:test/core/services/language_service.dart';

/// Service to manage data refresh when language changes
class DataRefreshService extends ChangeNotifier {
  final LanguageService _languageService;
  final List<VoidCallback> _refreshCallbacks = [];
  String? _lastLanguage;
  bool _isRefreshing = false;

  DataRefreshService(this._languageService) {
    _lastLanguage = _languageService.currentLocale.languageCode;
    _languageService.addListener(_onLanguageChanged);
  }

  /// Register a callback to be called when language changes
  void registerRefreshCallback(VoidCallback callback) {
    if (!_refreshCallbacks.contains(callback)) {
      _refreshCallbacks.add(callback);
    }
  }

  /// Unregister a callback
  void unregisterRefreshCallback(VoidCallback callback) {
    _refreshCallbacks.remove(callback);
  }

  /// Called when language changes
  void _onLanguageChanged() {
    final currentLanguage = _languageService.currentLocale.languageCode;
    
    // Only refresh if language actually changed and not during initial load
    if (_lastLanguage != null &&
        _lastLanguage != currentLanguage &&
        !_languageService.isChanging &&
        !_isRefreshing) {
      _triggerRefresh();
    }

    _lastLanguage = currentLanguage;
  }

  /// Trigger refresh with proper error handling and debouncing
  void _triggerRefresh() async {
    if (_isRefreshing) return;

    try {
      _isRefreshing = true;

      if (kDebugMode) {
        //print('DataRefreshService: Triggering refresh for ${_refreshCallbacks.length} callbacks',);
      }

      // Add small delay to ensure UI has updated
      await Future.delayed(const Duration(milliseconds: 300));

      // Execute all callbacks
      for (final callback in List.from(_refreshCallbacks)) {
        try {
          callback();
        } catch (e) {
          if (kDebugMode) {
            //print('DataRefreshService: Error in refresh callback: $e');
          }
        }
      }
      
      // Additional delay to ensure all data loads complete
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      _isRefreshing = false;
    }
  }

  /// Manually trigger refresh for all registered callbacks
  void refreshAll() {
    if (!_isRefreshing) {
      _triggerRefresh();
    }
  }

  /// Get current refresh status
  bool get isRefreshing => _isRefreshing;

  /// Get number of registered callbacks
  int get callbackCount => _refreshCallbacks.length;

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _refreshCallbacks.clear();
    super.dispose();
  }
}
