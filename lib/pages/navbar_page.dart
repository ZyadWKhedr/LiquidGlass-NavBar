import 'package:flutter/material.dart';
import '../widgets/bottom_nav_scaffold.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'profile_page.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavScaffold(
      pages: const [
        HomePage(),
        SearchPage(),
        ProfilePage(),
        // SizedBox(),
      ],
      icons: const [
        Icon(Icons.import_contacts),
        Icon(Icons.search_rounded),
        Icon(Icons.person_rounded),
        // Icons.settings_rounded,
      ],
      labels: const [
        'Home',
        'Search',
        'Profile',
        // 'Settings',
      ],
      navbarHeight: 70,
      indicatorWidth: 70,
      bottomPadding: 20,
      horizontalPadding: 15,
      selectedColor: Colors.green,
      unselectedColor: Colors.white,
    );
  }
}
