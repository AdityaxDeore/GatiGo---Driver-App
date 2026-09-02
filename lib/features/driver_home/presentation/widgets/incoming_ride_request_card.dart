import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/ride_request.dart';

class IncomingRideRequestCard extends StatefulWidget {
  final RideRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onExpired;

  const IncomingRideRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onExpired,
  });

  @override
  State<IncomingRideRequestCard> createState() => _IncomingRideRequestCardState();
}

class _IncomingRideRequestCardState extends State<IncomingRideRequestCard> {
  late Timer _timer;
  int _secondsLeft = 15;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.request.expiresAt.difference(DateTime.now()).inSeconds;
    if (_secondsLeft < 0) _secondsLeft = 0;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: const BoxDecoration(
              color: PinkAppTheme.primaryPink,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("New Ride Request", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text("\${_secondsLeft}s", style: TextStyle(color: PinkAppTheme.primaryPink, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(widget.request.riderName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Text("₹\${widget.request.estimatedFare.toStringAsFixed(0)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: PinkAppTheme.primaryPink)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("PICKUP", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(widget.request.pickupAddress, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11.0, top: 4, bottom: 4),
                  child: Align(alignment: Alignment.centerLeft, child: Container(width: 2, height: 20, color: Colors.grey)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: PinkAppTheme.primaryPink),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("DROP-OFF", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(widget.request.destinationAddress, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("\${widget.request.estimatedDurationMins} mins", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onReject,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("REJECT", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: widget.onAccept,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: PinkAppTheme.success,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("ACCEPT RIDE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
