import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'core/localization/language_cubit.dart';
import 'core/storage/session_storage.dart';
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
      _checkAndRequestLocationPermission();
    });
  }

  Future<void> _checkAndRequestLocationPermission() async {
    final locationService = LocationService();
    await locationService.requestPermission();
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
