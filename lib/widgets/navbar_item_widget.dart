import 'package:flutter/material.dart';

/// A single navbar item widget with icon and label.
///
/// This widget represents an individual item in the navbar,
/// displaying an icon and label with different styles based on selection state.
class NavbarItemWidget extends StatelessWidget {
  /// The icon to display for this navbar item
  final IconData icon;

  /// The label text to display below the icon
  final String label;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  const NavbarItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.grey,
              size: isSelected ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.grey,
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
