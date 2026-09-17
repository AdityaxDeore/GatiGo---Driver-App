import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/theme/theme.dart';
import 'core/localization/language_cubit.dart';
import 'core/storage/session_storage.dart';
import 'core/services/fcm_service.dart';
import 'features/auth/presentation/screens/phone_auth_screen.dart';
import 'features/driver_home/presentation/screens/driver_home_screen.dart';
import 'features/driver_registration/presentation/screens/driver_registration_screen.dart';
import 'features/driver_registration/presentation/screens/verification_status_screen.dart';
import 'features/driver_home/domain/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  // Initialize Firebase & FCM background handler
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase init notice: $e');
  }

  // Restore persistent login and approval session
  await SessionStorage.init();

  runApp(const PinkAutoDriverApp());
}

class PinkAutoDriverApp extends StatefulWidget {
  const PinkAutoDriverApp({super.key});

  @override
  State<PinkAutoDriverApp> createState() => _PinkAutoDriverAppState();
}

class _PinkAutoDriverAppState extends State<PinkAutoDriverApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppServices();
    });
  }

  Future<void> _initializeAppServices() async {
    final locationService = LocationService();
    await locationService.requestPermission();

    // Initialize FCM push notification service if driver is authenticated
    if (SessionStorage.isLoggedIn()) {
      await FcmService().initialize();
    }
  }

  String _getInitialRoute() {
    if (SessionStorage.isLoggedIn()) {
      if (SessionStorage.isDriverRegistered()) {
        return '/home';
      }
      if (SessionStorage.isVerificationPending()) {
        return '/verification-status';
      }
      return '/registration';
    }
    return '/phone-auth';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
      ],
      child: MaterialApp(
        title: 'Pink Auto Driver',
        debugShowCheckedModeBanner: false,
        theme: PinkAppTheme.lightTheme,
        initialRoute: _getInitialRoute(),
        routes: {
          '/phone-auth': (context) => const PhoneAuthScreen(),
          '/registration': (context) => const DriverRegistrationScreen(),
          '/verification-status': (context) => const VerificationStatusScreen(),
          '/home': (context) => const DriverHomeScreen(),
        },
      ),
    );
  }
}
