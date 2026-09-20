import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/translated_text.dart';
import '../../../../core/storage/session_storage.dart';
import '../viewmodels/phone_auth_viewmodel.dart';
import '../widgets/driver_auth_header.dart';
import '../widgets/driver_auth_input_switcher.dart';
import '../widgets/driver_auth_logo.dart';
import '../widgets/driver_auth_timer.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  late final PhoneAuthViewModel _viewModel;
  AuthState? _lastStep;

  @override
  void initState() {
    super.initState();
    _viewModel = PhoneAuthViewModel();
    _viewModel.addListener(_handleStepChange);
    _lastStep = _viewModel.currentStep;
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleStepChange);
    _viewModel.dispose();
    super.dispose();
  }

  void _handleStepChange() {
    if (_viewModel.currentStep != _lastStep) {
      if (_viewModel.currentStep == AuthState.enteringOtp) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _viewModel.otpFocusNodes.isNotEmpty) {
            _viewModel.otpFocusNodes[0].requestFocus();
          }
        });
      }
      _lastStep = _viewModel.currentStep;
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: TranslatedText(message), backgroundColor: color),
    );
  }

  void _sendOtp() {
    _viewModel.sendOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: () => _showSnackBar("Code sent! (Dev test OTP: 123456)", PinkAppTheme.primaryPink),
    );
  }

  void _verifyOtp() {
    _viewModel.verifyOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: (authData) async {
        _showSnackBar("Authentication Successful!", PinkAppTheme.success);
        final token = authData['token'] as String? ?? '';
        final user = authData['user'] as Map<String, dynamic>? ?? {};
        final isReg = user['is_registered'] == true;
        final isApp = user['is_approved'] == true;
        final phone = _viewModel.phoneController.text.trim();
        await SessionStorage.login(token, isRegistered: isReg, phone: phone.isNotEmpty ? '+91 $phone' : null);
        if (token.isNotEmpty) ApiClient().setAuthToken(token);
        if (mounted) {
          final target = !isReg ? '/registration' : (isApp ? '/home' : '/verification-status');
          Navigator.pushReplacementNamed(context, target);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isPhoneStep = _viewModel.currentStep == AuthState.enteringPhone;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: !isPhoneStep
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: PinkAppTheme.textDark),
                    onPressed: _viewModel.goBack,
                  )
                : null,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [PinkAppTheme.accentPurple.withValues(alpha: 0.06), PinkAppTheme.primaryPink.withValues(alpha: 0.03), Colors.white],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
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
                              currentStep: _viewModel.currentStep,
                              phone: _viewModel.phoneController.text,
                              textTheme: textTheme,
                            ),
                          ),
                          const SizedBox(height: 32),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: DriverAuthInputSwitcher(
                              currentStep: _viewModel.currentStep,
                              phoneController: _viewModel.phoneController,
                              phoneError: _viewModel.phoneError,
                              onPhoneSubmitted: _sendOtp,
                              otpControllers: _viewModel.otpControllers,
                              otpFocusNodes: _viewModel.otpFocusNodes,
                              onOtpChanged: (code) {
                                if (code.length == 6) _verifyOtp();
                              },
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: DriverAuthTimer(
                              currentStep: _viewModel.currentStep,
                              canResendOtp: _viewModel.canResendOtp,
                              resendTimerSeconds: _viewModel.resendTimerSeconds,
                              onResend: _viewModel.startTimer,
                              textTheme: textTheme,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: DriverAuthActionButton(
                                currentStep: _viewModel.currentStep,
                                onSendOtp: _sendOtp,
                                onVerifyOtp: _verifyOtp,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
