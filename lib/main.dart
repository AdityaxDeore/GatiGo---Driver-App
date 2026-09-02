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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(const PinkAutoDriverApp());
}

class PinkAutoDriverApp extends StatelessWidget {
  const PinkAutoDriverApp({super.key});

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
        initialRoute: SessionStorage.isLoggedIn() 
            ? (SessionStorage.isDriverRegistered() ? '/home' : '/registration')
            : '/phone-auth',
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
