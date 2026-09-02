import 'dart:async';
import '../models/ride_request.dart';
import '../models/driver_status.dart';

class RideService {
  DriverStatus _currentStatus = DriverStatus.offline;
  Timer? _mockRequestTimer;
  final StreamController<RideRequest?> _requestStreamController = StreamController.broadcast();

  Stream<RideRequest?> get incomingRequests => _requestStreamController.stream;

  Future<bool> setOnlineStatus(bool isOnline, LocationCoordinate currentLoc) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _currentStatus = isOnline ? DriverStatus.online : DriverStatus.offline;

    if (isOnline) {
      _startMockRequestGenerator(currentLoc);
    } else {
      _stopMockRequestGenerator();
      _requestStreamController.add(null);
    }

    return true;
  }

  void _startMockRequestGenerator(LocationCoordinate currentLoc) {
    _mockRequestTimer?.cancel();
    // Generate a mock request after 5 seconds of going online
    _mockRequestTimer = Timer(const Duration(seconds: 5), () {
      if (_currentStatus == DriverStatus.online) {
        final mockRequest = RideRequest(
          id: 'req_\${DateTime.now().millisecondsSinceEpoch}',
          riderName: 'Priya M.',
          pickupLocation: LocationCoordinate(
              latitude: currentLoc.latitude + 0.002,
              longitude: currentLoc.longitude + 0.002),
          pickupAddress: 'Tech Park Main Gate',
          destinationLocation: LocationCoordinate(
              latitude: currentLoc.latitude + 0.05,
              longitude: currentLoc.longitude + 0.05),
          destinationAddress: 'Indiranagar 100ft Road',
          estimatedDistanceKm: 4.2,
          estimatedDurationMins: 15,
          estimatedFare: 120.0,
          rideType: 'Pink Auto Standard',
          expiresAt: DateTime.now().add(const Duration(seconds: 15)),
        );
        _requestStreamController.add(mockRequest);
      }
    });
  }

  void _stopMockRequestGenerator() {
    _mockRequestTimer?.cancel();
  }

  Future<bool> acceptRequest(String requestId) async {
    // Mock backend assigning the ride
    await Future.delayed(const Duration(milliseconds: 800));
    // Assume success for now, in real life check if still available
    _stopMockRequestGenerator();
    _requestStreamController.add(null);
    return true;
  }

  Future<bool> rejectRequest(String requestId, LocationCoordinate currentLoc) async {
    // Mock backend handling rejection
    await Future.delayed(const Duration(milliseconds: 300));
    _requestStreamController.add(null);
    _startMockRequestGenerator(currentLoc); // start waiting for next ride
    return true;
  }
}
