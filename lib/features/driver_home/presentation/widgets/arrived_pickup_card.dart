import 'package:flutter/material.dart';
import 'package:pink_auto/core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class ArrivedPickupCard extends StatefulWidget {
  final RideRequest request;
  final Future<bool> Function(String) onStartTrip;

  const ArrivedPickupCard({
    super.key,
    required this.request,
    required this.onStartTrip,
  });

  @override
  State<ArrivedPickupCard> createState() => _ArrivedPickupCardState();
}

class _ArrivedPickupCardState extends State<ArrivedPickupCard> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleStart() async {
    final otp = _otpController.text.trim();
    if (otp.length != 4) {
      setState(() => _errorText = 'Enter 4-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await widget.onStartTrip(otp);
    
    if (mounted && !success) {
      setState(() {
        _isLoading = false;
        _errorText = 'Invalid OTP. Try 1234.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
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
              const Icon(Icons.check_circle, color: PinkAppTheme.success, size: 64),
              const SizedBox(height: 16),
              const Text("Arrived at Pickup", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Ask \${widget.request.riderName} for the 4-digit PIN", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '----',
                  errorText: _errorText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  counterText: '',
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() => _errorText = null);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PinkAppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "START TRIP",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
