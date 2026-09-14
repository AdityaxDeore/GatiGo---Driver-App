import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class PickupNavigationCard extends StatelessWidget {
  final RideRequest request;
  final VoidCallback onArrived;
  final bool hasArrived;

  const PickupNavigationCard({
    super.key,
    required this.request,
    required this.onArrived,
    this.hasArrived = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: PinkAppTheme.primaryPink.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: PinkAppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.navigation, color: PinkAppTheme.primaryPink, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "En Route to Pickup",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.pickupAddress,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: PinkAppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Distance Remaining", style: TextStyle(color: Colors.black54, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            "${request.estimatedDistanceKm} km",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: PinkAppTheme.textDark,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Estimated Time", style: TextStyle(color: Colors.black54, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            "${request.estimatedDurationMins} min",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: PinkAppTheme.primaryPink,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: hasArrived
                    ? SizedBox(
                        key: const ValueKey('arrived_pickup_btn'),
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: onArrived,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PinkAppTheme.primaryPink,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: PinkAppTheme.primaryPink.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "ARRIVED AT PICKUP",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey('driving_pickup_banner'),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: PinkAppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: PinkAppTheme.primaryPink.withValues(alpha: 0.2)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: PinkAppTheme.primaryPink,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Driving to Pickup Location...",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: PinkAppTheme.primaryPink,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
