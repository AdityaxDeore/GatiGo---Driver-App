import 'package:flutter/material.dart';
import '../../localization/translated_text.dart';

class MdsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;

  const MdsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            TranslatedText(text),
          ],
        ),
      );
    }

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TranslatedText(text),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 18),
        ],
      ],
    );

    return ElevatedButton(
      onPressed: onPressed,
      child: buttonChild,
    );
  }
}
