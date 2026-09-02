import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/driver_status.dart';
import '../../domain/models/trip_state.dart';
import '../../domain/models/ride_request.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/ride_service.dart';

class DriverHomeViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final RideService _rideService = RideService();

  DriverStatus _status = DriverStatus.offline;
  TripState _tripState = TripState.available;
  LocationCoordinate? _currentLocation;
  RideRequest? _currentRequest;
  String? _errorMessage;

  StreamSubscription<LocationCoordinate>? _locationSub;
  StreamSubscription<RideRequest?>? _rideSub;

  DriverStatus get status => _status;
  TripState get tripState => _tripState;
  LocationCoordinate? get currentLocation => _currentLocation;
  RideRequest? get currentRequest => _currentRequest;
  String? get errorMessage => _errorMessage;

  bool get isOnline => _status == DriverStatus.online;

  DriverHomeViewModel() {
    _init();
  }

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
        notifyListeners();
      } else if (request == null && _tripState == TripState.requestReceived) {
        _currentRequest = null;
        _tripState = TripState.available;
        notifyListeners();
      }
    });
  }

  Future<void> toggleOnlineStatus() async {
    if (_status == DriverStatus.goingOnline || _status == DriverStatus.goingOffline) return;

    if (!isOnline) {
      _status = DriverStatus.goingOnline;
      _errorMessage = null;
      notifyListeners();

      final hasPerm = await _locationService.checkPermissions();
      if (!hasPerm) {
        _status = DriverStatus.error;
        _errorMessage = "Location permission is required to go online.";
        notifyListeners();
        return;
      }

      _currentLocation ??= await _locationService.getCurrentLocation();
      if (_currentLocation == null) {
        _status = DriverStatus.error;
        _errorMessage = "Could not determine location.";
        notifyListeners();
        return;
      }

      final success = await _rideService.setOnlineStatus(true, _currentLocation!);
      if (success) {
        _status = DriverStatus.online;
        _tripState = TripState.available;
        
        // Start tracking location
        _locationSub = _locationService.getLocationStream().listen((loc) {
          _currentLocation = loc;
          notifyListeners();
        });
      } else {
        _status = DriverStatus.error;
        _errorMessage = "Failed to go online.";
      }
      notifyListeners();
    } else {
      _status = DriverStatus.goingOffline;
      notifyListeners();

      final success = await _rideService.setOnlineStatus(false, _currentLocation!);
      if (success) {
        _status = DriverStatus.offline;
        _tripState = TripState.available;
        _currentRequest = null;
        _locationSub?.cancel();
      } else {
        _status = DriverStatus.error;
        _errorMessage = "Failed to go offline.";
      }
      notifyListeners();
    }
  }

  void handleRequestExpired() {
    if (_tripState == TripState.requestReceived) {
      _tripState = TripState.available;
      _currentRequest = null;
      notifyListeners();
      if (_currentLocation != null) {
        _rideService.rejectRequest('expired', _currentLocation!);
      }
    }
  }

  Future<void> acceptRide() async {
    if (_currentRequest == null) return;
    
    final success = await _rideService.acceptRequest(_currentRequest!.id);
    if (success) {
      _tripState = TripState.drivingToPickup;
      notifyListeners();
    } else {
      _errorMessage = "Ride no longer available.";
      _tripState = TripState.available;
      _currentRequest = null;
      notifyListeners();
    }
  }

  Future<void> rejectRide() async {
    if (_currentRequest == null || _currentLocation == null) return;
    
    _tripState = TripState.available;
    final reqId = _currentRequest!.id;
    _currentRequest = null;
    notifyListeners();

    await _rideService.rejectRequest(reqId, _currentLocation!);
  }

  void arrivedAtPickup() {
    if (_tripState == TripState.drivingToPickup) {
      _tripState = TripState.arrivedAtPickup;
      notifyListeners();
    }
  }

  Future<bool> startTrip(String otp) async {
    // Mock OTP validation (e.g., '1234' is correct)
    if (otp == '1234') {
      _tripState = TripState.tripStarted;
      notifyListeners();
      return true;
    }
    return false;
  }

  void completeTrip() {
    if (_tripState == TripState.tripStarted) {
      _tripState = TripState.completed;
      notifyListeners();
    }
  }

  void resetToOnline() {
    if (_tripState == TripState.completed && _currentLocation != null) {
      _tripState = TripState.available;
      _currentRequest = null;
      notifyListeners();
      _rideService.setOnlineStatus(true, _currentLocation!); // trigger next mock request
    }
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _rideSub?.cancel();
    super.dispose();
  }
}
