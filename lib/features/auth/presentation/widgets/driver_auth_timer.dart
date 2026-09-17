import 'package:flutter/material.dart';
import '../../../../core/localization/translated_text.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/phone_auth_viewmodel.dart';

/// OTP countdown timer and resend button row.
class DriverAuthTimer extends StatelessWidget {
  final AuthState currentStep;
  final bool canResendOtp;
  final int resendTimerSeconds;
  final VoidCallback onResend;
  final TextTheme textTheme;

  const DriverAuthTimer({
    super.key,
    required this.currentStep,
    required this.canResendOtp,
    required this.resendTimerSeconds,
    required this.onResend,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep != AuthState.enteringOtp) {
      return const SizedBox.shrink(key: ValueKey('empty_timer'));
    }
    return Padding(
      key: const ValueKey('otp_timer'),
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TranslatedText(
            !canResendOtp
                ? "Resend code in ${resendTimerSeconds}s"
                : "Didn't receive the code? ",
            style: textTheme.bodyMedium,
          ),
          if (canResendOtp)
            GestureDetector(
              onTap: onResend,
              child: TranslatedText(
                "Resend OTP",
                style: textTheme.bodyMedium?.copyWith(
                  color: PinkAppTheme.primaryPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
