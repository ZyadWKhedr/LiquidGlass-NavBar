import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navbar_item_widget.dart';
import 'navbar_draggable_indicator.dart';
import 'navbar_background.dart';
import '../providers/navbar_providers.dart';

class NavbarWidget extends ConsumerWidget {
  final List<Widget> icons;
  final List<String> labels;
  final double indicatorWidth;
  final double navbarHeight;
  final double bottomPadding;
  final double horizontalPadding;
  final Color selectedColor;
  final Color unselectedColor;

  const NavbarWidget({
    super.key,
    required this.icons,
    required this.labels,
    this.indicatorWidth = 70,
    this.navbarHeight = 70,
    this.bottomPadding = 20,
    this.horizontalPadding = 20,
    this.selectedColor = Colors.amber,
    this.unselectedColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final notifier = ref.read(navbarStateProvider.notifier);

    final screenWidth = 1.sw;
    final itemCount = icons.length;

    // Create keys to measure each icon
    final List<GlobalKey> iconKeys = List.generate(
      itemCount,
      (_) => GlobalKey(),
    );

    // After first frame, measure exact center of each icon
    if (navbarState.positions.isEmpty && icons.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Set measured positions in notifier
        notifier.initMeasuredPositions(iconKeys);
      });
    }

    final positions = navbarState.positions;
    final dragCenter = navbarState.draggablePosition;
    final currentIndex = navbarState.currentIndex;

    return SizedBox(
      width: screenWidth,
      height: navbarHeight.h + bottomPadding.h,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Background
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPadding.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: NavbarBackground(
                width: screenWidth,
                height: navbarHeight.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(itemCount, (i) {
                    return NavbarItemWidget(
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      key: iconKeys[i],
                      icon: icons[i],
                      label: labels[i],
                      isSelected: i == currentIndex,
                      onTap: () => notifier.setCurrentIndex(i),
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Draggable indicator
          if (positions.isNotEmpty)
            NavbarDraggableIndicator(
              position: dragCenter,
              baseSize: indicatorWidth,
              itemCount: itemCount,
              snapPositions: positions,
              onDragUpdate: notifier.setDraggablePosition,
              onDragEnd: notifier.setCurrentIndex,
              bottomOffset: bottomPadding.h,
            ),
        ],
      ),
    );
  }
}
