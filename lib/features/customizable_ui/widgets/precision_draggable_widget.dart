import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';
import '../utils/drag_physics.dart';

class PrecisionDraggableWidget extends StatefulWidget {
  final String widgetId;
  final Widget child;
  final Offset position;
  final bool isDragging;

  const PrecisionDraggableWidget({
    super.key,
    required this.widgetId,
    required this.child,
    required this.position,
    required this.isDragging,
  });

  @override
  State<PrecisionDraggableWidget> createState() => _PrecisionDraggableWidgetState();
}

class _PrecisionDraggableWidgetState extends State<PrecisionDraggableWidget> {
  Offset _dragStartOffset = Offset.zero;
  Offset _widgetStartOffset = Offset.zero;
  bool _isDragging = false;
  DateTime? _lastUpdateTime;
  Offset? _lastPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: MouseRegion(
        cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: Listener(
          onPointerDown: (details) => _onDragStart(details, context),
          onPointerMove: (details) => _onDragUpdate(details, context),
          onPointerUp: (details) => _onDragEnd(context),
          onPointerCancel: (details) => _onDragEnd(context),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) => _onDragStartFromPan(details, context),
            onPanUpdate: (details) => _onDragUpdateFromPan(details, context),
            onPanEnd: (details) => _onDragEnd(context),
            onPanCancel: () => _onDragEnd(context),
            child: _buildWidgetContent(),
          ),
        ),
      ),
    );
  }

  void _onDragStart(PointerDownEvent details, BuildContext context) {
    _isDragging = true;
    _dragStartOffset = details.position;
    _widgetStartOffset = widget.position;
    _lastUpdateTime = DateTime.now();
    _lastPosition = widget.position;

    context.read<UIBloc>().add(WidgetDragStarted(widget.widgetId));
  }

  void _onDragStartFromPan(DragStartDetails details, BuildContext context) {
    _isDragging = true;
    _dragStartOffset = details.globalPosition;
    _widgetStartOffset = widget.position;
    _lastUpdateTime = DateTime.now();
    _lastPosition = widget.position;

    context.read<UIBloc>().add(WidgetDragStarted(widget.widgetId));
  }

  void _onDragUpdateFromPan(DragUpdateDetails details, BuildContext context) {
    if (!_isDragging) return;

    // Calculate exact position based on cursor movement
    final currentCursorPosition = _dragStartOffset + details.delta;

    final newPosition = DragPhysics.calculateExactPosition(
      dragStartPosition: _dragStartOffset,
      currentCursorPosition: currentCursorPosition,
      widgetStartPosition: _widgetStartOffset,
    );

    // Apply smooth constraints if needed
    final constrainedPosition = _applySmoothConstraints(newPosition);

    // Update screen bounds constraints
    final boundedPosition = _constrainToScreenBounds(constrainedPosition, context);

    context.read<UIBloc>().add(WidgetMoved(widget.widgetId, boundedPosition));

    _lastUpdateTime = DateTime.now();
    _lastPosition = boundedPosition;
  }

  void _onDragUpdate(PointerMoveEvent details, BuildContext context) {
    if (!_isDragging) return;

    // Calculate exact position based on cursor
    final newPosition = DragPhysics.calculateExactPosition(
      dragStartPosition: _dragStartOffset,
      currentCursorPosition: details.position,
      widgetStartPosition: _widgetStartOffset,
    );

    // Apply smooth constraints if needed
    final constrainedPosition = _applySmoothConstraints(newPosition);

    // Update screen bounds constraints
    final boundedPosition = _constrainToScreenBounds(constrainedPosition, context);

    context.read<UIBloc>().add(WidgetMoved(widget.widgetId, boundedPosition));

    _lastUpdateTime = DateTime.now();
    _lastPosition = boundedPosition;
  }

  Offset _applySmoothConstraints(Offset newPosition) {
    if (_lastPosition == null) return newPosition;

    final timeDelta = DateTime.now().difference(_lastUpdateTime!);
    
    // Use minimal smoothing for high precision
    return DragPhysics.applySmoothConstraints(
      rawPosition: newPosition,
      previousPosition: _lastPosition!,
      smoothingFactor: 0.8, // Higher = more responsive, lower = more smooth
    );
  }

  Offset _constrainToScreenBounds(Offset position, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // More precise widget size estimation
    final widgetSize = _estimateWidgetSize();
    const margin = 8.0;

    return Offset(
      position.dx.clamp(margin, screenSize.width - widgetSize.width - margin),
      position.dy.clamp(margin, screenSize.height - widgetSize.height - margin),
    );
  }

  Size _estimateWidgetSize() {
    // Estimate based on widget type or use fixed size
    switch (widget.widgetId) {
      case 'counter':
        return const Size(120, 120);
      case 'toggle':
        return const Size(120, 100);
      case 'slider':
        return const Size(180, 100);
      case 'color_picker':
        return const Size(150, 150);
      case 'text_editor':
        return const Size(180, 120);
      default:
        return const Size(150, 120);
    }
  }

  void _onDragEnd(BuildContext context) {
    if (_isDragging) {
      _isDragging = false;
      context.read<UIBloc>().add(WidgetDragEnded(widget.widgetId));
    }
  }

  Widget _buildWidgetContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50), // Faster animation for responsiveness
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDragging ? 0.4 : 0.15),
            blurRadius: widget.isDragging ? 25 : 10,
            offset: Offset(0, widget.isDragging ? 8 : 3),
            spreadRadius: widget.isDragging ? 3 : 0,
          ),
          if (widget.isDragging)
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
        border: Border.all(
          color: widget.isDragging ? Colors.blue.shade500 : Colors.grey.shade400,
          width: widget.isDragging ? 3.0 : 1.5,
        ),
      ),
      transform: Matrix4.identity()
        ..scale(widget.isDragging ? 1.08 : 1.0)
        ..rotateZ(widget.isDragging ? 0.02 : 0.0),
      transformAlignment: Alignment.center,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: IgnorePointer(
            ignoring: widget.isDragging,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
