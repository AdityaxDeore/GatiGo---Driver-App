import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Small chip displaying distance, duration, and priority highlights.
class RideHighlightChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPink;

  const RideHighlightChip({
    super.key,
    required this.icon,
    required this.label,
    this.isPink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isPink ? PinkAppTheme.backgroundLight : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isPink ? PinkAppTheme.primaryPink : Colors.black54,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPink ? PinkAppTheme.primaryPink : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
