import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'navbar_item_widget.dart';
import 'navbar_draggable_indicator.dart';
import 'navbar_background.dart';

class NavbarWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<IconData> icons;
  final List<String> labels;

  const NavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.labels,
  });

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  double _draggableX = 0; // draggable position
  final double _draggableSize = 50 * 1.5;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      useBackdropGroup: true,
      settings: const LiquidGlassSettings(thickness: 20, blur: 1),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final rowWidth = constraints.maxWidth;
            final itemCount = widget.icons.length;

            // Compute center positions dynamically
            // Account for the navbar's horizontal margin (20px on each side)
            final navbarMargin = 20.0;
            final availableWidth = rowWidth - (navbarMargin * 2);
            final itemWidth = availableWidth / itemCount;

            final positions = List.generate(
              itemCount,
              (i) =>
                  navbarMargin +
                  (i * itemWidth) +
                  (itemWidth / 2) -
                  (_draggableSize * 1.2 / 2),
            );

            // Make sure _draggableX is initialized at the selected index
            if (_draggableX == 0 && positions.isNotEmpty) {
              _draggableX = positions[widget.currentIndex];
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
                      final isSelected = widget.currentIndex == index;
                      return NavbarItemWidget(
                        icon: widget.icons[index],
                        label: widget.labels[index],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _draggableX = positions[index];
                          });
                          widget.onTap(index);
                        },
                      );
                    }),
                  ),
                ),

                // Draggable indicator
                NavbarDraggableIndicator(
                  position: _draggableX,
                  size: _draggableSize,
                  snapPositions: positions,
                  onDragUpdate: (newPosition) {
                    setState(() {
                      _draggableX = newPosition;
                    });
                  },
                  onDragEnd: (newIndex) {
                    setState(() {
                      _draggableX = positions[newIndex];
                    });
                    widget.onTap(newIndex);
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
