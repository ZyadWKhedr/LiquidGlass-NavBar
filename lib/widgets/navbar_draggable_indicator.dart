import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// A draggable indicator widget for the navbar.
///
/// This widget displays a glassmorphic indicator that can be dragged
/// horizontally and snaps to predefined positions.
class NavbarDraggableIndicator extends StatelessWidget {
  /// The current X position of the draggable indicator
  final double position;

  /// The size of the draggable indicator
  final double size;

  /// List of valid positions where the indicator can snap to
  final List<double> snapPositions;

  /// Callback when the indicator is dragged
  final Function(double) onDragUpdate;

  /// Callback when the drag ends
  final Function(int) onDragEnd;

  const NavbarDraggableIndicator({
    super.key,
    required this.position,
    required this.size,
    required this.snapPositions,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          double newPosition = position + details.delta.dx;
          // Clamp position to valid range
          newPosition = newPosition.clamp(
            snapPositions.first,
            snapPositions.last,
          );
          onDragUpdate(newPosition);
        },
        onHorizontalDragEnd: (_) {
          // Find nearest snap position
          double closest = snapPositions[0];
          double minDist = (position - snapPositions[0]).abs();

          for (double p in snapPositions) {
            double d = (position - p).abs();
            if (d < minDist) {
              minDist = d;
              closest = p;
            }
          }

          final newIndex = snapPositions.indexOf(closest);
          onDragEnd(newIndex);
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
                  width: size * 1.1,
                  height: 55,
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
