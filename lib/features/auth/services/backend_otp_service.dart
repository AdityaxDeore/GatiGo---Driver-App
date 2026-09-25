import '../../../../core/services/driver_api_service.dart';
import 'firebase_phone_auth_service.dart';

class BackendOtpService {
  final DriverApiService apiService;

  BackendOtpService(this.apiService);

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    return await apiService.requestOtp(phoneNumber: '+91$phone');
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await apiService.verifyOtp(phoneNumber: '+91$phone', otp: otp);
    if (res['success'] == true) {
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final user = data['user'] as Map<String, dynamic>? ?? {};
      return {
        'success': true,
        'token': data['token'] as String? ?? '',
        'user': user,
        'isRegistered': user['is_registered'] == true,
        'isApproved': user['is_approved'] == true,
      };
    } else {
      return {'success': false, 'error': res['error']};
    }
  }

  Future<Map<String, dynamic>> verifyFirebaseOtp({
    required String verificationId,
    required String smsCode,
    required String phone,
  }) async {
    final userCred = await FirebasePhoneAuthService.signInWithOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final user = userCred.user;
    final idToken = await user?.getIdToken();
    if (user == null || idToken == null) throw Exception('Auth failed');

    // Sync or verify with driver backend
    final res = await apiService.verifyOtp(phoneNumber: '+91$phone', otp: smsCode);
    if (res['success'] == true) {
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final userData = data['user'] as Map<String, dynamic>? ?? {};
      return {
        'success': true,
        'token': data['token'] as String? ?? idToken,
        'user': userData,
        'isRegistered': userData['is_registered'] == true,
        'isApproved': userData['is_approved'] == true,
      };
    }

    return {
      'success': true,
      'token': idToken,
      'user': {
        'id': user.uid,
        'phone_number': '+91$phone',
        'role': 'driver',
        'is_registered': false,
        'is_approved': false,
      },
      'isRegistered': false,
      'isApproved': false,
    };
  }

  Future<bool> initiatePhoneAuth({
    required String phone,
    int? resendToken,
    required void Function(String smsCode) onSmsCode,
    required void Function(String message) onError,
    required void Function(String? verificationId, int? resendToken, String message, String? devOtp) onSuccess,
  }) async {
    if (!FirebasePhoneAuthService.isFirebaseReady) {
      try {
        final res = await requestOtp(phone);
        if (res['success'] == true) {
          final data = res['data'];
          final devOtp = (data is Map && data['dev_otp'] != null)
              ? data['dev_otp'].toString()
              : (data is Map && data['otp'] != null ? data['otp'].toString() : null);
          onSuccess(null, null, "OTP dispatched to +91 $phone", devOtp);
          return true;
        } else {
          final err = res['error'];
          onError(err is Map ? (err['message'] ?? 'Failed to send OTP') : 'Failed to send OTP');
          return false;
        }
      } catch (e) {
        onError('Network error: $e');
        return false;
      }
    }

    return FirebasePhoneAuthService.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      resendToken: resendToken,
      onVerificationCompleted: (cred) {
        if (cred.smsCode != null && cred.smsCode!.isNotEmpty) {
          onSmsCode(cred.smsCode!);
        }
      },
      onVerificationFailed: (e) {
        onError(e.message ?? 'SMS delivery failed (${e.code}).');
      },
      onCodeSent: (id, token) => onSuccess(id, token, "Verification code sent via SMS to +91 $phone", null),
      onCodeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<bool> verifyPhoneAuth({
    required String phone,
    required String enteredOtp,
    required String? verificationId,
    required void Function(String message) onError,
    required void Function(Map<String, dynamic> authData) onSuccess,
  }) async {
    if (!FirebasePhoneAuthService.isFirebaseReady || verificationId == null) {
      return _verifyWithBackend(phone, enteredOtp, onError, onSuccess);
    }

    try {
      final res = await verifyFirebaseOtp(
        verificationId: verificationId,
        smsCode: enteredOtp,
        phone: phone,
      );
      onSuccess(res);
      return true;
    } catch (e) {
      onError('Verification failed: ${e.toString().replaceAll("Exception: ", "")}');
      return false;
    }
  }

  Future<bool> _verifyWithBackend(
    String phone,
    String enteredOtp,
    void Function(String message) onError,
    void Function(Map<String, dynamic> authData) onSuccess,
  ) async {
    try {
      final res = await verifyOtp(phone, enteredOtp);
      if (res['success'] == true) {
        onSuccess(res);
        return true;
      }
      final err = res['error'];
      final msg = err is Map ? (err['message'] ?? 'Invalid code') : 'Invalid code';
      onError(msg.toString());
      return false;
    } catch (e) {
      onError('Verification failed: $e');
      return false;
    }
  }
}
