import 'package:flutter/material.dart';

/// Width breakpoints shared by every screen that adapts between mobile and
/// desktop layouts. Priority order per the product brief: Desktop > Web >
/// Tablet > Mobile — `desktop` covers both desktop and wide web/tablet.
class Breakpoints {
  const Breakpoints._();

  static const double desktop = 900;
}

/// Picks between a mobile and a desktop layout based on the available
/// width, so every screen uses the same breakpoint instead of each
/// hardcoding its own.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.mobile, required this.desktop});

  final WidgetBuilder mobile;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= Breakpoints.desktop ? desktop(context) : mobile(context);
  }
}
