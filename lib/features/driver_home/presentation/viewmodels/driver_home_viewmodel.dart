import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/driver_status.dart';
import '../../domain/models/trip_state.dart';
import '../../domain/models/ride_request.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/ride_service.dart';
import '../../../../core/services/driver_api_service.dart';
import 'driver_trip_actions.dart';

class DriverHomeViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final RideService _rideService = RideService();
  final DriverApiService _apiService = DriverApiService();
  late final DriverTripActions _tripActions = DriverTripActions(_apiService);

  DriverStatus _status = DriverStatus.offline;
  TripState _tripState = TripState.available;
  LocationCoordinate? _currentLocation;
  RideRequest? _currentRequest;
  String? _errorMessage;
  bool _hasReachedPickup = false;
  bool _hasReachedDestination = false;

  StreamSubscription<LocationCoordinate>? _locationSub;
  StreamSubscription<RideRequest?>? _rideSub;

  DriverStatus get status => _status;
  TripState get tripState => _tripState;
  LocationCoordinate? get currentLocation => _currentLocation;
  RideRequest? get currentRequest => _currentRequest;
  String? get errorMessage => _errorMessage;
  bool get hasReachedPickup => _hasReachedPickup;
  bool get hasReachedDestination => _hasReachedDestination;
  bool get isOnline => _status == DriverStatus.online;

  DriverHomeViewModel() { _init(); }

  Future<void> _init() async {
    final hasPerm = await _locationService.checkPermissions();
    if (hasPerm) {
      _currentLocation = await _locationService.getCurrentLocation();
      notifyListeners();
    }
    _rideSub = _rideService.incomingRequests.listen((request) {
      if (request != null && _tripState == TripState.available) {
        _currentRequest = request;
        _tripState = TripState.requestReceived;
      } else if (request == null && _tripState == TripState.requestReceived) {
        _currentRequest = null;
        _tripState = TripState.available;
      }
      notifyListeners();
    });
  }

  Future<void> toggleOnlineStatus() async {
    if (_status == DriverStatus.goingOnline || _status == DriverStatus.goingOffline) return;
    if (!isOnline) {
      _status = DriverStatus.goingOnline;
      _errorMessage = null;
      notifyListeners();

      final hasPerm = await _locationService.checkPermissions();
      _currentLocation ??= await _locationService.getCurrentLocation();
      if (!hasPerm || _currentLocation == null) {
        _status = DriverStatus.error;
        _errorMessage = !hasPerm ? "Location permission required." : "Location unavailable.";
        notifyListeners();
        return;
      }

      final success = await _rideService.setOnlineStatus(true, _currentLocation!);
      if (success) {
        _status = DriverStatus.online;
        _tripState = TripState.available;
        _locationSub = _locationService.getLocationStream().listen((loc) {
          _currentLocation = loc;
          notifyListeners();
        });
      } else {
        _status = DriverStatus.error;
        _errorMessage = "Failed to go online on server.";
      }
    } else {
      _status = DriverStatus.goingOffline;
      notifyListeners();
      await _rideService.setOnlineStatus(false, _currentLocation ?? const LocationCoordinate(latitude: 0, longitude: 0));
      _status = DriverStatus.offline;
      _tripState = TripState.available;
      _currentRequest = null;
      _locationSub?.cancel();
    }
    notifyListeners();
  }

  void handleRequestExpired() {
    if (_tripState == TripState.requestReceived && _currentRequest != null) {
      final reqId = _currentRequest!.id;
      _tripState = TripState.available;
      _currentRequest = null;
      notifyListeners();
      if (_currentLocation != null) _rideService.rejectRequest(reqId, _currentLocation!);
    }
  }

  Future<void> acceptRide() async {
    if (_currentRequest == null) return;
    final success = await _rideService.acceptRequest(_currentRequest!.id);
    if (success) {
      _hasReachedPickup = false;
      _hasReachedDestination = false;
      _tripState = TripState.drivingToPickup;
    } else {
      _errorMessage = "Ride no longer available.";
      _tripState = TripState.available;
      _currentRequest = null;
    }
    notifyListeners();
  }

  Future<void> rejectRide() async {
    if (_currentRequest == null || _currentLocation == null) return;
    final reqId = _currentRequest!.id;
    _tripState = TripState.available;
    _currentRequest = null;
    notifyListeners();
    await _rideService.rejectRequest(reqId, _currentLocation!);
  }

  void setReachedPickup(bool reached) {
    if (_hasReachedPickup != reached) { _hasReachedPickup = reached; notifyListeners(); }
  }

  void setReachedDestination(bool reached) {
    if (_hasReachedDestination != reached) { _hasReachedDestination = reached; notifyListeners(); }
  }

  Future<void> arrivedAtPickup() async {
    if (_tripState == TripState.drivingToPickup && _currentRequest != null) {
      _hasReachedPickup = true;
      _tripState = TripState.arrivedAtPickup;
      notifyListeners();
      await _tripActions.markArrived(_currentRequest!.id);
    }
  }

  Future<bool> startTrip(String otp) async {
    if (_currentRequest == null) return false;
    final ok = await _tripActions.startTripWithOtp(_currentRequest!.id, otp);
    if (ok) {
      _hasReachedDestination = false;
      _tripState = TripState.tripStarted;
      _errorMessage = null;
    } else {
      _errorMessage = "Invalid OTP. Please verify with rider.";
    }
    notifyListeners();
    return ok;
  }

  void arrivedAtDestination() {
    if (_tripState == TripState.tripStarted) {
      _hasReachedDestination = true;
      _tripState = TripState.arrivedAtDestination;
      notifyListeners();
    }
  }

  Future<bool> completeTripWithOtp(String otp) async {
    if (_currentRequest == null) return false;
    final ok = await _tripActions.completeTripWithOtp(_currentRequest!.id, otp);
    if (ok) {
      _tripState = TripState.completed;
      _errorMessage = null;
      notifyListeners();
    }
    return ok;
  }

  void resetToOnline() {
    if (_tripState == TripState.completed) {
      _tripState = TripState.available;
      _currentRequest = null;
      _hasReachedPickup = false;
      _hasReachedDestination = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _rideSub?.cancel();
    _rideService.dispose();
    super.dispose();
  }
}
