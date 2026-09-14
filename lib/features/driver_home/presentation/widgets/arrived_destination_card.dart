import 'package:flutter/material.dart';
import 'package:pink_auto/core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class ArrivedDestinationCard extends StatefulWidget {
  final RideRequest request;
  final Future<bool> Function(String) onVerifyOtp;

  const ArrivedDestinationCard({
    super.key,
    required this.request,
    required this.onVerifyOtp,
  });

  @override
  State<ArrivedDestinationCard> createState() => _ArrivedDestinationCardState();
}

class _ArrivedDestinationCardState extends State<ArrivedDestinationCard> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 4) {
      setState(() => _errorText = 'Enter 4-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await widget.onVerifyOtp(otp);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          _errorText = 'Please enter a valid 4-digit PIN';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: PinkAppTheme.primaryPink.withValues(alpha: 0.15),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PinkAppTheme.primaryPink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.where_to_vote_rounded,
                  color: PinkAppTheme.primaryPink,
                  size: 52,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Arrived at Destination",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: PinkAppTheme.accentPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ask ${widget.request.riderName} for the 4-digit Drop-off PIN",
                style: const TextStyle(color: PinkAppTheme.textLight, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                  color: PinkAppTheme.accentPurple,
                ),
                decoration: InputDecoration(
                  hintText: '----',
                  errorText: _errorText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PinkAppTheme.primaryPink,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          "VERIFY & COMPLETE RIDE",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
