# customizable_ui

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




# Structure
├── main.dart
├── app.dart
├── features/
│   └── customizable_ui/
│       ├── bloc/
│       │   ├── ui_bloc.dart
│       │   ├── ui_event.dart
│       │   └── ui_state.dart
│       ├── models/
│       │   └── widget_position.dart
│       ├── widgets/
│       │   ├── draggable_widget.dart
│       │   ├── counter_widget.dart
│       │   ├── toggle_widget.dart
│       │   ├── slider_widget.dart
│       │   ├── color_picker_widget.dart
│       │   └── text_editor_widget.dart
│       └── customizable_ui_page.dart



# dependencies

equatable --> to override hashCodes and ==
bloc --> state management