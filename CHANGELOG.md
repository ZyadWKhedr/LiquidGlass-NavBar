## 1.0.0

* Initial release of `liquid_glass_navbar`
* **Fully adaptive navbar** - Supports any number of icons (tested with 3-9+ items)
* **Precise position calculation** - Uses GlobalKey measurements for pixel-perfect indicator alignment
* **Two-stage position system**:
  * Stage 1: Fast approximation with even spacing
  * Stage 2: Measured positions using GlobalKey for pixel-perfect alignment
* **Adaptive indicator width** - Automatically scales based on item count (70%-100%)
* **Responsive design** - Complete integration with flutter_screenutil
* **Overflow protection** - Clamped boundaries and TextOverflow.ellipsis
* **Smooth animations** - PageController-based transitions with drag gestures
* **Customizable** - Extensive parameters for sizes, colors, and spacing
* **Clean architecture** - Separated widgets and providers for testability
* **Zero dependencies conflicts** - Works seamlessly with existing projects
