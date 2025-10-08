import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';

class EnhancedDraggableWidget extends StatefulWidget {
  final String widgetId;
  final Widget child;
  final Offset position;
  final bool isDragging;

  const EnhancedDraggableWidget({
    super.key,
    required this.widgetId,
    required this.child,
    required this.position,
    required this.isDragging,
  });

  @override
  State<EnhancedDraggableWidget> createState() => _EnhancedDraggableWidgetState();
}

class _EnhancedDraggableWidgetState extends State<EnhancedDraggableWidget> {
  final GlobalKey _widgetKey = GlobalKey();
  Offset? _grabPointOffset;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: CompositionalGestureDetector(
        onDragStart: (details) => _onDragStart(details, context),
        onDragUpdate: (details) => _onDragUpdate(details, context),
        onDragEnd: (details) => _onDragEnd(context),
        child: MouseRegion(
          cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
          child: _buildWidgetContent(),
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details, BuildContext context) {
    _isDragging = true;
    
    // Calculate the exact point where the widget was grabbed relative to its top-left corner
    final renderBox = _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final localTouchPosition = renderBox.globalToLocal(details.globalPosition);
      _grabPointOffset = localTouchPosition;
    } else {
      // Fallback: use the center of the widget
      _grabPointOffset = const Offset(75, 60); // Approximate center
    }
    
    context.read<UIBloc>().add(WidgetDragStarted(widget.widgetId));
  }

  void _onDragUpdate(DragUpdateDetails details, BuildContext context) {
    if (!_isDragging || _grabPointOffset == null) return;

    // Calculate the new position so the grab point stays exactly under the cursor
    final newPosition = details.globalPosition - _grabPointOffset!;
    
    // Constrain to screen bounds
    final constrainedPosition = _constrainToScreenBounds(newPosition, context);
    
    // Update immediately
    context.read<UIBloc>().add(WidgetMoved(widget.widgetId, constrainedPosition));
  }

  void _onDragEnd(BuildContext context) {
    if (_isDragging) {
      _isDragging = false;
      _grabPointOffset = null;
      context.read<UIBloc>().add(WidgetDragEnded(widget.widgetId));
    }
  }

  Offset _constrainToScreenBounds(Offset position, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widgetSize = _estimateWidgetSize();
    const margin = 8.0;

    double x = position.dx;
    double y = position.dy;

    // Ensure the widget stays within screen bounds
    x = x.clamp(margin, screenSize.width - widgetSize.width - margin);
    y = y.clamp(margin, screenSize.height - widgetSize.height - margin);

    return Offset(x, y);
  }

  Size _estimateWidgetSize() {
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

  Widget _buildWidgetContent() {
    return Container(
      key: _widgetKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDragging ? 0.5 : 0.15),
              blurRadius: widget.isDragging ? 30 : 10,
              offset: Offset(0, widget.isDragging ? 10 : 3),
              spreadRadius: widget.isDragging ? 5 : 0,
            ),
            if (widget.isDragging)
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
        ],
        border: Border.all(
          color: widget.isDragging ? Colors.blue.shade600 : Colors.grey.shade400,
          width: widget.isDragging ? 3.5 : 1.5,
        ),
      ),
      transform: Matrix4.identity()
        ..scale(widget.isDragging ? 1.08 : 1.0),
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
    ),
    );
  }
}

// Helper class to handle both mouse and touch events properly
class CompositionalGestureDetector extends StatelessWidget {
  final Widget child;
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const CompositionalGestureDetector({
    super.key,
    required this.child,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // Convert PointerDownEvent to DragStartDetails
        onDragStart(DragStartDetails(
          globalPosition: event.position,
          localPosition: event.localPosition,
        ));
      },
      onPointerMove: (event) {
        onDragUpdate(DragUpdateDetails(
          globalPosition: event.position,
          delta: event.delta,
        ));
      },
      onPointerUp: (event) {
        onDragEnd(DragEndDetails(velocity: Velocity.zero));
      },
      onPointerCancel: (event) {
        onDragEnd(DragEndDetails(velocity: Velocity.zero));
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: onDragStart,
        onPanUpdate: onDragUpdate,
        onPanEnd: onDragEnd,
        child: child,
      ),
    );
  }
}