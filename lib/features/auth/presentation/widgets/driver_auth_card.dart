import 'package:flutter/material.dart';
import '../viewmodels/phone_auth_viewmodel.dart';
import 'driver_auth_header.dart';
import 'driver_auth_input_switcher.dart';
import 'driver_auth_logo.dart';
import 'driver_auth_timer.dart';

class DriverAuthCard extends StatelessWidget {
  final PhoneAuthViewModel viewModel;
  final TextTheme textTheme;
  final VoidCallback onSendOtp;
  final VoidCallback onResendOtp;
  final VoidCallback onVerifyOtp;

  const DriverAuthCard({
    super.key,
    required this.viewModel,
    required this.textTheme,
    required this.onSendOtp,
    required this.onResendOtp,
    required this.onVerifyOtp,
  });

  @override
  Widget build(BuildContext context) {
    final isPhoneStep = viewModel.currentStep == AuthState.enteringPhone;

    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28.0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const DriverAuthLogo(),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: DriverAuthHeader(
                currentStep: viewModel.currentStep,
                phone: viewModel.phoneController.text,
                textTheme: textTheme,
                onEditPhone: viewModel.goBack,
              ),
            ),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: DriverAuthInputSwitcher(
                currentStep: viewModel.currentStep,
                phoneController: viewModel.phoneController,
                phoneError: viewModel.phoneError,
                otpError: viewModel.otpError,
                onPhoneSubmitted: onSendOtp,
                otpControllers: viewModel.otpControllers,
                otpFocusNodes: viewModel.otpFocusNodes,
                onOtpChanged: (code) {
                  if (code.length == 6) onVerifyOtp();
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: DriverAuthTimer(
                currentStep: viewModel.currentStep,
                canResendOtp: viewModel.canResendOtp,
                resendTimerSeconds: viewModel.resendTimerSeconds,
                onResend: onResendOtp,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: DriverAuthActionButton(
                  currentStep: viewModel.currentStep,
                  isLoading: viewModel.isLoading,
                  onSendOtp: onSendOtp,
                  onVerifyOtp: onVerifyOtp,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
