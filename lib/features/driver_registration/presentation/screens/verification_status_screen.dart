import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/mds/widgets/mds_button.dart';
import '../../../../core/storage/session_storage.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.hourglass_empty, size: 80, color: PinkAppTheme.primaryPink),
              const SizedBox(height: 32),
              const Text(
                "Application Submitted",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your driver and vehicle documents are currently under review. This usually takes up to 24 hours.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              MdsButton(
                text: "Refresh Status (Mock Approve)",
                onPressed: () async {
                  // Mock approval for demo
                  await SessionStorage.login('mock-jwt-token-value-xyz', isRegistered: true);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
