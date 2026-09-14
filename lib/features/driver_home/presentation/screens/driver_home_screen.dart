import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pink_auto/core/theme/theme.dart';
import 'package:pink_auto/core/storage/session_storage.dart';
import '../viewmodels/driver_home_viewmodel.dart';
import '../../domain/models/driver_status.dart';
import '../../domain/models/trip_state.dart';
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
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: PinkAppTheme.primaryPink,
                ),
                accountName: Text(
                  SessionStorage.getDriverName(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
                accountEmail: Text(
                  "${SessionStorage.getDriverPhone()} • ${SessionStorage.getAutoType()} (${SessionStorage.getVehicleNumber()})",
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.electric_rickshaw, color: PinkAppTheme.primaryPink, size: 36),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Earnings"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Rides"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text("Documents"),
                onTap: () {},
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  await SessionStorage.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/phone-auth');
                  }
                },
              ),
            ],
          ),
        ),
      ),
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
          // Driver Status Header overlay
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vm.status == DriverStatus.online ? PinkAppTheme.success : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vm.status == DriverStatus.online ? "You're Online" : "Offline",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Error Overlay
          if (vm.errorMessage != null)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.all(12),
                  color: PinkAppTheme.error,
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // Offline Banner in Map Area
          if (vm.status == DriverStatus.offline)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded, color: Colors.grey, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "You are currently offline",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Bar (Available/Online)
          if (vm.tripState == TripState.available)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: PinkAppTheme.primaryPink.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    )
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: PinkAppTheme.backgroundLight,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Today's Earnings", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹0.00",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: PinkAppTheme.textDark,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: PinkAppTheme.backgroundLight,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Completed Rides", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "0",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: PinkAppTheme.primaryPink,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: vm.status == DriverStatus.goingOnline || vm.status == DriverStatus.goingOffline
                                ? null
                                : vm.toggleOnlineStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.isOnline ? const Color(0xFF2C2C3E) : PinkAppTheme.primaryPink,
                              elevation: vm.isOnline ? 2 : 6,
                              shadowColor: PinkAppTheme.primaryPink.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            ),
                            child: vm.status == DriverStatus.goingOnline || vm.status == DriverStatus.goingOffline
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        vm.isOnline ? Icons.power_settings_new : Icons.bolt,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        vm.isOnline ? "GO OFFLINE" : "GO ONLINE",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
