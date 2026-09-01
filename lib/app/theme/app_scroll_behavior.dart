import 'package:flutter/material.dart';

/// Removes Flutter's default Android-style glow/stretch overscroll
/// indicator app-wide — one of the biggest visual tells that a web/
/// desktop app is "a Flutter app" rather than a native-feeling product,
/// and something no amount of widget-level styling fixes.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
