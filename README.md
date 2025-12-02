# LiquidGlass NavBar

A Flutter application demonstrating a **glass‑morphic bottom navigation bar** with smooth drag interactions, animated draggable indicator, and **Riverpod** state management.

## Features

https://github.com/user-attachments/assets/70b9125a-58b3-4459-8dda-fed93351e915


- **Liquid Glass UI** using `liquid_glass_renderer` for a frosted‑glass effect.
- **Custom Navbar** split into reusable widgets:
  - `NavbarBackground` – glass‑styled container.
  - `NavbarItemWidget` – individual icon + label.
  - `NavbarDraggableIndicator` – animated draggable highlight.
- **Riverpod** (`flutter_riverpod`) for clean, testable state management of the selected index and drag offset.
- **PageView** navigation with iOS‑style drag‑to‑switch pages.
- **Responsive design** – works on any screen size.

## Project Structure
```
lib/
├─ main.dart                     # Entry point wrapped with ProviderScope
├─ pages/
│   ├─ home_page.dart           # Example home screen
│   ├─ search_page.dart         # Placeholder search screen
│   ├─ profile_page.dart        # Placeholder profile screen
│   └─ navbar_page.dart         # Hosts PageView and NavbarWidget
├─ widgets/
│   ├─ navbar_widget.dart       # Combines background, items, indicator
│   ├─ navbar_item_widget.dart  # Single navbar item component
│   ├─ navbar_background.dart   # Glass background container
│   └─ navbar_draggable_indicator.dart # Draggable highlight
└─ providers/
    └─ navbar_providers.dart    # Riverpod StateNotifier for index & drag
```

## State Management (Riverpod)
- `NavbarState` holds `currentIndex` and `dragOffset`.
- `navbarStateProvider` is a `StateNotifierProvider` exposing the state.
- UI reads the state via `ref.watch(navbarStateProvider)` and updates it with `ref.read(navbarStateProvider.notifier)`.
- This decouples UI from `setState` and makes the logic easily testable.

## Getting Started
1. **Prerequisites**
   - Flutter SDK (stable) installed.
   - A device or emulator.
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app**
   ```bash
   flutter run
   ```
   The app launches with the home page and the glass‑styled bottom navigation bar.

## Customisation
- **Icons & Labels** – modify the `icons` and `labels` lists in `NavbarPage`.
- **Colors & Sizes** – adjust the `LiquidGlassSettings` and widget dimensions in the component files.
- **State Logic** – extend `NavbarState` to include more UI state (e.g., badge counts).

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
