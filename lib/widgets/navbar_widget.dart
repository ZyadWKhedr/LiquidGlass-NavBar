import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navbar_item_widget.dart';
import 'navbar_draggable_indicator.dart';
import 'navbar_background.dart';
import '../providers/navbar_providers.dart';

class NavbarWidget extends ConsumerWidget {
  final List<IconData> icons;
  final List<String> labels;

  final double indicatorSize;
  final double navbarHeight;
  final double bottomPadding;
  final double horizontalPadding;
  final double dragMultiplier;
  final double snapThreshold;

  const NavbarWidget({
    super.key,
    required this.icons,
    required this.labels,
    this.indicatorSize = 75,
    this.navbarHeight = 70,
    this.bottomPadding = 30,
    this.horizontalPadding = 20,
    this.dragMultiplier = 0.3,
    this.snapThreshold = 80,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final notifier = ref.read(navbarStateProvider.notifier);

    // Initialize positions once
    if (navbarState.positions.isEmpty && icons.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final containerWidth = MediaQuery.of(context).size.width;
        notifier.initPositions(
          itemCount: icons.length,
          containerWidth: containerWidth,
          horizontalPadding: horizontalPadding,
          indicatorSize: indicatorSize,
        );
      });
    }

    final currentIndex = navbarState.currentIndex;
    final dragOffset = navbarState.draggablePosition;
    final positions = navbarState.positions;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ).copyWith(bottom: bottomPadding),
          child: NavbarBackground(
            width: MediaQuery.of(context).size.width,
            height: navbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(icons.length, (index) {
                final isSelected = currentIndex == index;
                return NavbarItemWidget(
                  icon: icons[index],
                  label: labels[index],
                  isSelected: isSelected,
                  onTap: () => notifier.setCurrentIndex(index),
                );
              }),
            ),
          ),
        ),

        // Draggable indicator
        if (positions.isNotEmpty)
          NavbarDraggableIndicator(
            index: currentIndex,
            position: dragOffset,
            size: indicatorSize,
            snapPositions: positions,
            onDragUpdate: notifier.setDraggablePosition,
            onDragEnd: notifier.setCurrentIndex,
          ),
      ],
    );
  }
}
