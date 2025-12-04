import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class NavbarState {
  final int currentIndex;
  final double draggablePosition;
  final double dragOffset;
  final List<double> positions; // Centers of icons

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

  /// Initialize positions evenly (existing method)
  void initPositions({required int itemCount, required double containerWidth}) {
    final itemWidth = containerWidth / itemCount;
    final positions = List.generate(
      itemCount,
      (i) => itemWidth * i + itemWidth / 2,
    );

    state = state.copyWith(
      positions: positions,
      draggablePosition: positions[state.currentIndex],
    );
  }

  /// Initialize positions using actual icon sizes (GlobalKey)
  void initMeasuredPositions(List<GlobalKey> iconKeys) {
    final positions = iconKeys.map((key) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        // center of the icon in global coordinates
        final center = box.localToGlobal(Offset.zero).dx + box.size.width / 2;
        return center;
      }
      return 0.0;
    }).toList();

    if (positions.isNotEmpty) {
      state = state.copyWith(
        positions: positions,
        draggablePosition: positions[state.currentIndex],
      );
    }
  }

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

  void setDragOffset(double offset) {
    state = state.copyWith(dragOffset: offset);
  }

  void setDraggablePosition(double position) {
    state = state.copyWith(draggablePosition: position);
  }

  void resetDragOffset() {
    state = state.copyWith(dragOffset: 0);
  }
}

final navbarStateProvider =
    StateNotifierProvider<NavbarStateNotifier, NavbarState>(
      (ref) => NavbarStateNotifier(),
    );
