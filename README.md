# LiquidGlass NavBar

A Flutter application demonstrating a **fully adaptive glass‑morphic bottom navigation bar** with precise position calculation, smooth drag interactions, and **Riverpod** state management. **Scales seamlessly to any number of icons** with pixel-perfect indicator alignment.

## Features



https://github.com/user-attachments/assets/c083a53d-5b9f-4355-9b77-4a04e70198d3



- **Fully Adaptive** – supports any number of navbar items (tested with 3-9+ icons)
- **Precise Position Calculation** – uses GlobalKey measurements for pixel-perfect indicator alignment
- **Liquid Glass UI** using `liquid_glass_renderer` for a stunning frosted‑glass effect
- **Responsive Design** with `flutter_screenutil` for consistent scaling across all devices
- **Custom Navbar** split into reusable widgets:
  - `NavbarBackground` – glass‑styled container with adaptive sizing
  - `NavbarItemWidget` – individual icon + label with overflow protection
  - `NavbarDraggableIndicator` – animated draggable highlight with adaptive width
- **Riverpod** (`flutter_riverpod`) for clean, testable state management
- **PageView** navigation with iOS‑style drag‑to‑switch pages
- **Dynamic Width Calculation** – indicator automatically adjusts width based on item count

## Adaptive Position Calculation System

The navbar uses a sophisticated **two-stage position calculation** to ensure the draggable indicator aligns perfectly with each icon, regardless of how many items are in the navbar.

### Stage 1: Initial Positions (Fast Approximation)

When the navbar is first rendered, it calculates approximate positions for immediate display:

```dart
void initPositions({required int itemCount, required double containerWidth}) {
  final itemWidth = containerWidth / itemCount;
  final positions = List.generate(
    itemCount,
    (i) => itemWidth * i + itemWidth / 2,  // Center of each item space
  );
}
```

**Calculation:**
- **Item Width**: `screenWidth / itemCount`  
  *Example: 400px width ÷ 3 items = 133.33px per item*
- **Center Position**: `(itemWidth × index) + (itemWidth / 2)`  
  *Example for index 1: (133.33 × 1) + 66.67 = 200px (center of item 1)*

This provides quick, evenly-spaced positions for smooth initial rendering.

### Stage 2: Measured Positions (Pixel-Perfect Alignment)

After icons are rendered, the navbar measures their **actual positions** using `GlobalKey`:

```dart
void initMeasuredPositions(List<GlobalKey> iconKeys) {
  final positions = iconKeys.map((key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      // Get global X coordinate of icon's left edge
      final leftEdge = box.localToGlobal(Offset.zero).dx;
      
      // Calculate center by adding half the icon's actual width
      final center = leftEdge + box.size.width / 2;
      
      return center;
    }
    return 0.0;
  }).toList();
}
```

**How It Works:**
1. **GlobalKey** is attached to each `NavbarItemWidget`
2. `findRenderObject()` retrieves the actual rendered widget's `RenderBox`
3. `localToGlobal(Offset.zero)` converts local coordinates to screen coordinates
4. `box.size.width / 2` calculates half the icon's actual rendered width
5. **Final Center** = `leftEdge.x + (actualWidth / 2)`

**Why This Matters:**
- Icons may not be evenly spaced due to `MainAxisAlignment.spaceEvenly`
- Text labels can vary in width, affecting layout
- Padding and margins differ across screen sizes
- Measured positions guarantee **pixel-perfect alignment** regardless of these variations

### Adaptive Indicator Width

The indicator automatically adjusts its width based on the number of items:

```dart
final adaptiveWidth = (baseSize * (3 / itemCount).clamp(0.7, 1.0)).w;
```

**Examples:**
- **3 items**: `70 × (3/3) = 70px` (full width)
- **6 items**: `70 × (3/6) = 35px × 0.7 = 49px` (70% minimum)
- **9 items**: `70 × (3/9) = 23.33px × 0.7 = 49px` (clamped to 70% minimum)

