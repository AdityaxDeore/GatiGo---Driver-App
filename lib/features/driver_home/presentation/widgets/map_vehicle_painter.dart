import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Helper for rendering vehicle sprites, orientation tangents, and destination markers.
class MapVehiclePainter {
  static void drawAnimatedVehicleOnPath({
    required Canvas canvas,
    required Path path,
    required double progress,
    required double pulseValue,
  }) {
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
      drawVehicleAt(
        canvas: canvas,
        position: tangent.position,
        angle: tangent.angle,
        pulseValue: pulseValue,
      );
    }
  }

  static void drawVehicleAt({
    required Canvas canvas,
    required Offset position,
    required double angle,
    required double pulseValue,
  }) {
    canvas.save();
    canvas.translate(position.dx, position.dy);

    // Pulse radar ring around vehicle
    final pulsePaint = Paint()
      ..color = PinkAppTheme.primaryPink.withValues(
        alpha: 0.3 * (1.0 - pulseValue),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset.zero, 18 + (pulseValue * 14), pulsePaint);

    // Vehicle Shadow
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(0, 3), 16, shadowPaint);

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

  static void drawMarker({
    required Canvas canvas,
    required Offset pt,
    required String label,
    required Color color,
    required double pulseValue,
  }) {
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
}
