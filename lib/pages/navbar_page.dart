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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final notifier = ref.read(navbarStateProvider.notifier);
    final currentIndex = navbarState.currentIndex;
    final dragOffset = navbarState.dragOffset;

    return Scaffold(
      body: Stack(
        children: [
          // PAGE VIEW
          Transform.translate(
            offset: Offset(dragOffset * 0.25, 0),

            child: PageView(
              controller: notifier.pageController,
              physics: const NeverScrollableScrollPhysics(),
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
                  final newOffset = dragOffset + details.delta.dx * 0.3;
                  notifier.setDragOffset(newOffset);
                },

                // DRAG END
                onHorizontalDragEnd: (_) {
                  if (dragOffset.abs() > 80) {
                    final jump = -(dragOffset / 80).round();
                    final newIndex = (currentIndex + jump).clamp(
                      0,
                      _pages.length - 1,
                    );
                    if (newIndex != currentIndex) {
                      notifier.setCurrentIndex(newIndex);
                    }
                  }
                  notifier.resetDragOffset();
                },

                child: NavbarWidget(
                  icons: [
                    Icons.home_rounded,
                    Icons.search_rounded,
                    Icons.person_rounded,
                  ],
                  labels: ['Home', 'Search', 'Profile'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
