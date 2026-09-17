import '../../../../core/services/driver_api_service.dart';

class DriverTripActions {
  final DriverApiService apiService;

  DriverTripActions(this.apiService);

  Future<bool> markArrived(String? rideId) async {
    if (rideId == null) return false;
    return apiService.updateTripStatus(rideId: rideId, status: 'arrived');
  }

  Future<bool> startTripWithOtp(String? rideId, String otp) async {
    if (rideId == null) return false;
    return apiService.updateTripStatus(
      rideId: rideId,
      status: 'in_progress',
      otp: otp.trim(),
    );
  }

  Future<bool> completeTripWithOtp(String? rideId, String otp) async {
    if (rideId == null) return false;
    return apiService.updateTripStatus(
      rideId: rideId,
      status: 'completed',
      otp: otp.trim(),
    );
  }
}
