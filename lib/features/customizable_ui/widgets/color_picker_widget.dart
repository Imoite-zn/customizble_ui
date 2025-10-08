import 'package:customizable_ui/features/customizable_ui/bloc/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        final currentColor = state.colorValues['color_picker'] ?? Colors.blue;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Color Picker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: [
                _ColorCircle(
                  color: Colors.red,
                  currentColor: currentColor,
                  onTap: () => _changeColor(context, Colors.red),
                ),
                _ColorCircle(
                  color: Colors.blue,
                  currentColor: currentColor,
                  onTap: () => _changeColor(context, Colors.blue),
                ),
                _ColorCircle(
                  color: Colors.green,
                  currentColor: currentColor,
                  onTap: () => _changeColor(context, Colors.green),
                ),
                _ColorCircle(
                  color: Colors.orange,
                  currentColor: currentColor,
                  onTap: () => _changeColor(context, Colors.orange),
                ),
                _ColorCircle(
                  color: Colors.purple,
                  currentColor: currentColor,
                  onTap: () => _changeColor(context, Colors.purple),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _changeColor(BuildContext context, Color color) {
    context.read<UIBloc>().add(ColorChanged('color_picker', color));
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final Color currentColor;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.currentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: currentColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}