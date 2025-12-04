import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class NavbarDraggableIndicator extends StatelessWidget {
  final double position;
  final double size;
  final List<double> snapPositions;
  final Function(double) onDragUpdate;
  final Function(int) onDragEnd;
  final int index;

  /// Optional vertical offset
  final double bottomOffset;

  const NavbarDraggableIndicator({
    super.key,
    required this.position,
    required this.size,
    required this.snapPositions,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.index,
    this.bottomOffset = 35,
  });

  @override
  Widget build(BuildContext context) {
    double adjustedPosition = position;
    // Optional fine-tuned offsets per index
    if (index == 0) adjustedPosition += 16;
    if (index == 1) adjustedPosition -= 3;
    if (index == 2) adjustedPosition -= 16;

    return Positioned(
      left: adjustedPosition,
      bottom: bottomOffset,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          double newPosition = position + details.delta.dx;
          newPosition = newPosition.clamp(
            snapPositions.first,
            snapPositions.last,
          );
          onDragUpdate(newPosition);
        },
        onHorizontalDragEnd: (_) {
          double closest = snapPositions[0];
          double minDist = (position - snapPositions[0]).abs();
          for (double p in snapPositions) {
            double d = (position - p).abs();
            if (d < minDist) {
              minDist = d;
              closest = p;
            }
          }
          onDragEnd(snapPositions.indexOf(closest));
        },
        child: LiquidGlassLayer(
          settings: const LiquidGlassSettings(
            lightIntensity: 1.5,
            thickness: 20,
            blur: 1,
          ),
          child: LiquidStretch(
            stretch: 0.7,
            interactionScale: 1.05,
            child: LiquidGlass(
              glassContainsChild: true,
              shape: LiquidRoundedSuperellipse(borderRadius: 30),
              child: GlassGlow(
                child: Container(
                  width: size * 1.2,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
