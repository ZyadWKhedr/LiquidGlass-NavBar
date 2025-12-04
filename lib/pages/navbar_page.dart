import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'profile_page.dart';

class NavbarPage extends ConsumerWidget {
  const NavbarPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    // SizedBox(),
    // SizedBox(),
    // SizedBox(),
    // SizedBox(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(navbarStateProvider);
    final notifier = ref.read(navbarStateProvider.notifier);

    final currentIndex = state.currentIndex;
    final dragOffset = state.dragOffset;

    return Scaffold(
      body: Stack(
        children: [
          // PAGE VIEW WITH PARALLAX SHIFT
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
                behavior: HitTestBehavior.translucent,

                // HORIZONTAL DRAG UPDATE
                onHorizontalDragUpdate: (details) {
                  notifier.setDragOffset(dragOffset + details.delta.dx * 0.3);
                },

                // HORIZONTAL DRAG END
                onHorizontalDragEnd: (_) {
                  const threshold = 80;

                  if (dragOffset.abs() > threshold) {
                    final jump = -(dragOffset / threshold).round();
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

                child: const NavbarWidget(
                  navbarHeight: 70,
                  bottomPadding: 30,

                  icons: [
                    Icons.home_rounded,
                    Icons.search_rounded,
                    Icons.person_rounded,
                    Icons.settings_rounded,
                    Icons.notifications_rounded,
                    Icons.favorite_rounded,
                    Icons.shopping_cart_rounded,
                    // Icons.menu_rounded,
                    // Icons.logout_rounded,
                  ],
                  labels: [
                    'Home',
                    'Search',
                    'Profile',
                    'Settings',
                    'Notifications',
                    'Favorites',
                    'Shopping Cart',
                    // 'Menu',
                    // 'Logout',
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
