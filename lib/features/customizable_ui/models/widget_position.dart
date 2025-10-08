import 'package:flutter/material.dart';


class WidgetPosition {
  final String id;
  final Offset position;
  final bool isDragging;


  const WidgetPosition({this.isDragging = false, required this.id, required this.position});

  WidgetPosition copyWith({Offset? position, bool? isDragging}) {
    return WidgetPosition(
      id: id,
      position : position ?? this.position,
      isDragging :isDragging ?? this.isDragging ,
    );
  }
}
