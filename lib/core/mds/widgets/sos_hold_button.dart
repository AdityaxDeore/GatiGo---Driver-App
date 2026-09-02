import 'package:flutter/material.dart';

class SosDialog extends StatelessWidget {
  final VoidCallback onTriggered;

  const SosDialog({super.key, required this.onTriggered});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withValues(
          alpha: 0.85,
        ), // Full screen translucent dark overlay
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HOLD FOR A SECOND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'TO SEND EMERGENCY SOS',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 60),

            // Big circular button with animation around it
            SosHoldButton(onTriggered: onTriggered),

            const SizedBox(height: 80),

            // Close button below (small circle with X cross to cut/close)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.white30, width: 2.0),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SosHoldButton extends StatefulWidget {
  final VoidCallback onTriggered;

  const SosHoldButton({super.key, required this.onTriggered});

  @override
  State<SosHoldButton> createState() => _SosHoldButtonState();
}

class _SosHoldButtonState extends State<SosHoldButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTriggered();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isHolding = true;
        });
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isHolding = false;
        });
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() {
          _isHolding = false;
        });
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing outer glow if holding (Large size)
              if (_isHolding)
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
                  ),
                ),
              // Core SOS Circle (Large size)
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD32F2F),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 54, // Huge letters
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              // Circular Progress around the SOS circle (Large size, thicker stroke)
              SizedBox(
                width: 214,
                height: 214,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8, // Thicker stroke for arcade/game feel
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD32F2F),
                  ),
                  backgroundColor: Colors.white12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
