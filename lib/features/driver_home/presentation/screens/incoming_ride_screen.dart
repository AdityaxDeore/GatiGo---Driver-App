import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/ride_request.dart';
import '../widgets/incoming_ride_actions.dart';
import '../widgets/incoming_ride_fare_card.dart';
import '../widgets/incoming_ride_header.dart';
import '../widgets/incoming_ride_route_timeline.dart';

class IncomingRideScreen extends StatefulWidget {
  final RideRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onExpired;

  const IncomingRideScreen({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onExpired,
  });

  @override
  State<IncomingRideScreen> createState() => _IncomingRideScreenState();
}

class _IncomingRideScreenState extends State<IncomingRideScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsLeft = 15;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.request.expiresAt.difference(DateTime.now()).inSeconds;
    if (_secondsLeft <= 0) _secondsLeft = 15;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer.cancel();
        widget.onExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_secondsLeft / 15.0).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: PinkAppTheme.primaryPink.withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IncomingRideHeader(
                    pulseAnimation: _pulseAnimation,
                    progress: progress,
                    secondsLeft: _secondsLeft,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IncomingRideFareCard(request: widget.request),
                          const SizedBox(height: 20),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          IncomingRideRouteTimeline(request: widget.request),
                        ],
                      ),
                    ),
                  ),
                  IncomingRideActions(
                    onAccept: widget.onAccept,
                    onReject: widget.onReject,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
