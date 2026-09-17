import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'driver_api_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM Background message: ${message.messageId} - ${message.data}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final DriverApiService _api = DriverApiService();

  final StreamController<Map<String, dynamic>> _rideRequestController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onRideRequest =>
      _rideRequestController.stream;

  bool _initialized = false;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        _fcmToken = await _fcm.getToken();
        debugPrint('Driver FCM Token: $_fcmToken');
        if (_fcmToken != null) {
          await _api.updateFcmToken(_fcmToken!);
        }

        // Subscribe to relevant driver broadcast topics
        await _fcm.subscribeToTopic('drivers_all');
        await _fcm.subscribeToTopic('drivers_pink_auto');
      }

      _fcm.onTokenRefresh.listen((newToken) async {
        _fcmToken = newToken;
        await _api.updateFcmToken(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM Foreground: ${message.notification?.title} - ${message.data}');
        final type = message.data['type'];
        if (type == 'ride_request' || type == 'new_ride_request' || type == 'dispatch') {
          _rideRequestController.add(message.data);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('FCM App opened from notification: ${message.data}');
        final type = message.data['type'];
        if (type == 'ride_request' || type == 'new_ride_request' || type == 'dispatch') {
          _rideRequestController.add(message.data);
        }
      });

      _initialized = true;
    } catch (e) {
      debugPrint('FcmService initialization error: $e');
    }
  }

  void dispose() {
    _rideRequestController.close();
  }
}
