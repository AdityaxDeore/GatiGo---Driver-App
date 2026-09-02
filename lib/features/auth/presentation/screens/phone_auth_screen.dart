import 'package:flutter/material.dart';
import '../../../../core/mds/widgets/mds_button.dart';
import '../../../../core/mds/widgets/mds_otp_input.dart';
import '../../../../core/mds/widgets/mds_phone_input_field.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/translated_text.dart';
import '../../../../core/storage/session_storage.dart';
import '../viewmodels/phone_auth_viewmodel.dart';

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
      SnackBar(
        content: TranslatedText(message),
        backgroundColor: color,
      ),
    );
  }

  void _sendOtp() {
    _viewModel.sendOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: () {},
    );
  }

  void _verifyOtp() {
    _viewModel.verifyOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: (isRegistered) async {
        _showSnackBar("Authentication Successful!", PinkAppTheme.success);
        
        await SessionStorage.login('mock-jwt-token-value-xyz', isRegistered: isRegistered);
        
        if (mounted) {
          if (isRegistered) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, '/registration');
          }
        }
      },
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    switch (_viewModel.currentStep) {
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
              "We will send you a 4-digit verification code.",
              style: textTheme.bodyMedium?.copyWith(color: PinkAppTheme.textLight),
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
            TranslatedText(
              "A verification code has been successfully dispatched to +91 ${_viewModel.phoneController.text}",
              style: textTheme.bodyMedium?.copyWith(color: PinkAppTheme.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  Widget _buildInput() {
    switch (_viewModel.currentStep) {
      case AuthState.enteringPhone:
        return MdsPhoneInputField(
          key: const ValueKey(AuthState.enteringPhone),
          controller: _viewModel.phoneController,
          errorText: _viewModel.phoneError,
          onSubmitted: (_) => _sendOtp(),
        );
      case AuthState.enteringOtp:
        return MdsOtpInput(
          key: const ValueKey(AuthState.enteringOtp),
          controllers: _viewModel.otpControllers,
          focusNodes: _viewModel.otpFocusNodes,
          onChanged: (code) {
            if (code.length == 4) {
              _verifyOtp();
            }
          },
        );
    }
  }

  Widget _buildTimer(TextTheme textTheme) {
    if (_viewModel.currentStep != AuthState.enteringOtp) {
      return const SizedBox.shrink(key: ValueKey('empty_timer'));
    }
    return Padding(
      key: const ValueKey('otp_timer'),
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TranslatedText(
            !_viewModel.canResendOtp
                ? "Resend code in ${_viewModel.resendTimerSeconds}s"
                : "Didn't receive the code? ",
            style: textTheme.bodyMedium,
          ),
          if (_viewModel.canResendOtp)
            GestureDetector(
              onTap: _viewModel.startTimer,
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

  Widget _buildButton() {
    switch (_viewModel.currentStep) {
      case AuthState.enteringPhone:
        return MdsButton(
          key: const ValueKey('phone_btn'),
          text: "Send Verification Code",
          onPressed: _sendOtp,
        );
      case AuthState.enteringOtp:
        return MdsButton(
          key: const ValueKey('otp_btn'),
          text: "Verify & Proceed",
          onPressed: _verifyOtp,
        );
    }
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
                colors: [
                  PinkAppTheme.accentPurple.withValues(alpha: 0.06),
                  PinkAppTheme.primaryPink.withValues(alpha: 0.03),
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                          // Logo Badge
                          Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
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
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // Header texts
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _buildHeader(textTheme),
                          ),
                          const SizedBox(height: 32),

                          // Inputs
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _buildInput(),
                          ),

                          // Optional resend timer
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _buildTimer(textTheme),
                          ),
                          const SizedBox(height: 32),

                          // Center primary action button
                          Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _buildButton(),
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
