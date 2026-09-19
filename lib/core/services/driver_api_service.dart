import '../network/api_client.dart';

class DriverApiService {
  final ApiClient _client = ApiClient();

  // 1. Toggle Duty Status (Online / Offline)
  Future<bool> setDutyStatus(bool isOnline, {double? latitude, double? longitude}) async {
    try {
      final body = <String, dynamic>{
        'duty_status': isOnline ? 'online' : 'offline',
      };
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;

      await _client.patch('/api/v1/drivers/me/status', body: body);
      return true;
    } catch (_) {
      return false;
    }
  }

  // 2. Stream Real-Time Driver Location to RTDB & Fleet Engine
  Future<bool> updateLocation({
    required double lat,
    required double lng,
    double? heading,
    double? speed,
  }) async {
    try {
      await _client.patch(
        '/api/v1/drivers/me/location',
        body: {
          'latitude': lat,
          'longitude': lng,
          if (heading != null) 'heading': heading,
          if (speed != null) 'speed': speed,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // 3. Respond to Dispatch (Accept / Reject)
  Future<bool> respondToDispatch({
    required String rideId,
    required String action, // 'accept' | 'reject'
  }) async {
    try {
      final res = await _client.patch(
        '/api/v1/rides/$rideId/respond',
        body: {'action': action},
      );
      return res != null;
    } catch (_) {
      return false;
    }
  }

  // 4. Update Ride Lifecycle State
  Future<bool> updateTripStatus({
    required String rideId,
    required String status,
    String? otp,
  }) async {
    try {
      await _client.patch(
        '/api/v1/rides/$rideId/status',
        body: {
          'status': status,
          if (otp != null) 'otp': otp,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // 5. Fetch Single Ride Details
  Future<Map<String, dynamic>?> getRide(String rideId) async {
    try {
      final res = await _client.get('/api/v1/rides/$rideId');
      return res is Map<String, dynamic> ? (res['data'] ?? res) : null;
    } catch (_) {
      return null;
    }
  }

  // 6. Fetch Available Rides Nearby (Fallback Poller)
  Future<List<dynamic>> getAvailableRides({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      final res = await _client.get(
        '/api/v1/rides/available?latitude=$latitude&longitude=$longitude&radiusKm=$radiusKm',
      );
      if (res is Map && res['data'] is List) {
        return res['data'];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // 6. Update Driver FCM Device Token
  Future<bool> updateFcmToken(String token) async {
    try {
      await _client.patch('/api/v1/users/me', body: {'fcm_token': token});
      return true;
    } catch (_) {
      return false;
    }
  }

  // 7. Driver Profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await _client.get('/api/v1/drivers/me');
      return res is Map<String, dynamic> ? (res['data'] ?? res) : null;
    } catch (_) {
      return null;
    }
  }

  // 8. Driver Registration
  Future<Map<String, dynamic>?> registerDriver({
    required String fullName,
    required String phone,
    required String licenseNumber,
    required String vehiclePlate,
    required String vehicleMakeModel,
    String serviceType = 'pink_auto',
    String gender = 'female',
  }) async {
    try {
      final res = await _client.post(
        '/api/v1/drivers/register-complete',
        body: {
          'full_name': fullName,
          'phone_number': phone,
          'license_number': licenseNumber,
          'vehicle_plate': vehiclePlate,
          'vehicle_make_model': vehicleMakeModel,
          'service_type': serviceType,
          'gender': gender,
        },
      );
      return res is Map<String, dynamic> ? (res['data'] ?? res) : null;
    } catch (_) {
      return null;
    }
  }

  // 9. Auth & Registration Verification
  Future<Map<String, dynamic>> requestOtp({required String phoneNumber}) async {
    try {
      final res = await _client.post('/api/v1/auth/request-otp', body: {'phone_number': phoneNumber, 'role': 'driver'});
      return res is Map<String, dynamic> ? res : {'success': false, 'error': 'Invalid response'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({required String phoneNumber, required String otp}) async {
    try {
      final res = await _client.post('/api/v1/auth/verify-otp', body: {'phone_number': phoneNumber, 'otp': otp, 'role': 'driver'});
      return res is Map<String, dynamic> ? res : {'success': false, 'error': 'Invalid response'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> getRegistrationStatus() async {
    try {
      final res = await _client.get('/api/v1/drivers/me/registration-status');
      return res is Map<String, dynamic> ? (res['data'] ?? res) : null;
    } catch (_) {
      return null;
    }
  }
}
