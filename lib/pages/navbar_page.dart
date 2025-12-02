import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_test/pages/home_page.dart';
import 'package:liquid_glass_test/pages/search_page.dart';
import 'package:liquid_glass_test/pages/profile_page.dart';
import 'package:liquid_glass_test/widgets/navbar_widget.dart';
import 'package:liquid_glass_test/providers/navbar_providers.dart';

class NavbarPage extends ConsumerWidget {
  NavbarPage({super.key});

  final List<Widget> _pages = [HomePage(), SearchPage(), ProfilePage()];
  final PageController _pageController = PageController(initialPage: 0);

  void _onNavTapped(WidgetRef ref, int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    ref.read(navbarStateProvider.notifier).setCurrentIndex(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final currentIndex = navbarState.currentIndex;
    final dragOffset = navbarState.dragOffset;

    return Scaffold(
      body: Stack(
        children: [
          // PAGE VIEW
          Transform.translate(
            offset: Offset(dragOffset * 0.4, 0),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) =>
                  ref.read(navbarStateProvider.notifier).setCurrentIndex(i),
              children: _pages,
            ),
          ),

          // FLOATING NAVBAR
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                // DRAG UPDATE
                onHorizontalDragUpdate: (details) {
                  final newOffset = dragOffset + details.delta.dx;
                  ref
                      .read(navbarStateProvider.notifier)
                      .setDragOffset(newOffset);
                },

                // DRAG END
                onHorizontalDragEnd: (_) {
                  if (dragOffset < -80 && currentIndex < _pages.length - 1) {
                    _onNavTapped(ref, currentIndex + 1);
                  } else if (dragOffset > 80 && currentIndex > 0) {
                    _onNavTapped(ref, currentIndex - 1);
                  }
                  ref.read(navbarStateProvider.notifier).resetDragOffset();
                },

                child: NavbarWidget(
                  icons: [
                    Icons.home_rounded,
                    Icons.search_rounded,
                    Icons.person_rounded,
                  ],
                  labels: ['Home', 'Search', 'Profile'],
                  currentIndex: currentIndex,
                  onTap: (index) => _onNavTapped(ref, index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
