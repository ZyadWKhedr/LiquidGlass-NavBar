import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'navbar_item_widget.dart';
import 'navbar_draggable_indicator.dart';
import 'navbar_background.dart';
import '../providers/navbar_providers.dart';

class NavbarWidget extends ConsumerWidget {
  final List<IconData> icons;
  final List<String> labels;

  const NavbarWidget({super.key, required this.icons, required this.labels});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final currentIndex = navbarState.currentIndex;
    final dragOffset = navbarState.draggablePosition;

    return LiquidGlassLayer(
      useBackdropGroup: true,
      settings: const LiquidGlassSettings(thickness: 20, blur: 1),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final rowWidth = constraints.maxWidth;
            final itemCount = icons.length;
            final navbarMargin = 20.0;
            final availableWidth = rowWidth - (navbarMargin * 2);
            final itemWidth = availableWidth / itemCount;

            final positions = List.generate(
              itemCount,
              (i) =>
                  navbarMargin +
                  (i * itemWidth) +
                  (itemWidth / 2) -
                  (50 * 1.5 * 1.2 / 2),
            );

            // Initialize draggable position if not set
            if (dragOffset == 0 && positions.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref
                    .read(navbarStateProvider.notifier)
                    .setDraggablePosition(positions[currentIndex]);
              });
            }

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Navbar background with items
                NavbarBackground(
                  width: rowWidth,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(itemCount, (index) {
                      final isSelected = currentIndex == index;
                      return NavbarItemWidget(
                        icon: icons[index],
                        label: labels[index],
                        isSelected: isSelected,
                        onTap: () {
                          // Update provider state
                          ref
                              .read(navbarStateProvider.notifier)
                              .setCurrentIndex(index);
                          ref
                              .read(navbarStateProvider.notifier)
                              .setDraggablePosition(positions[index]);
                        },
                      );
                    }),
                  ),
                ),

                // Draggable indicator
                NavbarDraggableIndicator(
                  position: dragOffset,
                  size: 50 * 1.5,
                  snapPositions: positions,
                  onDragUpdate: (newPosition) {
                    ref
                        .read(navbarStateProvider.notifier)
                        .setDraggablePosition(newPosition);
                  },
                  onDragEnd: (newIndex) {
                    ref
                        .read(navbarStateProvider.notifier)
                        .setCurrentIndex(newIndex);
                    ref
                        .read(navbarStateProvider.notifier)
                        .setDraggablePosition(positions[newIndex]);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
