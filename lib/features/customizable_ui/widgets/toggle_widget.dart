import 'package:customizable_ui/features/customizable_ui/bloc/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        final isToggled = state.toggleValues['toggle'] ?? false;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Toggle Switch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Switch(
              value: isToggled,
              onChanged: (value) {
                context.read<UIBloc>().add(const ToggleChanged('toggle'));
              },
            ),
            const SizedBox(height: 4),
            Text(
              isToggled ? 'ON' : 'OFF',
              style: TextStyle(
                color: isToggled ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}