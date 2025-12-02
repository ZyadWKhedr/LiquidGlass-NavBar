import 'package:flutter/material.dart';
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

class NavbarStateNotifier extends StateNotifier<NavbarState> {
  NavbarStateNotifier()
    : super(
        NavbarState(currentIndex: 0, draggablePosition: 0.0, dragOffset: 0.0),
      ) {
    pageController = PageController(initialPage: 0);
  }

  late final PageController pageController;

  /// Change page and update index
  void setCurrentIndex(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    state = state.copyWith(currentIndex: index);
  }

  /// Update draggable position
  void setDraggablePosition(double position) {
    state = state.copyWith(draggablePosition: position);
  }

  /// Update drag offset
  void setDragOffset(double offset) {
    state = state.copyWith(dragOffset: offset);
  }

  void resetDragOffset() {
    state = state.copyWith(dragOffset: 0.0);
  }
}

final navbarStateProvider =
    StateNotifierProvider<NavbarStateNotifier, NavbarState>((ref) {
      return NavbarStateNotifier();
    });
