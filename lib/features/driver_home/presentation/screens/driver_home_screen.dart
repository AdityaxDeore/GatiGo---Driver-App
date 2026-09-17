import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/driver_home_viewmodel.dart';
import '../../domain/models/trip_state.dart';
import '../widgets/driver_home_drawer.dart';
import '../widgets/driver_status_header.dart';
import '../widgets/driver_duty_bottom_bar.dart';
import '../widgets/pickup_navigation_card.dart';
import '../widgets/arrived_pickup_card.dart';
import '../widgets/dropoff_navigation_card.dart';
import '../widgets/arrived_destination_card.dart';
import '../widgets/ride_completed_card.dart';
import '../widgets/simulated_ride_map_view.dart';
import 'incoming_ride_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverHomeViewModel(),
      child: const DriverHomeView(),
    );
  }
}

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverHomeViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: const Icon(Icons.menu, color: Colors.black),
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const DriverHomeDrawer(),
      body: Stack(
        children: [
          // Animated Simulated Ride Map Canvas
          Positioned.fill(
            child: SimulatedRideMapView(
              tripState: vm.tripState,
              request: vm.currentRequest,
              onArrivedAtPickup: () => vm.setReachedPickup(true),
              onTripCompleted: () => vm.setReachedDestination(true),
            ),
          ),

          // Status header & offline overlay
          DriverStatusHeader(
            status: vm.status,
            errorMessage: vm.errorMessage,
          ),

          // Bottom Bar (Available/Online)
          if (vm.tripState == TripState.available)
            DriverDutyBottomBar(
              status: vm.status,
              isOnline: vm.isOnline,
              onToggleStatus: vm.toggleOnlineStatus,
            ),

          // Dedicated Full-screen Screen popping up for incoming ride requests
          if (vm.tripState == TripState.requestReceived && vm.currentRequest != null)
            Positioned.fill(
              child: IncomingRideScreen(
                request: vm.currentRequest!,
                onAccept: vm.acceptRide,
                onReject: vm.rejectRide,
                onExpired: vm.handleRequestExpired,
              ),
            ),

          // Driving To Pickup
          if (vm.tripState == TripState.drivingToPickup && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: PickupNavigationCard(
                request: vm.currentRequest!,
                hasArrived: vm.hasReachedPickup,
                onArrived: vm.arrivedAtPickup,
              ),
            ),

          // Arrived at Pickup
          if (vm.tripState == TripState.arrivedAtPickup && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ArrivedPickupCard(
                request: vm.currentRequest!,
                onStartTrip: vm.startTrip,
              ),
            ),

          // Navigating to Dropoff
          if (vm.tripState == TripState.tripStarted && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: DropoffNavigationCard(
                request: vm.currentRequest!,
                hasArrived: vm.hasReachedDestination,
                onCompleteRide: vm.arrivedAtDestination,
              ),
            ),

          // Arrived at Destination - Dropoff OTP Verification
          if (vm.tripState == TripState.arrivedAtDestination && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ArrivedDestinationCard(
                request: vm.currentRequest!,
                onVerifyOtp: vm.completeTripWithOtp,
              ),
            ),

          // Ride Completed
          if (vm.tripState == TripState.completed && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: RideCompletedCard(
                request: vm.currentRequest!,
                onDone: vm.resetToOnline,
              ),
            ),
        ],
      ),
    );
  }
}
