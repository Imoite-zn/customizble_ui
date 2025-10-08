import 'package:flutter/material.dart';

class DragPerformanceMonitor {
  static final List<Duration> _frameTimes = [];
  static final int _maxSamples = 60;

  static void recordFrameTime(Duration frameTime) {
    _frameTimes.add(frameTime);
    if (_frameTimes.length > _maxSamples) {
      _frameTimes.removeAt(0);
    }
  }

  static double getAverageFrameTime() {
    if (_frameTimes.isEmpty) return 0;
    final total = _frameTimes.fold(0, (sum, time) => sum + time.inMicroseconds);
    return total / _frameTimes.length / 1000; // Convert to milliseconds
  }

  static double getFPS() {
    final avgFrameTime = getAverageFrameTime();
    return avgFrameTime > 0 ? 1000 / avgFrameTime : 0;
  }
}