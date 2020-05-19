class Dimension {
  static double height = 0.0;
  static double width = 0.0;
  static double statusBarHeight = 0.0;
  static double bottomPadding = 0.0;

  static double getWidth(double size) {
    return width * size;
  }

  static double getHeight(double size) {
    return height * size;
  }

  static double getSafeAreaHeight() {
    return height - statusBarHeight - bottomPadding;
  }
}
