import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/driver_api_service.dart';
import '../../services/backend_otp_service.dart';

enum AuthState { enteringPhone, enteringOtp }

class PhoneAuthViewModel extends ChangeNotifier {
  final BackendOtpService _backendOtpService;

  AuthState _currentStep = AuthState.enteringPhone;
  int _resendTimerSeconds = 30;
  Timer? _timer;
  String? _verificationId;
  int? _resendToken;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  String? _phoneError;
  String? get phoneError => _phoneError;
  String? _otpError;
  String? get otpError => _otpError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthState get currentStep => _currentStep;
  int get resendTimerSeconds => _resendTimerSeconds;
  bool get canResendOtp => _resendTimerSeconds == 0;

  PhoneAuthViewModel({DriverApiService? apiService})
      : _backendOtpService = BackendOtpService(apiService ?? DriverApiService());

  void startTimer() {
    _resendTimerSeconds = 30;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds == 0) {
        _timer?.cancel();
      } else {
        _resendTimerSeconds--;
      }
      notifyListeners();
    });
  }

  void goBack() {
    if (_currentStep == AuthState.enteringOtp) {
      _currentStep = AuthState.enteringPhone;
      _phoneError = null;
      _otpError = null;
      notifyListeners();
    }
  }

  void clearOtp() {
    for (var c in otpControllers) {
      c.clear();
    }
    notifyListeners();
  }

  Future<bool> sendOtp({
    required void Function(String message) onError,
    required VoidCallback onSuccess,
  }) async {
    final phone = phoneController.text.replaceAll(' ', '').trim();
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _phoneError = "Please enter a valid 10-digit mobile number";
      notifyListeners();
      onError(_phoneError!);
      return false;
    }

    _phoneError = null;
    _otpError = null;
    _isLoading = true;
    notifyListeners();

    return _backendOtpService.initiatePhoneAuth(
      phone: phone,
      resendToken: _resendToken,
      onSmsCode: (code) {
        for (int i = 0; i < code.length && i < otpControllers.length; i++) {
          otpControllers[i].text = code[i];
        }
        notifyListeners();
      },
      onError: (msg) {
        _isLoading = false;
        _phoneError = msg;
        notifyListeners();
        onError(msg);
      },
      onSuccess: (id, token, msg, devOtp) {
        _verificationId = id;
        _resendToken = token;
        _isLoading = false;
        clearOtp();
        _currentStep = AuthState.enteringOtp;
        startTimer();
        notifyListeners();
        onSuccess();
      },
    );
  }

  Future<bool> resendOtp({
    required void Function(String message) onError,
    required VoidCallback onSuccess,
  }) async {
    if (!canResendOtp) {
      onError("Please wait $_resendTimerSeconds seconds before resending");
      return false;
    }
    return sendOtp(onError: onError, onSuccess: onSuccess);
  }

  Future<bool> verifyOtp({
    required void Function(String message) onError,
    required void Function(Map<String, dynamic> authData) onSuccess,
  }) async {
    final otp = otpControllers.map((c) => c.text.trim()).join();
    if (otp.length != 6) {
      _otpError = "Please enter the complete 6-digit verification code";
      notifyListeners();
      onError(_otpError!);
      return false;
    }

    _otpError = null;
    _isLoading = true;
    notifyListeners();

    final phone = phoneController.text.replaceAll(' ', '').trim();
    return _backendOtpService.verifyPhoneAuth(
      phone: phone,
      enteredOtp: otp,
      verificationId: _verificationId,
      onError: (msg) {
        _isLoading = false;
        _otpError = msg;
        clearOtp();
        notifyListeners();
        onError(msg);
      },
      onSuccess: (data) {
        _timer?.cancel();
        _isLoading = false;
        notifyListeners();
        onSuccess(data);
      },
    );
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
