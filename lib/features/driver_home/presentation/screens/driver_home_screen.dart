import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pink_auto/core/theme/theme.dart';
import 'package:pink_auto/core/storage/session_storage.dart';
import '../viewmodels/driver_home_viewmodel.dart';
import '../../domain/models/driver_status.dart';
import '../../domain/models/trip_state.dart';
import '../widgets/incoming_ride_request_card.dart';
import '../widgets/pickup_navigation_card.dart';
import '../widgets/arrived_pickup_card.dart';
import '../widgets/dropoff_navigation_card.dart';
import '../widgets/ride_completed_card.dart';

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
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: PinkAppTheme.primaryPink),
                accountName: Text("Driver Profile"),
                accountEmail: Text("+91 99999 99999"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: PinkAppTheme.primaryPink),
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
          // Map Background placeholder
          Container(
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        vm.currentLocation != null
                            ? "Lat: \${vm.currentLocation!.latitude.toStringAsFixed(4)}, Lng: \${vm.currentLocation!.longitude.toStringAsFixed(4)}"
                            : "Locating Driver...",
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
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

          // Offline Overlay
          if (vm.status == DriverStatus.offline)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Text(
                  "You are offline",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Today's Earnings", style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text("₹0.00", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Rides", style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text("0", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: vm.status == DriverStatus.goingOnline || vm.status == DriverStatus.goingOffline
                                ? null
                                : vm.toggleOnlineStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.isOnline ? Colors.red : PinkAppTheme.success,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            ),
                            child: vm.status == DriverStatus.goingOnline || vm.status == DriverStatus.goingOffline
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    vm.isOnline ? "GO OFFLINE" : "GO ONLINE",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Incoming Ride Request
          if (vm.tripState == TripState.requestReceived && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: IncomingRideRequestCard(
                  request: vm.currentRequest!,
                  onAccept: vm.acceptRide,
                  onReject: vm.rejectRide,
                  onExpired: vm.handleRequestExpired,
                ),
              ),
            ),

          // Driving To Pickup
          if (vm.tripState == TripState.drivingToPickup && vm.currentRequest != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: PickupNavigationCard(
                request: vm.currentRequest!,
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
                onCompleteRide: vm.completeTrip,
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
