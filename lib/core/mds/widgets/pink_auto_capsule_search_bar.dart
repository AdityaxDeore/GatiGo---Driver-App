import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PinkAutoCapsuleSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const PinkAutoCapsuleSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1.0),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: PinkAppTheme.primaryPink, size: 24.0),
            SizedBox(width: 12.0),
            Expanded(
              child: Text(
                'Where to?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: PinkAppTheme.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