This ensures the indicator is always visible but doesn't overwhelm the navbar when many items are present.

### Overflow Prevention

The indicator is clamped to stay within screen bounds:

```dart
final clampedCenter = position.clamp(
  adaptiveWidth / 2,           // Left boundary
  screenWidth - adaptiveWidth / 2,  // Right boundary
);
```

This prevents the indicator from rendering off-screen during drag gestures.

## Project Structure
```
lib/
├─ main.dart                     # Entry point with ScreenUtilInit
├─ pages/
│   ├─ home_page.dart           # Example home screen
│   ├─ search_page.dart         # Placeholder search screen
│   ├─ profile_page.dart        # Placeholder profile screen
│   └─ navbar_page.dart         # Hosts PageView and NavbarWidget
├─ widgets/
│   ├─ navbar_widget.dart       # Main navbar with position calculation
│   ├─ navbar_item_widget.dart  # Single navbar item (Expanded widget)
│   ├─ navbar_background.dart   # Adaptive glass background
│   └─ navbar_draggable_indicator.dart # Adaptive draggable highlight
└─ providers/
    └─ navbar_providers.dart    # Riverpod StateNotifier with position state
```

## State Management (Riverpod)

**NavbarState** holds:
- `currentIndex` – currently selected tab
- `draggablePosition` – X coordinate of indicator center
- `dragOffset` – temporary drag offset for page transitions
- `positions` – list of measured icon center positions

**Key Methods:**
- `initPositions()` – calculates approximate positions for initial render
- `initMeasuredPositions()` – updates with precise GlobalKey measurements
- `setCurrentIndex()` – animates to new page and updates indicator position
- `setDraggablePosition()` – updates indicator during drag gestures
- `setDragOffset()` – updates page view offset during swipe gestures

## Getting Started

1. **Prerequisites**
   - Flutter SDK (stable) installed
   - A device or emulator

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Customization

### Adding More Icons

Simply add more items to the `icons` and `labels` lists in `NavbarPage`:

```dart
const NavbarWidget(
  icons: [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.person_rounded,
    Icons.settings_rounded,      // Add more icons
    Icons.notifications_rounded,
    Icons.favorite_rounded,
  ],
  labels: [
    'Home',
    'Search',
    'Profile',
    'Settings',                  // Add corresponding labels
    'Notifications',
    'Favorites',
  ],
)
```

The navbar **automatically adapts** to any number of items with proper spacing and indicator sizing.

### Adjusting Appearance

- **Indicator Width**: Change `indicatorWidth` parameter (default: 70)
- **Navbar Height**: Change `navbarHeight` parameter (default: 70)
- **Bottom Padding**: Change `bottomPadding` parameter (default: 20)
- **Glass Effect**: Modify `LiquidGlassSettings` in `NavbarBackground`
- **Colors**: Customize `selectedColor` and `unselectedColor` in `NavbarItemWidget`
- **Icon Sizes**: Adjust `selectedIconSize` and `unselectedIconSize`

### Responsive Scaling

All dimensions use `flutter_screenutil` extensions:
- `.w` – responsive width
- `.h` – responsive height  
- `.sp` – responsive font size
- `.r` – responsive radius

Design size is set to `Size(426.67, 952)` in `main.dart`. Adjust to match your design specifications.

## Technical Highlights

 **GlobalKey-based Position Measurement** for pixel-perfect alignment  
 **Adaptive Width Calculation** scales from 70% to 100% based on item count  
 **Overflow Protection** with clamped boundaries and `TextOverflow.ellipsis`  
 **Responsive Design** using `flutter_screenutil` throughout  
 **Clean Architecture** with separated concerns (UI, state, widgets)  
 **Optimized Rendering** with `const` constructors where possible  
 **Smooth Animations** with `PageController` and gesture-based transitions

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
