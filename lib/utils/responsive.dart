import 'package:flutter/material.dart';

/// Responsive breakpoints and helpers
class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileBreakpoint && w < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Returns value based on screen size
  static T value<T>(BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= desktopBreakpoint) return desktop ?? tablet ?? mobile;
    if (w >= mobileBreakpoint) return tablet ?? mobile;
    return mobile;
  }

  /// Content max width for centering on large screens
  static double contentMaxWidth(BuildContext context) {
    return value(context, mobile: double.infinity, tablet: 700, desktop: 800);
  }

  /// Horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    return value(context, mobile: 20.0, tablet: 32.0, desktop: 48.0);
  }

  /// Grid cross axis count for favorites
  static int favoritesGridColumns(BuildContext context) {
    return value(context, mobile: 2, tablet: 3, desktop: 4);
  }
}

/// Wraps content with a max-width constraint for larger screens
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveCenter({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.contentMaxWidth(context),
        ),
        child: child,
      ),
    );
  }
}
