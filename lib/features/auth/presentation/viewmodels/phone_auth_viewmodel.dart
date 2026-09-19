import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/driver_api_service.dart';

enum AuthState { enteringPhone, enteringOtp }

class PhoneAuthViewModel extends ChangeNotifier {
  final DriverApiService _apiService;
  AuthState _currentStep = AuthState.enteringPhone;
  int _resendTimerSeconds = 30;
  Timer? _timer;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  String? _phoneError;
  String? get phoneError => _phoneError;

  AuthState get currentStep => _currentStep;
  int get resendTimerSeconds => _resendTimerSeconds;
  bool get canResendOtp => _resendTimerSeconds == 0;

  PhoneAuthViewModel({DriverApiService? apiService})
      : _apiService = apiService ?? DriverApiService();

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

  Future<bool> sendOtp({
    required void Function(String message) onError,
    required VoidCallback onSuccess,
  }) async {
    final phone = phoneController.text.replaceAll(' ', '').trim();
    final phoneRegex = RegExp(r'^\d{10}$');
    
    if (!phoneRegex.hasMatch(phone)) {
      _phoneError = "Please enter a valid 10-digit mobile number";
      notifyListeners();
      onError(_phoneError!);
      return false;
    }

    _phoneError = null;
    final res = await _apiService.requestOtp(phoneNumber: '+91$phone');
    if (res['success'] == true) {
      _currentStep = AuthState.enteringOtp;
      startTimer();
      notifyListeners();
      onSuccess();
      return true;
    } else {
      final err = res['error'];
      final msg = err is Map ? (err['message'] ?? 'Failed to send verification code') : 'Failed to send verification code';
      _phoneError = msg;
      notifyListeners();
      onError(msg);
      return false;
    }
  }

  Future<bool> verifyOtp({
    required void Function(String message) onError,
    required void Function(Map<String, dynamic> authData) onSuccess,
  }) async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      onError("Please enter the complete 6-digit verification code");
      return false;
    }

    final phone = phoneController.text.replaceAll(' ', '').trim();
    final res = await _apiService.verifyOtp(phoneNumber: '+91$phone', otp: otp);
    if (res['success'] == true) {
      _timer?.cancel();
      notifyListeners();
      onSuccess(res['data'] as Map<String, dynamic>? ?? {});
      return true;
    } else {
      final err = res['error'];
      final msg = err is Map ? (err['message'] ?? 'Invalid verification code') : 'Invalid verification code';
      onError(msg);
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
