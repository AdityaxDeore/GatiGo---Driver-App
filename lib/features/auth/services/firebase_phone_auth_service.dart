import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePhoneAuthService {
  static bool get isFirebaseReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    int? resendToken,
    required void Function(PhoneAuthCredential credential) onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    if (!isFirebaseReady) return false;

    final completer = Completer<bool>();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: (e) {
          onVerificationFailed(e);
          if (!completer.isCompleted) completer.complete(false);
        },
        codeSent: (verificationId, token) {
          onCodeSent(verificationId, token);
          if (!completer.isCompleted) completer.complete(true);
        },
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      );
    } catch (_) {
      return false;
    }
    return completer.future;
  }

  static Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}
