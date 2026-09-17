import 'package:flutter/material.dart';
import 'package:pink_auto/core/theme/theme.dart';
import '../../domain/models/driver_status.dart';

/// Bottom bar displayed when driver is in available state to toggle duty status.
class DriverDutyBottomBar extends StatelessWidget {
  final DriverStatus status;
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const DriverDutyBottomBar({
    super.key,
    required this.status,
    required this.isOnline,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isTransitioning =
        status == DriverStatus.goingOnline || status == DriverStatus.goingOffline;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: PinkAppTheme.primaryPink.withValues(alpha: 0.1),
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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: PinkAppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Earnings",
                              style: TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "₹0.00",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: PinkAppTheme.textDark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: PinkAppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Completed Rides",
                              style: TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isTransitioning ? null : onToggleStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOnline
                          ? const Color(0xFF2C2C3E)
                          : PinkAppTheme.primaryPink,
                      elevation: isOnline ? 2 : 6,
                      shadowColor:
                          PinkAppTheme.primaryPink.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isTransitioning
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isOnline
                                    ? Icons.power_settings_new
                                    : Icons.bolt,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isOnline ? "GO OFFLINE" : "GO ONLINE",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  color: Colors.white,
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
      ),
    );
  }
}
