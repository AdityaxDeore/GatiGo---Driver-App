import 'package:geolocator/geolocator.dart';
import '../models/ride_request.dart';

class LocationService {
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    } 

    return true;
  }

  Future<LocationCoordinate?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    final position = await Geolocator.getCurrentPosition();
    return LocationCoordinate(latitude: position.latitude, longitude: position.longitude);
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
