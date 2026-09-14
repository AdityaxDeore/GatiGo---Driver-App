import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_auto/features/driver_home/domain/models/ride_request.dart';
import 'package:pink_auto/features/driver_home/domain/models/trip_state.dart';
import 'package:pink_auto/features/driver_home/presentation/screens/incoming_ride_screen.dart';
import 'package:pink_auto/features/driver_home/presentation/widgets/simulated_ride_map_view.dart';
import 'package:pink_auto/features/driver_home/presentation/widgets/arrived_destination_card.dart';
import 'package:pink_auto/features/driver_home/presentation/widgets/pickup_navigation_card.dart';
import 'package:pink_auto/features/driver_home/presentation/widgets/dropoff_navigation_card.dart';

void main() {
  final mockRequest = RideRequest(
    id: 'test_req_1',
    riderName: 'Priya M.',
    pickupLocation: const LocationCoordinate(latitude: 12.9716, longitude: 77.5946),
    pickupAddress: 'Tech Park Main Gate',
    destinationLocation: const LocationCoordinate(latitude: 12.9800, longitude: 77.6000),
    destinationAddress: 'Indiranagar 100ft Road',
    estimatedDistanceKm: 4.2,
    estimatedDurationMins: 15,
    estimatedFare: 120.0,
    rideType: 'Pink Auto Standard',
    expiresAt: DateTime.now().add(const Duration(seconds: 15)),
  );

  testWidgets('IncomingRideScreen renders rider info and handles accept',
      (WidgetTester tester) async {
    bool accepted = false;
    bool rejected = false;

    await tester.pumpWidget(
      MaterialApp(
        home: IncomingRideScreen(
          request: mockRequest,
          onAccept: () => accepted = true,
          onReject: () => rejected = true,
          onExpired: () {},
        ),
      ),
    );

    expect(find.text('NEW RIDE REQUEST'), findsOneWidget);
    expect(find.text('Priya M.'), findsOneWidget);
    expect(find.text('Tech Park Main Gate'), findsOneWidget);
    expect(find.text('Indiranagar 100ft Road'), findsOneWidget);
    expect(find.text('ACCEPT RIDE'), findsOneWidget);

    await tester.tap(find.text('ACCEPT RIDE'));
    expect(accepted, isTrue);
    expect(rejected, isFalse);
  });

  testWidgets('SimulatedRideMapView renders without errors in drivingToPickup state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimulatedRideMapView(
            tripState: TripState.drivingToPickup,
            request: mockRequest,
            onArrivedAtPickup: () {},
            onTripCompleted: () {},
          ),
        ),
      ),
    );

    expect(find.byType(SimulatedRideMapView), findsOneWidget);
    expect(find.textContaining('En route to Pickup'), findsOneWidget);
  });

  testWidgets('ArrivedDestinationCard prompts for Drop-off OTP and verifies successfully',
      (WidgetTester tester) async {
    String enteredOtp = '';
    bool verified = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArrivedDestinationCard(
            request: mockRequest,
            onVerifyOtp: (otp) async {
              enteredOtp = otp;
              verified = (otp.length == 4);
              return verified;
            },
          ),
        ),
      ),
    );

    expect(find.text('Arrived at Destination'), findsOneWidget);
    expect(find.textContaining('Ask Priya M. for the 4-digit Drop-off PIN'), findsOneWidget);
    expect(find.text('VERIFY & COMPLETE RIDE'), findsOneWidget);

    // Enter universal 4-digit OTP
    await tester.enterText(find.byType(TextField), '7291');
    await tester.pump();

    // Verify & Complete
    await tester.tap(find.text('VERIFY & COMPLETE RIDE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(enteredOtp, '7291');
    expect(verified, isTrue);
  });

  testWidgets('PickupNavigationCard shows button only when hasArrived is true',
      (WidgetTester tester) async {
    // When hasArrived is false (driving to pickup)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupNavigationCard(
            request: mockRequest,
            hasArrived: false,
            onArrived: () {},
          ),
        ),
      ),
    );

    expect(find.text('Driving to Pickup Location...'), findsOneWidget);
    expect(find.text('ARRIVED AT PICKUP'), findsNothing);

    // When hasArrived is true (vehicle actually arrived)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupNavigationCard(
            request: mockRequest,
            hasArrived: true,
            onArrived: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ARRIVED AT PICKUP'), findsOneWidget);
    expect(find.text('Driving to Pickup Location...'), findsNothing);
  });

  testWidgets('DropoffNavigationCard shows button only when hasArrived is true',
      (WidgetTester tester) async {
    // When hasArrived is false (driving to destination)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DropoffNavigationCard(
            request: mockRequest,
            hasArrived: false,
            onCompleteRide: () {},
          ),
        ),
      ),
    );

    expect(find.text('Driving to Destination...'), findsOneWidget);
    expect(find.text('ARRIVED AT DESTINATION'), findsNothing);

    // When hasArrived is true (vehicle actually arrived)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DropoffNavigationCard(
            request: mockRequest,
            hasArrived: true,
            onCompleteRide: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ARRIVED AT DESTINATION'), findsOneWidget);
    expect(find.text('Driving to Destination...'), findsNothing);
  });
}
