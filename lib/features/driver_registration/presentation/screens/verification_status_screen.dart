import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/mds/widgets/mds_button.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../../core/services/driver_api_service.dart';

class VerificationStatusScreen extends StatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  State<VerificationStatusScreen> createState() => _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen> {
  bool _isLoading = false;

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    try {
      final status = await DriverApiService().getRegistrationStatus();
      if (!mounted) return;
      if (status != null && status['is_approved'] == true) {
        await SessionStorage.approveDriver();
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
        return;
      }
      final reason = status?['rejection_reason'];
      final vStatus = status?['verification_status'] ?? 'pending';
      final isRej = vStatus == 'rejected';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isRej ? "Application rejected: ${reason ?? 'Contact support'}" : "Application is under review ($vStatus)."),
        backgroundColor: isRej ? Colors.red : PinkAppTheme.primaryPink,
      ));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PinkAppTheme.accentPurple.withValues(alpha: 0.06),
              PinkAppTheme.primaryPink.withValues(alpha: 0.03),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: PinkAppTheme.primaryPink.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PinkAppTheme.backgroundLight,
                          border: Border.all(
                            color: PinkAppTheme.primaryPink.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          size: 48,
                          color: PinkAppTheme.primaryPink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      "Application Submitted",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: PinkAppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your ${SessionStorage.getAutoType()} documents are currently under verification. This usually takes up to 24 hours.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: PinkAppTheme.textLight,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: PinkAppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: PinkAppTheme.primaryPink.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: PinkAppTheme.primaryPink, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  SessionStorage.getAutoType(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: PinkAppTheme.textDark,
                                  ),
                                ),
                                Text(
                                  "Vehicle: ${SessionStorage.getVehicleNumber()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "IN REVIEW",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    MdsButton(
                      text: _isLoading ? "Checking..." : "Check Verification Status",
                      onPressed: _isLoading ? null : _checkStatus,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
