import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/trip_state.dart';
import 'map_vehicle_painter.dart';

/// CustomPainter rendering city road grid, route polylines, and moving vehicles.
class SimulatedMapCanvasPainter extends CustomPainter {
  final TripState tripState;
  final double pickupProgress;
  final double destinationProgress;
  final double pulseValue;

  SimulatedMapCanvasPainter({
    required this.tripState,
    required this.pickupProgress,
    required this.destinationProgress,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF1F4F8));

    _drawParksAndCanals(canvas, size);
    _drawRoadGrid(canvas, size);

    final w = size.width;
    final h = size.height;

    final startPt = Offset(w * 0.22, h * 0.72);
    final turn1 = Offset(w * 0.22, h * 0.52);
    final turn2 = Offset(w * 0.65, h * 0.52);
    final pickupPt = Offset(w * 0.65, h * 0.38);
    final destTurn1 = Offset(w * 0.65, h * 0.24);
    final destTurn2 = Offset(w * 0.32, h * 0.24);
    final destPt = Offset(w * 0.32, h * 0.12);

    final pickupPath = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..lineTo(turn1.dx, turn1.dy)
      ..lineTo(turn2.dx, turn2.dy)
      ..lineTo(pickupPt.dx, pickupPt.dy);

    final destPath = Path()
      ..moveTo(pickupPt.dx, pickupPt.dy)
      ..lineTo(destTurn1.dx, destTurn1.dy)
      ..lineTo(destTurn2.dx, destTurn2.dy)
      ..lineTo(destPt.dx, destPt.dy);

    if (tripState == TripState.drivingToPickup ||
        tripState == TripState.arrivedAtPickup) {
      _drawRoute(canvas, pickupPath, pickupProgress, PinkAppTheme.primaryPink);
      MapVehiclePainter.drawMarker(
        canvas: canvas,
        pt: pickupPt,
        label: "PICKUP",
        color: Colors.green,
        pulseValue: pulseValue,
      );
    } else if (tripState == TripState.tripStarted ||
        tripState == TripState.arrivedAtDestination ||
        tripState == TripState.completed) {
      _drawRoute(canvas, destPath, destinationProgress, PinkAppTheme.accentPurple);
      MapVehiclePainter.drawMarker(
        canvas: canvas,
        pt: destPt,
        label: "DROP-OFF",
        color: PinkAppTheme.primaryPink,
        pulseValue: pulseValue,
      );
    }

    if (tripState == TripState.drivingToPickup) {
      MapVehiclePainter.drawAnimatedVehicleOnPath(
        canvas: canvas,
        path: pickupPath,
        progress: pickupProgress,
        pulseValue: pulseValue,
      );
    } else if (tripState == TripState.arrivedAtPickup) {
      MapVehiclePainter.drawVehicleAt(
        canvas: canvas,
        position: pickupPt,
        angle: -math.pi / 2,
        pulseValue: pulseValue,
      );
    } else if (tripState == TripState.tripStarted) {
      MapVehiclePainter.drawAnimatedVehicleOnPath(
        canvas: canvas,
        path: destPath,
        progress: destinationProgress,
        pulseValue: pulseValue,
      );
    } else if (tripState == TripState.arrivedAtDestination ||
        tripState == TripState.completed) {
      MapVehiclePainter.drawVehicleAt(
        canvas: canvas,
        position: destPt,
        angle: -math.pi / 2,
        pulseValue: pulseValue,
      );
    } else {
      MapVehiclePainter.drawVehicleAt(
        canvas: canvas,
        position: startPt,
        angle: -math.pi / 2,
        pulseValue: pulseValue,
      );
    }
  }

  void _drawParksAndCanals(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final parkPaint = Paint()..color = const Color(0xFFE2F3E5);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.28, w * 0.35, h * 0.18),
        const Radius.circular(16),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.42, w * 0.24, h * 0.22),
        const Radius.circular(16),
      ),
      parkPaint,
    );

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
    final majorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final minorPaint = Paint()
      ..color = const Color(0xFFF9FAFB)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roads = [
      Path()..moveTo(w * 0.22, 0)..lineTo(w * 0.22, h),
      Path()..moveTo(w * 0.65, 0)..lineTo(w * 0.65, h),
      Path()..moveTo(w * 0.44, 0)..lineTo(w * 0.44, h),
      Path()..moveTo(0, h * 0.12)..lineTo(w, h * 0.12),
      Path()..moveTo(0, h * 0.24)..lineTo(w, h * 0.24),
      Path()..moveTo(0, h * 0.38)..lineTo(w, h * 0.38),
      Path()..moveTo(0, h * 0.52)..lineTo(w, h * 0.52),
      Path()..moveTo(0, h * 0.72)..lineTo(w, h * 0.72),
    ];

    for (var r in roads) {
      canvas.drawPath(r, majorPaint);
      canvas.drawPath(r, minorPaint);
    }
  }

  void _drawRoute(Canvas canvas, Path path, double progress, Color activeColor) {
    canvas.drawPath(
      path,
      Paint()
        ..color = activeColor.withValues(alpha: 0.25)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

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

    canvas.drawPath(
      activePath,
      Paint()
        ..color = activeColor
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant SimulatedMapCanvasPainter oldDelegate) {
    return oldDelegate.tripState != tripState ||
        oldDelegate.pickupProgress != pickupProgress ||
        oldDelegate.destinationProgress != destinationProgress ||
        oldDelegate.pulseValue != pulseValue;
  }
}
