import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider for the NavbarStateNotifier
final navbarStateProvider =
    StateNotifierProvider<NavbarStateNotifier, NavbarState>((ref) {
      return NavbarStateNotifier();
    });

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

/// StateNotifier for managing Navbar state and PageController
class NavbarStateNotifier extends StateNotifier<NavbarState> {
  NavbarStateNotifier()
    : super(
        NavbarState(currentIndex: 0, draggablePosition: 0.0, dragOffset: 0.0),
      ) {
    pageController = PageController(initialPage: 0);
  }

  late final PageController pageController;

  /// Dispose the page controller when notifier is disposed
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Change page and update index with animation
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

  /// Update drag offset with friction (iOS-style)
  void setDragOffset(double offset, {double friction = 0.32}) {
    state = state.copyWith(dragOffset: offset * friction);
  }

  /// Reset drag offset to zero
  void resetDragOffset() {
    state = state.copyWith(dragOffset: 0.0);
  }

  /// Handle drag release with momentum and snapping
  void handleDragEnd({required double dragOffset, required int pageCount}) {
    const snapThreshold = 85; // min drag to trigger page change
    final currentIndex = state.currentIndex;

    // Move to next page
    if (dragOffset < -snapThreshold) {
      if (currentIndex < pageCount - 1) {
        setCurrentIndex(currentIndex + 1);
      }
    }
    // Move to previous page
    else if (dragOffset > snapThreshold) {
      if (currentIndex > 0) {
        setCurrentIndex(currentIndex - 1);
      }
    }

    resetDragOffset();
  }
}
