import 'package:flutter/material.dart';
import '../../domain/models/ride_request.dart';
import '../../domain/models/trip_state.dart';
import 'simulated_map_canvas_painter.dart';
import 'trip_navigation_hud.dart';

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
            final isDrivingToPickup =
                widget.tripState == TripState.drivingToPickup;
            final isTripStarted = widget.tripState == TripState.tripStarted;

            if (isDrivingToPickup) {
              progress = _pickupAnimController.value;
            } else if (isTripStarted) {
              progress = _destinationAnimController.value;
            } else if (widget.tripState == TripState.arrivedAtPickup ||
                widget.tripState == TripState.arrivedAtDestination ||
                widget.tripState == TripState.completed) {
              progress = 1.0;
            }

            return Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: SimulatedMapCanvasPainter(
                    tripState: widget.tripState,
                    pickupProgress: _pickupAnimController.value,
                    destinationProgress: _destinationAnimController.value,
                    pulseValue: _pulseController.value,
                  ),
                ),
                if (isDrivingToPickup || isTripStarted)
                  TripNavigationHud(
                    isDrivingToPickup: isDrivingToPickup,
                    request: widget.request,
                    progress: progress,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
