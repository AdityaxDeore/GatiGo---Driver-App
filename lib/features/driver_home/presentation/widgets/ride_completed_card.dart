import 'package:flutter/material.dart';
import 'package:pink_auto/core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class RideCompletedCard extends StatelessWidget {
  final RideRequest request;
  final VoidCallback onDone;

  const RideCompletedCard({
    super.key,
    required this.request,
    required this.onDone,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PinkAppTheme.primaryPink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: PinkAppTheme.primaryPink, size: 56),
              ),
              const SizedBox(height: 16),
              const Text(
                "Ride Completed!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PinkAppTheme.accentPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Collect cash from the rider", style: TextStyle(color: PinkAppTheme.textLight, fontSize: 15)),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: PinkAppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PinkAppTheme.primaryPink.withValues(alpha: 0.25)),
                ),
                child: Column(
                  children: [
                    const Text("Total Fare", style: TextStyle(color: PinkAppTheme.accentPurple, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "₹${request.estimatedFare.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: PinkAppTheme.primaryPink,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PinkAppTheme.primaryPink,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    "DONE & READY FOR NEXT RIDE",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
