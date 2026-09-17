import 'package:flutter/material.dart';
import '../../../../core/mds/widgets/mds_button.dart';
import '../../../../core/mds/widgets/mds_otp_input.dart';
import '../../../../core/mds/widgets/mds_phone_input_field.dart';
import '../viewmodels/phone_auth_viewmodel.dart';

/// Renders either phone number input or 4-digit OTP input based on auth step.
class DriverAuthInputSwitcher extends StatelessWidget {
  final AuthState currentStep;
  final TextEditingController phoneController;
  final String? phoneError;
  final VoidCallback onPhoneSubmitted;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final ValueChanged<String> onOtpChanged;

  const DriverAuthInputSwitcher({
    super.key,
    required this.currentStep,
    required this.phoneController,
    required this.phoneError,
    required this.onPhoneSubmitted,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onOtpChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case AuthState.enteringPhone:
        return MdsPhoneInputField(
          key: const ValueKey(AuthState.enteringPhone),
          controller: phoneController,
          errorText: phoneError,
          onSubmitted: (_) => onPhoneSubmitted(),
        );
      case AuthState.enteringOtp:
        return MdsOtpInput(
          key: const ValueKey(AuthState.enteringOtp),
          controllers: otpControllers,
          focusNodes: otpFocusNodes,
          onChanged: onOtpChanged,
        );
    }
  }
}

/// Primary button switching between "Send Verification Code" and "Verify & Proceed".
class DriverAuthActionButton extends StatelessWidget {
  final AuthState currentStep;
  final VoidCallback onSendOtp;
  final VoidCallback onVerifyOtp;

  const DriverAuthActionButton({
    super.key,
    required this.currentStep,
    required this.onSendOtp,
    required this.onVerifyOtp,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case AuthState.enteringPhone:
        return MdsButton(
          key: const ValueKey('phone_btn'),
          text: "Send Verification Code",
          onPressed: onSendOtp,
        );
      case AuthState.enteringOtp:
        return MdsButton(
          key: const ValueKey('otp_btn'),
          text: "Verify & Proceed",
          onPressed: onVerifyOtp,
        );
    }
  }
}
