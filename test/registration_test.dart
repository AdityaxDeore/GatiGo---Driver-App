import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pink_auto/core/storage/session_storage.dart';
import 'package:pink_auto/features/driver_registration/presentation/screens/driver_registration_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SessionStorage.init();
  });

  testWidgets('Registration screen allows selecting Normal Auto vs Pink Auto',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const DriverRegistrationScreen(),
        routes: {
          '/verification-status': (_) => const Scaffold(body: Text('Verification Status Screen')),
        },
      ),
    );

    // Step 0: Personal Details
    expect(find.text('Personal Details'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 1: Driving Licence
    expect(find.text('Driving Licence'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 2: Vehicle Details
    expect(find.text('Vehicle Details'), findsOneWidget);
    expect(find.text('Auto Rickshaw Category'), findsOneWidget);
    expect(find.text('Pink Auto'), findsOneWidget);
    expect(find.text('Normal Auto'), findsOneWidget);

    // Tap on Normal Auto
    await tester.tap(find.text('Normal Auto'));
    await tester.pumpAndSettle();

    // Proceed to Step 3: Vehicle Documents
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Proceed to Step 4: Identity
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Proceed to Step 5: Review Application
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Review Application'), findsOneWidget);
    expect(find.textContaining('Category: Normal Auto'), findsOneWidget);

    // Submit registration
    await tester.tap(find.text('Submit Application'));
    await tester.pumpAndSettle();

    // Check SessionStorage has persisted the selection
    expect(SessionStorage.getAutoType(), 'Normal Auto');
    expect(SessionStorage.isVerificationPending(), isTrue);
  });
}
