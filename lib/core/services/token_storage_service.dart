import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _sessionTokenKey = 'session_token';
  static const String _tokenExpirationKey = 'token_expiration';
  static const String _userIdKey = 'user_id';
  static const String _userUuidKey = 'user_uuid';
  static const String _userEmailKey = 'user_email';
  static const String _userStatusKey = 'user_status';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedEmailKey = 'remembered_email';
  static const String _rememberedPasswordKey = 'remembered_password';

  final SharedPreferences _prefs;

  TokenStorageService(this._prefs);

  // Save tokens with expiration
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String sessionToken,
    int? expiresIn,
  }) async {
    final expirationTime = expiresIn != null 
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;
    
    await Future.wait([
      _prefs.setString(_accessTokenKey, accessToken),
      _prefs.setString(_refreshTokenKey, refreshToken),
      _prefs.setString(_sessionTokenKey, sessionToken),
      if (expirationTime != null)
        _prefs.setInt(_tokenExpirationKey, expirationTime.millisecondsSinceEpoch),
    ]);
  }

  // Save user data
  Future<void> saveUserData({
    required int userId,
    required String userUuid,
    required String userEmail,
    required String userStatus,
  }) async {
    await Future.wait([
      _prefs.setInt(_userIdKey, userId),
      _prefs.setString(_userUuidKey, userUuid),
      _prefs.setString(_userEmailKey, userEmail),
      _prefs.setString(_userStatusKey, userStatus),
    ]);
  }

  // Get tokens
  String? get accessToken => _prefs.getString(_accessTokenKey);
  String? get refreshToken => _prefs.getString(_refreshTokenKey);
  String? get sessionToken => _prefs.getString(_sessionTokenKey);
  
  // Get token expiration
  DateTime? get tokenExpiration {
    final timestamp = _prefs.getInt(_tokenExpirationKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Get user data
  int? get userId => _prefs.getInt(_userIdKey);
  String? get userUuid => _prefs.getString(_userUuidKey);
  String? get userEmail => _prefs.getString(_userEmailKey);
  String? get userStatus => _prefs.getString(_userStatusKey);

  // Check if user is logged in
  bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
  
  // Check if token is expired or about to expire (within 5 minutes)
  bool get isTokenExpired {
    final expiration = tokenExpiration;
    if (expiration == null) return false;
    return DateTime.now().add(const Duration(minutes: 5)).isAfter(expiration);
  }
  
  // Check if token needs refresh (within 30 minutes of expiration)
  bool get shouldRefreshToken {
    final expiration = tokenExpiration;
    if (expiration == null) return false;
    return DateTime.now().add(const Duration(minutes: 30)).isAfter(expiration);
  }

  // Mark onboarding as completed
  Future<void> setOnboardingCompleted({bool completed = true}) async {
    await _prefs.setBool(_onboardingCompletedKey, completed);
  }

  bool get isOnboardingCompleted => _prefs.getBool(_onboardingCompletedKey) ?? false;

  // Remember me functionality
  Future<void> setRememberMe({
    required bool remember, 
    String? email, 
    String? password
  }) async {
    await _prefs.setBool(_rememberMeKey, remember);
    if (remember) {
      if (email != null) {
        await _prefs.setString(_rememberedEmailKey, email);
      }
      if (password != null) {
        await _prefs.setString(_rememberedPasswordKey, password);
      }
    } else {
      await _prefs.remove(_rememberedEmailKey);
      await _prefs.remove(_rememberedPasswordKey);
    }
  }

  bool get isRememberMeEnabled => _prefs.getBool(_rememberMeKey) ?? false;
  String? get rememberedEmail => _prefs.getString(_rememberedEmailKey);
  String? get rememberedPassword => _prefs.getString(_rememberedPasswordKey);

  // Clear only remember me data (if user wants to forget credentials)
  Future<void> clearRememberMe() async {
    await Future.wait([
      _prefs.remove(_rememberMeKey),
      _prefs.remove(_rememberedEmailKey),
      _prefs.remove(_rememberedPasswordKey),
    ]);
  }

  // Clear all data (logout) - but preserve remember me settings
  Future<void> clearAll() async {
    await Future.wait([
      _prefs.remove(_accessTokenKey),
      _prefs.remove(_refreshTokenKey),
      _prefs.remove(_sessionTokenKey),
      _prefs.remove(_tokenExpirationKey),
      _prefs.remove(_userIdKey),
      _prefs.remove(_userUuidKey),
      _prefs.remove(_userEmailKey),
      _prefs.remove(_userStatusKey),
      // Note: We DON'T clear remember me data on logout
      // This allows user to have email pre-filled on next login
    ]);
  }

  // Update access token (for refresh token flow)
  Future<void> updateAccessToken(String newAccessToken, {int? expiresIn}) async {
    final expirationTime = expiresIn != null 
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;
    
    await Future.wait([
      _prefs.setString(_accessTokenKey, newAccessToken),
      if (expirationTime != null)
        _prefs.setInt(_tokenExpirationKey, expirationTime.millisecondsSinceEpoch),
    ]);
  }
}
