import 'package:customizable_ui/features/customizable_ui/bloc/ui_state.dart';
import 'package:customizable_ui/features/customizable_ui/models/widget_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/ui_bloc.dart';
import 'bloc/ui_event.dart';
import 'widgets/draggable_widget.dart';
import 'widgets/counter_widget.dart';
import 'widgets/toggle_widget.dart';
import 'widgets/slider_widget.dart';
import 'widgets/color_picker_widget.dart';
import 'widgets/text_editor_widget.dart';

class CustomizableUIPage extends StatelessWidget {
  const CustomizableUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customizable UI'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          _buildDragToggle(context),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UIBloc>().add(ResetPositions());
            },
            tooltip: 'Reset Positions',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
        ],
      ),
      body: BlocBuilder<UIBloc, UIState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.purple.shade50],
              ),
            ),
            child: Stack(
              children: [
                // Build all draggable widgets
                ...state.widgetPositions.map((widgetPosition) {
                  return _buildDraggableWidget(
                    context,
                    widgetPosition,
                    state,
                  );
                }).toList(),

                // Instructions and status
                _buildStatusOverlay(state, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragToggle(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Drag',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: state.isDragEnabled,
                onChanged: (enabled) {
                  context.read<UIBloc>().add(DragFeatureToggled(enabled));
                },
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.white70,
                inactiveThumbColor: Colors.grey.shade300,
                inactiveTrackColor: Colors.grey.shade500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableWidget(
    BuildContext context,
    WidgetPosition widgetPosition,
    UIState state,
  ) {
    switch (widgetPosition.id) {
      case 'counter':
        return DraggableWidget(
          widgetId: widgetPosition.id,
          position: widgetPosition.position,
          isDragging: widgetPosition.isDragging,
          child: const CounterWidget(),
        );
      case 'toggle':
        return DraggableWidget(
          widgetId: widgetPosition.id,
          position: widgetPosition.position,
          isDragging: widgetPosition.isDragging,
          child: const ToggleWidget(),
        );
      case 'slider':
        return DraggableWidget(
          widgetId: widgetPosition.id,
          position: widgetPosition.position,
          isDragging: widgetPosition.isDragging,
          child: const SliderWidget(),
        );
      case 'color_picker':
        return DraggableWidget(
          widgetId: widgetPosition.id,
          position: widgetPosition.position,
          isDragging: widgetPosition.isDragging,
          child: const ColorPickerWidget(),
        );
      case 'text_editor':
        return DraggableWidget(
          widgetId: widgetPosition.id,
          position: widgetPosition.position,
          isDragging: widgetPosition.isDragging,
          child: const TextEditorWidget(),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildStatusOverlay(UIState state, BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.isDragEnabled ? Icons.drag_handle : Icons.lock,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  state.isDragEnabled ? 'Drag Mode: ON' : 'Drag Mode: LOCKED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.isDragEnabled 
                ? 'Drag widgets to rearrange them'
                : 'UI is locked - toggle drag mode to rearrange',
            style: TextStyle(
              color: state.isDragEnabled ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: BlocBuilder<UIBloc, UIState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• Use the Drag toggle to enable/disable moving widgets'),
                const Text('• Drag any widget to move it around'),
                const Text('• Reset positions to start over'),
                const SizedBox(height: 16),
                Text(
                  'Current Mode: ${state.isDragEnabled ? "DRAG ENABLED" : "UI LOCKED"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: state.isDragEnabled ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}