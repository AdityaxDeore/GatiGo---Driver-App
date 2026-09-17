import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

/// Top Turn-By-Turn navigation overlay HUD during active driving state.
class TripNavigationHud extends StatelessWidget {
  final bool isDrivingToPickup;
  final RideRequest? request;
  final double progress;

  const TripNavigationHud({
    super.key,
    required this.isDrivingToPickup,
    this.request,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 64, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PinkAppTheme.primaryPink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDrivingToPickup
                      ? Icons.turn_left
                      : Icons.navigation_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isDrivingToPickup
                          ? "En route to Pickup (${request?.pickupAddress ?? 'Tech Park'})"
                          : "Heading to Drop-off (${request?.destinationAddress ?? 'Indiranagar'})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDrivingToPickup
                          ? "In ${((1.0 - progress) * 1.5).toStringAsFixed(1)} km • Speed: 28 km/h"
                          : "In ${((1.0 - progress) * 4.2).toStringAsFixed(1)} km • Speed: 34 km/h",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.navigation,
                      size: 11,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDrivingToPickup ? "GPS" : "LIVE",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
