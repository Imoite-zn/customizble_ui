import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui_event.dart';
import 'ui_state.dart';

class UIBloc extends Bloc<UIEvent, UIState> {
  UIBloc() : super(UIState.initial()) {
    on<UIInitialized>(_onInitialized);
    on<WidgetMoved>(_onWidgetMoved);
    on<CounterIncremented>(_onCounterIncremented);
    on<CounterDecremented>(_onCounterDecremented);
    on<ToggleChanged>(_onToggleChanged);
    on<SliderChanged>(_onSliderChanged);
    on<ColorChanged>(_onColorChanged);
    on<TextChanged>(_onTextChanged);
    on<ResetPositions>(_onResetPositions);
    on<WidgetDragStarted>(_onWidgetDragStarted);
    on<WidgetDragEnded>(_onWidgetDragEnded);
    on<DragFeatureToggled>(_onDragFeatureToggled);
  }

  void _onInitialized(UIInitialized event, Emitter<UIState> emit) {
    // Initial state is already set
  }

  // void _onWidgetMoved(WidgetMoved event, Emitter<UIState> emit) {
  //   final newPositions = state.widgetPositions.map((position) {
  //     if (position.id == event.widgetId) {
  //       return position.copyWith(position: event.newPosition);
  //     }
  //     return position;
  //   }).toList();

  //   emit(state.copyWith(widgetPositions: newPositions));
  // }
  void _onWidgetMoved(WidgetMoved event, Emitter<UIState> emit) {
    final newPositions = state.widgetPositions.map((position) {
      if (position.id == event.widgetId) {
        return position.copyWith(position: event.newPosition);
      }
      return position;
    }).toList();

    emit(state.copyWith(widgetPositions: newPositions));
  }

  void _onCounterIncremented(CounterIncremented event, Emitter<UIState> emit) {
    final currentValue = state.counterValues[event.widgetId] ?? 0;
    emit(
      state.copyWith(
        counterValues: {...state.counterValues}
          ..[event.widgetId] = currentValue + 1,
      ),
    );
  }

  void _onCounterDecremented(CounterDecremented event, Emitter<UIState> emit) {
    final currentValue = state.counterValues[event.widgetId] ?? 0;
    emit(
      state.copyWith(
        counterValues: {...state.counterValues}
          ..[event.widgetId] = currentValue - 1,
      ),
    );
  }

  void _onToggleChanged(ToggleChanged event, Emitter<UIState> emit) {
    final currentValue = state.toggleValues[event.widgetId] ?? false;
    emit(
      state.copyWith(
        toggleValues: {...state.toggleValues}..[event.widgetId] = !currentValue,
      ),
    );
  }

  void _onSliderChanged(SliderChanged event, Emitter<UIState> emit) {
    emit(
      state.copyWith(
        sliderValues: {...state.sliderValues}..[event.widgetId] = event.value,
      ),
    );
  }

  void _onColorChanged(ColorChanged event, Emitter<UIState> emit) {
    emit(
      state.copyWith(
        colorValues: {...state.colorValues}..[event.widgetId] = event.color,
      ),
    );
  }

  void _onTextChanged(TextChanged event, Emitter<UIState> emit) {
    emit(
      state.copyWith(
        textValues: {...state.textValues}..[event.widgetId] = event.text,
      ),
    );
  }

  void _onResetPositions(ResetPositions event, Emitter<UIState> emit) {
    emit(UIState.initial());
  }

  void _onWidgetDragStarted(WidgetDragStarted event, Emitter<UIState> emit) {
    final newPositions = state.widgetPositions.map((position) {
      if (position.id == event.widgetId) {
        return position.copyWith(isDragging: true);
      }
      return position;
    }).toList();

    emit(state.copyWith(widgetPositions: newPositions));
  }

  void _onWidgetDragEnded(WidgetDragEnded event, Emitter<UIState> emit) {
    final newPositions = state.widgetPositions.map((position) {
      if (position.id == event.widgetId) {
        return position.copyWith(isDragging: false);
      }
      return position;
    }).toList();

    emit(state.copyWith(widgetPositions: newPositions));
  }

  // Add this handler to the UIBloc
  void _onDragFeatureToggled(DragFeatureToggled event, Emitter<UIState> emit) {
    emit(state.copyWith(isDragEnabled: event.isDragEnabled));
  }
}
