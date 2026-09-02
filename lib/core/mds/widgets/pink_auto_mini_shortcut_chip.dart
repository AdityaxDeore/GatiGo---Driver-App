import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PinkAutoMiniShortcutChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PinkAutoMiniShortcutChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1.0,
              ),
            ),
            child: Icon(
              icon,
              color: PinkAppTheme.accentPurple,
              size: 24.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: PinkAppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
