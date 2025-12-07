import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavbarItemWidget extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  final double selectedIconSize;
  final double unselectedIconSize;
  final double selectedFontSize;
  final double unselectedFontSize;
  final Color selectedColor;
  final Color unselectedColor;

  /// Removed fixed margin to avoid overflow!
  final EdgeInsetsGeometry padding;

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
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: isSelected ? selectedColor : unselectedColor,
                size: (isSelected ? selectedIconSize : unselectedIconSize).sp,
              ),
              child: icon,
            ),
            SizedBox(height: 3.h),
            FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,

              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontSize: isSelected
                      ? selectedFontSize.sp
                      : unselectedFontSize.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
