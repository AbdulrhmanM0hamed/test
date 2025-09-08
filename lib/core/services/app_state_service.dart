import 'package:shared_preferences/shared_preferences.dart';

class AppStateService {
  static const String _isOnboardingCompletedKey = 'is_onboarding_completed';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _hasLoggedOutKey = 'has_logged_out';

  final SharedPreferences _prefs;

  AppStateService(this._prefs);

  // Onboarding state
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_isOnboardingCompletedKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_isOnboardingCompletedKey) ?? false;
  }

  // Login state
  Future<void> setLoggedIn(bool loggedIn) async {
    await _prefs.setBool(_isLoggedInKey, loggedIn);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Remember me functionality
  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool(_rememberMeKey, remember);
  }

  bool getRememberMe() {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  // Save login credentials
  Future<void> saveCredentials(String email, String password) async {
    await _prefs.setString(_savedEmailKey, email);
    await _prefs.setString(_savedPasswordKey, password);
  }

  // Get saved credentials
  Map<String, String?> getSavedCredentials() {
    return {
      'email': _prefs.getString(_savedEmailKey),
      'password': _prefs.getString(_savedPasswordKey),
    };
  }

  // Clear saved credentials
  Future<void> clearSavedCredentials() async {
    await _prefs.remove(_savedEmailKey);
    await _prefs.remove(_savedPasswordKey);
    await _prefs.setBool(_rememberMeKey, false);
  }

  // Logout state
  Future<void> setHasLoggedOut(bool hasLoggedOut) async {
    await _prefs.setBool(_hasLoggedOutKey, hasLoggedOut);
  }

  bool hasLoggedOut() {
    return _prefs.getBool(_hasLoggedOutKey) ?? false;
  }

  // Clear all app state (for complete reset)
  Future<void> clearAllState() async {
    await _prefs.remove(_isOnboardingCompletedKey);
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_rememberMeKey);
    await _prefs.remove(_savedEmailKey);
    await _prefs.remove(_savedPasswordKey);
    await _prefs.remove(_hasLoggedOutKey);
  }

  // Get initial route based on app state
  String getInitialRoute() {
    // If user has never completed onboarding, show onboarding
    if (!isOnboardingCompleted()) {
      return '/onboarding';
    }
    
    // Always go to home after onboarding, regardless of login status
    // Login will be handled when user tries to access profile
    return '/home';
  }

  // Handle successful login
  Future<void> handleSuccessfulLogin({
    required bool rememberMe,
    String? email,
    String? password,
  }) async {
    await setLoggedIn(true);
    await setHasLoggedOut(false);
    
    if (rememberMe && email != null && password != null) {
      await setRememberMe(true);
      await saveCredentials(email, password);
    } else {
      await clearSavedCredentials();
    }
  }

  // Handle logout
  Future<void> handleLogout() async {
    await setLoggedIn(false);
    await setHasLoggedOut(true);
    
    // Only clear credentials if remember me is false
    if (!getRememberMe()) {
      await clearSavedCredentials();
    }
  }
}
