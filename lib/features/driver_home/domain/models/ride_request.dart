class LocationCoordinate {
  final double latitude;
  final double longitude;

  const LocationCoordinate({required this.latitude, required this.longitude});

  factory LocationCoordinate.fromJson(dynamic json) {
    if (json is Map) {
      return LocationCoordinate(
        latitude: (json['latitude'] ?? json['lat'] ?? 0.0).toDouble(),
        longitude: (json['longitude'] ?? json['lng'] ?? 0.0).toDouble(),
      );
    }
    return const LocationCoordinate(latitude: 0.0, longitude: 0.0);
  }
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

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickup'] ?? {};
    final dropoff = json['dropoff'] ?? {};
    final fare = (json['fare'] ?? json['estimated_fare'] ?? 0.0).toDouble();
    final distance = (json['distance_km'] ?? json['estimated_distance_km'] ?? 0.0).toDouble();
    final duration = (json['duration_mins'] ?? json['estimated_duration_mins'] ?? 0).toInt();

    DateTime exp;
    if (json['dispatch_expires_at'] != null) {
      exp = DateTime.tryParse(json['dispatch_expires_at'].toString()) ??
          DateTime.now().add(const Duration(seconds: 15));
    } else {
      exp = DateTime.now().add(const Duration(seconds: 15));
    }

    return RideRequest(
      id: json['id'] ?? json['ride_id'] ?? '',
      riderName: json['rider_name'] ?? json['riderName'] ?? 'Rider',
      pickupLocation: LocationCoordinate.fromJson(pickup['location'] ?? pickup),
      pickupAddress: pickup['address'] ?? json['pickup_address'] ?? 'Pickup Point',
      destinationLocation: LocationCoordinate.fromJson(dropoff['location'] ?? dropoff),
      destinationAddress: dropoff['address'] ?? json['destination_address'] ?? 'Destination Point',
      estimatedDistanceKm: distance,
      estimatedDurationMins: duration,
      estimatedFare: fare,
      rideType: json['service_type'] ?? json['rideType'] ?? 'pink_auto',
      expiresAt: exp,
    );
  }
}
