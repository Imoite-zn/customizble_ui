import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/widget_position.dart';

class UIState extends Equatable {
  final List<WidgetPosition> widgetPositions;
  final Map<String, int> counterValues;
  final Map<String, bool> toggleValues;
  final Map<String, double> sliderValues;
  final Map<String, Color> colorValues;
  final Map<String, String> textValues;
  final bool isDragEnabled; 

  const UIState({
    required this.isDragEnabled,
    required this.widgetPositions,
    required this.counterValues,
    required this.toggleValues,
    required this.sliderValues,
    required this.colorValues,
    required this.textValues,
  });

  factory UIState.initial() {
    return UIState(
      widgetPositions: [
        const WidgetPosition(id: 'counter', position: Offset(50, 50)),
        const WidgetPosition(id: 'toggle', position: Offset(200, 50)),
        const WidgetPosition(id: 'slider', position: Offset(350, 50)),
        const WidgetPosition(id: 'color_picker', position: Offset(50, 200)),
        const WidgetPosition(id: 'text_editor', position: Offset(200, 200)),
      ],
      counterValues: {'counter': 0},
      toggleValues: {'toggle': false},
      sliderValues: {'slider': 0.5},
      colorValues: {'color_picker': Colors.blue},
      textValues: {'text_editor': 'Edit me!'},
      isDragEnabled: true,
    );
  }

  UIState copyWith({
    List<WidgetPosition>? widgetPositions,
    Map<String, int>? counterValues,
    Map<String, bool>? toggleValues,
    Map<String, double>? sliderValues,
    Map<String, Color>? colorValues,
    Map<String, String>? textValues,
    bool? isDragEnabled,
  }) {
    return UIState(
      widgetPositions: widgetPositions ?? this.widgetPositions,
      counterValues: counterValues ?? this.counterValues,
      toggleValues: toggleValues ?? this.toggleValues,
      sliderValues: sliderValues ?? this.sliderValues,
      colorValues: colorValues ?? this.colorValues,
      textValues: textValues ?? this.textValues,
      isDragEnabled: isDragEnabled ?? this.isDragEnabled,
    );
  }

  @override
  List<Object> get props => [
        widgetPositions,
        counterValues,
        toggleValues,
        sliderValues,
        colorValues,
        textValues,
        isDragEnabled,
      ];
}
