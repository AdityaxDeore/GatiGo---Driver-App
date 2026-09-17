import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'driver_api_service.dart';

class LocationStreamingService {
  static final LocationStreamingService _instance =
      LocationStreamingService._internal();
  factory LocationStreamingService() => _instance;
  LocationStreamingService._internal();

  final DriverApiService _api = DriverApiService();
  StreamSubscription<Position>? _positionSubscription;
  Timer? _heartbeatTimer;
  Position? _lastSentPosition;
  DateTime? _lastSentTime;
  bool _isStreaming = false;

  bool get isStreaming => _isStreaming;
  Position? get lastPosition => _lastSentPosition;

  Future<void> startStreaming() async {
    if (_isStreaming) return;
    _isStreaming = true;

    try {
      final currentPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _sendLocation(currentPos);
    } catch (e) {
      debugPrint('Initial location fetch failed: $e');
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 10 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      final now = DateTime.now();
      if (_lastSentTime == null ||
          now.difference(_lastSentTime!).inSeconds >= 5) {
        _sendLocation(position);
      }
    }, onError: (err) {
      debugPrint('Location stream error: $err');
    });

    // Heartbeat every 15 seconds if stationary so driver stays online in RTDB
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      if (!_isStreaming) return;
      final now = DateTime.now();
      if (_lastSentPosition != null &&
          (_lastSentTime == null ||
              now.difference(_lastSentTime!).inSeconds >= 14)) {
        _sendLocation(_lastSentPosition!);
      }
    });
  }

  Future<void> _sendLocation(Position pos) async {
    _lastSentPosition = pos;
    _lastSentTime = DateTime.now();
    try {
      await _api.updateLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        heading: pos.heading,
        speed: pos.speed,
      );
    } catch (e) {
      debugPrint('Failed to stream location to backend: $e');
    }
  }

  void stopStreaming() {
    _isStreaming = false;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}
