import 'package:flutter/material.dart';
import '../../../../core/localization/translated_text.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/phone_auth_viewmodel.dart';

/// Title and instructional subtitle header for driver authentication steps.
class DriverAuthHeader extends StatelessWidget {
  final AuthState currentStep;
  final String phone;
  final TextTheme textTheme;
  final VoidCallback? onEditPhone;

  const DriverAuthHeader({
    super.key,
    required this.currentStep,
    required this.phone,
    required this.textTheme,
    this.onEditPhone,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case AuthState.enteringPhone:
        return Column(
          key: const ValueKey(AuthState.enteringPhone),
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              "Enter your mobile number",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: PinkAppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TranslatedText(
              "We will send you a 6-digit verification code.",
              style: textTheme.bodyMedium?.copyWith(
                color: PinkAppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case AuthState.enteringOtp:
        return Column(
          key: const ValueKey(AuthState.enteringOtp),
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              "Enter confirmation code",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: PinkAppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                TranslatedText(
                  "A verification code has been successfully dispatched to +91 $phone",
                  style: textTheme.bodyMedium?.copyWith(
                    color: PinkAppTheme.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onEditPhone != null)
                  GestureDetector(
                    onTap: onEditPhone,
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: PinkAppTheme.primaryPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
    }
  }
}
