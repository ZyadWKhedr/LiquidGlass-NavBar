import 'package:flutter_riverpod/legacy.dart';

/// Provider for the current selected navbar index
final currentIndexProvider = StateProvider<int>((ref) => 0);

/// Provider for the draggable indicator's X position
final draggablePositionProvider = StateProvider<double>((ref) => 0.0);

/// Provider for the drag offset used in page transitions
final dragOffsetProvider = StateProvider<double>((ref) => 0.0);

/// Navbar state class to hold all navbar-related state
class NavbarState {
  final int currentIndex;
  final double draggablePosition;
  final double dragOffset;

  NavbarState({
    required this.currentIndex,
    required this.draggablePosition,
    required this.dragOffset,
  });

  NavbarState copyWith({
    int? currentIndex,
    double? draggablePosition,
    double? dragOffset,
  }) {
    return NavbarState(
      currentIndex: currentIndex ?? this.currentIndex,
      draggablePosition: draggablePosition ?? this.draggablePosition,
      dragOffset: dragOffset ?? this.dragOffset,
    );
  }
}

/// StateNotifier for managing navbar state
class NavbarStateNotifier extends StateNotifier<NavbarState> {
  NavbarStateNotifier()
    : super(
        NavbarState(currentIndex: 0, draggablePosition: 0.0, dragOffset: 0.0),
      );

  /// Update the current index
  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  /// Update the draggable position
  void setDraggablePosition(double position) {
    state = state.copyWith(draggablePosition: position);
  }

  /// Update the drag offset
  void setDragOffset(double offset) {
    state = state.copyWith(dragOffset: offset);
  }

  /// Reset drag offset to zero
  void resetDragOffset() {
    state = state.copyWith(dragOffset: 0.0);
  }
}

/// Provider for the navbar state notifier
final navbarStateProvider =
    StateNotifierProvider<NavbarStateNotifier, NavbarState>((ref) {
      return NavbarStateNotifier();
    });
