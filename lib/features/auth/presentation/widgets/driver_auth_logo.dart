import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Circular branded logo badge displayed at the top of driver auth screen.
class DriverAuthLogo extends StatelessWidget {
  const DriverAuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PinkAppTheme.primaryPink,
          border: Border.all(
            color: PinkAppTheme.primaryPink.withValues(alpha: 0.2),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: PinkAppTheme.primaryPink.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: Transform.scale(
            scale: 1.18,
            child: Image.asset(
              'assets/images/logo_new.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
