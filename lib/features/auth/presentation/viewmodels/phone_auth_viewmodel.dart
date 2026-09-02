import 'dart:async';
import 'package:flutter/material.dart';

enum AuthState { enteringPhone, enteringOtp }

class PhoneAuthViewModel extends ChangeNotifier {
  AuthState _currentStep = AuthState.enteringPhone;
  int _resendTimerSeconds = 30;
  Timer? _timer;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  String? _phoneError;
  String? get phoneError => _phoneError;

  AuthState get currentStep => _currentStep;
  int get resendTimerSeconds => _resendTimerSeconds;
  bool get canResendOtp => _resendTimerSeconds == 0;

  void startTimer() {
    _resendTimerSeconds = 30;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds == 0) {
        _timer?.cancel();
        notifyListeners();
      } else {
        _resendTimerSeconds--;
        notifyListeners();
      }
    });
  }

  void goBack() {
    if (_currentStep == AuthState.enteringOtp) {
      _currentStep = AuthState.enteringPhone;
      _phoneError = null;
      notifyListeners();
    }
  }

  bool sendOtp({
    required void Function(String message) onError,
    required VoidCallback onSuccess,
  }) {
    final phone = phoneController.text.replaceAll(' ', '').trim();
    final phoneRegex = RegExp(r'^\d{10}$');
    
    if (phoneRegex.hasMatch(phone)) {
      _phoneError = null;
      _currentStep = AuthState.enteringOtp;
      startTimer();
      notifyListeners();
      onSuccess();
      return true;
    } else {
      _phoneError = "Please enter a valid 10-digit mobile number";
      notifyListeners();
      onError(_phoneError!);
      return false;
    }
  }

  bool verifyOtp({
    required void Function(String message) onError,
    required void Function(bool isRegistered) onSuccess,
  }) {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      _timer?.cancel();
      // For now, mock a check if driver is registered based on phone number.
      // E.g., if phone number is '9999999999' they are registered, else they are new.
      final phone = phoneController.text.replaceAll(' ', '').trim();
      final bool isRegistered = phone == '9999999999';

      notifyListeners();
      onSuccess(isRegistered);
      return true;
    } else {
      onError("Please enter the complete 4-digit code");
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
