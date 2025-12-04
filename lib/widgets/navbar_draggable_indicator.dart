import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class NavbarDraggableIndicator extends StatelessWidget {
  final double position; // Center X of indicator
  final double baseSize; // Base size for 3 items
  final int itemCount; // Total number of navbar items
  final List<double> snapPositions; // Centers of items
  final Function(double) onDragUpdate;
  final Function(int) onDragEnd;
  final double bottomOffset;

  const NavbarDraggableIndicator({
    super.key,
    required this.position,
    required this.baseSize,
    required this.itemCount,
    required this.snapPositions,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.bottomOffset = 20,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = 1.sw;

    // Adaptive width based on item count, never smaller than 60.w
    final adaptiveWidth = (baseSize * (3.5 / itemCount).clamp(1, 1.2)).w;

    // Clamp the center so indicator never goes off-screen
    final clampedCenter = position.clamp(
      adaptiveWidth / 2,
      screenWidth - adaptiveWidth / 2,
    );

    return Positioned(
      left: clampedCenter - adaptiveWidth / 2, // exact center
      bottom: bottomOffset.h + 5.h,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          final newPos = (position + details.delta.dx).clamp(
            adaptiveWidth / 2,
            screenWidth - adaptiveWidth / 2,
          );
          onDragUpdate(newPos);
        },
        onHorizontalDragEnd: (_) {
          // Snap to nearest measured icon center
          double closest = snapPositions[0];
          double minDist = (position - closest).abs();

          for (double p in snapPositions) {
            final dist = (position - p).abs();
            if (dist < minDist) {
              minDist = dist;
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
                  width: adaptiveWidth,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((adaptiveWidth / 2).r),
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
