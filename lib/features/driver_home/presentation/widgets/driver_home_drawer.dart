import 'package:flutter/material.dart';
import 'package:pink_auto/core/storage/session_storage.dart';
import 'package:pink_auto/core/theme/theme.dart';

/// Navigation drawer for the driver home screen.
class DriverHomeDrawer extends StatelessWidget {
  const DriverHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: PinkAppTheme.primaryPink,
              ),
              accountName: Text(
                SessionStorage.getDriverName(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                "${SessionStorage.getDriverPhone()} • ${SessionStorage.getAutoType()} (${SessionStorage.getVehicleNumber()})",
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.electric_rickshaw,
                  color: PinkAppTheme.primaryPink,
                  size: 36,
                ),
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
    );
  }
}
