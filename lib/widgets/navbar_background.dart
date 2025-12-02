import 'package:flutter/material.dart';
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
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: 30),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
        child: child,
      ),
    );
  }
}
