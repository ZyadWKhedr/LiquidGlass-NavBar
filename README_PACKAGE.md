# liquid_glass_navbar

A fully adaptive glassmorphic bottom navigation bar for Flutter with precise position calculation and smooth drag interactions. **Scales seamlessly to any number of icons** with pixel-perfect indicator alignment.

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![Pub Version](https://img.shields.io/badge/version-1.0.0-blue)](https://pub.dev/packages/liquid_glass_navbar)

## Features

✨ **Fully Adaptive** – Supports any number of navbar items (tested with 3-9+ icons)  
🎯 **Precise Position Calculation** – Uses GlobalKey measurements for pixel-perfect indicator alignment  
💎 **Liquid Glass UI** – Stunning frosted glass effect using `liquid_glass_renderer`  
📱 **Responsive Design** – Consistent scaling with `flutter_screenutil`  
⚡ **Smooth Animations** – iOS-style drag gestures and page transitions  
🎨 **Highly Customizable** – Extensive parameters for colors, sizes, and spacing  
🧩 **Clean Architecture** – Modular widgets with Riverpod state management

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_glass_navbar: ^1.0.0
  flutter_riverpod: ^3.0.3
  flutter_screenutil: ^5.9.3
  liquid_glass_renderer: ^0.2.0-dev.4
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Wrap your app with providers

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(426.67, 952),
      builder: (context, child) => const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}
```

### 2. Use NavbarWidget in your page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';

class NavbarPage extends ConsumerWidget {
  const NavbarPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(navbarStateProvider);
    final notifier = ref.read(navbarStateProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // Your pages with PageView
          PageView(
            controller: notifier.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),

          // The adaptive navbar
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: NavbarWidget(
                icons: const [
                  Icons.home_rounded,
                  Icons.search_rounded,
                  Icons.person_rounded,
                ],
                labels: const ['Home', 'Search', 'Profile'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## How It Works: Position Calculation

### Two-Stage Position System

The navbar uses a sophisticated **two-stage approach** for indicator positioning:

#### Stage 1: Initial Positions (Fast Approximation)

```dart
void initPositions({required int itemCount, required double containerWidth}) {
  final itemWidth = containerWidth / itemCount;
  final positions = List.generate(
    itemCount,
    (i) => itemWidth * i + itemWidth / 2,
  );
}
```

**Calculation:**
- **Item Width**: `screenWidth / itemCount`
- **Center Position**: `(itemWidth × index) + (itemWidth / 2)`

#### Stage 2: Measured Positions (Pixel-Perfect)

```dart
void initMeasuredPositions(List<GlobalKey> iconKeys) {
  final positions = iconKeys.map((key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final leftEdge = box.localToGlobal(Offset.zero).dx;
      final center = leftEdge + box.size.width / 2;
      return center;
    }
    return 0.0;
  }).toList();
}
```

**Why Measured Positions?**
- Icons may not be evenly spaced due to `MainAxisAlignment.spaceEvenly`
- Text labels can vary in width
- Padding/margins differ across screen sizes
- **Result**: Pixel-perfect alignment regardless of variations

### Adaptive Indicator Width

The indicator automatically adjusts based on item count:

```dart
final adaptiveWidth = (baseSize * (3 / itemCount).clamp(0.7, 1.0)).w;
```

**Examples:**
- 3 items: `70px` (100%)
- 6 items: `49px` (70% minimum)
- 9 items: `49px` (clamped to 70%)

## Customization

### NavbarWidget Parameters

```dart
NavbarWidget(
  icons: [...],              // Required: List of IconData
  labels: [...],             // Required: List of String
  indicatorWidth: 70,        // Base width for 3 items
  navbarHeight: 70,          // Height of navbar
  bottomPadding: 20,         // Space from bottom
)
```

### NavbarItemWidget Parameters

```dart
NavbarItemWidget(
  selectedIconSize: 28,
  unselectedIconSize: 24,
  selectedFontSize: 12,
  unselectedFontSize: 10,
  selectedColor: Colors.amber,
  unselectedColor: Colors.grey,
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
)
```

## Example with Many Icons

The navbar scales beautifully to any number of items:

```dart
NavbarWidget(
  icons: const [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.person_rounded,
    Icons.settings_rounded,
    Icons.notifications_rounded,
    Icons.favorite_rounded,
    // Add as many as you need!
  ],
  labels: const [
    'Home', 'Search', 'Profile',
    'Settings', 'Notifications', 'Favorites',
  ],
)
```

## Dependencies

- `flutter_riverpod` ^3.0.3 - State management
- `flutter_screenutil` ^5.9.3 - Responsive design
- `liquid_glass_renderer` ^0.2.0-dev.4 - Glass effect

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

[ZyadWKhedr](https://github.com/ZyadWKhedr)
