import 'package:customizable_ui/features/customizable_ui/bloc/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../bloc/ui_event.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        final value = state.sliderValues['slider'] ?? 0.5;
        
        return SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Slider',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Slider(
                value: value,
                onChanged: (newValue) {
                  context.read<UIBloc>().add(SliderChanged('slider', newValue));
                },
              ),
              const SizedBox(height: 4),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}