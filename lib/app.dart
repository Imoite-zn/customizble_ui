import 'package:customizable_ui/features/customizable_ui/bloc/ui_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/customizable_ui/bloc/ui_bloc.dart';
import 'features/customizable_ui/customizable_ui_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UIBloc()..add(UIInitialized()),
      child: const CustomizableUIPage(),
    );
  }
}
