import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UIEvent extends Equatable {
  const UIEvent();

  @override
  List<Object> get props => [];
}

class UIInitialized extends UIEvent {}

class WidgetMoved extends UIEvent {
  final String widgetId;
  final Offset newPosition;

  const WidgetMoved(this.widgetId, this.newPosition);

  @override
  List<Object> get props => [widgetId, newPosition];
}

class CounterIncremented extends UIEvent {
  final String widgetId;

  const CounterIncremented(this.widgetId);

  @override
  List<Object> get props => [widgetId];
}

class CounterDecremented extends UIEvent {
  final String widgetId;

  const CounterDecremented(this.widgetId);

  @override
  List<Object> get props => [widgetId];
}

class ToggleChanged extends UIEvent {
  final String widgetId;

  const ToggleChanged(this.widgetId);

  @override
  List<Object> get props => [widgetId];
}

class SliderChanged extends UIEvent {
  final String widgetId;
  final double value;

  const SliderChanged(this.widgetId, this.value);

  @override
  List<Object> get props => [widgetId, value];
}

class ColorChanged extends UIEvent {
  final String widgetId;
  final Color color;

  const ColorChanged(this.widgetId, this.color);

  @override
  List<Object> get props => [widgetId, color];
}

class TextChanged extends UIEvent {
  final String widgetId;
  final String text;

  const TextChanged(this.widgetId, this.text);

  @override
  List<Object> get props => [widgetId, text];
}

// Add these new events
class WidgetDragStarted extends UIEvent {
  final String widgetId;

  const WidgetDragStarted(this.widgetId);

  @override
  List<Object> get props => [widgetId];
}

class WidgetDragEnded extends UIEvent {
  final String widgetId;

  const WidgetDragEnded(this.widgetId);

  @override
  List<Object> get props => [widgetId];
}

class DragFeatureToggled extends UIEvent {
  final bool isDragEnabled;

  const DragFeatureToggled(this.isDragEnabled);

  @override
  List<Object> get props => [isDragEnabled];
}

class ResetPositions extends UIEvent {}
