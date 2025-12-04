import 'package:flutter/material.dart';

class NavbarItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Optional customization
  final double selectedIconSize;
  final double unselectedIconSize;
  final double selectedFontSize;
  final double unselectedFontSize;
  final Color selectedColor;
  final Color unselectedColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const NavbarItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedIconSize = 28,
    this.unselectedIconSize = 24,
    this.selectedFontSize = 12,
    this.unselectedFontSize = 10,
    this.selectedColor = Colors.amber,
    this.unselectedColor = Colors.grey,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: isSelected ? selectedIconSize : unselectedIconSize,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: isSelected ? selectedFontSize : unselectedFontSize,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
