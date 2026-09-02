class LocationCoordinate {
  final double latitude;
  final double longitude;

  const LocationCoordinate({required this.latitude, required this.longitude});
}

class RideRequest {
  final String id;
  final String riderName;
  final LocationCoordinate pickupLocation;
  final String pickupAddress;
  final LocationCoordinate destinationLocation;
  final String destinationAddress;
  final double estimatedDistanceKm;
  final int estimatedDurationMins;
  final double estimatedFare;
  final String rideType;
  final DateTime expiresAt;

  RideRequest({
    required this.id,
    required this.riderName,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.destinationLocation,
    required this.destinationAddress,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMins,
    required this.estimatedFare,
    required this.rideType,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
