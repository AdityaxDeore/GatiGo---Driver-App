import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsDriverRegistered = 'is_driver_registered';
  static const String _keyIsVerificationPending = 'is_verification_pending';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyProfileImageUrl = 'profile_image_url';
  static const String _keyDriverName = 'driver_name';
  static const String _keyDriverPhone = 'driver_phone';
  static const String _keyVehicleNumber = 'vehicle_number';
  static const String _keyAutoType = 'auto_type';

  static bool _isLoggedIn = false;
  static bool _isDriverRegistered = false;
  static bool _isVerificationPending = false;
  static String? _authToken;
  static String? _profileImageUrl;
  static String _driverName = 'Driver';
  static String _driverPhone = '';
  static String _vehicleNumber = '';
  static String _autoType = 'Pink Auto';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _isDriverRegistered = prefs.getBool(_keyIsDriverRegistered) ?? false;
    _isVerificationPending = prefs.getBool(_keyIsVerificationPending) ?? false;
    _authToken = prefs.getString(_keyAuthToken);
    _profileImageUrl = prefs.getString(_keyProfileImageUrl);
    _driverName = prefs.getString(_keyDriverName) ?? 'Driver';
    _driverPhone = prefs.getString(_keyDriverPhone) ?? '';
    _vehicleNumber = prefs.getString(_keyVehicleNumber) ?? '';
    _autoType = prefs.getString(_keyAutoType) ?? 'Pink Auto';
  }

  static bool isLoggedIn() => _isLoggedIn;

  static bool isDriverRegistered() => _isDriverRegistered;

  static bool isVerificationPending() => _isVerificationPending;

  static String? getAuthToken() => _authToken;

  static String? getProfileImageUrl() => _profileImageUrl;

  static String getDriverName() => _driverName;

  static String getDriverPhone() => _driverPhone;

  static String getVehicleNumber() => _vehicleNumber;

  static String getAutoType() => _autoType;

  static Future<void> login(
    String token, {
    bool isRegistered = false,
    String? phone,
    String? name,
  }) async {
    _isLoggedIn = true;
    _authToken = token;
    _isDriverRegistered = isRegistered;
    if (phone != null && phone.isNotEmpty) _driverPhone = phone;
    if (name != null && name.isNotEmpty) _driverName = name;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyAuthToken, token);
    await prefs.setBool(_keyIsDriverRegistered, isRegistered);
    if (phone != null && phone.isNotEmpty) {
      await prefs.setString(_keyDriverPhone, phone);
    }
    if (name != null && name.isNotEmpty) {
      await prefs.setString(_keyDriverName, name);
    }
  }

  static Future<void> submitForVerification({
    String? name,
    String? phone,
    String? vehicleNumber,
    String? autoType,
  }) async {
    _isVerificationPending = true;
    if (name != null && name.isNotEmpty) _driverName = name;
    if (phone != null && phone.isNotEmpty) _driverPhone = phone;
    if (vehicleNumber != null && vehicleNumber.isNotEmpty) {
      _vehicleNumber = vehicleNumber;
    }
    if (autoType != null && autoType.isNotEmpty) {
      _autoType = autoType;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsVerificationPending, true);
    if (name != null && name.isNotEmpty) {
      await prefs.setString(_keyDriverName, name);
    }
    if (phone != null && phone.isNotEmpty) {
      await prefs.setString(_keyDriverPhone, phone);
    }
    if (vehicleNumber != null && vehicleNumber.isNotEmpty) {
      await prefs.setString(_keyVehicleNumber, vehicleNumber);
    }
    if (autoType != null && autoType.isNotEmpty) {
      await prefs.setString(_keyAutoType, autoType);
    }
  }

  static Future<void> approveDriver() async {
    _isLoggedIn = true;
    _isDriverRegistered = true;
    _isVerificationPending = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setBool(_keyIsDriverRegistered, true);
    await prefs.setBool(_keyIsVerificationPending, false);
  }

  static Future<void> setDriverRegistered(bool isRegistered) async {
    _isDriverRegistered = isRegistered;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDriverRegistered, isRegistered);
  }

  static Future<void> logout() async {
    _isLoggedIn = false;
    _isDriverRegistered = false;
    _isVerificationPending = false;
    _authToken = null;
    _profileImageUrl = null;
    _driverName = 'Driver';
    _driverPhone = '';
    _vehicleNumber = '';
    _autoType = 'Auto';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyIsDriverRegistered);
    await prefs.remove(_keyIsVerificationPending);
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyProfileImageUrl);
    await prefs.remove(_keyDriverName);
    await prefs.remove(_keyDriverPhone);
    await prefs.remove(_keyVehicleNumber);
    await prefs.remove(_keyAutoType);
  }

  static Future<void> saveProfileImage(String url) async {
    _profileImageUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImageUrl, url);
  }

  static Future<void> clear() async {
    await logout();
  }
}

