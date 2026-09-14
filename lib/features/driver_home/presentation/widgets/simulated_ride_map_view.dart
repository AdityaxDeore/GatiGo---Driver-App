import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/ride_request.dart';
import '../../domain/models/trip_state.dart';

class SimulatedRideMapView extends StatefulWidget {
  final TripState tripState;
  final RideRequest? request;
  final VoidCallback onArrivedAtPickup;
  final VoidCallback onTripCompleted;

  const SimulatedRideMapView({
    super.key,
    required this.tripState,
    this.request,
    required this.onArrivedAtPickup,
    required this.onTripCompleted,
  });

  @override
  State<SimulatedRideMapView> createState() => _SimulatedRideMapViewState();
}

class _SimulatedRideMapViewState extends State<SimulatedRideMapView>
    with TickerProviderStateMixin {
  late AnimationController _pickupAnimController;
  late AnimationController _destinationAnimController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pickupAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _destinationAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pickupAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onArrivedAtPickup();
      }
    });
    _pickupAnimController.addListener(() {
      if (_pickupAnimController.value >= 0.99) {
        widget.onArrivedAtPickup();
      }
    });

    _destinationAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTripCompleted();
      }
    });
    _destinationAnimController.addListener(() {
      if (_destinationAnimController.value >= 0.99) {
        widget.onTripCompleted();
      }
    });

    _checkAndStartAnimations();
  }

  @override
  void didUpdateWidget(covariant SimulatedRideMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tripState != widget.tripState) {
      _checkAndStartAnimations();
    }
  }

  void _checkAndStartAnimations() {
    if (widget.tripState == TripState.drivingToPickup) {
      if (!_pickupAnimController.isAnimating &&
          _pickupAnimController.status != AnimationStatus.completed) {
        _pickupAnimController.forward();
      }
    } else if (widget.tripState == TripState.tripStarted) {
      if (!_destinationAnimController.isAnimating &&
          _destinationAnimController.status != AnimationStatus.completed) {
        _destinationAnimController.forward();
      }
    } else if (widget.tripState == TripState.available ||
        widget.tripState == TripState.requestReceived) {
      _pickupAnimController.reset();
      _destinationAnimController.reset();
    }
  }

  @override
  void dispose() {
    _pickupAnimController.dispose();
    _destinationAnimController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: Listenable.merge([
            _pickupAnimController,
            _destinationAnimController,
            _pulseController,
          ]),
          builder: (context, _) {
            double progress = 0.0;
            bool isDrivingToPickup =
                widget.tripState == TripState.drivingToPickup;
            bool isTripStarted = widget.tripState == TripState.tripStarted;

            if (isDrivingToPickup) {
              progress = _pickupAnimController.value;
            } else if (isTripStarted) {
              progress = _destinationAnimController.value;
            } else if (widget.tripState == TripState.arrivedAtPickup) {
              progress = 1.0;
            } else if (widget.tripState == TripState.arrivedAtDestination ||
                widget.tripState == TripState.completed) {
              progress = 1.0;
            }

            return Stack(
              children: [
                // Custom Painted Street Map
                CustomPaint(
                  size: size,
                  painter: _MapCanvasPainter(
                    tripState: widget.tripState,
                    pickupProgress: _pickupAnimController.value,
                    destinationProgress: _destinationAnimController.value,
                    pulseValue: _pulseController.value,
                  ),
                ),

                // Top Turn-By-Turn HUD during driving
                if (isDrivingToPickup || isTripStarted)
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 64, 16, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: PinkAppTheme.primaryPink,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDrivingToPickup
                                    ? Icons.turn_left
                                    : Icons.navigation_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isDrivingToPickup
                                        ? "En route to Pickup (${widget.request?.pickupAddress ?? 'Tech Park'})"
                                        : "Heading to Drop-off (${widget.request?.destinationAddress ?? 'Indiranagar'})",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isDrivingToPickup
                                        ? "In ${((1.0 - progress) * 1.5).toStringAsFixed(1)} km • Speed: 28 km/h"
                                        : "In ${((1.0 - progress) * 4.2).toStringAsFixed(1)} km • Speed: 34 km/h",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.navigation,
                                      size: 11, color: Colors.greenAccent),
                                  const SizedBox(width: 4),
                                  Text(
                                    isDrivingToPickup ? "GPS" : "LIVE",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final TripState tripState;
  final double pickupProgress;
  final double destinationProgress;
  final double pulseValue;

  _MapCanvasPainter({
    required this.tripState,
    required this.pickupProgress,
    required this.destinationProgress,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. City Background
    final bgPaint = Paint()..color = const Color(0xFFF1F4F8);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Green Parks & Landmarks
    _drawParksAndCanals(canvas, size);

    // 3. City Road Grid
    _drawRoadGrid(canvas, size);

    // Map Coordinates defined relative to available screen size
    final w = size.width;
    final h = size.height;

    // Fixed realistic Waypoints on map:
    // Start (Driver initial position)
    final startPt = Offset(w * 0.22, h * 0.72);
    // Intermediate turn 1
    final turn1 = Offset(w * 0.22, h * 0.52);
    // Intermediate turn 2 (Bridge cross)
    final turn2 = Offset(w * 0.65, h * 0.52);
    // Pickup (Tech Park Main Gate)
    final pickupPt = Offset(w * 0.65, h * 0.38);
    // Destination turn 1
    final destTurn1 = Offset(w * 0.65, h * 0.24);
    // Destination turn 2
    final destTurn2 = Offset(w * 0.32, h * 0.24);
    // Destination (Indiranagar 100ft Rd)
    final destPt = Offset(w * 0.32, h * 0.12);

    // Path 1: Driver -> Pickup
    final pickupPath = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..lineTo(turn1.dx, turn1.dy)
      ..lineTo(turn2.dx, turn2.dy)
      ..lineTo(pickupPt.dx, pickupPt.dy);

    // Path 2: Pickup -> Destination
    final destPath = Path()
      ..moveTo(pickupPt.dx, pickupPt.dy)
      ..lineTo(destTurn1.dx, destTurn1.dy)
      ..lineTo(destTurn2.dx, destTurn2.dy)
      ..lineTo(destPt.dx, destPt.dy);

    // 4. Draw Route Polylines
    if (tripState == TripState.drivingToPickup ||
        tripState == TripState.arrivedAtPickup) {
      _drawRoute(canvas, pickupPath, pickupProgress, PinkAppTheme.primaryPink);
    } else if (tripState == TripState.tripStarted ||
        tripState == TripState.arrivedAtDestination ||
        tripState == TripState.completed) {
      _drawRoute(canvas, destPath, destinationProgress, PinkAppTheme.accentPurple);
    }

    // 5. Draw Markers
    if (tripState == TripState.drivingToPickup ||
        tripState == TripState.arrivedAtPickup) {
      _drawMarker(canvas, pickupPt, "PICKUP", Colors.green, Icons.person_pin_circle);
    }

    if (tripState == TripState.tripStarted ||
        tripState == TripState.arrivedAtDestination ||
        tripState == TripState.completed) {
      _drawMarker(canvas, destPt, "DROP-OFF", PinkAppTheme.primaryPink, Icons.flag_rounded);
    }

    // 6. Draw Animated Vehicle (Pink Auto)
    if (tripState == TripState.drivingToPickup) {
      _drawAnimatedVehicleOnPath(canvas, pickupPath, pickupProgress);
    } else if (tripState == TripState.arrivedAtPickup) {
      _drawVehicleAt(canvas, pickupPt, -math.pi / 2);
    } else if (tripState == TripState.tripStarted) {
      _drawAnimatedVehicleOnPath(canvas, destPath, destinationProgress);
    } else if (tripState == TripState.arrivedAtDestination || tripState == TripState.completed) {
      _drawVehicleAt(canvas, destPt, -math.pi / 2);
    } else {
      // Default idle driver vehicle at start point
      _drawVehicleAt(canvas, startPt, -math.pi / 2);
    }
  }

  void _drawParksAndCanals(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Green Park 1 (Botanical Gardens)
    final parkPaint = Paint()..color = const Color(0xFFE2F3E5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.28, w * 0.35, h * 0.18),
        const Radius.circular(16),
      ),
      parkPaint,
    );

    // Green Park 2 (Tech Park Green)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.42, w * 0.24, h * 0.22),
        const Radius.circular(16),
      ),
      parkPaint,
    );

    // Water Canal
    final canalPaint = Paint()
      ..color = const Color(0xFFD6EAF8)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final canalPath = Path()
      ..moveTo(0, h * 0.46)
      ..cubicTo(w * 0.35, h * 0.44, w * 0.65, h * 0.48, w, h * 0.45);
    canvas.drawPath(canalPath, canalPaint);
  }

  void _drawRoadGrid(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final majorRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFF9FAFB)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    // Road grid lines
    final roads = [
      // Vertical Avenues
      Path()..moveTo(w * 0.22, 0)..lineTo(w * 0.22, h),
      Path()..moveTo(w * 0.65, 0)..lineTo(w * 0.65, h),
      Path()..moveTo(w * 0.44, 0)..lineTo(w * 0.44, h),
      // Horizontal Streets
      Path()..moveTo(0, h * 0.12)..lineTo(w, h * 0.12),
      Path()..moveTo(0, h * 0.24)..lineTo(w, h * 0.24),
      Path()..moveTo(0, h * 0.38)..lineTo(w, h * 0.38),
      Path()..moveTo(0, h * 0.52)..lineTo(w, h * 0.52),
      Path()..moveTo(0, h * 0.72)..lineTo(w, h * 0.72),
    ];

    for (var r in roads) {
      canvas.drawPath(r, majorRoadPaint);
      canvas.drawPath(r, minorRoadPaint);
    }
  }

  void _drawRoute(Canvas canvas, Path path, double progress, Color activeColor) {
    // 1. Background Route Line
    final bgRoutePaint = Paint()
      ..color = activeColor.withValues(alpha: 0.25)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, bgRoutePaint);

    // 2. Active Animated Polyline (up to current progress)
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final totalLength = metrics.fold<double>(0.0, (sum, m) => sum + m.length);
    final targetLength = totalLength * progress.clamp(0.0, 1.0);

    final activePath = Path();
    double accumulated = 0.0;

    for (var metric in metrics) {
      if (accumulated + metric.length <= targetLength) {
        activePath.addPath(metric.extractPath(0, metric.length), Offset.zero);
        accumulated += metric.length;
      } else {
        final remaining = targetLength - accumulated;
        if (remaining > 0) {
          activePath.addPath(metric.extractPath(0, remaining), Offset.zero);
        }
        break;
      }
    }

    final activeRoutePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(activePath, activeRoutePaint);
  }

  void _drawAnimatedVehicleOnPath(
      Canvas canvas, Path path, double progress) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final totalLength = metrics.fold<double>(0.0, (sum, m) => sum + m.length);
    final currentDist = totalLength * progress.clamp(0.0, 1.0);

    double accumulated = 0.0;
    ui.Tangent? tangent;

    for (var metric in metrics) {
      if (accumulated + metric.length >= currentDist) {
        final localDist = currentDist - accumulated;
        tangent = metric.getTangentForOffset(localDist);
        break;
      }
      accumulated += metric.length;
    }

    if (tangent != null) {
      // Rotation angle from tangent
      double angle = tangent.angle;
      _drawVehicleAt(canvas, tangent.position, angle);
    }
  }

  void _drawVehicleAt(Canvas canvas, Offset position, double angle) {
    canvas.save();
    canvas.translate(position.dx, position.dy);

    // Pulse radar ring around vehicle
    final pulsePaint = Paint()
      ..color = PinkAppTheme.primaryPink.withValues(alpha: 0.3 * (1.0 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset.zero, 18 + (pulseValue * 14), pulsePaint);

    // Vehicle Shadow
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(0, 3), 16, shadowPaint);

    // Rotate towards driving heading
    canvas.rotate(angle);

    // Vehicle Body (Pink Auto)
    final bodyPaint = Paint()..color = PinkAppTheme.primaryPink;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 26, height: 18),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrect, bodyPaint);

    // Auto Yellow Hood / Roof Stripe
    final roofPaint = Paint()..color = Colors.yellow.shade700;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(-2, 0), width: 14, height: 14),
        const Radius.circular(4),
      ),
      roofPaint,
    );

    // Windshield
    final glassPaint = Paint()..color = Colors.lightBlue.shade100;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(8, 0), width: 5, height: 12),
        const Radius.circular(2),
      ),
      glassPaint,
    );

    // Headlight Beams
    final headlightPaint = Paint()..color = Colors.amberAccent;
    canvas.drawCircle(const Offset(13, -5), 2.5, headlightPaint);
    canvas.drawCircle(const Offset(13, 5), 2.5, headlightPaint);

    canvas.restore();
  }

  void _drawMarker(Canvas canvas, Offset pt, String label, Color color,
      IconData icon) {
    // Pulse wave at pin
    final ripple = Paint()
      ..color = color.withValues(alpha: 0.25 * (1.0 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(pt, 12 + (pulseValue * 10), ripple);

    // Pin shadow
    canvas.drawCircle(
      Offset(pt.dx, pt.dy + 3),
      14,
      Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Pin Head
    final pinPaint = Paint()..color = color;
    canvas.drawCircle(pt, 14, pinPaint);

    // Center white dot
    canvas.drawCircle(pt, 5, Paint()..color = Colors.white);

    // Marker Badge Label
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: 10,
        letterSpacing: 0.5,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(pt.dx, pt.dy - 24),
        width: textPainter.width + 12,
        height: 18,
      ),
      const Radius.circular(6),
    );

    canvas.drawRRect(bgRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    textPainter.paint(
      canvas,
      Offset(pt.dx - (textPainter.width / 2), pt.dy - 32),
    );
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.tripState != tripState ||
        oldDelegate.pickupProgress != pickupProgress ||
        oldDelegate.destinationProgress != destinationProgress ||
        oldDelegate.pulseValue != pulseValue;
  }
}
