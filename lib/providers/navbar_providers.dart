import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class NavbarState {
  final int currentIndex;
  final double draggablePosition;
  final double dragOffset;
  final List<double> positions; // Pre-calculated positions

  NavbarState({
    required this.currentIndex,
    required this.draggablePosition,
    required this.dragOffset,
    required this.positions,
  });

  NavbarState copyWith({
    int? currentIndex,
    double? draggablePosition,
    double? dragOffset,
    List<double>? positions,
  }) {
    return NavbarState(
      currentIndex: currentIndex ?? this.currentIndex,
      draggablePosition: draggablePosition ?? this.draggablePosition,
      dragOffset: dragOffset ?? this.dragOffset,
      positions: positions ?? this.positions,
    );
  }
}

class NavbarStateNotifier extends StateNotifier<NavbarState> {
  NavbarStateNotifier()
    : super(
        NavbarState(
          currentIndex: 0,
          draggablePosition: 0,
          dragOffset: 0,
          positions: [],
        ),
      ) {
    pageController = PageController(initialPage: 0);
  }

  late final PageController pageController;

  /// Initialize positions based on container width and number of items
  void initPositions({
    required int itemCount,
    required double containerWidth,
    double horizontalPadding = 20,
    double indicatorSize = 75,
  }) {
    final availableWidth = containerWidth - horizontalPadding * 2;
    final itemWidth = availableWidth / itemCount;

    final positions = List.generate(
      itemCount,
      (i) =>
          horizontalPadding +
          (i * itemWidth) +
          (itemWidth / 2) -
          (indicatorSize * 1.2 / 2),
    );

    state = state.copyWith(
      positions: positions,
      draggablePosition: positions[state.currentIndex],
    );
  }

  /// Change page and update index
  void setCurrentIndex(int index) {
    if (state.positions.isEmpty) return;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    state = state.copyWith(
      currentIndex: index,
      draggablePosition: state.positions[index],
    );
  }

  /// Update draggable position
  void setDraggablePosition(double position) {
    state = state.copyWith(draggablePosition: position);
  }

  /// Update drag offset
  void setDragOffset(double offset) {
    state = state.copyWith(dragOffset: offset);
  }

  /// Reset drag offset
  void resetDragOffset() {
    state = state.copyWith(dragOffset: 0.0);
  }
}

/// Provider
final navbarStateProvider =
    StateNotifierProvider<NavbarStateNotifier, NavbarState>((ref) {
      return NavbarStateNotifier();
    });
