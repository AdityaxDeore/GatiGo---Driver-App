import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/translated_text.dart';
import '../../../../core/storage/session_storage.dart';
import '../viewmodels/phone_auth_viewmodel.dart';
import '../widgets/driver_auth_card.dart';

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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: TranslatedText(message), backgroundColor: color),
    );
  }


  Future<void> _sendOtp() async {

    _viewModel.sendOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: () => _showSnackBar(
        "Verification code sent via SMS to +91 ${_viewModel.phoneController.text.trim()}",
        PinkAppTheme.primaryPink,
      ),
    );
  }

  void _resendOtp() {
    _viewModel.resendOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: () => _showSnackBar("New verification code dispatched!", PinkAppTheme.primaryPink),
    );
  }

  void _verifyOtp() {
    _viewModel.verifyOtp(
      onError: (message) => _showSnackBar(message, PinkAppTheme.error),
      onSuccess: (authData) async {
        _showSnackBar("Authentication Successful!", PinkAppTheme.success);
        final token = authData['token'] as String? ?? '';
        final user = authData['user'] as Map<String, dynamic>? ?? {};
        final isReg = user['is_registered'] == true || authData['isRegistered'] == true;
        final isApp = user['is_approved'] == true || authData['isApproved'] == true;
        final phone = _viewModel.phoneController.text.trim();
        await SessionStorage.login(
          token,
          isRegistered: isReg,
          isApproved: isApp,
          phone: phone.isNotEmpty ? '+91 $phone' : null,
        );
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
                  child: DriverAuthCard(
                    viewModel: _viewModel,
                    textTheme: textTheme,
                    onSendOtp: _sendOtp,
                    onResendOtp: _resendOtp,
                    onVerifyOtp: _verifyOtp,
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
