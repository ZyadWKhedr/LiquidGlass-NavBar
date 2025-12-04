import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// A glassmorphic background container for the navbar.
///
/// This widget provides the visual background for the navbar
/// using liquid glass effects.
class NavbarBackground extends StatelessWidget {
  /// The width of the navbar background
  final double width;

  /// The height of the navbar background
  final double height;

  /// The child widget to display inside the background
  final Widget child;

  const NavbarBackground({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      settings: const LiquidGlassSettings(thickness: 20, blur: 2),
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: 30),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w), // adaptive margin
          width: width.w, // adaptive width
          height: height.h, // adaptive height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.r), // adaptive radius
          ),
          child: child,
        ),
      ),
    );
  }
}
