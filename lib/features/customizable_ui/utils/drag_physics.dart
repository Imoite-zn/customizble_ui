import 'package:flutter/material.dart';

class DragPhysics {
  static const double cursorFollowPrecision = 1.0; // 1:1 cursor following
  static const double maxDragSpeed = 5000.0; // pixels per second
  static const double smoothingThreshold = 0.1;

  /// Calculates the exact position for 1:1 cursor following
  static Offset calculateExactPosition({
    required Offset dragStartPosition,
    required Offset currentCursorPosition,
    required Offset widgetStartPosition,
  }) {
    // Simple 1:1 mapping - widget moves exactly with cursor
    final delta = currentCursorPosition - dragStartPosition;
    return widgetStartPosition + delta;
  }

  /// Applies smooth constraints to prevent jitter while maintaining precision
  static Offset applySmoothConstraints({
    required Offset rawPosition,
    required Offset previousPosition,
    required double smoothingFactor,
  }) {
    // For high-precision dragging, we use minimal smoothing
    // This maintains 1:1 cursor tracking while reducing micro-jitter
    if (smoothingFactor < smoothingThreshold) {
      return rawPosition;
    }

    final smoothedPosition = Offset.lerp(
      previousPosition,
      rawPosition,
      smoothingFactor,
    );

    return smoothedPosition ?? rawPosition;
  }

  /// Gets the exact cursor position relative to the widget
  static Offset getLocalCursorPosition(Offset globalCursorPosition, Offset widgetPosition) {
    return globalCursorPosition - widgetPosition;
  }

  /// Calculates drag velocity for potential future enhancements
  static double calculateDragVelocity(Offset delta, Duration timeDelta) {
    final speedX = delta.dx / timeDelta.inMilliseconds * 1000;
    final speedY = delta.dy / timeDelta.inMilliseconds * 1000;
    return Offset(speedX, speedY).distance;
  }
}