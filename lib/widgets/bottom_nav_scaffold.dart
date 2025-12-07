import 'package:flutter/material.dart';
import '../providers/navbar_providers.dart';
import 'navbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavScaffold extends ConsumerStatefulWidget {
  final List<Widget> pages;
  final List<Widget> icons;
  final List<String> labels;

  // Optional styling
  final double navbarHeight;
  final double indicatorWidth;
  final double bottomPadding;
  final Color selectedColor;
  final Color unselectedColor;
  final double horizontalPadding;

  const BottomNavScaffold({
    super.key,
    required this.pages,
    required this.icons,
    required this.labels,
    this.navbarHeight = 70,
    this.indicatorWidth = 70,
    this.bottomPadding = 20,
    this.selectedColor = Colors.amber,
    this.unselectedColor = Colors.grey,
    this.horizontalPadding = 10,
  });

  @override
  ConsumerState<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends ConsumerState<BottomNavScaffold> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(navbarStateProvider.notifier);
    final state = ref.watch(navbarStateProvider);

    final currentIndex = state.currentIndex;
    final dragOffset = state.dragOffset;

    return Scaffold(
      body: Stack(
        children: [
          // PageView with parallax
          Transform.translate(
            offset: Offset(dragOffset * 0.25, 0),
            child: PageView(
              controller: notifier.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.pages,
            ),
          ),

          // Floating navbar with draggable
          Positioned(
            bottom: widget.bottomPadding,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,

                onHorizontalDragUpdate: (details) {
                  notifier.setDragOffset(dragOffset + details.delta.dx * 0.3);
                },

                onHorizontalDragEnd: (_) {
                  const threshold = 80;

                  if (dragOffset.abs() > threshold) {
                    final jump = -(dragOffset / threshold).round();
                    final newIndex = (currentIndex + jump).clamp(
                      0,
                      widget.pages.length - 1,
                    );
                    if (newIndex != currentIndex) {
                      notifier.setCurrentIndex(newIndex);
                    }
                  }

                  notifier.resetDragOffset();
                },

                child: NavbarWidget(
                  icons: widget.icons,
                  labels: widget.labels,
                  selectedColor: widget.selectedColor,
                  unselectedColor: widget.unselectedColor,
                  indicatorWidth: widget.indicatorWidth,
                  navbarHeight: widget.navbarHeight,
                  bottomPadding: widget.bottomPadding,
                  horizontalPadding: widget.horizontalPadding,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
