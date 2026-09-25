import 'package:flutter/material.dart';
import '../../localization/translated_text.dart';
import '../../theme/theme.dart';

class MdsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;
  final bool isLoading;

  const MdsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: PinkAppTheme.primaryPink,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: TranslatedText(
                      text,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      );
    }

    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TranslatedText(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 18),
              ],
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );
  }
}
