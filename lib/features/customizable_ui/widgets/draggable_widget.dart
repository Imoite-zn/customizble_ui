import 'package:customizable_ui/features/customizable_ui/bloc/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';

class DraggableWidget extends StatefulWidget {
  final String widgetId;
  final Widget child;
  final Offset position;
  final bool isDragging;

  const DraggableWidget({
    super.key,
    required this.widgetId,
    required this.child,
    required this.position,
    required this.isDragging,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Offset? _grabPointOffset;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: state.isDragEnabled
              ? _buildDraggableVersion(context)
              : _buildStaticVersion(),
        );
      },
    );
  }

  Widget _buildDraggableVersion(BuildContext context) {
    return Listener(
      onPointerDown: (details) => _onDragStart(details, context),
      onPointerMove: (details) => _onDragUpdate(details, context),
      onPointerUp: (details) => _onDragEnd(context),
      onPointerCancel: (details) => _onDragEnd(context),
      child: MouseRegion(
        cursor: _isDragging
            ? SystemMouseCursors.grabbing
            : SystemMouseCursors.grab,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: _buildWidgetContent(),
        ),
      ),
    );
  }

  Widget _buildStaticVersion() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: _buildWidgetContent(),
    );
  }

  void _onDragStart(PointerDownEvent details, BuildContext context) {
    final state = context.read<UIBloc>().state;
    if (!state.isDragEnabled) return;

    _isDragging = true;
    _grabPointOffset = details.localPosition;
    context.read<UIBloc>().add(WidgetDragStarted(widget.widgetId));
  }

  void _onDragUpdate(PointerMoveEvent details, BuildContext context) {
    final state = context.read<UIBloc>().state;
    if (!state.isDragEnabled || !_isDragging || _grabPointOffset == null)
      return;

    final newPosition = details.position - _grabPointOffset!;
    final constrainedPosition = _constrainToScreenBounds(newPosition, context);

    context.read<UIBloc>().add(
      WidgetMoved(widget.widgetId, constrainedPosition),
    );
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

    return Offset(
      position.dx.clamp(margin, screenSize.width - widgetSize.width - margin),
      position.dy.clamp(margin, screenSize.height - widgetSize.height - margin),
    );
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

  // Widget _buildWidgetContent() {
  //   return BlocBuilder<UIBloc, UIState>(
  //     builder: (context, state) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 100),
  //         curve: Curves.easeOut,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(widget.isDragging ? 0.4 : 0.15),
  //               blurRadius: widget.isDragging ? 25 : 10,
  //               offset: Offset(0, widget.isDragging ? 8 : 3),
  //               spreadRadius: widget.isDragging ? 3 : 0,
  //             ),
  //             if (widget.isDragging)
  //               BoxShadow(
  //                 color: Colors.blue.withOpacity(0.3),
  //                 blurRadius: 20,
  //                 spreadRadius: 3,
  //               ),
  //           ],
  //           border: Border.all(
  //             color: widget.isDragging
  //                 ? Colors.blue.shade500
  //                 : (state.isDragEnabled ? Colors.grey.shade400 : Colors.grey.shade300),
  //             width: widget.isDragging ? 3.0 : 1.5,
  //           ),
  //         ),
  //         transform: Matrix4.identity()
  //           ..scale(widget.isDragging ? 1.05 : 1.0),
  //         transformAlignment: Alignment.center,
  //         child: Material(
  //           type: MaterialType.transparency,
  //           borderRadius: BorderRadius.circular(12),
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             child: IgnorePointer(
  //               ignoring: widget.isDragging,
  //               child: widget.child,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildWidgetContent() {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        final isDragEnabled = state.isDragEnabled;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isDragEnabled) ...[
                BoxShadow(
                  color: Colors.black.withValues(alpha:
                    widget.isDragging ? 0.4 : 0.15,
                  ),
                  blurRadius: widget.isDragging ? 25 : 10,
                  offset: Offset(0, widget.isDragging ? 8 : 3),
                  spreadRadius: widget.isDragging ? 3 : 0,
                ),
                if (widget.isDragging)
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
              ] else ...[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ],
            border: Border.all(
              color: widget.isDragging
                  ? Colors.blue.shade500
                  : (isDragEnabled
                        ? Colors.grey.shade400
                        : Colors.grey.shade300),
              width: widget.isDragging ? 3.0 : (isDragEnabled ? 1.5 : 1.0),
            ),
          ),
          transform: Matrix4.identity()
            ..scale(widget.isDragging ? 1.05 : (isDragEnabled ? 1.0 : 0.98)),
          transformAlignment: Alignment.center,
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: IgnorePointer(
                ignoring: widget.isDragging,
                child: Opacity(
                  opacity: isDragEnabled ? 1.0 : 0.8,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
