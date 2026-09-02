class SessionStorage {
  static bool _isLoggedIn = false;
  static bool _isDriverRegistered = false;
  static String? _authToken;
  static String? _profileImageUrl;

  static bool isLoggedIn() {
    return _isLoggedIn;
  }

  static bool isDriverRegistered() {
    return _isDriverRegistered;
  }

  static String? getAuthToken() {
    return _authToken;
  }

  static String? getProfileImageUrl() {
    return _profileImageUrl;
  }

  static Future<void> login(String token, {bool isRegistered = false}) async {
    _isLoggedIn = true;
    _authToken = token;
    _isDriverRegistered = isRegistered;
  }

  static Future<void> logout() async {
    _isLoggedIn = false;
    _isDriverRegistered = false;
    _authToken = null;
    _profileImageUrl = null;
  }

  static Future<void> saveProfileImage(String url) async {
    _profileImageUrl = url;
  }

  static Future<void> clear() async {
    await logout();
  }
}
