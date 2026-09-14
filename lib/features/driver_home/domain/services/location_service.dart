import 'package:geolocator/geolocator.dart';
import '../models/ride_request.dart';

class LocationService {
  /// Prompts the user for location access if not already granted.
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    } 

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    return true;
  }

  Future<LocationCoordinate?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    try {
      final lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null) {
        return LocationCoordinate(
          latitude: lastPos.latitude,
          longitude: lastPos.longitude,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(milliseconds: 1500),
        ),
      );
      return LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return const LocationCoordinate(
        latitude: 12.9716,
        longitude: 77.5946,
      );
    }
  }

  Stream<LocationCoordinate> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )
    ).map((pos) => LocationCoordinate(latitude: pos.latitude, longitude: pos.longitude));
  }
}
