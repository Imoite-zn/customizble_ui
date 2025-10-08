import 'package:flutter/widgets.dart';

class DragOptimizations {
  static const double minDragDistance = 3.0;
  static const double maxDragSpeed = 2000.0; // pixels per second
  static const double smoothFactor = 0.7;

  static double applySmoothing(double delta, double velocity) {
    // Limit extreme velocities
    final limitedVelocity = velocity.clamp(-maxDragSpeed, maxDragSpeed);
    
    // Apply smooth factor and normalize
    final smoothedDelta = delta + (limitedVelocity * smoothFactor / 1000);
    
    // Filter out micro-movements to reduce jitter
    if (smoothedDelta.abs() < minDragDistance) {
      return delta; // Return original delta for small movements
    }
    
    return smoothedDelta;
  }

  static Offset calculateOptimalPosition(
    Offset currentPosition,
    Offset delta,
    Velocity velocity,
    Size screenSize,
  ) {
    // Apply velocity-based smoothing
    final smoothedDelta = Offset(
      applySmoothing(delta.dx, velocity.pixelsPerSecond.dx),
      applySmoothing(delta.dy, velocity.pixelsPerSecond.dy),
    );

    final newPosition = currentPosition + smoothedDelta;

    // Constrain to screen bounds with margin
    const margin = 20.0;
    const widgetWidth = 180.0;
    const widgetHeight = 120.0;

    return Offset(
      newPosition.dx.clamp(margin, screenSize.width - widgetWidth - margin),
      newPosition.dy.clamp(margin, screenSize.height - widgetHeight - margin),
    );
  }
}