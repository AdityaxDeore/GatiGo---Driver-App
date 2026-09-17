import '../network/api_client.dart';

class DriverApiService {
  final ApiClient _client = ApiClient();

  // 1. Toggle Duty Status (Online / Offline)
  Future<bool> setDutyStatus(bool isOnline) async {
    try {
      await _client.patch(
        '/api/v1/drivers/me/status',
        body: {
          'duty_status': isOnline ? 'online' : 'offline',
        },
      );
      return true;
    } catch (_) {
      // Return true to allow fallback simulation mode
      return false;
    }
  }

  // 2. Driver Profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await _client.get('/api/v1/drivers/me');
      return res is Map<String, dynamic> ? (res['data'] ?? res) : null;
    } catch (_) {
      return null;
    }
  }

  // 3. Available Nearby Rides for Bidding
  Future<List<dynamic>> getAvailableRides({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    String? serviceType,
  }) async {
    try {
      final query = 'latitude=$latitude&longitude=$longitude&radiusKm=$radiusKm${serviceType != null ? '&service_type=$serviceType' : ''}';
      final res = await _client.get('/api/v1/rides/available?$query');
      if (res is Map && res['data'] is List) {
        return res['data'];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // 4. Submit Offer / Bid
  Future<bool> submitOffer({
    required String rideId,
    required double proposedFare,
    required int estimatedArrivalMinutes,
  }) async {
    try {
      await _client.post(
        '/api/v1/rides/$rideId/offers',
        body: {
          'proposed_fare': proposedFare,
          'estimated_arrival_minutes': estimatedArrivalMinutes,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // 5. Update Ride Lifecycle State
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

  // 6. Driver Registration
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
}
