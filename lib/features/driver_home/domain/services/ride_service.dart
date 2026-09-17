import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/services/driver_api_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/location_streaming_service.dart';
import '../models/ride_request.dart';
import '../models/driver_status.dart';

class RideService {
  final DriverApiService _apiService = DriverApiService();
  final FcmService _fcmService = FcmService();
  final LocationStreamingService _locationStreamer = LocationStreamingService();

  DriverStatus _currentStatus = DriverStatus.offline;
  final StreamController<RideRequest?> _requestStreamController =
      StreamController.broadcast();
  StreamSubscription<Map<String, dynamic>>? _fcmSub;
  Timer? _dispatchPollTimer;

  Stream<RideRequest?> get incomingRequests => _requestStreamController.stream;

  RideService() {
    _initFcmListener();
  }

  void _initFcmListener() {
    _fcmSub = _fcmService.onRideRequest.listen((data) async {
      if (_currentStatus != DriverStatus.online) return;
      final rideId = data['ride_id'] ?? data['id'];
      if (rideId != null) {
        await _fetchAndEmitRide(rideId.toString(), fallbackData: data);
      }
    });
  }

  Future<void> _fetchAndEmitRide(String rideId, {Map<String, dynamic>? fallbackData}) async {
    try {
      final rideData = await _apiService.getRide(rideId);
      if (rideData != null) {
        final request = RideRequest.fromJson(rideData);
        _requestStreamController.add(request);
        return;
      }
    } catch (e) {
      debugPrint('Error fetching dispatched ride: $e');
    }

    if (fallbackData != null) {
      try {
        final request = RideRequest.fromJson(fallbackData);
        _requestStreamController.add(request);
      } catch (_) {}
    }
  }

  Future<bool> setOnlineStatus(bool isOnline, LocationCoordinate currentLoc) async {
    final success = await _apiService.setDutyStatus(
      isOnline,
      latitude: currentLoc.latitude,
      longitude: currentLoc.longitude,
    );

    _currentStatus = isOnline ? DriverStatus.online : DriverStatus.offline;

    if (isOnline) {
      await _locationStreamer.startStreaming();
      _startDispatchPoller(currentLoc);
    } else {
      _locationStreamer.stopStreaming();
      _stopDispatchPoller();
      _requestStreamController.add(null);
    }

    return success;
  }

  void _startDispatchPoller(LocationCoordinate currentLoc) {
    _dispatchPollTimer?.cancel();
    // Fallback periodic poll in case FCM is delayed
    _dispatchPollTimer = Timer.periodic(const Duration(seconds: 8), (_) async {
      if (_currentStatus != DriverStatus.online) return;
      try {
        final available = await _apiService.getAvailableRides(
          latitude: currentLoc.latitude,
          longitude: currentLoc.longitude,
        );
        if (available.isNotEmpty) {
          final first = available.first;
          if (first is Map<String, dynamic>) {
            _requestStreamController.add(RideRequest.fromJson(first));
          }
        }
      } catch (_) {}
    });
  }

  void _stopDispatchPoller() {
    _dispatchPollTimer?.cancel();
    _dispatchPollTimer = null;
  }

  Future<bool> acceptRequest(String requestId) async {
    final success = await _apiService.respondToDispatch(
      rideId: requestId,
      action: 'accept',
    );
    if (success) {
      _requestStreamController.add(null);
    }
    return success;
  }

  Future<bool> rejectRequest(String requestId, LocationCoordinate currentLoc) async {
    await _apiService.respondToDispatch(
      rideId: requestId,
      action: 'reject',
    );
    _requestStreamController.add(null);
    return true;
  }

  void dispose() {
    _fcmSub?.cancel();
    _stopDispatchPoller();
    _requestStreamController.close();
  }
}
