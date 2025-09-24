import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_storage_service.dart';

class AuthStateService extends ChangeNotifier {
  static AuthStateService? _instance;
  TokenStorageService? _tokenStorageService;
  bool _isLoggedIn = false;
  
  static AuthStateService get instance {
    _instance ??= AuthStateService._internal();
    return _instance!;
  }
  
  AuthStateService._internal() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _tokenStorageService = TokenStorageService(prefs);
    await _checkAuthStatus();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> _checkAuthStatus() async {
    if (_tokenStorageService == null) return;
    
    final token = _tokenStorageService!.accessToken;
    final wasLoggedIn = _isLoggedIn;
    _isLoggedIn = token != null && token.isNotEmpty;
    
    if (wasLoggedIn != _isLoggedIn) {
      notifyListeners();
    }
  }

  Future<void> setLoggedIn(bool loggedIn) async {
    if (_isLoggedIn != loggedIn) {
      _isLoggedIn = loggedIn;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_tokenStorageService != null) {
      await _tokenStorageService!.clearAll();
    }
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  // Check auth status periodically
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}
