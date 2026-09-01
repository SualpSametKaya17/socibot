import 'package:flutter/material.dart';

import '../../app/theme/app_breakpoints.dart';

/// Picks between mobile, tablet, and desktop layouts based on the
/// available width, so every screen uses the same breakpoints instead of
/// each hardcoding its own. [tablet] is optional — screens that don't
/// need a distinct tablet treatment fall back to [desktop].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.tablet) return desktop(context);
    if (width >= AppBreakpoints.mobile) return (tablet ?? desktop)(context);
    return mobile(context);
  }
}
