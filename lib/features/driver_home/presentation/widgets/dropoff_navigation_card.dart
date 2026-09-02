import 'package:flutter/material.dart';
import 'package:pink_auto/core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class DropoffNavigationCard extends StatelessWidget {
  final RideRequest request;
  final VoidCallback onCompleteRide;

  const DropoffNavigationCard({
    super.key,
    required this.request,
    required this.onCompleteRide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
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
                  const Icon(Icons.location_on, color: PinkAppTheme.primary, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Navigating to Drop-off", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text(request.destinationAddress, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Remaining", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("\${request.estimatedDistanceKm} km", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("ETA", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("\${request.estimatedDurationMins} min", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: PinkAppTheme.success)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onCompleteRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PinkAppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text(
                    "COMPLETE RIDE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
